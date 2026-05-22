import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_image.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool fromMe;

  const MessageBubble({
    super.key,
    required this.message,
    this.imageUrl,
    this.imageBytes,
    this.fromMe = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final alignment = fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = fromMe ? colors.primary : colors.secondary;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (fromMe && (imageUrl != null || imageBytes != null)) ...[
          MessageImage(imageUrl: imageUrl, imageBytes: imageBytes),
          const SizedBox(height: 5),
        ],
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 5),
        if (!fromMe && (imageUrl != null || imageBytes != null)) ...[
          MessageImage(imageUrl: imageUrl, imageBytes: imageBytes),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
