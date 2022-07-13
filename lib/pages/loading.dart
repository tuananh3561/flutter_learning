import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  void getTime() async{
    var url = Uri.https('worldtimeapi.org', '/api/timezone/Europe/London', {'q': '{http}'});

    // make the request
    Response response = await get(url);
    if (response.statusCode == 200) {
      Map jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      //get properties from data
      String datetime = jsonResponse['datetime'];
      String offset = jsonResponse['utc_offset'].substring(1,3);
      //create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      print(now);

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime();
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
