import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:proyecto_c1/presentation/blocs/posts_bloc.dart';
import 'package:proyecto_c1/presentation/pages/posts_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsPageOff extends StatefulWidget {
  const PostsPageOff({super.key});

  @override
  State<PostsPageOff> createState() => _PostsPageOffState();
}

class _PostsPageOffState extends State<PostsPageOff> {
  late StreamSubscription<ConnectivityResult> subscription;

  // Future<void> someMethod() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print('ehy');
  //   String? jsonResponse = prefs.getString('response');
  //   if (jsonResponse != null) {
  //     // Map<String, dynamic> data = jsonDecode(jsonResponse);
  //     // id = data['id'];
  //     // name = data['name'];
  //     // des = data['des'];
  //     print(jsonResponse);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PostsPage()));
        // context.read<PostsBloc>().add(GetPosts());
      } else {
        const snackBar = SnackBar(
          content: Text(
            'Local',
            style: TextStyle(),
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Offline'),
      ),
    );
  }
}
