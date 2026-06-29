import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/screens/dashboard/DashboardAgenda.dart';
import 'package:cbfapp/screens/dashboard/DashboardHome.dart';
import 'package:cbfapp/screens/dashboard/DashboardResources.dart';
import 'package:cbfapp/screens/dashboard/DashboardSpeakers.dart';
import 'package:cbfapp/screens/dashboard/QRScannerScreen.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  late Future<UserInfoModel> _userdetailsFuture;
  late List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("userId");

    if (userId != null) {
      _userdetailsFuture = UserService().fetchUserDetails(userId);

      setState(() {
        _pages = [
          DashboardHome(userDetailsFuture: _userdetailsFuture),
          const DashboardAgenda(),
          const DashboardSpeakers(),
          const DashboardResources(),
        ];
      });
    } else {
      debugPrint("User ID not found in SharedPreferences");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required String assetPath,
    required String? label,
  }) {
    final bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Image.asset(
        assetPath,
        height: 20,
        width: 24,
        color: isSelected ? AppColors.primaryColor : const Color(0xFF374957),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      floatingActionButton: _selectedIndex != 3
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                );

                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanned: $result')),
                  );
                }
              },
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 6,
              highlightElevation: 10,
              child: const Icon(Icons.qr_code_scanner, size: 28),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        elevation: 3,
        // shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: AppColors.primaryWhite,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.primaryColor.withOpacity(0.9),
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildNavItem(
                index: 0,
                assetPath: "assets/images/homeicon.png",
                label: "Home"),
            _buildNavItem(
                index: 1,
                assetPath: "assets/images/agenda.png",
                label: "Agenda"),
            _buildNavItem(
                index: 2,
                assetPath: "assets/images/microphone.png",
                label: "Speakers"),
            _buildNavItem(
                index: 3,
                assetPath: "assets/images/resources.png",
                label: "Gallery"),
          ],
        ),
      ),
    );
  }
}
