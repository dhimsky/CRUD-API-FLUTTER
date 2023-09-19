import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restapi/add-book.dart';
import 'package:restapi/edit-book.dart';
import 'package:restapi/model.dart';
import 'package:restapi/repository.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new PostHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) => MyHomePage(title: 'Test API'),
        '/add-book': (context) => AddBook(),
        '/edit-book': (context) => EditBook(),
      },
      home: MyHomePage(title: 'Test API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> listBook = [];
  Repository repository = Repository();
  bool isLoading = true;

  getData() async {
    try {
      final response = await repository.getData();
      if (response.isNotEmpty) {
        setState(() {
          listBook = response;
          isLoading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load data from API.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).popAndPushNamed('/add-book'),
          )
        ],
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : listBook.isEmpty // Periksa jika listBook kosong
              ? Center(
                  child: Text(
                      'Data Kosong'), // Tampilkan pesan "Data Kosong" jika tidak ada data
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .popAndPushNamed('/edit-book', arguments: [
                              listBook[index].id,
                              listBook[index].name,
                              listBook[index].price.toString(),
                              listBook[index].desc
                            ]),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listBook[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Rp. ' + listBook[index].price.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    listBook[index].desc,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool deleteConfirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi Hapus Data'),
                                    content: Text(
                                        'Anda yakin ingin menghapus data ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(false); // Batal menghapus
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // Konfirmasi menghapus
                                        },
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (deleteConfirmed) {
                                bool response = await repository
                                    .deleteData(listBook[index].id);
                                if (response) {
                                  print('Delete data success!');
                                } else {
                                  print('Delete data failed!');
                                }
                                getData();
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: listBook.length,
                  ),
                ),
    );
  }
}
