import 'package:flutter/material.dart';

class MyMessageBubble extends StatelessWidget {
  final int index;

  const MyMessageBubble({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3541/3541871.png',
        ),
      ),
      title: Text('User $index'),
      subtitle: Text('Hello! This is a message from user $index.'),
    );
  }
}