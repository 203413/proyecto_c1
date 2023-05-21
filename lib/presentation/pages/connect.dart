import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:proyecto_c1/presentation/pages/posts_page.dart';
import 'package:proyecto_c1/presentation/pages/posts_page_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  late StreamSubscription<ConnectivityResult> subscription;

  Future<List<dynamic>> getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonResponse = prefs.getString('response');
    if (jsonResponse != null) {
      return json.decode(jsonResponse);
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        const snackBar = SnackBar(
          content: Text(
            'Hay coneccion',
            style: TextStyle(),
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PostsPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline')),
      body: FutureBuilder<List<dynamic>>(
        future: getSavedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available');
          } else {
            final dataList = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: dataList!.map((data) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    color: Colors.black12,
                    child: ListTile(
                      leading: Text(data['id'].toString()),
                      title: Text(data['name']),
                      subtitle: Text(data['des']),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
