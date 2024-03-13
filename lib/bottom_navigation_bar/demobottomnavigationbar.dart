import 'package:flutter/material.dart';

class DemoBottomNavigationBar extends StatefulWidget {
  const DemoBottomNavigationBar({super.key});

  @override
  State<DemoBottomNavigationBar> createState() =>
      _DemoBottomNavigationBarState();
}

class _DemoBottomNavigationBarState extends State<DemoBottomNavigationBar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = const <Widget>[
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Container(
          child: Image.network(
            "https://www.pngall.com/wp-content/uploads/12/Illustration-PNG.png",
            width: 350,
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Center(
        child: Container(
          child: Image.network(
            "https://www.pngall.com/wp-content/uploads/12/Illustration-PNG-Cutout.png",
            width: 350,
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Container(
          child: Image.network(
            "https://www.pngall.com/wp-content/uploads/12/Illustration-PNG-Image.png",
            width: 350,
          ),
        ),
      ),
    );
  }
}
