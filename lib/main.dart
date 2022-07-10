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
        // child: Text(
        //   'hello tuan anh',
        //   style: TextStyle(
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 2.0,
        //     color: Colors.grey,
        //     fontFamily: "IndieFlower",
        //   ),
        // ),
        // child: Image(
        //   // image: NetworkImage("https://upanh123.com/wp-content/uploads/2021/04/anh-dep-tren-mang1.jpg"),
        //   image: AssetImage("assets/space-1.jpg"),
        // ),
        // child: Image.asset('assets/space-3.jpg'),
        // child: Image.network("https://upanh123.com/wp-content/uploads/2021/04/anh-dep-tren-mang1.jpg"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('click me'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
