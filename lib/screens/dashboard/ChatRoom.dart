import 'package:cbfapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/user_model.dart';
import '../../models/users_model.dart';
import '../../theme/colors.dart';
import 'AllUsersPage.dart';
import 'UserChatProfile.dart';

class ChatRoomPage extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const ChatRoomPage({super.key, this.userDetailsFuture});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late Future<UsersInfoModel?> _allUsers;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  IO.Socket? socket;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  UserData? currentUser;
  int onlineUsers = 0;
  Map<String, dynamic>? _replyTo;

  @override
  void initState() {
    super.initState();
    _loadUserAndConnect();
    _allUsers = UserService().fetchAllUsers();
  }

  Future<void> _loadUserAndConnect() async {
    if (widget.userDetailsFuture != null) {
      final user = await widget.userDetailsFuture!;
      setState(() {
        currentUser = user.data;
      });
      _connectToSocket();
    }
  }


  void _connectToSocket() {
    socket = IO.io(
        'https://unified-ion-463310-a5.uc.r.appspot.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    socket!.onConnect((_) {
      print('✅ Connected to server');
      socket!.emit("registerUser", currentUser!.id);
      print("📤 Sent id to server: ${currentUser!.id}");
    });

    // ✅ Send email of current user to backend




    socket!.on("messageHistory", (history) {
      setState(() {
        _messages.clear();
        for (var item in history) {
          _messages.add(Map<String, dynamic>.from(item));
        }
      });
    });

    socket!.on("message", (data) {
      setState(() {
        _messages.add(Map<String, dynamic>.from(data));
      });
    });

    socket!.on("userCount", (data) {
      setState(() {
        onlineUsers = data ?? 0;
      });
    });

    socket!.onDisconnect((_) {
      print('❌ Disconnected from server');
    });
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty || currentUser == null) return;

    final msgData = {
      'userId': currentUser!.id.toString(),
      'name': "${currentUser!.firstName} ${currentUser!.lastName}",
      'profileImageUrl': "assets/images/user.jpg",
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'replyTo': _replyTo != null
          ? {
              'message': _replyTo!['message'],
              'name': _replyTo!['name'],
            }
          : null,
    };

    socket?.emit("message", msgData);
    _controller.clear();
    setState(() {
      _replyTo = null;
    });
  }

  String _formatTime(String timestamp) {
    final time = DateTime.parse(timestamp);
    return DateFormat.jm().format(time);
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(messageDate).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return DateFormat("dd MMM yyyy").format(date);
  }

  @override
  void dispose() {
    socket?.dispose();
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Group Chat")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, List<Map<String, dynamic>>> groupedMessages = {};
    final filteredMessages = _searchQuery.isEmpty
        ? _messages
        : _messages.where((msg) {
            final content = (msg['message'] ?? '').toString().toLowerCase();
            final sender = (msg['name'] ?? '').toString().toLowerCase();
            return content.contains(_searchQuery) ||
                sender.contains(_searchQuery);
          }).toList();

    for (var msg in filteredMessages) {
      final timestamp = msg['timestamp'];
      if (timestamp != null) {
        final date = DateTime.parse(timestamp);
        final key = _formatDateLabel(date);
        groupedMessages.putIfAbsent(key, () => []).add(msg);
      }
    }

    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.primaryWhite,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllUsersPage(
                    onlineUserCount: onlineUsers,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$onlineUsers ${onlineUsers > 1 ? "users" : "user"} online",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<UsersInfoModel?>(
                  future: _allUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("");
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data?.data == null) {
                      return const Text("Failed to load users");
                    }

                    final users = snapshot.data!.data;

                    final names = users
                        .map((user) => "${user.firstName} ${user.lastName}")
                        .join(", ");

                    return Text(
                      names,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )
              ],
            ),
          ),

        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
        toolbarHeight: 80, // Adjust height if needed
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupedMessages.length,
              itemBuilder: (context, groupIndex) {
                final dateKey = groupedMessages.keys.elementAt(groupIndex);
                final dayMessages = groupedMessages[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dateKey,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ...dayMessages.map((msg) {
                      final isMe = msg['userId'] == currentUser!.id.toString();
                      final timestamp =
                          msg['timestamp'] ?? DateTime.now().toIso8601String();

                      return GestureDetector(
                        onLongPress: () => setState(() => _replyTo = msg),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMe)
                                GestureDetector(
                                  onTap: () {
                                    final userId =
                                        int.tryParse(msg['userId'] ?? '');
                                    if (userId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              UserProfileScreen(userId: userId),
                                        ),
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage("assets/images/user.jpg"),
                                  ),
                                ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg['name'] ?? 'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (msg['replyTo'] != null)
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${msg['replyTo']['name']}: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: msg['replyTo']['message'],
                                                style: TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? Colors.blue.shade100
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            msg['message'] ?? '',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatTime(timestamp),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isMe) const SizedBox(width: 10),
                              if (isMe)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("assets/images/user.jpg"),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          if (_replyTo != null)
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Replying to ${_replyTo!['name']}\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: _replyTo!['message'],
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => setState(() => _replyTo = null),
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter message",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
