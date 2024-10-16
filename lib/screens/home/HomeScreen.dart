import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flipmlkitocr/screens/product/ProductScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<String>> categories = [
    ['Fruits', 'assets/fruits.png'],
    ['Meat', 'assets/meat.png'],
    ['Chips', 'assets/chips.png'],
    ['Bakery', 'assets/bakery.png'],
    ['Meat', 'assets/meat.png'],
    ['Chips', 'assets/chips.png'],
    ['Bakery', 'assets/bakery.png']
  ];
  List<List<dynamic>> products = [
    ['Apple', 100, '1kg', 'assets/apple.png'],
    ['Pineapple', 120, '1.5kg', 'assets/pineapple.png'],
    ['Pomegranate', 150, '2kg', 'assets/pomegranate.png'],
    ['Orange', 200, '1kg', 'assets/orange.png'],
    ['Apple', 100, '1kg', 'assets/apple.png'],
    ['Pineapple', 120, '1.5kg', 'assets/pineapple.png'],
    ['Pomegranate', 150, '2kg', 'assets/pomegranate.png'],
    ['Orange', 200, '1kg', 'assets/orange.png']
  ];
  final TextEditingController searchController = TextEditingController();
  Widget categoryItem(List<String> item) {
    return Container(
      width: 90,
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                fit: BoxFit.cover,
                width: 60,
                item[1],
              ),
            ),
            Text(item[0]),
          ]),
    );
  }

  Widget product(List<dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductScreen()));
      },
      child: Container(
        width: 90,
        alignment: Alignment.center,
        child: Card(
          elevation: 3,
          surfaceTintColor: Colors.transparent,
          color: Colors.white,
          shadowColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * .45,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(20)),
                        child: Container(
                          color: Color.fromRGBO(254, 288, 288, .1),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5, bottom: 5),
                            child: Text(
                              '-15%',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.heart_broken_outlined,
                          color: Color.fromRGBO(184, 186, 187, 1),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Image.asset(
                      item[3],
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width * .35,
                      height: MediaQuery.of(context).size.width * .30,
                    ),
                  ),
                  Text(
                    '₹ ${item[1]}',
                    style: GoogleFonts.roboto(color: Colors.green),
                  ),
                  Text(
                    item[0],
                    style: GoogleFonts.roboto(fontSize: 23),
                  ),
                  Text(
                    item[2],
                    style: GoogleFonts.roboto(color: Colors.grey),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.green, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Add to cart',
                              style: GoogleFonts.roboto(
                                  color: Colors.green, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Container(
                                    height: 40,
                                    color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        color: Colors.white,
                                        Icons.shopping_bag_outlined,
                                        size: 30,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.asset(
              'assets/user.avif',
              filterQuality: FilterQuality.low,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello chegue! \nWhat are you looking for ?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 16,
                ),
                SearchBar(
                  leading: Icon(Icons.search),
                  controller: searchController,
                  surfaceTintColor:
                      MaterialStatePropertyAll<Color>(Colors.transparent),
                  shadowColor: MaterialStatePropertyAll<Color>(Colors.white),
                  elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                    return 1.0; // Same here; customize if you want different elevation for different states
                  }),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
                  hintText: 'Search Keywords...',
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromRGBO(244, 255, 249, 1)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return categoryItem(categories[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Featured Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .63, // Adjust aspect ratio if needed
                        crossAxisSpacing: 8.0, // Space between columns
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) =>
                          product(products[index])),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(),
    );
  }
}
