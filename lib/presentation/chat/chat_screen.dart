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
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3541/3541871.png'),
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