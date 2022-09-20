import 'package:dio/dio.dart';
import '../models/config.dart';
import 'package:get_it/get_it.dart';

class HttpService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  HttpService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.coinApiBaseUrl;
  }

  Future<Response?> get(String path) async {
    try {
      String url = '$_base_url$path';
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      print('HttpService: Unable to perform get request');
      print(e);
    }
  }
}
