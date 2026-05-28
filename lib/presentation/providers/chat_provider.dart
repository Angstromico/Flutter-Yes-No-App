import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/datasources/joke_datasource.dart';
import 'package:yes_no_app/infrastructure/datasources/yes_no_datasource.dart';
import 'package:yes_no_app/infrastructure/models/joke_model.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final YesNoDatasource yesNoDatasource = YesNoDatasource();
  final JokeDatasource jokeDatasource = JokeDatasource();

  bool isTyping = false;
  bool _isFetchingJoke = false;
  bool _awaitingPunchline = false;
  int _pendingUserMessages = 0;
  JokeModel? _currentJoke;

  List<Message> messageList = [
    Message(text: 'Hola amor!', fromWho: FromWho.me),
    Message(text: 'Ya regresaste del trabajo?', fromWho: FromWho.me),
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messageList.add(Message(text: text, fromWho: FromWho.me));
    _pendingUserMessages++;

    notifyListeners();
    moveScrollToBottom();

    await _processPendingMessages();
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
    _setTyping(true);

    try {
      _currentJoke = await jokeDatasource.getRandomJoke();
    } catch (_) {
      _setTyping(false);
      _isFetchingJoke = false;
      messageList.add(Message(
        text: 'No pude obtener un chiste. Intenta de nuevo.',
        fromWho: FromWho.hers,
      ));
      notifyListeners();
      moveScrollToBottom();
      return;
    }

    _isFetchingJoke = false;
    _setTyping(false);

    if (_currentJoke == null) return;

    messageList.add(Message(
      text: _currentJoke!.setup,
      fromWho: FromWho.hers,
    ));
    _awaitingPunchline = true;

    notifyListeners();
    moveScrollToBottom();

    if (_pendingUserMessages > 0) {
      await _processPendingMessages();
    }
  }

  void _deliverPunchline() {
    if (_currentJoke == null) return;

    messageList.add(Message(
      text: _currentJoke!.punchline,
      fromWho: FromWho.hers,
    ));
    _currentJoke = null;
    _awaitingPunchline = false;

    notifyListeners();
    moveScrollToBottom();
  }

  void _setTyping(bool value) {
    isTyping = value;
    notifyListeners();
  }

  Future<void> sendImage(String imageUrl) async {
    final newMessage = Message(
      text: 'GIF Sent',
      fromWho: FromWho.me,
      imageUrl: imageUrl,
    );
    messageList.add(newMessage);
    _pendingUserMessages++;

    notifyListeners();
    moveScrollToBottom();

    await _processPendingMessages();
  }

  Future<void> sendImageBytes(Uint8List bytes) async {
    final newMessage = Message(
      text: 'Sticker/GIF Sent',
      fromWho: FromWho.me,
      imageBytes: bytes,
    );
    messageList.add(newMessage);
    _pendingUserMessages++;

    notifyListeners();
    moveScrollToBottom();

    await _processPendingMessages();
  }

  Future<void> herReply() async {
    final herMessage = await yesNoDatasource.getAnswer();
    messageList.add(Message(
      text: herMessage.answer,
      fromWho: FromWho.hers,
      imageUrl: herMessage.image,
    ));

    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
