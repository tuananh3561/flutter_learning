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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("hello word"),
          FlatButton(
            onPressed: () {},
            child: Text("click me"),
            color: Colors.red,
          ),
          Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.all(10.0),
            child: Text("inside container"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('click me'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
