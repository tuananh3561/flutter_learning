// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ItemWidget {
  String name;
  Function onTap;

  ItemWidget({required this.name, required this.onTap});
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  List listWidget = [
    ItemWidget(
      name: 'Item 1',
      onTap: () {
        print('Item 1');
      },
    ),
    ItemWidget(
      name: 'Item 2',
      onTap: () {
        print('Item 2');
      },
    ),
    ItemWidget(
      name: 'Item 3',
      onTap: () {
        print('Item 3');
      },
    ),
    ItemWidget(
      name: 'Item 4',
      onTap: () {
        print('Item 4');
      },
    ),
    ItemWidget(
      name: 'Item 5',
      onTap: () {
        print('Item 5');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          title: Text(
            "Widget",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: listWidget.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: listWidget[index].onTap,
              child: Card(
                color: Colors.deepPurple[300],
                shadowColor: Colors.deepPurple[500],
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: Text(
                    listWidget[index].name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
