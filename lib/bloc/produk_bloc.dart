import 'dart:convert';
import 'package:responsi/helpers/api.dart';
import 'package:responsi/helpers/api_url.dart';
import 'package:responsi/model/produk.dart';

class ProdukBloc {
  // Mengambil daftar produk dari API
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listAlergi;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    
    // Mendapatkan daftar produk dari respon
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    
    // Parsing JSON ke objek Produk
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    
    return produks;
  }

  // Menambah produk baru
  static Future addProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.createAlergi;
    
    var body = {
      "allergen": produk!.allergen,
      "reaction": produk.reaction,
      "severity_scale": produk.severityScale.toString()
    };
    
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    
    return jsonObj['status'];
  }

  // Mengupdate produk yang sudah ada
  static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateAlergi(produk.id!);
    print(apiUrl);
    
    var body = {
      "allergen": produk.allergen,
      "reaction": produk.reaction,
      "severity_scale": produk.severityScale.toString()
    };
    
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    
    return jsonObj['status'];
  }

  // Menghapus produk berdasarkan id
  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteAlergi(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
