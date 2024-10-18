import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to set system overlay style
import 'package:responsi/bloc/logout_bloc.dart';
import 'package:responsi/bloc/produk_bloc.dart';
import 'package:responsi/model/produk.dart';
import 'package:responsi/ui/login_page.dart';
import 'package:responsi/ui/produk_detail.dart';
import 'package:responsi/ui/produk_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the system status bar color to yellow shade 600
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.yellow[600], // Top status bar color
        statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
      ),
    );

    return MaterialApp(
      title: 'List Allergen',
      theme: ThemeData(
        primaryColor: Colors.yellow[600], // Bright yellow shade 600
        scaffoldBackgroundColor: Colors.yellow[50], // Light yellow background
        fontFamily: 'Helvetica',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow[600], // Bright yellow AppBar
          titleTextStyle: const TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 16,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow[600], // Bright yellow FAB
          foregroundColor: Colors.black,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.yellow[600], // Bright yellow buttons
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const ProdukPage(),
    );
  }
}

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Set preferred height for the AppBar
        child: AppBar(
          backgroundColor: Colors.yellow[600], // Keep the yellow AppBar color
          title: const Text(
            'List Allergen',
            style: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer using Builder's context
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      )
                    });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: ProdukBloc.getProduks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListProduk(list: snapshot.data)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List? list;

  const ListProduk({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemProduk(produk: list![i]);
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.grey[200], // Set the card color to grey shade 200
        child: ListTile(
          title: Text(
            produk.allergen!,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Reaction: ${produk.reaction!}, Severity: ${produk.severityScale}",
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
