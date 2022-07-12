import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  int counter = 0;

  void getData() async {
    String username = await Future.delayed(Duration(seconds: 3), () {
      print('getData');
      return "tuananh";
    });

    String bio =  await Future.delayed(Duration(seconds: 2), () {
      print('getData 1');
      return "121212";
    });
    print('$username - $bio');

  }

  @override
  void initState() {
    super.initState();
    getData();
    print('initState function ran');
  }

  @override
  Widget build(BuildContext context) {
    print('build function ran');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Location"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: SafeArea(
        child: RaisedButton(
          onPressed: () {
            setState(() {
              counter += 1;
            });
          },
          child: Text('counter is $counter'),
        ),
      ),
    );
  }
}
