import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:proyecto_c1/presentation/blocs/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late StreamSubscription<ConnectivityResult> subscription;
  late String id;
  late String name;
  late String des;

  Future<void> someMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('ehy');
    String? jsonResponse = prefs.getString('response');
    print(jsonResponse);
  }

  @override
  // void initState() {
  //   super.initState();
  //   context.read<PostsBloc>().add(GetPosts());
  // }

  void initState() {
    super.initState();
    someMethod();
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
        context.read<PostsBloc>().add(GetPosts());
      } else {
        const snackBar = SnackBar(
          content: Text(
            'No Hay coneccion',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Loaded) {
          return SingleChildScrollView(
            child: Column(
                children: state.posts.map((post) {
              return Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                color: Colors.black12,
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(post.id.toString()),
                      title: Text(post.name),
                      subtitle: Text(post.des),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print(post.id.toString());
                          },
                          child: Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print('Delete');
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList()),
          );
        } else if (state is Error) {
          return Center(
            child: Text(state.error, style: const TextStyle(color: Colors.red)),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
