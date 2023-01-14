import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:openai/widgets/loading_message.dart';

import '../chat_repository.dart';
import '../widgets/openai_message.dart';
import '../widgets/user_message.dart';

class ChatProvider extends ChangeNotifier {
  List<Widget> messages = [];
  List<Widget> get getMessages => messages;
  bool isMessageRecieved = false;
  AudioPlayer player = AudioPlayer();

  Future<void> sendChat(String txt) async {
    await playMessageAudio();
    addUserMessage(txt);

    Map<String, dynamic> response =
        await ChatRepository.sendMessage(prompt: txt);

    String text = response['choices'][0]['text'];

    playMessageAudio().whenComplete(
      () {
        text = text.replaceFirst("\n\n", "");
        messages.removeLast();
        messages.add(OpenaiMessage(text: text));
        isMessageRecieved = true;
        notifyListeners();
      },
    );
  }

  void addUserMessage(txt) {
    isMessageRecieved = false;
    messages.add(UserMessage(text: txt));
    messages.add(const LoadingMessage(text: "Please Wait ..."));
    notifyListeners();
  }

  Future<void> clearAllMessages() async {
    await playDeleteAudio().whenComplete(() {
      messages.clear();
      notifyListeners();
    });
  }

  Future<void> playMessageAudio() async {
    await player.play(UrlSource('https://mobcup.net/d/a256e3ap/mp3'));
  }

  Future<void> playDeleteAudio() async {
    await player.play(UrlSource('https://mobcup.net/d/fy7m08kn/mp3'));
  }
}
