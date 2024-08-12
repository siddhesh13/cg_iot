// lib/widgets/torch_toggle_button.dart
import 'package:flutter/material.dart';
import '../services/torch_service.dart';

class TorchToggleButton extends StatefulWidget {
  final TorchService torchService;

  TorchToggleButton({required this.torchService});

  @override
  _TorchToggleButtonState createState() => _TorchToggleButtonState();
}

class _TorchToggleButtonState extends State<TorchToggleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 100,
      icon: Icon(
        widget.torchService.isTorchOn
            ? Icons.flashlight_on
            : Icons.flashlight_off,
        color: widget.torchService.isTorchOn ? Colors.yellow : Colors.grey,
      ),
      onPressed: () async {
        //await widget.torchService.toggleTorch();
        setState(() {});
      },
    );
  }
}
