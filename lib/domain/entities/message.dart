
import 'dart:typed_data';

enum FromWho { me, hers }

class Message {
  final String text;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final FromWho fromWho;

  Message({
    required this.text,
    this.imageUrl,
    this.imageBytes,
    required this.fromWho,
  });
}
