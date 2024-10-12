import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flipmlkitocr/core/api.dart';
import 'package:flipmlkitocr/data/model.dart';
import 'package:flipmlkitocr/data/product_model/product_model.dart';

import '../contentmodel.dart';



class Groq {
  final Api _api = Api();

  Future<Product> GroqRequest(String speech) async {

    log("entered");
     Map<String, dynamic> body = {
       "messages": [
         {
           "role": "system",
           "content": "You provide answers in JSON schema format that can be parsed immediately in Flutter without any special characters, structured as follows{\"productName\":\"string\",\"brand\":\"string\",\"productType\":\"string\",\"manufactureDate\":\"string\",\"expiryDate\":\"string\",\"size\":\"string\",\"mrp\":\"string\",\"quantity\":\"string\",\"ingredients\":[\"string\"],\"sterilizationMethod\":\"string\",\"directions\":\"string\",\"safetyWarning\":\"string\",\"nutritionalValue\":{\"calories\":\"string\",\"protein\":\"string\",\"carbohydrates\":\"string\",\"sugars\":\"string\",\"fats\":\"string\"},\"manufacturer\":{\"name\":\"string\",\"certifications\":[\"string\"],\"address\":{\"manufacturing\":\"string\",\"registered\":\"string\"},\"contact\":{\"email\":\"string\",\"website\":\"string\",\"customerCareNumber\":\"string\"}}}"
         },
         {
           "role": "user",
           "content": "Provide the details of the product including the name, brand, type, manufacture date, expiry date, size, MRP, quantity, ingredients, instructions for use, manufacturer details, and customer care information.. the raw data is.\"${speech}\""
         }
       ],
       "model": "llama3-70b-8192",
       "temperature": 1,
       "max_tokens": 1024,
       "top_p": 1,
       "stream": false,
       "response_format": {
         "type": "json_object"
       },
       "stop": null
     }

    ;
    Response response = await _api.sendRequest.post("/completions",
        data: body
    );
    print("respnse data");
    print(response.data);
    String content = response.data['choices'][0]['message']['content'];

    Map<String, dynamic> decodedContent = jsonDecode(content);
    print(decodedContent);

    GroqModel geoResponse = GroqModel.fromJson(response.data);
    print("groqresp");
    print(geoResponse.choices![0].message!.content);
    Map<String, dynamic> jsonMap = json.decode(geoResponse.choices![0].message!.content.toString());

    // Create GeoResponse object from JSON
    // GeoResponse gr = GeoResponse.fromJson(jsonMap);
    Product product = Product.fromJson(jsonMap);


    // Print GeoResponse object
   print(product.brand);
    return product;
  }
}