 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyToClipboard(BuildContext context,{required String textToCopy}) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Text copied to clipboard')),
    // );
  }