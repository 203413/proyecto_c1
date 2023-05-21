import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_c1/presentation/pages/posts_page.dart';

import '../../data/datasources/base_url.dart';

class put extends StatefulWidget {
  final String argument;

  put({required this.argument});
  @override
  _putState createState() => _putState();
}

class _putState extends State<put> {
  String inputText1 = '';
  String inputText2 = '';

  void _storeTextInputs() {
    // Aquí puedes almacenar los valores de los inputs en tus variables
    print('Texto 1: $inputText1');
    print('Texto 2: $inputText2');
    print(widget.argument);
  }

  Future getPosts() async {
    //print('DataSource');
    var url = Uri.https(baseurl, '/api/v1/location/${widget.argument}/');
    //var response = await http.get(url);
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: '{"name":"$inputText1","des":"$inputText2"}',
    );
    if (response.statusCode == 200) {
      print('siuuuuuuu');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PostsPage()));
    } else {
      print('oajasjaj');
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    inputText1 = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    inputText2 = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Descripción',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: getPosts,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
