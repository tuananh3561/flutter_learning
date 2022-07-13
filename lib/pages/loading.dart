import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String time = '';

  void setupWorldTime()  async {
    WorldTime instance = WorldTime(location: 'Berlin', flag: 'garmany.png', url: 'Europe/Berlin');
    await instance.getTime();
    setState((){
      time = instance.time;
    });

    print(instance.time);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupWorldTime();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(time),
        ),
      ),
    );
  }
}
