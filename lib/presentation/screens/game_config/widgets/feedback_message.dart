import 'package:flutter/material.dart';

/// Widget hiển thị thông báo phản hồi với hiệu ứng animation
/// Được sử dụng để thông báo kết quả của các hành động như cập nhật, lưu, di chuyển, v.v.
class FeedbackMessage extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;
  final Duration displayDuration;
  final bool autoHide;

  const FeedbackMessage({
    Key? key,
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.onTap,
    this.displayDuration = const Duration(seconds: 3),
    this.autoHide = true,
  }) : super(key: key);

  /// Hiển thị thông báo thành công
  static FeedbackMessage success({
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 3),
    bool autoHide = true,
  }) {
    return FeedbackMessage(
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.green,
      onTap: onTap,
      displayDuration: displayDuration,
      autoHide: autoHide,
    );
  }

  /// Hiển thị thông báo lỗi
  static FeedbackMessage error({
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 5),
    bool autoHide = true,
  }) {
    return FeedbackMessage(
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red,
      onTap: onTap,
      displayDuration: displayDuration,
      autoHide: autoHide,
    );
  }

  /// Hiển thị thông báo cảnh báo
  static FeedbackMessage warning({
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 4),
    bool autoHide = true,
  }) {
    return FeedbackMessage(
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: Colors.orange,
      onTap: onTap,
      displayDuration: displayDuration,
      autoHide: autoHide,
    );
  }

  /// Hiển thị FeedbackMessage như một overlay
  static Future<void> show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.info_outline,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 3),
    bool autoHide = true,
  }) async {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: FeedbackMessage(
              message: message,
              icon: icon,
              backgroundColor: backgroundColor,
              textColor: textColor,
              onTap: onTap,
              displayDuration: displayDuration,
              autoHide: autoHide,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    await Future.delayed(displayDuration + const Duration(milliseconds: 300));
    overlayEntry.remove();
  }

  /// Hiển thị thông báo thành công như một overlay
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 3),
  }) async {
    return show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.green,
      onTap: onTap,
      displayDuration: displayDuration,
    );
  }

  /// Hiển thị thông báo lỗi như một overlay
  static Future<void> showError(
    BuildContext context, {
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 5),
  }) async {
    return show(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red,
      onTap: onTap,
      displayDuration: displayDuration,
    );
  }

  /// Hiển thị thông báo cảnh báo như một overlay
  static Future<void> showWarning(
    BuildContext context, {
    required String message,
    VoidCallback? onTap,
    Duration displayDuration = const Duration(seconds: 4),
  }) async {
    return show(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: Colors.orange,
      onTap: onTap,
      displayDuration: displayDuration,
    );
  }

  @override
  State<FeedbackMessage> createState() => _FeedbackMessageState();
}

class _FeedbackMessageState extends State<FeedbackMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    if (widget.autoHide) {
      Future.delayed(widget.displayDuration, () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.onTap ?? () => Navigator.of(context).pop(),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.textColor,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: widget.textColor.withOpacity(0.7),
                          size: 18,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
