import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      // body: Container(
      //   margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      //   padding: EdgeInsets.all(50.0),
      //   color: Colors.grey[400],
      //   child: Text("hello"),
      // ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Text("hello"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('click me'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
