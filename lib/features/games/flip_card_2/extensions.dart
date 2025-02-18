import 'dart:ui';

extension DurationExtensions on Duration {
  Duration get half => Duration(milliseconds: inMilliseconds ~/ 2);
}

extension OffsetExtensions on Offset {
  Offset interpolate(Offset other, double t) {
    return Offset(
      lerpDouble(dx, other.dx, t)!,
      lerpDouble(dy, other.dy, t)!,
    );
  }
}
