import 'package:flappy_dash/features/games/flappy_dash/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2288FA),
      child: Stack(
        children: [
          Positioned(
            top: 200,
            left: -50,
            child: SvgPicture.asset(
              'assets/icons/ic_back.svg',
              fit: BoxFit.fitHeight,
              height: 500,
              colorFilter: ColorFilter.mode(
                // ignore: deprecated_member_use
                const Color.fromARGB(255, 202, 222, 20).withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 800,
            child: SvgPicture.asset(
              'assets/icons/ic_close.svg',
              fit: BoxFit.fitHeight,
              height: 500,
              colorFilter: ColorFilter.mode(
                // ignore: deprecated_member_use
                Colors.white.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            top: -300,
            left: 400,
            child: SvgPicture.asset(
              'assets/icons/ic_home.svg',
              fit: BoxFit.fitHeight,
              height: 500,
              colorFilter: ColorFilter.mode(
                // ignore: deprecated_member_use
                Colors.white.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
