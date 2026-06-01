import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/datasources/joke_datasource.dart';
import 'package:yes_no_app/infrastructure/datasources/yes_no_datasource.dart';
import 'package:yes_no_app/infrastructure/models/joke_model.dart';

enum ChatType { yesNo, jokes }

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final YesNoDatasource yesNoDatasource = YesNoDatasource();
  final JokeDatasource jokeDatasource = JokeDatasource();

  ChatType selectedChatType = ChatType.jokes;
  ChatType? _typingChatType;
  bool _isFetchingJoke = false;
  bool _awaitingPunchline = false;
  int _pendingUserMessages = 0;
  JokeModel? _currentJoke;

  final List<Message> _jokeMessages = [
    Message(text: 'Hola amor!', fromWho: FromWho.me),
    Message(text: 'Ya regresaste del trabajo?', fromWho: FromWho.me),
  ];

  final List<Message> _yesNoMessages = [
    Message(
      text: 'Ask me a yes/no question and I will answer with a GIF.',
      fromWho: FromWho.hers,
    ),
  ];

  bool get isTyping => _typingChatType == selectedChatType;

  List<Message> get messageList => _messagesFor(selectedChatType);

  void setChatType(ChatType chatType) {
    if (selectedChatType == chatType) return;

    selectedChatType = chatType;
    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final chatType = selectedChatType;
    _messagesFor(chatType).add(Message(text: text, fromWho: FromWho.me));

    notifyListeners();
    moveScrollToBottom();

    if (chatType == ChatType.yesNo) {
      await _sendYesNoReply(text);
      return;
    }

    _pendingUserMessages++;
    await _processPendingMessages();
  }

  Future<void> _sendYesNoReply(String text) async {
    if (!text.trim().endsWith('?')) {
      _yesNoMessages.add(
        Message(
          text: 'Please ask me a yes/no question ending with a question mark.',
          fromWho: FromWho.hers,
        ),
      );
      notifyListeners();
      moveScrollToBottom();
      return;
    }

    _setTyping(ChatType.yesNo, true);

    try {
      final herMessage = await yesNoDatasource.getAnswer();
      _yesNoMessages.add(
        Message(
          text: herMessage.answer,
          fromWho: FromWho.hers,
          imageUrl: herMessage.image,
        ),
      );
    } catch (_) {
      _yesNoMessages.add(
        Message(
          text: 'I could not get an answer right now. Please try again.',
          fromWho: FromWho.hers,
        ),
      );
    } finally {
      _setTyping(ChatType.yesNo, false);
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> _processPendingMessages() async {
    if (_awaitingPunchline && _pendingUserMessages > 0) {
      _pendingUserMessages--;
      _deliverPunchline();
    }

    if (!_awaitingPunchline && !_isFetchingJoke && _pendingUserMessages > 0) {
      _pendingUserMessages--;
      await _fetchJokeSetup();
    }
  }

  Future<void> _fetchJokeSetup() async {
    _isFetchingJoke = true;
    _setTyping(ChatType.jokes, true);

    try {
      _currentJoke = await jokeDatasource.getRandomJoke();
    } catch (_) {
      _setTyping(ChatType.jokes, false);
      _isFetchingJoke = false;
      _jokeMessages.add(
        Message(
          text: 'No pude obtener un chiste. Intenta de nuevo.',
          fromWho: FromWho.hers,
        ),
      );
      notifyListeners();
      moveScrollToBottom();
      return;
    }

    _isFetchingJoke = false;
    _setTyping(ChatType.jokes, false);

    if (_currentJoke == null) return;

    _jokeMessages.add(
      Message(text: _currentJoke!.setup, fromWho: FromWho.hers),
    );
    _awaitingPunchline = true;

    notifyListeners();
    moveScrollToBottom();

    if (_pendingUserMessages > 0) {
      await _processPendingMessages();
    }
  }

  void _deliverPunchline() {
    if (_currentJoke == null) return;

    _jokeMessages.add(
      Message(text: _currentJoke!.punchline, fromWho: FromWho.hers),
    );
    _currentJoke = null;
    _awaitingPunchline = false;

    notifyListeners();
    moveScrollToBottom();
  }

  void _setTyping(ChatType chatType, bool value) {
    if (value) {
      _typingChatType = chatType;
    } else if (_typingChatType == chatType) {
      _typingChatType = null;
    }
    notifyListeners();
  }

  Future<void> sendImage(String imageUrl) async {
    final chatType = selectedChatType;
    final newMessage = Message(
      text: 'GIF Sent',
      fromWho: FromWho.me,
      imageUrl: imageUrl,
    );
    _messagesFor(chatType).add(newMessage);

    notifyListeners();
    moveScrollToBottom();

    if (chatType == ChatType.yesNo) return;

    _pendingUserMessages++;
    await _processPendingMessages();
  }

  Future<void> sendImageBytes(Uint8List bytes) async {
    final chatType = selectedChatType;
    final newMessage = Message(
      text: 'Sticker/GIF Sent',
      fromWho: FromWho.me,
      imageBytes: bytes,
    );
    _messagesFor(chatType).add(newMessage);

    notifyListeners();
    moveScrollToBottom();

    if (chatType == ChatType.yesNo) return;

    _pendingUserMessages++;
    await _processPendingMessages();
  }

  Future<void> herReply() async {
    final herMessage = await yesNoDatasource.getAnswer();
    messageList.add(
      Message(
        text: herMessage.answer,
        fromWho: FromWho.hers,
        imageUrl: herMessage.image,
      ),
    );

    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!chatScrollController.hasClients) return;

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<Message> _messagesFor(ChatType chatType) {
    return chatType == ChatType.yesNo ? _yesNoMessages : _jokeMessages;
  }

  @override
  void dispose() {
    chatScrollController.dispose();
    super.dispose();
  }
}
