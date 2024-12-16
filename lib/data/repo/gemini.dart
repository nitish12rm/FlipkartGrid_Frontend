//toh repository ka kam kya hota h
//basically ye api see data leke model me dal deta h
//toh repository me api--> data--> model --> to be used in the application
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../core/api.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';



class ItenaryRepo {
  final Api _api = Api();



Future<void> _sendImagePrompt(String imgPath) async {
  try {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-8b',
      apiKey: "AIzaSyDeILHP21JmwZNLAGQoUZwYHpnHy1QhQ0Y",
    );
    ByteData catBytes = await rootBundle.load(imgPath);
    String prompt = "tell me the brand of this product";
    final content = [
      Content.multi([
        TextPart(prompt),
        // The only accepted mime types are image/*.
        DataPart('image/jpeg', catBytes.buffer.asUint8List()),

      ])
    ];


    var response = await model.generateContent(content);
    var text = response.text;
  } catch (e) {
    log("error: ${e.toString()}");
  }
}
}