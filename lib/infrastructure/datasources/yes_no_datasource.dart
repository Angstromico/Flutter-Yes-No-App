import 'package:dio/dio.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class YesNoDatasource {
  final _dio = Dio();

  Future<YesNoModel> getAnswer() async {
    final response = await _dio.get('https://yesno.wtf/api');
    return YesNoModel.fromJson(response.data);
  }
}
