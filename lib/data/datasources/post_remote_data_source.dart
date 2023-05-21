import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostRemoteDataSource {
  // https://jsonplaceholder.typicode.com/posts
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImp implements PostRemoteDataSource {
  @override
  Future<List<PostModel>> getPosts() async {
    //print('DataSource');
    var url = Uri.https(
        'ec07-2806-262-3404-a3-c073-1616-fb58-f546.ngrok-free.app',
        '/api/v1/location/');
    var response = await http.get(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      String jsonResponse = response.body;

      await prefs.setString('response', jsonResponse);

      return convert
          .jsonDecode(response.body)
          .map<PostModel>((data) => PostModel.fromJson(data))
          .toList();
    } else {
      throw Exception();
    }
  }
}
