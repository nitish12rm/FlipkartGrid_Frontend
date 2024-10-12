import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


const String api_key = "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";
String BASE_URL = "https://api.groq.com/openai/v1/chat";
const Map<String, dynamic> DEFAULT_HEADERS = {
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