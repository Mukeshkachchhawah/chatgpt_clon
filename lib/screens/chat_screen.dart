import 'dart:convert';

import 'package:chatgpt_clon/api_services/api_key.dart';
import 'package:chatgpt_clon/custom_widget/custom_message.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var textMessageContorller = TextEditingController();
  final List<Message> _messages = [];

  bool isTyping = true;

  void SendMessage() {
    Message message = Message(text: textMessageContorller.text, isMe: true);
    textMessageContorller.clear();
    setState(() {
      _messages.insert(0, message);
    });

    //// call by sendChatGPTApi
    sendChatGptApi(message.text);
  }

  Widget buildMessage(Message message) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
            crossAxisAlignment: message.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.isMe ? 'You ' : 'ChatGPT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(message.text)
            ]),
      ),
    );
  }

  void sendChatGptApi(String message) async {
    final apiKey =
        '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'; // Replace with your GPT-3 API key.
    final apiUrl = 'https://api.openai.com/v1/audio/translations';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
        "max_tokens": 500,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final gpt3Response = jsonResponse['choices'][0]['text'];
      setState(() {
        _messages.add(Message(text: textMessageContorller.text, isMe: true));
      });
    } else {
      // Handle API request errors.
    }

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ChatGpt",
          style: TextStyle(fontSize: 25),
        ),

        /// add image chat gpt and remove this icon
        leading: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        actions: [
          Icon(
            Icons.people,
            color: Colors.white,
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
              child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return buildMessage(_messages[index]);
            },
          )),
          TextField(
            controller: textMessageContorller,
            decoration: InputDecoration(
                hintText: "Type a message.....",
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: InkWell(
                  onTap: SendMessage,
                  child: Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
                border: OutlineInputBorder()),
          )
        ],
      )),
    );
  }
}
