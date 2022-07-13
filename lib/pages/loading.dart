import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  void getData() async{
    var url = Uri.https('jsonplaceholder.typicode.com', '/todos/1', {'q': '{http}'});

    Response response = await get(url);
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var userId = jsonResponse['userId'];
      print('Number of books about http: $userId.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("Loading screen"),
      ),
    );
  }
}
