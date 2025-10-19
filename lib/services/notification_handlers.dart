// ignore_for_file: unused_element, unused_local_variable

import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // <-- untuk navigatorKey jika kamu pakai global key
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:e_hrm/contraints/endpoints.dart';
import 'package:e_hrm/firebase_options.dart';
import 'package:e_hrm/services/api_services.dart';

/// ---------------------------------------------------------------------------
/// BACKGROUND HANDLERS (WAJIB TOP-LEVEL)
/// ---------------------------------------------------------------------------

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Pastikan Firebase siap saat isolate background
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Cegah duplikat: jika message punya "notification", Android biasanya sudah
  // nunjukin sistem notif-nya sendiri. Kita pakai guard di showLocalNotification.
  final String uniqueLogId = DateTime.now().millisecondsSinceEpoch.toString();
  NotificationHandler().showLocalNotification(
    message,
    from: 'BackgroundHandler_$uniqueLogId',
    fromBackground: true,
  );
}

// iOS 10+: callback ketika user tap notif (saat app di background/terminated)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Kamu bisa mem-parsing payload di sini juga, namun
  // biasanya kita arahkan semua routing ke NotificationHandler._handleTapPayload
  // agar satu pintu.
}

/// ---------------------------------------------------------------------------
/// NOTIFICATION HANDLER (SINGLETON)
/// ---------------------------------------------------------------------------

class NotificationHandler {
  NotificationHandler._internal();
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiService _apiService = ApiService();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _cachedToken;
  bool _initialized = false;

  /// Simpel anti-duplicated map: track messageId / dedupeKey (ukuran kecil saja).
  final LinkedHashSet<String> _seenKeys = LinkedHashSet<String>();

  /// Opsional: inject navigator key agar bisa navigasi dari sini.
  /// Kalau di app kamu punya GlobalKey<NavigatorState> navigatorKey;
  /// kamu bisa set lewat setter ini setelah create MaterialApp.
  GlobalKey<NavigatorState>? navigatorKey;
  set attachNavigator(GlobalKey<NavigatorState> key) => navigatorKey = key;

  /// -------------------------------------------------------------------------
  /// INIT
  /// -------------------------------------------------------------------------
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // 1) Permission FCM
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2) Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3) Init flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false, // kita minta via plugin di bawah
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) {
        _handleTapPayload(resp.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 4) Minta permission via plugin (iOS/macOS)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // 5) Android channel
    await _createAndroidNotificationChannel();

    // 6) Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final String uniqueLogId = DateTime.now().millisecondsSinceEpoch
          .toString();
      showLocalNotification(
        message,
        from: 'ForegroundListener_$uniqueLogId',
        fromBackground: false,
      );
    });

    // 7) Tap notif saat app dibuka dari background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleTapPayload(jsonEncode(message.data));
    });

    // 8) Tap notif saat app dibuka dari terminated
    final initial = await _firebaseMessaging.getInitialMessage();
    if (initial != null) {
      _handleTapPayload(jsonEncode(initial.data));
    }

    // 9) Token → server
    await _getTokenAndSendToServer();
    _firebaseMessaging.onTokenRefresh.listen(_sendTokenToServer);
  }

  /// -------------------------------------------------------------------------
  /// INTERNAL UTILS
  /// -------------------------------------------------------------------------

  bool _shouldShowLocal(RemoteMessage message, {required bool fromBackground}) {
    final hasNotificationPayload =
        message.notification != null &&
        ((message.notification!.title?.isNotEmpty ?? false) ||
            (message.notification!.body?.isNotEmpty ?? false));

    // Saat background di Android, payload.notification sudah ditangani sistem.
    // Kita hindari duplikat lokal.
    if (!kIsWeb && fromBackground && hasNotificationPayload) {
      return false;
    }
    return true;
  }

  bool _isDuplicateKey(String key) {
    if (_seenKeys.contains(key)) return true;
    _seenKeys.add(key);
    if (_seenKeys.length > 100) {
      _seenKeys.remove(_seenKeys.first);
    }
    return false;
  }

  int _stableIdFrom(String input) => input.hashCode & 0x7fffffff;

  /// Pusat navigasi berdasarkan payload
  void _handleTapPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;

    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(jsonDecode(payload));
    } catch (_) {
      return;
    }

    // Contoh skema:
    // {
    //   "type": "absensi",
    //   "action": "checkin" | "checkout",
    //   "status": "berhasil" | "gagal" | "terlambat",
    //   "checkin_id": "...",
    //   "route": "/absensi/detail",
    //   "routeArgs": {"id": "..."}
    // }

    final route = (data['route'] as String?) ?? '';
    final routeArgs = (data['routeArgs'] as Map?)?.cast<String, dynamic>();

    // Jika kamu pakai navigatorKey global:
    final nav = navigatorKey?.currentState;
    if (nav != null && route.isNotEmpty) {
      // Pastikan dipanggil di event loop berikutnya (aman dari isolate).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nav.pushNamed(route, arguments: routeArgs);
      });
    }
  }

  /// -------------------------------------------------------------------------
  /// PUBLIC: TAMPILKAN NOTIF (UMUM)
  /// -------------------------------------------------------------------------

  void showLocalNotification(
    RemoteMessage message, {
    String from = 'Unknown',
    required bool fromBackground,
  }) {
    // Aktifkan guard duplikasi Android background
    if (!_shouldShowLocal(message, fromBackground: fromBackground)) return;

    // Prefer data payload agar konsisten cross-platform
    final Map<String, dynamic> data = message.data;

    final String type = (data['type'] as String?)?.trim() ?? '';
    final String title =
        data['title'] ??
        message.notification?.title ??
        (type.isNotEmpty ? 'Notifikasi $type' : 'Notifikasi');
    final String body =
        data['body'] ??
        message.notification?.body ??
        'Anda memiliki notifikasi baru.';

    // dedupe key: pakai messageId atau fallback kombinasi konten
    final String dedupeKey =
        message.messageId ??
        data['dedupeKey'] ??
        '$type|$title|$body|${data['action'] ?? ''}';

    if (_isDuplicateKey(dedupeKey)) return;

    final int notificationId = _stableIdFrom(dedupeKey);

    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Channel untuk notifikasi penting.',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        tag: 'e_hrm_general',
        groupKey: 'e_hrm_general',
        // styleInformation: BigTextStyleInformation('')  // bisa diisi untuk big text
      ),
      iOS: const DarwinNotificationDetails(
        threadIdentifier: 'e_hrm_general',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        threadIdentifier: 'e_hrm_general',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    _localNotifications.show(
      notificationId,
      title,
      body,
      details,
      payload: jsonEncode(data),
    );
  }

  /// -------------------------------------------------------------------------
  /// PUBLIC: KHUSUS ABSENSI (CHECK-IN / CHECK-OUT)
  /// -------------------------------------------------------------------------

  /// Helper untuk bikin title/body konsisten dari payload absensi.
  /// Server cukup kirim: { type:"absensi", action:"checkin/checkout", status:"..." , ... }
  void showAbsensiNotification({
    required String action, // "checkin" | "checkout"
    required String status, // "berhasil" | "gagal" | "terlambat" | dll.
    String? lokasiNama,
    String? jamLabel, // contoh "08:02 WITA"
    Map<String, dynamic>? extraData,
  }) {
    final isCheckin = action.toLowerCase() == 'checkin';
    final prefix = isCheckin ? 'Check-in' : 'Check-out';

    // Title & body default
    final title = '$prefix $status';
    final body = [
      if (lokasiNama?.isNotEmpty == true) 'Lokasi: $lokasiNama',
      if (jamLabel?.isNotEmpty == true) 'Waktu: $jamLabel',
    ].where((e) => e.isNotEmpty).join(' • ');

    final data = <String, dynamic>{
      'type': 'absensi',
      'action': isCheckin ? 'checkin' : 'checkout',
      'status': status,
      if (lokasiNama != null) 'lokasi_nama': lokasiNama,
      if (jamLabel != null) 'jam': jamLabel,
      // Contoh route tujuan ketika ditap
      'route': '/absensi/riwayat',
      'routeArgs': <String, dynamic>{},
      if (extraData != null) ...extraData,
      // dedupeKey supaya update kecil tidak dobel
      'dedupeKey':
          'absensi|$action|$status|${lokasiNama ?? ''}|${jamLabel ?? ''}',
      'title': title,
      'body': body.isNotEmpty ? body : 'Status $prefix: $status',
    };

    final int id = _stableIdFrom(data['dedupeKey'] as String);

    _localNotifications.show(
      id,
      data['title'] as String,
      data['body'] as String,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Channel untuk notifikasi penting.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          tag: 'e_hrm_absensi',
          groupKey: 'e_hrm_absensi',
        ),
        iOS: DarwinNotificationDetails(
          threadIdentifier: 'e_hrm_absensi',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(
          threadIdentifier: 'e_hrm_absensi',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  /// -------------------------------------------------------------------------
  /// TOKEN MANAGEMENT
  /// -------------------------------------------------------------------------

  Future<String?> getFcmToken() async {
    if (_cachedToken != null) return _cachedToken;
    try {
      _cachedToken = await _firebaseMessaging.getToken();
      return _cachedToken;
    } catch (_) {
      return null;
    }
  }

  Future<void> _getTokenAndSendToServer() async {
    final String? token = await getFcmToken();
    if (token != null) {
      await _sendTokenToServer(token);
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      await _apiService.postDataPrivate(Endpoints.getNotifications, {
        'token': token,
      });
    } catch (_) {
      // abaikan gagal kirim token
    }
  }

  /// -------------------------------------------------------------------------
  /// ANDROID CHANNEL
  /// -------------------------------------------------------------------------

  Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel untuk notifikasi penting.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}

/// Akses global jika kamu mau import dari tempat lain.
final notificationHandler = NotificationHandler();
