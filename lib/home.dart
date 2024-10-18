import 'package:flipmlkitocr/main.dart';
import 'package:flipmlkitocr/screens/freshnessPage.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF900C3F),
        title: Text('Flipkart GRID 6.0',
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(
                    'Track: ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                Text(
                  'Robotics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(
                    'Theme: ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Smart Vision Technology Quality Control',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(
                    'Team Name: ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                Text(
                  'Abyss',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(
                    'Team Members: ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Nitish Kumar Gupta, Shashwat Srivastav, Shiven Upadhayay, Anushka Gupta, Divyansh Vishwakarma ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(title: "Product Detail")));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            color: Color(0XFFFFFC300),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Center(
                              child: Text(
                                'OCR',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Product Detail, MRP, Expiry Date, Brand Name',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20), // Spacing between buttons
                // Vertical Divider
                Column(
                  children: [
                    Container(
                      width: 2,
                      height: 100, // Adjust the height as needed
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
                SizedBox(width: 20), // Spacing between buttons
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Action for Freshness button
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Freshnesspage()));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            color: Color(0XFFFFFC300),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Center(
                              child: Text(
                                'Freshness',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Freshness\n',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
