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
      body: Center(
        // child: Icon(
        //   Icons.ac_unit,
        //   color: Colors.red,
        //   size: 50.0,
        // ),
        // child: RaisedButton(
        //   onPressed: () {},
        //   child: Text("Click me"),
        //   color: Colors.lightBlue,
        // ),
        // child: FlatButton(
        //   onPressed: () {
        //     print("you click me");
        //   },
        //   child: Text("Click me"),
        //   color: Colors.lightBlue,
        // ),
        // child: RaisedButton.icon(
        //   onPressed: () {
        //     print("you click me");
        //   },
        //   icon: Icon(Icons.mail),
        //   label: Text("click me"),
        //   color: Colors.lightBlue,
        // ),
        child: IconButton(
          onPressed: () {
            print("you click me");
          },
          icon: Icon(Icons.mail),
          color: Colors.lightBlue,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('click me'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
