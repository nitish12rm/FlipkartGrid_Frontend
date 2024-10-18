import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipmlkitocr/data/product_model/product_model.dart';
import 'package:flipmlkitocr/data/repo/groq.dart';
import 'package:flipmlkitocr/prod.dart';
import 'package:flipmlkitocr/screens/SplashScreen.dart';
import 'package:flipmlkitocr/screens/freshnessPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';
import 'navigationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Scanner',

      // home: const MyHomePage(title: 'Product Scanner'),
      home: Splash(),
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

  ProductInfo(
      {this.brand,
      this.productType,
      this.expiryDate,
      this.rawText,
      this.size,
      this.mrp,
      this.weight});
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
      isProcessing = false;
    });
  }

  // Helper method to safely convert dynamic to String
  String? _safeToString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  Future<void> exportProductToCSV() async {
    var status = await Permission.storage.request();

    if (status.isDenied) {
      // Handle the case when permission is denied
      print("Storage permission denied");
      return;
    } else if (status.isPermanentlyDenied) {
      // Permissions can be permanently denied, handle that case
      print(
          "Storage permission permanently denied. Please allow it from settings.");
      openAppSettings(); // Optionally redirect to app settings
      return;
    }

    if (product.productName == null) {
      print("No product information available to export.");
      return;
    }

    // Prepare data for CSV
    List<List<dynamic>> rows = [
      ["Field", "Value"], // Header
      ["Product Name", product.productName],
      ["Brand", product.brand],
      ["Type", product.productType],
      ["Manufacture Date", product.manufactureDate],
      ["Expiry Date", product.expiryDate],
      ["Size", product.size],
      ["MRP", product.mrp],
      ["Quantity", product.quantity],
      ["Ingredients", product.ingredients],
      ["Sterilization Method", product.sterilizationMethod],
      ["Directions", product.directions],
      ["Safety Warning", product.safetyWarning],
      ["Calories", product.nutritionalValue?.calories],
      ["Protein", product.nutritionalValue?.protein],
      ["Carbohydrates", product.nutritionalValue?.carbohydrates],
      ["Sugars", product.nutritionalValue?.sugars],
      ["Fats", product.nutritionalValue?.fats],
      ["Manufacturer Name", product.manufacturer?.name],
      ["Certifications", product.manufacturer?.certifications],
      ["Manufacturing Address", product.manufacturer?.address?.manufacturing],
      ["Registered Address", product.manufacturer?.address?.registered],
      ["Email", product.manufacturer?.contact?.email],
      ["Website", product.manufacturer?.contact?.website],
      [
        "Customer Care Number",
        product.manufacturer?.contact?.customerCareNumber
      ],
    ];

    String csv = const ListToCsvConverter().convert(rows);

    // Define the path to the custom directory
    String customPath = "/storage/emulated/0/productCsv";

    // Create the custom directory if it doesn't exist
    Directory customDirectory = Directory(customPath);
    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    // Specify the path for the CSV file
    String path = "$customPath/product_info.csv";

    // Write the CSV file
    File file = File(path);
    await file.writeAsString(csv);
    print("CSV file saved at: $path");
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
        final RecognizedText result =
            await textRecognizer.processImage(inputImage);

        final ImageLabelerOptions options =
            ImageLabelerOptions(confidenceThreshold: 0.8);
        final imageLabeler = ImageLabeler(options: options);
        final List<ImageLabel> labels =
            await imageLabeler.processImage(inputImage);

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

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back), // You can customize the icon here
          onPressed: () {
            Navigator.pop(context); // Handles back navigation
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color(0XFF900C3F),
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This page demonstrates the extraction of key details from grocery product.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "For better accuracy, take a closer picture of product",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Steps:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Upload one or more images of the product.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  '2. After uploading, click "Process Image." Please allow a few seconds for the results to appear.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ///Pictures
                    Visibility(
                      visible: imagePaths.isNotEmpty,
                      child: CarouselSlider.builder(
                        itemCount: imagePaths.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height *
                              .30, // Adjust height if needed
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Stack(
                            children: [
                              Image.file(
                                File(imagePaths[index]),
                                fit: BoxFit.fitHeight,
                                width: double.infinity,
                              ),
                              Positioned(
                                top: -5,
                                right: 110,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(CupertinoIcons.delete,
                                        color: Colors.red),
                                    onPressed: () => deleteImage(index),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imagePaths.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => setState(() {
                            _currentIndex = entry.key;
                          }),
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == entry.key
                                  ? Color(
                                      0XFF900C3F) // Selected page indicator color
                                  : Colors
                                      .grey, // Unselected page indicator color
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          child: InkWell(
                            onTap: pickImage,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0XFFFFFC300),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Text(
                                  "Add Image",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          child: InkWell(
                            onTap: imagePaths.isNotEmpty ? processImages : null,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: imagePaths.isEmpty
                                      ? Color(0XFFFF9E79F)
                                      : Color(0XFFFFFC300),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Text(
                                  'Process Images',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text('Selected Images: ${imagePaths.length}'),
                    SizedBox(height: 20),

                    if (isProcessing) CircularProgressIndicator(),

                    Visibility(
                        visible: product.productName != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Product Information',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildProductDetail('Product Name:',
                                      _safeToString(product.productName)),
                                  _buildProductDetail(
                                      'Brand:', _safeToString(product.brand)),
                                  _buildProductDetail('Type:',
                                      _safeToString(product.productType)),
                                  _buildProductDetail('Manufacture Date:',
                                      _safeToString(product.manufactureDate)),
                                  _buildProductDetail('Expiry Date:',
                                      _safeToString(product.expiryDate)),
                                  _buildProductDetail(
                                      'Size:', _safeToString(product.size)),
                                  _buildProductDetail(
                                      'MRP:', _safeToString(product.mrp)),
                                  _buildProductDetail('Quantity:',
                                      _safeToString(product.quantity)),
                                  _buildProductDetail('Ingredients:',
                                      _safeToString(product.ingredients)),
                                  _buildProductDetail(
                                      'Sterilization Method:',
                                      _safeToString(
                                          product.sterilizationMethod)),
                                  _buildProductDetail('Directions:',
                                      _safeToString(product.directions)),
                                  _buildProductDetail('Safety Warning:',
                                      _safeToString(product.safetyWarning)),
                                ],
                              ),
                            ),
                          ),
                        )),
                    Visibility(
                        visible: product.productName != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Nutritional Value',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildProductDetail(
                                      'Calories:',
                                      _safeToString(
                                          product.nutritionalValue?.calories)),
                                  _buildProductDetail(
                                      'Protein:',
                                      _safeToString(
                                          product.nutritionalValue?.protein)),
                                  _buildProductDetail(
                                      'Carbohydrates:',
                                      _safeToString(product
                                          .nutritionalValue?.carbohydrates)),
                                  _buildProductDetail(
                                      'Sugars:',
                                      _safeToString(
                                          product.nutritionalValue?.sugars)),
                                  _buildProductDetail(
                                      'Fats:',
                                      _safeToString(
                                          product.nutritionalValue?.fats)),
                                ],
                              ),
                            ),
                          ),
                        )),
                    Visibility(
                        visible: product.productName != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Manufacturer Information',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildProductDetail(
                                      'Name:',
                                      _safeToString(
                                          product.manufacturer?.name)),
                                  _buildProductDetail(
                                      'Certifications:',
                                      _safeToString(product
                                          .manufacturer?.certifications)),
                                  _buildProductDetail('Address:',
                                      'Manufacturing: ${_safeToString(product.manufacturer?.address?.manufacturing)}, Registered: ${_safeToString(product.manufacturer?.address?.registered)}'),

                                  SizedBox(height: 24),

                                  // if (x != null && x!.rawText != null) ...[
                                  //   Divider(),
                                  //   SizedBox(height: 8),
                                  //   Text(
                                  //     "Raw Data",
                                  //     style: TextStyle(fontWeight: FontWeight.bold,
                                  //         color: Colors.black),
                                  //   ),
                                  //   Text(x!.rawText!,
                                  //       style: TextStyle(color: Colors.black)),
                                  // ],
                                ],
                              ),
                            ),
                          ),
                        )),
                    Visibility(
                        visible: product.productName != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Contact Information',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildProductDetail(
                                      'Email:',
                                      _safeToString(product
                                          .manufacturer?.contact?.email)),
                                  _buildProductDetail(
                                      'Website:',
                                      _safeToString(product
                                          .manufacturer?.contact?.website)),
                                  _buildProductDetail(
                                      'Customer Care Number:',
                                      _safeToString(product.manufacturer
                                          ?.contact?.customerCareNumber)),

                                  // if (x != null && x!.rawText != null) ...[
                                  //   Divider(),
                                  //   SizedBox(height: 8),
                                  //   Text(
                                  //     "Raw Data",
                                  //     style: TextStyle(fontWeight: FontWeight.bold,
                                  //         color: Colors.black),
                                  //   ),
                                  //   Text(x!.rawText!,
                                  //       style: TextStyle(color: Colors.black)),
                                  // ],
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: product.productName!=null? InkWell(
      //   onTap: exportProductToCSV,
      //   child: Container(decoration: BoxDecoration(color: Color(0XFF900C3F),borderRadius: BorderRadius.circular(5)),child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
      //     child: Text("Export to CSV",style: TextStyle(color: Colors.white),),
      //   ),),
      // ):Container(),
    );
  }

  Widget _buildProductDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns the top of the text
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 10), // Small space between title and value
              Expanded(
                flex: 3,
                child: Text(
                  value ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                  softWrap:
                      true, // Ensures the text wraps onto the next line if needed
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.0,
          ),
        ],
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
