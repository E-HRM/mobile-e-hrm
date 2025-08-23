class Endpoints {
  static const String baseURL = "https://7qdb4npf-3000.asse.devtunnels.ms/api";

  //auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getdataprivate = "auth/getdataprivate/";

  //updateProfile
  static const String updateProfile = "users/";

  //getLayanan
  static const String getLayanan = "layanan/";

  //getTanggungan
  static const String getTanggungan = "tanggungan/";

  //getDokter
  static const String getDokter = "dokter/slot-today";

  //getdetaildokterbydateperiodic
  static String getDetailDokter(String id) => "dokter/$id/date-periodic";

  //post-book-antrean
  static const String bookAntrean = "book-antrean";

  //get-book-antrean
  static const String getAntrean = "book-antrean";
}
