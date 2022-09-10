// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../modules/chat_detail_page.dart';

class DoctorChatUsersList extends StatefulWidget{
  String text;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  DoctorChatUsersList({Key? key, required this.text,required this.secondaryText,required this.image,required this.time,required this.isMessageRead}) : super(key: key);
  @override
  _DoctorChatUsersListState createState() => _DoctorChatUsersListState();
}

class _DoctorChatUsersListState extends State<DoctorChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return const DoctorChatDetailPage();
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text),
                          const SizedBox(height: 6,),
                          Text(widget.secondaryText,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,color: widget.isMessageRead?Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }
}