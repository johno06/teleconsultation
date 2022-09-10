import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../modules/chat_detail_page.dart';

// ignore: must_be_immutable
class DoctorChatBubble extends StatefulWidget{
  ChatMessage chatMessage;
  DoctorChatBubble({Key? key, required this.chatMessage}) : super(key: key);
  @override
  _DoctorChatBubbleState createState() => _DoctorChatBubbleState();
}

class _DoctorChatBubbleState extends State<DoctorChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.receiver?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.type  == MessageType.receiver?Colors.white:Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(widget.chatMessage.message),
        ),
      ),
    );
  }
}