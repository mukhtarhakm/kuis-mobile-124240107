// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:kuis_mobile_124240107/views/home2.dart';
import 'package:kuis_mobile_124240107/views/profile.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int selectedIndex = 0;

  final List<String> titles = ["Home", "Profile"];

  @override
  Widget build(BuildContext context) {
    // Bebas pilih HomePage() (List) atau HomePage2() (Grid) sesuai kebutuhan:
    List<Widget> pages = [const HomePage2(), const ProfilePage()];

    return Scaffold(
      appBar: AppBar(title: Text(titles[selectedIndex])),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
