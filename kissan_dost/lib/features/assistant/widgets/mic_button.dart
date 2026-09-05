import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class MicButton extends StatefulWidget {
  const MicButton({
    super.key,
    required this.isListening,
    required this.onTap,
    this.isLoading = false,
  });

  final bool isListening;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isListening) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isListening && _controller.isAnimating) {
      _controller
        ..stop()
        ..value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = widget.isListening ? 1 + _controller.value * 0.08 : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: widget.isListening ? 0.5 : 0.3,
                    ),
                    blurRadius: widget.isListening ? 40 : 24,
                    spreadRadius: widget.isListening ? 8 : 4,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: widget.isLoading
            ? const CircularProgressIndicator(color: AppColors.textOnPrimary)
            : const Icon(
                Icons.mic,
                size: 64,
                color: AppColors.textOnPrimary,
              ),
      ),
    );
  }
}
