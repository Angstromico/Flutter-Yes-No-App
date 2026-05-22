import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class YesNoDatasource {
  final _dio = Dio();

  Future<YesNoModel> getAnswer() async {
    final url = dotenv.env['YES_NO_API_URL'] ?? 'https://yesno.wtf/api';
    final response = await _dio.get(url);
    return YesNoModel.fromJson(response.data);
  }
}
