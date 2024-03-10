import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DemoGoogleFonts extends StatelessWidget {
  const DemoGoogleFonts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'SPACE INVADERS',
              style: GoogleFonts.pressStart2p(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              'ENTER A COIN TO PLAY',
              style: GoogleFonts.pressStart2p(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
