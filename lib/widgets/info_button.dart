import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final String message;
  final double topOffset; // New parameter for top position adjustment

  InfoButton({required this.message, this.topOffset = -60});

  void _showOverlay(BuildContext context, String message) {
    OverlayEntry? overlayEntry;

    // Get the position and size of the button
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry?.remove(); // Remove overlay on tap outside
        },
        behavior: HitTestBehavior.translucent,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: buttonPosition.dy + topOffset, // Use the provided offset
                left: 14, // Align with the button's left
                child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjusted padding
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width - 32, // Subtract padding from screen width
    ),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8.0),
    ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info, size: 20.0),
      onPressed: () => _showOverlay(context, message),
    );
  }
}
