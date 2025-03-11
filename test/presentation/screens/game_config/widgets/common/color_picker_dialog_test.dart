import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';

void main() {
  group('ColorPickerDialog', () {
    test('colorToHex returns correct hex string', () {
      final color = Color(0xFFFF5500);
      final hexString = ColorPickerDialog.colorToHex(color);
      expect(hexString, '#ff5500');
    });

    test('hexToColor returns correct color', () {
      const hexString = '#ff5500';
      final color = ColorPickerDialog.hexToColor(hexString);
      expect(color, Color(0xFFFF5500));
    });

    test('hexToColor with 6 digit hex adds alpha channel', () {
      const hexString = 'ff5500';
      final color = ColorPickerDialog.hexToColor(hexString);
      expect(color, Color(0xFFFF5500));
    });

    testWidgets('show displays color picker dialog',
        (WidgetTester tester) async {
      bool colorChanged = false;
      Color? selectedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  ColorPickerDialog.show(
                    context,
                    Colors.blue,
                    (color) {
                      colorChanged = true;
                      selectedColor = color;
                    },
                  );
                },
                child: const Text('Show Color Picker'),
              );
            }),
          ),
        ),
      );

      // Tap the button to show the dialog
      await tester.tap(find.text('Show Color Picker'));
      await tester.pumpAndSettle();

      // Verify the dialog is shown
      expect(find.text('Chọn màu'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Chọn'), findsOneWidget);
    });

    testWidgets('showBlockPicker displays block picker dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  ColorPickerDialog.showBlockPicker(
                    context,
                    Colors.red,
                    (color) {},
                  );
                },
                child: const Text('Show Block Picker'),
              );
            }),
          ),
        ),
      );

      // Tap the button to show the dialog
      await tester.tap(find.text('Show Block Picker'));
      await tester.pumpAndSettle();

      // Verify the dialog is shown
      expect(find.text('Chọn màu nhanh'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
    });
  });
}
