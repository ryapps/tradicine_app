import 'package:flutter/material.dart';
import 'package:tradicine_app/helpers/db_helper.dart';
import 'package:tradicine_app/models/chat/chat.dart';

class DetailChatView extends StatefulWidget {
  final String sender;
  DetailChatView({required this.sender});

  @override
  _DetailChatViewState createState() => _DetailChatViewState();
}

class _DetailChatViewState extends State<DetailChatView> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await DatabaseHelper().getMessages();
    setState(() {
      _messages = messages.where((msg) => msg.sender == widget.sender).toList();
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final newMessage = Message(
      sender: widget.sender,
      message: _messageController.text,
      timestamp: DateTime.now().toString(),
    );

    await DatabaseHelper().insertMessage(newMessage);
    _messageController.clear();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sender), backgroundColor: Colors.green),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(message.message, style: TextStyle(color: Colors.white)),
                        Text(
                          message.timestamp.substring(11, 16), 
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Ketik pesan...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey),
                  
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
