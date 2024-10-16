import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package

class ProductScreen2 extends StatefulWidget {
  const ProductScreen2({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen2> {
  File? pickedImage; // To store the picked image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  // Function to pick an image
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path); // Store the selected image file
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Product',
          style: GoogleFonts.roboto(),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(500),
              bottomRight: Radius.circular(500)),
          child: Container(
            height: 300,
            width: 600,
            color: Color.fromRGBO(196, 245, 148, 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              // Display the picked image or a placeholder if no image is selected
              pickedImage != null
                  ? Image.file(
                pickedImage!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * .9,
              )
                  : Placeholder(
                fallbackHeight: 200,
                fallbackWidth: MediaQuery.of(context).size.width * .9,
              ),
              Text(
                'Apple',
                style: GoogleFonts.roboto(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                'Fruits',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '₹ 100',
                style: GoogleFonts.roboto(color: Colors.green),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Description',
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                style: GoogleFonts.roboto(fontSize: 15),
                'Apple Mountain works as a seller for many apple growers of apple. apple are easy to spot in your produce aisle. They are just like regular apple, but they will usually have a few more scars on  ReadMore',
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Text color
                      elevation: 5,
                      surfaceTintColor:
                      Colors.transparent, // Optional: Remove elevation
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      foregroundColor: Colors.green,
                      // Optional: Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Optional: Adjust border radius
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      child: Text('Add to Cart'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Text color
                      elevation: 5,
                      surfaceTintColor:
                      Colors.transparent, // Optional: Remove elevation
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      foregroundColor: Colors.white,
                      // Optional: Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Optional: Adjust border radius
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      child: Text('Add to Cart'),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage, // Button to pick image
                child: Text('Pick Image'),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
