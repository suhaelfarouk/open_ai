import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openai/providers/chat_provider.dart';
import 'package:openai/providers/speech_provider.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'widgets/user_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<SpeechProvider>(context, listen: false).initSpeech();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController chatController = TextEditingController();
    final themeModel = Provider.of<ThemeProvider>(context);
    final speechModel = Provider.of<SpeechProvider>(context);
    chatController.text = speechModel.lastWords;
    debugPrint('${speechModel.lastWords}lW');
    debugPrint('${chatController.text}CC');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 300,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Open GPT',
              style: TextStyle(
                color: themeModel.colorAccent,
                fontSize: 20,
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: themeModel.isLightModeOn == true
            ? Colors.grey[300]
            : Colors.grey[900],
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            splashRadius: 1,
            icon: Icon(
                themeModel.isLightModeOn == true
                    ? CupertinoIcons.moon
                    : CupertinoIcons.lightbulb,
                size: 30,
                color: themeModel.colorAccent),
            onPressed: () {
              themeModel.isLightModeOn == true
                  ? themeModel.isDarkMode()
                  : themeModel.isLightMode();
            },
          )
        ],
      ),
      backgroundColor: themeModel.colorBase,
      body: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            List<Widget> messages = provider.getMessages;
            if (provider.isMessageRecieved == true &&
                _scrollController.position.maxScrollExtent != 0) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent * 2,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut);
              debugPrint('${_scrollController.position.maxScrollExtent}ontext');
            }
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 70,
                  ),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return false;
                    },
                    child: ListView(
                      padding: const EdgeInsets.only(
                        bottom: 50,
                        top: 30,
                      ),
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        for (int i = 0; i < messages.length; i++) messages[i]
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: themeModel.isLightModeOn == true
                          ? Colors.grey[300]
                          : Colors.grey[900],
                    ),
                    child: Row(
                      children: [
                        // Icon(
                        //   CupertinoIcons.delete,
                        //   color: themeModel.colorAccent,
                        //   size: 20,
                        // ),
                        GestureDetector(
                          onTap: (() {
                            provider.clearAllMessages();
                          }),
                          child: Text(' Clear ',
                              style: TextStyle(color: themeModel.colorAccent)),
                        ),
                      ],
                    ),
                  ),
                ),
                UserInput(
                  chatController: chatController,
                  scrollController: _scrollController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
