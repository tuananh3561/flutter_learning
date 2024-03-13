import 'package:flutter/material.dart';

class DemoScaffoldMessenger extends StatelessWidget {
  const DemoScaffoldMessenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScaffoldMessenger Demo'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                const snackBar = SnackBar(
                  content: Text('A SnackBar has been shown.'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Show SnackBar'),
            ),
          );
        }),
      ),
    );
  }
}
