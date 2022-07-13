import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  late String location; // location name for the UI
  late String time; // the time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint
  bool isDayTime = false; // true or false if daytime or not

  WorldTime(
      {required this.location,
      required this.flag,
      required this.url}); // location url for api

  Future<void> getTime() async {
    try {
      Uri urlTimezone =
          Uri.https('worldtimeapi.org', '/api/timezone/$url', {'q': '{http}'});

      // make the request
      Response response = await get(urlTimezone);
      if (response.statusCode == 200) {
        Map jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        //get properties from data
        String datetime = jsonResponse['datetime'];
        String offset = jsonResponse['utc_offset'].substring(1, 3);
        //create DateTime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));

        //set the time property
        isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('caught error: $e.');
      time = 'could not get time data';
    }
  }
}
