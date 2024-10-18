import 'package:flutter/material.dart';
import 'package:responsi/bloc/produk_bloc.dart';
import 'package:responsi/model/produk.dart';
import 'package:responsi/ui/produk_page.dart';
import 'package:responsi/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProdukForm extends StatefulWidget {
  Produk? produk;

  ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH ALLERGEN";
  String tombolSubmit = "SIMPAN";

  final _allergenTextboxController = TextEditingController();
  final _reactionTextboxController = TextEditingController();
  final _severityScaleTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _allergenTextboxController.text = widget.produk!.allergen!;
        _reactionTextboxController.text = widget.produk!.reaction!;
        _severityScaleTextboxController.text = widget.produk!.severityScale.toString();
      });
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        elevation: 2.0,
        backgroundColor: Colors.yellow.shade600,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _allergenTextField(),
                const SizedBox(height: 16.0),
                _reactionTextField(),
                const SizedBox(height: 16.0),
                _severityScaleTextField(),
                const SizedBox(height: 24.0),
                _buttonSubmit(),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _allergenTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Allergen",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      keyboardType: TextInputType.text,
      controller: _allergenTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Allergen harus diisi";
        }
        return null;
      },
    );
  }

  Widget _reactionTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Reaction",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      keyboardType: TextInputType.text,
      controller: _reactionTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Reaction harus diisi";
        }
        return null;
      },
    );
  }

  Widget _severityScaleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Severity Scale",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      keyboardType: TextInputType.number,
      controller: _severityScaleTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Severity Scale harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            setState(() {
              _isLoading = true;
            });
            if (widget.produk != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.yellow.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        tombolSubmit,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void simpan() {
    Produk createProduk = Produk(
      id: null,
      allergen: _allergenTextboxController.text,
      reaction: _reactionTextboxController.text,
      severityScale: int.parse(_severityScaleTextboxController.text),
    );

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {
    Produk updateProduk = Produk(
      id: widget.produk!.id!,
      allergen: _allergenTextboxController.text,
      reaction: _reactionTextboxController.text,
      severityScale: int.parse(_severityScaleTextboxController.text),
    );

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }
}
