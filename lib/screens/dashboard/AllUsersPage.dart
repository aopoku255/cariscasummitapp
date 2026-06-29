import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../models/users_model.dart';
import '../../theme/colors.dart';
import 'PrivateChat.dart';

class AllUsersPage extends StatefulWidget {
  final int onlineUserCount; // You can remove this if server now handles it

  const AllUsersPage({
    super.key,
    required this.onlineUserCount,
  });

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  List<UsersData> _users = [];
  List<UsersData> _filteredUsers = [];
  Set<String> _onlineUserIds = {}; // ✅ Track online users by userId
  String _searchQuery = '';
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
  }

  void _connectToSocket() {
    socket = IO.io(
      'https://unified-ion-463310-a5.uc.r.appspot.com', // Replace with your deployed server
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("✅ Connected to socket server");

      socket.on("allUsers", (data) {
        print("👥 Received users: ${data.length}");
        final users =
            (data as List).map((json) => UsersData.fromJson(json)).toList();
        setState(() {
          _users = users;
          _filteredUsers = _applySearch(users, _searchQuery);
        });
      });
    });

    socket.on("onlineUsers", (data) {
      print("🟢 Online users: $data");
      setState(() {
        _onlineUserIds = Set<String>.from(data.map((e) => e.toString()));
      });
      print("ONLINE IDS: ${_onlineUserIds}");
    });

    socket.onDisconnect((_) {
      print("❌ Disconnected from socket server");
    });
  }

  List<UsersData> _applySearch(List<UsersData> users, String query) {
    if (query.isEmpty) return users;
    return users.where((user) {
      final fullName = "${user.firstName} ${user.lastName}".toLowerCase();
      final organization = user.organization.toLowerCase();
      return fullName.contains(query.toLowerCase()) ||
          organization.contains(query.toLowerCase());
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _applySearch(_users, _searchQuery);
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalOnline = _onlineUserIds.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("All Users"),
            Text(
              "$totalOnline online out of ${_users.length}",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or organization',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded shape
                  borderSide:
                      BorderSide.none, // Optional: remove default border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      final fullName = "${user.firstName} ${user.lastName}";
                      final isOnline =
                          _onlineUserIds.contains(user.id.toString());

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isOnline ? Colors.green : Colors.grey,
                          child: Text(user.firstName[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(fullName),
                        subtitle: Text(user.organization),
                        trailing: isOnline
                            ? const Text("Online",
                                style: TextStyle(color: Colors.green))
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrivateChatPage(
                                targetUser: user,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
