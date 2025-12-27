
import 'dart:math';

import 'package:flutter/material.dart';

class MicWaveformButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const MicWaveformButton({
    super.key,
    required this.isListening,
    required this.onPressed,
  });

  @override
  State<MicWaveformButton> createState() => _MicWaveformButtonState();
}

class _MicWaveformButtonState extends State<MicWaveformButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: widget.isListening
            ? _buildWaveform() 
            : const Icon(Icons.mic, color: Colors.black, size: 28), 
      ),
    );
  }

  Widget _buildWaveform() {
    return SizedBox(
      width: 40,
      height: 30,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
          
              final val = _controller.value + (index * 0.2);
       
            final height = 10 + (15 * (0.5 + 0.5 * sin(val * 6.28).abs()));

              return Container(
                width: 4,
                height: height,
                decoration: BoxDecoration(
                  color: _getGoogleColor(index),
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Color _getGoogleColor(int index) {
    const colors = [
      Color(0xFF4285F4),
      Color(0xFFDB4437),
      Color(0xFFF4B400),
      Color(0xFF0F9D58),
    ];
    return colors[index % colors.length];
  }
}