import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yes_no_app/infrastructure/models/joke_model.dart';

class JokeDatasource {
  final _dio = Dio();

  Future<JokeModel> getRandomJoke() async {
    final url = dotenv.env['JOKE_API_URL'] ?? 
        'https://official-joke-api.appspot.com/random_joke';
    final response = await _dio.get(url);
    return JokeModel.fromJson(response.data);
  }
}
