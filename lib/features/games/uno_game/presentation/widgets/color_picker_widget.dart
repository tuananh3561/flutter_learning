import 'package:flutter/material.dart';
import '../../domain/card.dart';

class ColorPickerWidget extends StatelessWidget {
  final Function(CardColor) onColorSelected;

  const ColorPickerWidget({
    Key? key,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          width: 300,
          height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Choose a Color',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorButton(
                      color: Colors.red, cardColor: CardColor.red),
                  const SizedBox(width: 20),
                  _buildColorButton(
                      color: Colors.blue, cardColor: CardColor.blue),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorButton(
                      color: Colors.green, cardColor: CardColor.green),
                  const SizedBox(width: 20),
                  _buildColorButton(
                      color: Colors.amber, cardColor: CardColor.yellow),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'This color will apply to subsequent plays',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton({
    required Color color,
    required CardColor cardColor,
  }) {
    return GestureDetector(
      onTap: () => onColorSelected(cardColor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
