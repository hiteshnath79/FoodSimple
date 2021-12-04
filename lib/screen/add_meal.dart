import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  var name = '';
  var url = '';

  CollectionReference foods = FirebaseFirestore.instance.collection('foods');

  Future<void> addFood() {
    // print('User added successfully');
    return foods
        .add({
          'fname': name,
          'fimage': url,
        })
        .then((value) => print('User added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  clearData() {
    _nameController.clear();
    _urlController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
        title: Text('Add Screen'),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Food Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please, enter the name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _urlController,
                            decoration: InputDecoration(labelText: 'Image Url'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please, enter an image URL';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromWidth(100.0))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  name = _nameController.text;
                                  url = _urlController.text;
                                  addFood();
                                  clearData();
                                });
                              }
                            },
                            child: Text('Add')),
                        ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromWidth(100.0))),
                            onPressed: () {
                              clearData();
                              Navigator.of(context);
                            },
                            child: Text('Cancel')),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
