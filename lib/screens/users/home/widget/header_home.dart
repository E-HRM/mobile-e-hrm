import 'package:e_hrm/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [Text("Manik Mahardika S.Kom"), Text("Divisi IT")],
        ),
        const SizedBox(width: 10),

        // Ganti ClipOval jadi child dari PopupMenuButton
        PopupMenuButton<int>(
          tooltip: 'Akun',
          onSelected: (action) async {
            // ambil root navigator SEBELUM await apa pun
            final nav = Navigator.of(context, rootNavigator: true);

            if (action == 2) {
              // opsi A: named route (pastikan terdaftar)
              nav.pushNamed('/profile-screen');

              // opsi B (paling kebal): dorong widget langsung
              // nav.push(MaterialPageRoute(builder: (_) => AuthWrapper(child: const ProfileScreen())));
            } else if (action == 4) {
              final auth = context.read<AuthProvider>();
              await auth.logout(context);
              nav.pushReplacementNamed('/login');
            }
          },

          itemBuilder: (context) => [
            PopupMenuItem(
              value: 2,
              child: Row(
                children: const [
                  Icon(Icons.person_2_outlined),
                  SizedBox(width: 8),
                  Text('Lihat Profil'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Row(
                children: const [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 8),
                  Text('Keluar'),
                ],
              ),
            ),
          ],
          child: ClipOval(
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
