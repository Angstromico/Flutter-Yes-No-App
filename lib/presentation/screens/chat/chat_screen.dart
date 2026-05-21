import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_bubble.dart';

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
                final isMine = index % 2 == 0;
                
                return MessageBubble(
                  message: isMine ? 'My message $index' : 'Other message $index',
                  fromMe: isMine,
                  imageUrl: isMine 
                    ? (index % 6 == 0 ? 'https://www.hudsonyardsnewyork.com/sites/default/files/styles/experience_details/public/2024-10/Vessel%20in%20New%20York%20City_Courtesy%20of%20Vessel_0.jpg?h=1701b1d9&itok=aY0GiOXO' : null)
                    : (index % 5 == 0 ? 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhq0m-UZ2Iq13G-_ysLKXzNEbTSMWbmlTxFj6Y_LdpZNzlsnuyVBvwfufpKvZbZKnX6eFYELPo1WptD60Kno5bdc7CkzErYDr3sOq2UqxMx7YRITEZgbqRDs_f2DpnPf6eDnCD1Itd_Aww8/s2048/SpaceX+Starship+evolution+2016-2019+by+Kimi+Talvitie.jpg' : null),
                );
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
