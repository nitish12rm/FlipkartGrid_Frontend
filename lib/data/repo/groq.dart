import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flipmlkitocr/secrets.dart';
import 'package:flipmlkitocr/core/api.dart';
import 'package:flipmlkitocr/data/fresh%20model/fresh_model.dart';
import 'package:flipmlkitocr/data/model.dart';
import 'package:flipmlkitocr/data/product_model/product_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../contentmodel.dart';



class Groq {
  final Api _api = Api();

  Future<Product> GroqRequest(String speech) async {

    log("entered");
     Map<String, dynamic> body = {
       "messages": [
         {
           "role": "system",
           "content": "You provide answers in JSON schema format that can be parsed immediately in Flutter without any special characters, structured as follows{\"productName\":\"string\",\"brand\":\"string\",\"productType\":\"string\",\"manufactureDate\":\"string\",\"expiryDate\":\"string\",\"size\":\"string\",\"mrp\":\"string\",\"quantity\":\"string\",\"ingredients\":[\"string\"],\"sterilizationMethod\":\"string\",\"directions\":\"string\",\"safetyWarning\":\"string\",\"nutritionalValue\":{\"calories\":\"string\",\"protein\":\"string\",\"carbohydrates\":\"string\",\"sugars\":\"string\",\"fats\":\"string\"},\"manufacturer\":{\"name\":\"string\",\"certifications\":[\"string\"],\"address\":{\"manufacturing\":\"string\",\"registered\":\"string\"},\"contact\":{\"email\":\"string\",\"website\":\"string\",\"customerCareNumber\":\"string\"}}} and never send null values. send NA string instead"
         },
         {
           "role": "user",
           "content": "You’re a knowledgeable product information specialist with extensive experience in detailing various grocery products. Your expertise lies in providing comprehensive and clear descriptions that include all relevant information about each item, ensuring that customers receive the details they need to make informed choices.Your task is to provide the details of the product. Here are the specifications you need to fill out:- ProductName:- Brand:- Type:- Manufacture Date:(Extract the Manufacturing Date (MFG Date) from the raw OCR text, which may appear in various formats such as DD/MM/YYYY (e.g., 15/08/2023), MM/YYYY (e.g., 08/2024), MMM YYYY (e.g., Aug 2024), or MM/DD/YYYY (e.g., 08/15/2023). Look for keywords like MFG, PKD,Manufactured, or Production Date to correctly associate the date with the MFG label. Ensure to handle irregularities such as misrecognized symbols, inconsistent spacing, and variations in the format. If no valid MFG Date is found, output 'NA.')- Expiry Date: (Extract the Expiry Date (EXP Date or UBD) from the raw OCR text. If a Manufacturing Date (MFG Date) is found, consider the context to determine the relevant expiry date, which may include formats such as DD/MM/YYYY, MM/DD/YYYY, YYYY/MM/DD, or variations like MMM YYYY and MM/YYYY. If a Manufacturing Date is not found, apply a more general search for expiry indicators, looking for keywords like EXP, UBD,Expiry, Best Before, and Use By, and extract the date in similar formats. In both cases, ensure to handle irregularities such as misrecognized symbols, varying spacing, and the potential absence of the year, returning the extracted date in a standardized format like 'DD/MM/YYYY' or 'MM/YYYY.' If no valid expiry date is found, output 'MFG + 1 year.')- Size:- MRP:-( Extract the Maximum Retail Price (MRP) in Indian Rupees (INR) from the raw OCR text, where the MRP is defined as a numeric value immediately followed by the currency sign Rs or ₹ and a postfix of either '/-' or '/'; there may be multiple such values present, so ensure to choose the largest valid candidate and format the output as ₹Number; if no valid candidate is found, output 'NA.' Additionally, account for irregularities such as misrecognized symbols (e.g., the rupee symbol being misread as '€' ), variations in the currency sign (e.g., 'Rs' or 'RS'), inconsistent spacing (e.g., '1000/-' vs. '1000 /-'), the presence of commas as thousand separators (e.g., '1,00,000/-'), and the potential absence of the postfix, ensuring accurate identification of candidates based on keywords like MRP or Maximum Retail Price while filtering out invalid or malformed entries. ) Quantity:-(a number postfix with si unit for weight like kg or g or l) Ingredients:- Instructions for Use:- Manufacturer Details:- Customer Care Information:. Keep in mind the major grocery brands commonly available in India, which include Amul, Parle, Patanjali, ITC, Britannia, Dabur, Tata, Haldiram's, Nestle India, MDH, Everest, Ashirvaad, Mother Dairy, Fortune, Kwality Walls, Kissan, Catch, Lijjat, Godrej, Priya, GRB, Rajdhani, Saffola, Sunfeast, Horlicks, Maggi, Bournvita, Complan, Rin, Surf Excel, Tide, Vim, Tropicana, Real, Frooti, Slice, Paper Boat, Bikano, Chitale, Nandini, Annapurna, Ruchi, Harpic, Lizol, Colgate, Closeup, Flipkart grocery, Pepsodent, Lux, Dove, Lifebuoy, Pears, Dettol, Savlon, Nivea, Himalaya, Vicco, Boroline, Hamdard, Fevicol, MTR, Priya Gold, Rooh Afza, Safal, Madhur, Sugar Free, Dalda, Dhara, Dukes, Nutrela, Weikfield, Gits, Eastern, KPL Shudhi, Double Horse, Aachi, Nirapara, Tops, Mother's Recipe, Ching's Secret, Smith & Jones, Tata Salt, Sundrop, Act II, Veetee, Heritage, Santoor, Vivel, Medimix, Himalaya Herbals, Kama Sutra, Fogg, Wild Stone, Set Wet, Park Avenue, Old Spice, Cinthol, Godrej No 1, Shakti Bhog, Kohinoor, Daawat, India Gate, Nature Fresh, and Golden Harvest.you can also fix spelling mistakes in the content. the raw data is\"${speech}\""
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
  Future<String> GroqRequestPredicSummary(String fruitRaw) async {

    log("entered");
    Map<String, dynamic> body = {
      "messages": [
        {
          "role": "system",
          "content": "provide output in string"
        },
        {
          "role": "user",
          "content": "You are a fruit specialist and have been working as a food inspector defining the freshness and the shelf life of the fruit please consider the given parameter and provide a breif summary detaling the information in human readable sentence\"${fruitRaw}\""
        }
      ],
      "model": "llama3-70b-8192",
      "temperature": 1,
      "max_tokens": 1024,
      "top_p": 1,
      "stream": false,
      "response_format": {
        "type": "string"
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
    String fuitSummary = json.decode(geoResponse.choices![0].message!.content.toString());


    return fuitSummary;
  }
  Future<FreshModel> getPrediction(String imageUrl) async {
    Dio dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true)
    );

    try {
      // Create form data
      FormData formData = FormData.fromMap({
        'image_url': imageUrl,  // Set your image URL here
      });

      // Make the request
      final response = await dio.post(
        Secrets.aws_api,
        data: formData,
      );

      // Check the response and convert to your model
      if (response.statusCode == 200) {
        print("jkshdkj");
        return FreshModel.fromJson(response.data); // Assuming you have a fromJson method
      } else {
        throw Exception('Failed to load prediction');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error making request: $e');
    }
  }

}