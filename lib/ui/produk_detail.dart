import 'package:flutter/material.dart';
import '/bloc/produk_bloc.dart';
import '/model/produk.dart';
import '/ui/produk_form.dart';
import '/ui/produk_page.dart';
import '/widget/warning_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.yellow.shade600,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Helvetica',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: ProdukDetail(),
    );
  }
}

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allergen Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.yellow.shade600,
        elevation: 2.0, // Minimal shadow for elegance
      ),
      body: Center(
        child: widget.produk != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText(
                            label: "Allergen",
                            value: widget.produk!.allergen ?? ""),
                        const SizedBox(height: 10),
                        _infoText(
                            label: "Reaction",
                            value: widget.produk!.reaction ?? ""),
                        const SizedBox(height: 10),
                        _infoText(
                            label: "Severity Scale",
                            value: widget.produk!.severityScale.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _tombolHapusEdit(),
                ],
              )
            : const Text(
                "Produk tidak ditemukan",
                style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
              ),
      ),
    );
  }

  Widget _infoText({required String label, required String value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _customButton(
          text: "EDIT",
          color: Colors.blue.shade600,
          icon: Icons.edit,
          onPressed: _editProduk,
        ),
        const SizedBox(width: 12),
        _customButton(
          text: "DELETE",
          color: Colors.red.shade400,
          icon: Icons.delete,
          onPressed: confirmHapus,
        ),
      ],
    );
  }

  Widget _customButton(
      {required String text,
      required Color color,
      required IconData icon,
      required Function() onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 4.0,
      ),
    );
  }

  void _editProduk() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukForm(
          produk: widget.produk!,
        ),
      ),
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(fontSize: 18.0, color: Colors.black87),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            ProdukBloc.deleteProduk(id: widget.produk!.id!).then((value) => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProdukPage()))
                }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
          child: const Text("Ya"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
          ),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
