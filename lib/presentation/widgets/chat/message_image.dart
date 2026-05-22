import 'package:flutter/material.dart';

class MessageImage extends StatelessWidget {
  final String imageUrl;

  const MessageImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: (imageUrl.startsWith('http'))
        ? Image.network(
            imageUrl,
            width: size.width * 0.7,
            height: 150,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                width: size.width * 0.7,
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const Text('Sending image...'),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size.width * 0.7,
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.error_outline)),
              );
            },
          )
        : Image.network( // Fallback or handle content:// if possible via external package later
            imageUrl,
            width: size.width * 0.7,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
               return Container(
                width: size.width * 0.7,
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Text('Image type not supported yet')),
              );
            },
          ),
    );
  }
}
