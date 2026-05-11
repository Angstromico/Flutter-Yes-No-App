import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pinimg.com/736x/1c/8b/0e/1c8b0e5a9d9f2a7c3e5b6a7f8c9d0e.jpg'),
          ),
        ),
        title: const Text('Chat Screen'),
        centerTitle: true,
      ),
      body: Center(
          child: FilledButton.tonal(onPressed: (){}, child: Text("Click me")),
      ),
    );
  }
}