import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/gif_selector.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3541/3541871.png'),
          ),
        ),
        title: const Text('Mi Amor ♥'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount: chatProvider.messageList.length,
                itemBuilder: (context, index) {
                  final message = chatProvider.messageList[index];

                  return MessageBubble(
                    message: message.text,
                    fromMe: (message.fromWho == FromWho.me),
                    imageUrl: message.imageUrl,
                  );
                },
              ),
            ),

            /// Caja de texto de mensajes
            Row(
              children: [
                GifSelector(
                  onGifSelected: chatProvider.sendImage,
                ),
                Expanded(
                  child: MessageFieldBox(
                    // onValue: (value) => chatProvider.sendMessage(value),
                    onValue: chatProvider.sendMessage,
                    onImageSelected: (uri, bytes) {
                      if (bytes != null) {
                        chatProvider.sendImageBytes(bytes);
                      } else if (uri != null) {
                        chatProvider.sendImage(uri);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
