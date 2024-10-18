import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flipmlkitocr/data/fresh%20model/fresh_model.dart';
import 'package:flipmlkitocr/data/repo/groq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Freshnesspage extends StatefulWidget {
  const Freshnesspage({super.key});

  @override
  State<Freshnesspage> createState() => _FreshnesspageState();
}

class _FreshnesspageState extends State<Freshnesspage> {
  String fruitSummary = '';
  List<String> imagePaths = [];
  List<String> downloadUrls = [];
  List<FreshModel> badModels = [];
  List<FreshModel> freshPredictions = [];
  FreshModel? selectedModel;
  Groq groq = Groq();
  XFile? image;
  String? downloadUrl;
  final textRecognizer = TextRecognizer();
  bool isProcessing = false;
  bool isDone = false;
  bool showData = false;

  void deleteImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      setState(() {
        imagePaths.removeAt(index);
        if (index < downloadUrls.length) {
          downloadUrls.removeAt(index);
          freshPredictions.clear();
          badModels.clear();
          selectedModel = null;
        }
      });
    } else {
      print('Error: Index out of range');
    }
  }

  void resetData() {
    setState(() {
      imagePaths.clear();
      downloadUrls.clear();
      badModels.clear();
      freshPredictions.clear();
      selectedModel = null;
      isProcessing = false;
      setState(() {});
      // productInfos.clear();
      // x = null;
      // product = Product();
    });
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      image = (await picker.pickImage(source: ImageSource.gallery));

      if (image == null) return;

      setState(() {
        imagePaths.add(image!.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<List<String>> _uploadImages(List<String> imagePaths) async {
    List<String> downloadUrls = [];

    for (String path in imagePaths) {
      try {
        // Convert string path to File
        File fileToUpload = File(path);

        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('uploads/${DateTime.now()}.png');
        await storageRef.putFile(fileToUpload);

        // Get download URL
        String downloadUrl = await storageRef.getDownloadURL();
        downloadUrls.add(downloadUrl);
        print('Uploaded: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return downloadUrls;
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
    // Groq groq = Groq();
    // Product prod = await groq.GroqRequest(infotext);
    // log(prod.brand ?? "brandName");
    // ProductInfo sorted = extractProductInfo(infotext);
    // setState(() {
    //   x = sorted;
    //   product = prod;
    //   isProcessing = false;
    // });
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
        title: Text("Fruit Freshness"),
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
                'This page demonstrates the analysis of fruit.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  "Note that the model has been trained on limited fruits as of now, which are Apple, Banana, Guava, Lemon, Lime, Orange, Pomegranate"),
              SizedBox(height: 20),
              Text(
                'Steps:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Upload two or more images of the fruit.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                '2. After uploading, click "Process Image." Please allow a few seconds for the results to appear.',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          onTap: () async {
                            freshPredictions.clear();
                            badModels.clear();
                            selectedModel = null;

                            setState(() {});
                            isDone = true;
                            List<String> downloadUrls =
                                await _uploadImages(imagePaths);
                            print(
                                downloadUrls); // Handle the download URLs as needed
                            for (String down in downloadUrls) {
                              FreshModel fresh = await groq.getPrediction(down);
                              freshPredictions.add(fresh);
                            }
                            isDone = false;
                            showData = true;

                            for (var model in freshPredictions) {
                              if (model.fruitClass != null &&
                                  model.fruitClass!.contains("Bad")) {
                                badModels.add(model);
                              }
                            }

                            // If we found bad models, select the one with the lowest estimatedDays
                            if (badModels.isNotEmpty) {
                              selectedModel = badModels.fold<FreshModel?>(
                                null,
                                (previous, current) {
                                  // Handle null or invalid estimatedDays
                                  int currentEstimatedDays = current
                                          .shelfLife?.estimatedDays
                                          ?.toInt() ??
                                      2147483647; // Use a large number if null
                                  int previousEstimatedDays = previous
                                          ?.shelfLife?.estimatedDays
                                          ?.toInt() ??
                                      2147483647; // Use a large number if null

                                  // Ensure both are valid integers for comparison
                                  return (previous == null ||
                                          currentEstimatedDays <
                                              previousEstimatedDays)
                                      ? current
                                      : previous;
                                },
                              );
                            } else {
                              // If no bad models exist, select the model with the lowest estimatedDays from all models
                              selectedModel =
                                  freshPredictions.fold<FreshModel?>(
                                null,
                                (previous, current) {
                                  // Handle null or invalid estimatedDays
                                  int currentEstimatedDays = current
                                          .shelfLife?.estimatedDays
                                          ?.toInt() ??
                                      2147483647; // Use a large number if null
                                  int previousEstimatedDays = previous
                                          ?.shelfLife?.estimatedDays
                                          ?.toInt() ??
                                      2147483647; // Use a large number if null

                                  // Ensure both are valid integers for comparison
                                  return (previous == null ||
                                          currentEstimatedDays <
                                              previousEstimatedDays)
                                      ? current
                                      : previous;
                                },
                              );
                            }

                            setState(() {});
                          },
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
                  if (isDone) CircularProgressIndicator(),
                  if (showData && selectedModel != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
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
                            _buildProductDetail(
                                'Confidence:',
                                _safeToString(
                                    '${(selectedModel!.confidence!.toDouble() * 100).toStringAsFixed(2)}%')),
                            _buildProductDetail(
                                'Expiry Date:',
                                _safeToString(
                                    selectedModel!.expiryDate.toString())),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Aligns the top of the text
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Fruit Class:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Small space between title and value
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          selectedModel!.fruitClass
                                                  .toString() ??
                                              'N/A',
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (showData && selectedModel != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Shelf Life',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildProductDetail(
                                'Estimated Date:',
                                _safeToString(
                                    selectedModel!.shelfLife!.estimatedDays)),
                            _buildProductDetail(
                                'Refrigerator:',
                                _safeToString(
                                    selectedModel!.shelfLife!.refrigerator)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Aligns the top of the text
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Shelf:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Small space between title and value
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${selectedModel!.shelfLife!.estimatedDays}' ??
                                              'N/A',
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ///info
                ],
              ),
            ],
          ),
        ),
      )),
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

  String? _safeToString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }
}
