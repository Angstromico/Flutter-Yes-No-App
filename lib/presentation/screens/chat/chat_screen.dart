import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/providers/theme_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/gif_selector.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/message_field_box.dart';
import 'package:yes_no_app/presentation/widgets/chat/typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedChatType = context.watch<ChatProvider>().selectedChatType;
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: const NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3541/3541871.png',
            ),
            onBackgroundImageError: (_, _) {},
          ),
        ),
        title: Text(selectedChatType == ChatType.jokes ? 'Jokes' : 'Yes or no'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
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
            const _ChatTypeSelector(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount:
                    chatProvider.messageList.length +
                    (chatProvider.isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < chatProvider.messageList.length) {
                    final message = chatProvider.messageList[index];

                    return MessageBubble(
                      message: message.text,
                      fromMe: (message.fromWho == FromWho.me),
                      imageUrl: message.imageUrl,
                      imageBytes: message.imageBytes,
                    );
                  }

                  return const TypingIndicator();
                },
              ),
            ),

            /// Caja de texto de mensajes
            Row(
              children: [
                GifSelector(onGifSelected: chatProvider.sendImage),
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

class _ChatTypeSelector extends StatelessWidget {
  const _ChatTypeSelector();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose chat type',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ChatType>(
              segments: const [
                ButtonSegment(
                  value: ChatType.yesNo,
                  label: Text('Yes or no'),
                  icon: Icon(Icons.help_outline),
                ),
                ButtonSegment(
                  value: ChatType.jokes,
                  label: Text('Jokes'),
                  icon: Icon(Icons.celebration_outlined),
                ),
              ],
              selected: {chatProvider.selectedChatType},
              onSelectionChanged: (selection) {
                chatProvider.setChatType(selection.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}
