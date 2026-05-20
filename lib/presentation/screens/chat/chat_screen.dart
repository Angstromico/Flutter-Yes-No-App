import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/other_message_bubble.dart';

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
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                if (index % 2 == 0) {
                  return MyMessageBubble(
                    message: 'My message $index',
                    imageUrl: (index % 6 == 0) ? 'https://yesno.wtf/assets/yes/2-4d2900fa99e32a03fcf11673a074ec10.gif' : null,
                  );
                } else {
                  return OtherMessageBubble(
                    message: 'Other message $index',
                    imageUrl: (index % 5 == 0) ? 'https://yesno.wtf/assets/no/0-bb7131dbac239e25d2f8ef41217e5831.gif' : null,
                  );
                }
              },
            ),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
             children: [
               Expanded(
                 child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(),
                    ),
                   ),
                 ),
                 IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Handle send button press
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
