
import 'dart:convert';

import 'package:chat_project/globals.dart';
import 'package:chat_project/history.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class MockBot extends StatefulWidget {
  const MockBot({super.key});

  @override
  State<MockBot> createState() => _MockBotState();
}

class _MockBotState extends State<MockBot> {
  final myBox=Hive.box("Chatbox");
  @override
  void initState() {
    super.initState();
    // Load data from Hive into lists when the screen is initialized
    userMessagesList = List<String>.from(myBox.get(1, defaultValue: []));
    botMessagesList = List<String>.from(myBox.get(2, defaultValue: []));
    timeAndDate = List<String>.from(myBox.get(3, defaultValue: []));
  }
  void _writeData(){
    setState(() {
      myBox.put(1, userMessagesList);
      myBox.put(2, botMessagesList);
      myBox.put(3, timeAndDate);
    });
  }
  ChatUser myself=ChatUser(
      id: "1",firstName: "Daniyal"
  );

  ChatUser bot=ChatUser(
      id: "2",firstName: "Geminai"
  );

  List<ChatMessage> messages=<ChatMessage>[];
  List<ChatUser> typing=<ChatUser>[];

  final ourUrl='https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAMSSFLg3KdYkyiYFIgQRHsoqduNE9JGmg';

  final header={
    'Content-Type': 'application/json'
  };
  onsend(ChatMessage msg) async {
    messages.insert(0, msg);
    typing.add(bot);
    setState(() {});

    var data = {
      "contents": [{"parts": [{"text": msg.text}]}]
    };

    try {
      var response = await http.post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result.containsKey('candidates') && result['candidates'] is List && result['candidates'].isNotEmpty) {
          var candidate = result['candidates'][0];

          if (candidate.containsKey('content')) {
            var content = candidate['content'];

            if (content.containsKey('parts') && content['parts'] is List && content['parts'].isNotEmpty) {

              var part = content['parts'][0];

              if (part.containsKey('text')) {
                String text = part['text'];

                ChatMessage m1 = ChatMessage(
                  text: text,
                  user: bot,
                  createdAt: DateTime.now(),
                );

                /// Insert the message into the messages list and update the UI
                botMessagesList.add(m1.text);
                _writeData();
                messages.insert(0, m1);
                setState(() {});
              } else {
                ChatMessage m2 = ChatMessage(
                  text: "Something went wrong, try again!!!",
                  user: bot,
                  createdAt: DateTime.now(),
                );
                botMessagesList.add("Something went wrong, try again.");
                _writeData();
                messages.insert(0, m2);
                setState(() {});
              }
            } else {
              ChatMessage m2 = ChatMessage(
                text: "Something went wrong, try again!!!",
                user: bot,
                createdAt: DateTime.now(),
              );
              botMessagesList.add("Something went wrong, try again.");
              _writeData();
              messages.insert(0, m2);
              setState(() {});
            }
          } else {
            ChatMessage m2 = ChatMessage(
              text: "Something went wrong, try again!!!",
              user: bot,
              createdAt: DateTime.now(),
            );
            botMessagesList.add("Something went wrong, try again.");
            _writeData();
            messages.insert(0, m2);
            setState(() {});
          }
        } else {
          ChatMessage m2 = ChatMessage(
            text: "Something went wrong, try again!!!",
            user: bot,
            createdAt: DateTime.now(),
          );
          botMessagesList.add("Something went wrong, try again.");
          _writeData();
          messages.insert(0, m2);
          setState(() {});
        }
      } else {
        ChatMessage m2 = ChatMessage(
          text: "Something went wrong, try again!!!",
          user: bot,
          createdAt: DateTime.now(),
        );
        botMessagesList.add("Something went wrong, try again.");
        _writeData();
        messages.insert(0, m2);
        setState(() {});
      }
    } catch (e) {
      ChatMessage m2 = ChatMessage(
        text: "Something went wrong, try again!!!",
        user: bot,
        createdAt: DateTime.now(),
      );
      messages.insert(0, m2);
      setState(() {});
    }
    typing.remove(bot);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500
        ),),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HistoryScreen()));
            },
            child: const Icon(Icons.history,size: 30,),
          ),
          const SizedBox(width: 20,)
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: DashChat(
        currentUser: myself,
        onSend: (ChatMessage msg) {
          DateTime now = DateTime.now();
          String timeDate = '${now.hour}:${now.minute}:${now.second} - ${now.day}/${now.month}/${now.year}';
          onsend(msg);
          userMessagesList.add(msg.text);
          timeAndDate.add(timeDate);
          _writeData();
          },
        messages: messages,
        typingUsers: typing,
        inputOptions: const InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: Colors.black),
        ),
        messageOptions: MessageOptions(
            currentUserContainerColor: Colors.black,
            avatarBuilder: yourAvatarBuilder
        ),
      ),
    );
  }
  Widget yourAvatarBuilder(ChatUser user,Function? onAvatarTap,Function? onAvatarLongPress ){
    return const Center(child: Image(image: AssetImage("images/google.png"),width: 40,height: 40,));
  }
}

///AIzaSyDpcFoWzn9ga7QgNRahgFF7UfYQ_75XzeA