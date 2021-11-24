import 'package:flutter/material.dart';

bool isListInItem(List l, var str) {
  str = str.toString();
  for (int i = 0; i < l.length; i++) {
    var lstr = l[i].toString();
    if (lstr == str) {
      return true;
    }
  }
  return false;
}

void ctAlert(BuildContext context, String content) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("뒤로")),
          ],
        );
      });
}
