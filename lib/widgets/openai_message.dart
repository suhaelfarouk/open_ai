import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class OpenaiMessage extends StatelessWidget {
  final String text;
  const OpenaiMessage({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                CupertinoIcons.waveform,
                size: 30,
                color: themeModel.colorAccent,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SelectableText(
                text,
                toolbarOptions: const ToolbarOptions(
                  copy: true,
                ),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: themeModel.colorAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
