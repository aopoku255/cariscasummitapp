import 'package:cbfapp/models/register_model.dart';
import 'package:cbfapp/services/register_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:cbfapp/screens/loading/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final RegisterService _registerService = RegisterService();

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to dashboard
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    }
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading overlay
      showLoadingOverlay(
        context,
        message: 'Signing in...',
        barrierDismissible: false,
      );

      try {
        RegisterModel user =
            await _registerService.registerUser(_emailController.text.trim());

        // Close loading overlay
        if (mounted) Navigator.pop(context);

        Navigator.pushNamed(context, "/otp", arguments: user);
      } catch (e) {
        print(e);

        // Close loading overlay
        if (mounted) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      bottomSheet: Container(
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dilogo.png"),
          ),
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
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [],
                          image: const DecorationImage(
                            image: AssetImage("assets/images/africa.png"),
                            fit: BoxFit.contain,
                            opacity: 0.04,
                            alignment: Alignment.center,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              Center(
                                child: Image.asset(
                                  "assets/images/africa.png",
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: MainText(
                                  text: "Login",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                  color: AppColors.primaryVoilet,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: MainText(
                                  text:
                                      "Enter your registered email to continue",
                                  fontSize: 14,
                                  color: AppColors.primaryGray,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 24),
                              MainText(
                                text: "Email address",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryVoilet,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "example@email.com",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Button(
                                  label: "Continue",
                                  backgroundColor: AppColors.primaryColor,
                                  onTap: _handleSignIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
