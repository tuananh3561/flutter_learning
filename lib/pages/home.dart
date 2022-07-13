import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    print(args);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/location");
              },
              icon: Icon(Icons.edit_location),
              label: Text('edit location'),
            ),
          ],
        ),
      ),
    );
  }
}
