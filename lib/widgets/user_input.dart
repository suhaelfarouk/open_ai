import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openai/providers/speech_provider.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';

class UserInput extends StatelessWidget {
  final TextEditingController chatController;
  final ScrollController scrollController;
  const UserInput({
    super.key,
    required this.chatController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeProvider>(context);
    final speechModel = Provider.of<SpeechProvider>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            color: themeModel.isLightModeOn == true
                ? Colors.grey[300]
                : Colors.grey[900]),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(CupertinoIcons.person,
                  size: 30, color: themeModel.colorAccent),
            ),
            Expanded(
              flex: 5,
              child: TextFormField(
                cursorColor: themeModel.colorAccent,
                expands: false,
                controller: chatController,
                cursorHeight: 20,
                cursorWidth: 1,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: themeModel.colorAccent),
                decoration: const InputDecoration(
                  // hintText: '    Made with  \u2764  by Suhael Farouk',
                  // hintStyle: TextStyle(
                  //   color: themeModel.colorAccent,
                  // ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                splashRadius: 1,
                icon: speechModel.speechToText.isNotListening
                    ? Icon(
                        CupertinoIcons.mic_off,
                        size: 30,
                        color: themeModel.colorAccent,
                      )
                    : Icon(
                        CupertinoIcons.mic,
                        size: 30,
                        color: themeModel.colorAccent,
                      ),
                onPressed: () {
                  // if (speechModel.initialized == false) {
                  //   speechModel.initSpeech();
                  // } else {
                  speechModel.speechToText.isNotListening
                      ? speechModel.startListening()
                      : speechModel.stopListening();
                  // }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                splashRadius: 1,
                icon: Icon(
                  CupertinoIcons.paperplane,
                  size: 30,
                  color: themeModel.colorAccent,
                ),
                onPressed: () {
                  context.read<ChatProvider>().sendChat(chatController.text);
                  FocusScope.of(context).unfocus();
                  chatController.clear();
                  speechModel.lastWords = '';
                  if (scrollController.position.maxScrollExtent != 0) {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent * 2,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  }
                  debugPrint(
                      '${scrollController.position.maxScrollExtent}ontap');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
