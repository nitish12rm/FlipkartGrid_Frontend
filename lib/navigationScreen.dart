import 'package:flipmlkitocr/screens/freshnessPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class Navigationscreen extends StatefulWidget {
  @override
  _NavigationscreenState createState() => _NavigationscreenState();
}

class _NavigationscreenState extends State<Navigationscreen> {
  int _selectedIndex = 0;

  // List of screens
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(title: 'Product Scanner'),
    Freshnesspage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _widgetOptions[_selectedIndex],  // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0XFF900C3F),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bag_fill),
            label: 'Product Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lab_flask_solid),
            label: 'Fruit Freshness',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Screen 1', style: TextStyle(fontSize: 24)),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Screen 2', style: TextStyle(fontSize: 24)),
    );
  }
}
