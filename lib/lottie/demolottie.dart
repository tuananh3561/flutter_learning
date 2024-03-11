import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DemoLottie extends StatelessWidget {
  const DemoLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Load a Lottie file from your assets
          Lottie.asset('assets/Animation - 1710139194731.json'),

          // Load a Lottie file from a remote url
          Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),

          // Load an animation and its images from a zip file
          // Lottie.asset(
          //   'assets/Animation - 1710139194731.lottie',
          // ),
          Lottie.network(
            'https://telegram.org/file/464001484/1/bzi7gr7XRGU.10147/815df2ef527132dd23',
            decoder: LottieComposition.decodeGZip,
          ),
          Lottie.asset(
            'assets/Animation - 1710139194731.lottie',
            decoder: LottieComposition.decodeGZip,
          )
        ],
      ),
    );
  }

  // Future<LottieComposition?> customDecoder(List<int> bytes) {
  //   return LottieComposition.decodeZip(bytes, filePicker: (files) {
  //     return files.firstWhereOrNull(
  //         (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
  //   });
  // }
}
