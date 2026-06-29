import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/users_model.dart';

class PrivateChatPage extends StatefulWidget {
  final UsersData targetUser;

  const PrivateChatPage({super.key, required this.targetUser});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _initPreferencesAndConnect();
  }

  Future<void> _initPreferencesAndConnect() async {
    final pref = await SharedPreferences.getInstance();
    final id = pref.getInt("userId");

    setState(() {
      userId = id;
    });

    _connectToSocket(id);
  }

  void _connectToSocket(int? id) {
    socket = IO.io(
      'http://10.131.131.166:8080',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    // Register listeners before connecting
    socket.on("privateMessage", (data) {
      if (data["sender"] == widget.targetUser.id ||
          data["receiver"] == widget.targetUser.id) {
        setState(() {
          _messages.add(data);
        });
      }
    });

    socket.on("privateMessageHistory", (data) {
      setState(() {
        _messages.clear();
        _messages.addAll(List<Map<String, dynamic>>.from(data));
      });
    });

    socket.onConnect((_) {
      print("✅ Connected to private chat socket");

      // ✅ Request message history only when socket is connected
      if (id != null) {
        socket.emit("getPrivateMessages", {
          "senderId": id,
          "receiverId": widget.targetUser.id,
        });
      }
    });

    socket.onDisconnect((_) {
      print("❌ Disconnected from socket");
    });

    socket.connect();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || userId == null) return;

    final messageData = {
      "sender": userId,
      "receiver": widget.targetUser.id,
      "message": text,
      "timestamp": DateTime.now().toIso8601String(),
    };

    socket.emit("privateMessage", messageData);

    setState(() {
      _messages.add(messageData);
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    socket.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.targetUser.firstName} ${widget.targetUser.lastName}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg["sender"].toString() == userId.toString();

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      msg["message"],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
