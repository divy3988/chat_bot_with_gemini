import 'dart:io';

import 'package:chat_bot/Services.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

const cloud_api_sec = 'KlXHYGY-1WBQ-jfYNcMFo_w_Rv4';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final gemini = Gemini.instance;
  final ImagePicker _picker = ImagePicker();

  ChatUser myself = ChatUser(
    id: "1",
    firstName: 'Divy',
  );
  ChatUser g = ChatUser(
    id: "2",
    firstName: 'Gemini',
  );

  List<ChatMessage> messages = [];
  void Serach_With_Gemini(ChatMessage m) {
    try {
      setState(() {
        messages.insert(0, m);
      });
      if (m.medias != null) {
        final file = File(m.medias!.first.url).readAsBytesSync();
        gemini.streamGenerateContent(
          m.text,
          images: [
            file,
          ],
        ).listen(
          (onData) {
            ChatMessage? lastmessage = messages.firstOrNull;
            if (lastmessage != null && lastmessage.user == g) {
              lastmessage = messages.removeAt(0);
              String? res = onData.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}");
              lastmessage.text += res!;
              setState(() {
                messages.insert(0, lastmessage!);
              });
            } else {
              String? res = onData.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}");
              ChatMessage mes =
                  ChatMessage(user: g, createdAt: DateTime.now(), text: res!);
              setState(() {
                messages.insert(0, mes);
              });
            }
          },
        );
      } else {
        gemini.streamGenerateContent(m.text).listen(
          (onData) {
            ChatMessage? lst_msg = messages.firstOrNull;
            if (lst_msg != null && lst_msg.user == g) {
              messages.removeAt(0);
              final res = onData.content?.parts?.fold(
                "",
                (p, c) => "$p ${c.text}",
              );
              lst_msg.text += res!;
              setState(() {
                messages.insert(0, lst_msg);
              });
            } else {
              final res = onData.content?.parts?.fold(
                "",
                (p, c) => "$p ${c.text}",
              );
              ChatMessage m = ChatMessage(
                user: g,
                createdAt: DateTime.now(),
                text: res!,
              );
              setState(() {
                messages.insert(0, m);
              });
            }
          },
        );
      }
    } catch (e) {
      print('Error in checkGemini: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Gemini Api Demo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: DashChat(
          currentUser: myself,
          onSend: (ChatMessage message) {
            Serach_With_Gemini(message);
          },
          messages: messages,
          messageOptions: MessageOptions(
            currentUserTextColor: Colors.black,
            currentUserContainerColor: Colors.grey[300],
            containerColor: Colors.white,
            textColor: Colors.black87,
            onTapMedia: (media) {
              services().showImage(media.url);
            },
          ),
          inputOptions: InputOptions(
            inputTextStyle: TextStyle(color: Color.fromARGB(255, 32, 31, 31)),
            sendButtonBuilder: (send) {
              return IconButton(
                onPressed: send,
                icon: Icon(Icons.send_rounded),
              );
            },
            showTraillingBeforeSend: true,
            alwaysShowSend: true,
            trailing: [
              IconButton(
                onPressed: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    ChatMessage m = ChatMessage(
                        user: myself,
                        createdAt: DateTime.now(),
                        text: "Describe this",
                        medias: [
                          ChatMedia(
                              url: pickedFile.path,
                              fileName: "",
                              type: MediaType.image),
                        ]);
                    Serach_With_Gemini(m);
                  }
                },
                icon: Icon(Icons.filter_sharp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
