import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  Widget buildInfoTile(String label, String? value) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(value?.isNotEmpty == true ? value! : 'N/A'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<UserInfoModel>(
          future: userService.fetchUserDetails(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('❌ Error: ${snapshot.error}'));
            }

            final user = snapshot.data!.data;
            final fullName =
            "${user.prefix} ${user.firstName} ${user.lastName} ${user.suffix}".trim();

            return ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.jpg"),
                    radius: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    fullName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                buildInfoTile('Email', user.email),
                buildInfoTile('Mobile Number', user.mobileNumber),
                buildInfoTile('Gender', user.gender),
                buildInfoTile('Attendance Type', user.attendaceType),
                buildInfoTile('Organization', user.organization),
                buildInfoTile('Sector', user.sector),
                buildInfoTile('Position', user.position),
                buildInfoTile('Continent', user.continent),
                buildInfoTile('Country', user.country),
              ],
            );
          },
        ),
      ),
    );
  }
}
