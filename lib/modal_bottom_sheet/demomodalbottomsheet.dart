import 'package:flutter/material.dart';
import 'package:flutter_learning/modal_bottom_sheet/Infoscreen.dart';

class DemoModalBottomSheet extends StatefulWidget {
  const DemoModalBottomSheet({super.key});

  @override
  State<DemoModalBottomSheet> createState() => _DemoModalBottomSheetState();
}

class _DemoModalBottomSheetState extends State<DemoModalBottomSheet> {
  void _openIconBottomPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const InfoScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('App Bar'),
        actions: [
          IconButton(
            onPressed: _openIconBottomPressed,
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home screen',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
