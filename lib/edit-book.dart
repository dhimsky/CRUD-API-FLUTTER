import 'package:flutter/material.dart';
import 'package:restapi/repository.dart';

class EditBook extends StatefulWidget {
  const EditBook({super.key});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  Repository repository = Repository();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    if (args[1].isNotEmpty) {
      _nameController.text = args[1];
    }
    if (args[2].isNotEmpty) {
      _priceController.text = args[2];
    }
    if (args[3].isNotEmpty) {
      _descController.text = args[3];
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/home');
              },
            ),
            Text('Edit Book'),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(hintText: 'Price'),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
              ElevatedButton(
                onPressed: () async {
                  BigInt bookId =
                      BigInt.tryParse(args[0].toString()) ?? BigInt.zero;
                  int price = int.tryParse(_priceController.text) ?? 0;
                  bool response = await repository.putData(
                    bookId,
                    _nameController.text,
                    price,
                    _descController.text,
                  );
                  if (response) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Gagal Mengupdate Data'),
                          content: Text(
                              'Tidak dapat mengupdate data, silahkan coba lagi nanti.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
