import 'package:flutter/material.dart';
import 'package:tradicine_app/components/color/random_color.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/helpers/db_helper.dart';
import 'package:tradicine_app/models/chat/chat.dart';
import 'package:tradicine_app/view/chat/detail_chat.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  List<Message> _chatList = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }


  Future<void> _loadChats() async {
    final chats = await DatabaseHelper().getLastMessagesPerChat();
    setState(() {
      _chatList = chats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(text: 'Daftar Chat'),
        backgroundColor: Colors.white,
      ),
      body: _chatList.isEmpty
          ? Center(child: Text("Belum ada chat"))
          : ListView.builder(
              itemCount: _chatList.length,
              itemBuilder: (context, index) {
                final chat = _chatList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getRandomColor(),
                    child: Text(chat.sender[0].toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(chat.sender,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(chat.message,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(chat.timestamp.substring(11, 16),
                      style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNav(page: 2),
    );
  }
}
