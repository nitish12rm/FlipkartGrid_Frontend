import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '',
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
              Image.asset(
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * .9,
                'assets/apples.png',
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
              )
            ],
          ),
        ),
      ]),
    );
  }
}
