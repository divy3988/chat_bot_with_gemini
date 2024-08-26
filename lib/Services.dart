import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class services {
  ChatUser myself = ChatUser(id: "1", firstName: 'Divy');
  ChatUser gemini = ChatUser(id: "2", firstName: 'Gemini');

  Widget showImage(String url) {
    return Container(
      color: Colors.transparent,
      height: 600,
      width: double.infinity,
      child: Center(
        child: Image.network(
          url,
          height: 250,
        ),
      ),
    );
  }
}
