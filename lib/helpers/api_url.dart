class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listAlergi = baseUrl + '/kesehatan/riwayat_alergi';
  static const String createAlergi = baseUrl + '/kesehatan/riwayat_alergi';
  static String updateAlergi(int id) {
    return baseUrl + '/kesehatan/riwayat_alergi/' + id.toString() + '/update';
  }

  static String showAlergi(int id) {
    return baseUrl + '/kesehatan/riwayat_alergi/' + id.toString();
  }

  static String deleteAlergi(int id) {
    return baseUrl + '/kesehatan/riwayat_alergi/' + id.toString() + '/delete';
  }
}
