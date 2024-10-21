import 'package:dio/dio.dart';
import 'package:flipmlkitocr/secrets.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


 String api_key = Secrets.groq_api;
String BASE_URL = "https://api.groq.com/openai/v1/chat";
 Map<String, dynamic> DEFAULT_HEADERS = {
  'content-type': 'application/json',
  "Authorization": "Bearer ${api_key}"
};


class Api{
  final Dio _dio = Dio();
  Api(){
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers = DEFAULT_HEADERS;


    _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true)
    );
  }
  Dio get sendRequest => _dio;

}