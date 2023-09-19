import 'package:flutter/material.dart';
import 'package:restapi/repository.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  Repository repository = Repository();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Text('Add Book'),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(hintText: 'Price'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                int price = int.tryParse(_priceController.text) ?? 0;
                bool response = await repository.postData(
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
                        title: Text('Gagal Menambah Data'),
                        content: Text(
                            'Tidak dapat menambah data, silahkan isi form dengan benar!'),
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
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
