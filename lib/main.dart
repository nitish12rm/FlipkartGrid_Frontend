
import 'dart:developer';
import 'dart:io';

import 'package:flipmlkitocr/data/product_model/product_model.dart';
import 'package:flipmlkitocr/data/repo/groq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Product Scanner'),
    );
  }
}

class ProductInfo {
  final String? brand;
  final String? productType;
  final String? expiryDate;
  final String? rawText;
  final String? size;
  final String? mrp;
  final String? weight;

  ProductInfo({this.brand, this.productType, this.expiryDate, this.rawText, this.size, this.mrp, this.weight});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Product product = Product();
  List<String> imagePaths = [];
  List<ProductInfo> productInfos = [];
  ProductInfo? x;

  final textRecognizer = TextRecognizer();
  bool isProcessing = false;

  void deleteImage(int index) {
    setState(() {
      imagePaths.removeAt(index);
    });
  }

  void resetData() {
    setState(() {
      imagePaths.clear();
      productInfos.clear();
      x = null;
      product = Product();
    });
  }

  // Helper method to safely convert dynamic to String
  String? _safeToString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }


  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        imagePaths.add(image.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> processImages() async {
    setState(() {
      isProcessing = true;
    });
    String infotext = "";
    for (String imagePath in imagePaths) {
      try {
        final inputImage = InputImage.fromFilePath(imagePath);
        final RecognizedText result = await textRecognizer.processImage(
            inputImage);

        final ImageLabelerOptions options = ImageLabelerOptions(
            confidenceThreshold: 0.8);
        final imageLabeler = ImageLabeler(options: options);
        final List<ImageLabel> labels = await imageLabeler.processImage(
            inputImage);

        String labelText = labels.map((label) => label.label).join(" ");

        // Process the recognized text
        infotext = infotext + " " + (result.text + " " + labelText);

        setState(() {
          infotext;
        });
      } catch (e) {
        print('Error processing image: $e');
      }
    }
    Groq groq = Groq();
    Product prod = await groq.GroqRequest(infotext);
    log(prod.brand ?? "brandName");
    ProductInfo sorted = extractProductInfo(infotext);
    setState(() {
      x = sorted;
      product = prod;
      isProcessing = false;
    });
  }

  ProductInfo extractProductInfo(String text) {
    String? brand;
    String? productType;
    String? expiryDate;
    String? size;
    String? mrp;
    String? weight;

    return ProductInfo(
      brand: brand,
      productType: productType,
      expiryDate: expiryDate,
      rawText: text,
      size: size,
      mrp: mrp,
      weight: weight,
    );
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.delete),
            onPressed: resetData,
            tooltip: 'Reset All Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Add Image'),
              ),
              SizedBox(height: 20),
              Text('Selected Images: ${imagePaths.length}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: imagePaths.isNotEmpty ? processImages : null,
                child: Text('Process Images'),
              ),
              SizedBox(height: 20),
              if (isProcessing)
                CircularProgressIndicator()
              else
                if (imagePaths.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.file(
                            File(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: -5,
                           right:30,
                            child: Center(
                              child: IconButton(
                                icon: Icon(CupertinoIcons.delete, color: Colors.red),
                                onPressed: () => deleteImage(index),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              SizedBox(height: 20),
              if (isProcessing)
                CircularProgressIndicator()
              else
                if (product != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Information',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 16),
                          _buildProductDetail(
                              'Product Name:', _safeToString(product
                              .productName)),
                          _buildProductDetail('Brand:', _safeToString(product
                              .brand)),
                          _buildProductDetail('Type:', _safeToString(product
                              .productType)),
                          _buildProductDetail(
                              'Manufacture Date:', _safeToString(product
                              .manufactureDate)),
                          _buildProductDetail(
                              'Expiry Date:', _safeToString(product
                              .expiryDate)),
                          _buildProductDetail('Size:', _safeToString(product
                              .size)),
                          _buildProductDetail('MRP:', _safeToString(product
                              .mrp)),
                          _buildProductDetail('Quantity:', _safeToString(product
                              .quantity)),
                          _buildProductDetail(
                              'Ingredients:', _safeToString(product
                              .ingredients)),
                          _buildProductDetail(
                              'Sterilization Method:', _safeToString(product
                              .sterilizationMethod)),
                          _buildProductDetail(
                              'Directions:', _safeToString(product.directions)),
                          _buildProductDetail(
                              'Safety Warning:', _safeToString(product
                              .safetyWarning)),

                          SizedBox(height: 24),

                          Text(
                            'Nutritional Value',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          _buildProductDetail('Calories:', _safeToString(product
                              .nutritionalValue?.calories)),
                          _buildProductDetail('Protein:', _safeToString(product
                              .nutritionalValue?.protein)),
                          _buildProductDetail(
                              'Carbohydrates:', _safeToString(product
                              .nutritionalValue?.carbohydrates)),
                          _buildProductDetail('Sugars:', _safeToString(product
                              .nutritionalValue?.sugars)),
                          _buildProductDetail('Fats:', _safeToString(product
                              .nutritionalValue?.fats)),

                          SizedBox(height: 24),

                          Text(
                            'Manufacturer Information',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          _buildProductDetail('Name:', _safeToString(product
                              .manufacturer?.name)),
                          _buildProductDetail(
                              'Certifications:', _safeToString(product
                              .manufacturer?.certifications)),
                          _buildProductDetail(
                              'Address:', 'Manufacturing: ${_safeToString(
                              product.manufacturer?.address
                                  ?.manufacturing)}, Registered: ${_safeToString(
                              product.manufacturer?.address?.registered)}'),

                          SizedBox(height: 24),

                          Text(
                            'Contact Information',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          _buildProductDetail('Email:', _safeToString(product
                              .manufacturer?.contact?.email)),
                          _buildProductDetail('Website:', _safeToString(product
                              .manufacturer?.contact?.website)),
                          _buildProductDetail(
                              'Customer Care Number:', _safeToString(product
                              .manufacturer?.contact?.customerCareNumber)),

                          if (x != null && x!.rawText != null) ...[
                            Divider(),
                            SizedBox(height: 8),
                            Text(
                              "Raw Data",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(x!.rawText!,
                                style: TextStyle(color: Colors.black)),
                          ],
                        ],
                      ),
                    ),
                  )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Pick Image',
        child: const Icon(CupertinoIcons.camera),
      ),
    );
  }

  Widget _buildProductDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: title,
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            TextSpan(text: ' ${value ?? 'N/A'}',
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

// Widget _buildProductDetail(String title, String? value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical padding for spacing
//     child: RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(text: title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
//           TextSpan(text: ' $value', style: TextStyle(fontSize: 16, color: Colors.black)),
//         ],
//       ),
//     ),
//   );
// }
}