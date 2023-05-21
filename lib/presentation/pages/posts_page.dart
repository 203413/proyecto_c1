import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_c1/data/datasources/base_url.dart';

import 'package:proyecto_c1/presentation/blocs/posts_bloc.dart';
import 'package:proyecto_c1/presentation/pages/add.dart';
import 'package:proyecto_c1/presentation/pages/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    context.read<PostsBloc>().add(GetPosts());
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        put(argument: post.id.toString())));
                          },
                          child: Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print('Delete');
                            delete(post.id.toString());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => add()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future delete(String id) async {
    var url = Uri.https(baseurl, '/api/v1/location/$id/');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Datos eliminados exitosamente');
      context.read<PostsBloc>().add(GetPosts());
    } else {
      print(
          'Error al eliminar los datos. Código de estado: ${response.statusCode}');
    }
  }
}
