import 'package:flutter/material.dart';

/// A draggable component that can be repositioned in the preview
class DraggableComponentPreview extends StatefulWidget {
  final Offset initialPosition;
  final Size size;
  final Widget child;
  final Function(Offset) onPositionChanged;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final bool isActive;

  const DraggableComponentPreview({
    Key? key,
    required this.initialPosition,
    required this.size,
    required this.child,
    required this.onPositionChanged,
    required this.onDragStart,
    required this.onDragEnd,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<DraggableComponentPreview> createState() =>
      _DraggableComponentPreviewState();
}

class _DraggableComponentPreviewState extends State<DraggableComponentPreview> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  void didUpdateWidget(DraggableComponentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPosition != widget.initialPosition) {
      setState(() {
        _position = widget.initialPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: (_) {
          widget.onDragStart();
        },
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (_) {
          widget.onPositionChanged(_position);
          widget.onDragEnd();
        },
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isActive ? Colors.red : Colors.transparent,
              width: widget.isActive ? 2 : 0,
            ),
          ),
          child: Stack(
            children: [
              // The actual component
              Positioned.fill(child: widget.child),

              // Drag handle in the corner when active
              if (widget.isActive)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.drag_indicator,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
