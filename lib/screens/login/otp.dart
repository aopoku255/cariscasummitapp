import 'dart:async';
import 'dart:convert';

import 'package:cbfapp/models/register_model.dart';
import 'package:cbfapp/services/otp_service.dart';
import 'package:cbfapp/services/register_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:cbfapp/screens/loading/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isResending = false;
  int _resendSeconds = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_resendSeconds > 1) {
          _resendSeconds--;
        } else {
          _resendSeconds = 0;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendOtp() async {
    final user = ModalRoute.of(context)?.settings.arguments as RegisterModel?;
    final email = (user?.email ?? '').trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is missing for OTP resend.')),
      );
      return;
    }

    if (_isResending || _resendSeconds > 0) return;

    setState(() => _isResending = true);

    try {
      await RegisterService().registerUser(email);
      _startResendTimer();
      for (final controller in _otpControllers) {
        controller.clear();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A new OTP has been sent to your email.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    final otp =
        _otpControllers.map((controller) => controller.text.trim()).join();

    if (!RegExp(r'^\d{4}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter the 4-digit OTP sent to your email.')),
      );
      return;
    }

    // Show loading overlay
    showLoadingOverlay(
      context,
      message: 'Verifying OTP...',
      barrierDismissible: false,
    );

    try {
      final user = ModalRoute.of(context)?.settings.arguments as RegisterModel?;
      final email = (user?.email ?? '').trim();

      if (email.isEmpty) {
        throw Exception('Email is missing for OTP verification.');
      }

      final loginResponse =
          await OtpService().verifyOtp(email: email, otp: otp);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);
      await prefs.setInt('userId', loginResponse.data.id);
      await prefs.setString(
          'userData', jsonEncode(loginResponse.data.toJson()));

      if (!mounted) return;
      Navigator.pop(context); // Close loading overlay
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false,
          arguments: loginResponse);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as RegisterModel?;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          color: AppColors.primaryColor,
        ),
      ),
      bottomSheet: Container(
        height: 30,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/dilogo.png')),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF7FAFF),
                Color(0xFFF3EEFF),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/africa.png'),
                          fit: BoxFit.contain,
                          opacity: 0.02,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/africa.png',
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 14),
                          MainText(
                            text: 'Enter OTP',
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: AppColors.primaryVoilet,
                          ),
                          const SizedBox(height: 8),
                          MainText(
                            text: user?.email != null && user!.email.isNotEmpty
                                ? 'We sent a 4-digit code to ${user.email}'
                                : 'We sent a 4-digit code to your email address.',
                            fontSize: 14,
                            color: AppColors.primaryGray,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 56,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 3) {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNodes[index + 1]);
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: Button(
                              label: 'Verify OTP',
                              backgroundColor: AppColors.primaryColor,
                              onTap: _verifyOtp,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Didn\'t receive the code? ',
                                style: TextStyle(color: Colors.black87),
                              ),
                              TextButton(
                                onPressed: (_isResending || _resendSeconds > 0)
                                    ? null
                                    : _resendOtp,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                  disabledForegroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                child: Text(
                                  _resendSeconds > 0
                                      ? 'Resend in $_resendSeconds s'
                                      : 'Resend OTP',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
