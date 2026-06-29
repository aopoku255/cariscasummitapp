import 'dart:convert';

import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/register_model.dart';
import '../../services/login_service.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ Tip 1
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final RegisterModel? user =
        ModalRoute.of(context)?.settings.arguments as RegisterModel?;

    if (user != null) {
      emailController.text = user.email;
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: EdgeInsets.all(10),
          color: AppColors.primaryColor,
        ),
      ),
      bottomSheet: Container(
        height: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/dilogo.png")),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/africa.png"),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MainText(
                      text: "Sign in",
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: AppColors.primaryGray,
                    ),
                    SizedBox(height: 60),
                    Form(
                      key: _formKey, // ✅ Tip 1: Assign GlobalKey
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user == null) ...[
                            MainText(
                              text: "Enter your email",
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGray,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Email is required"
                                      : null,
                              decoration: InputDecoration(
                                hintText: "example@email.com",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: AppColors.primaryGray),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                          MainText(
                            text: "Enter password sent to your email",
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGray,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) => value == null || value.isEmpty
                                ? "Password is required"
                                : null,
                            decoration: InputDecoration(
                              hintText: "**********",
                              labelStyle: TextStyle(
                                  fontSize: 20, color: AppColors.primaryGray),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: Button(
                              label: "Sign in",
                              backgroundColor: AppColors.primaryColor,
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate())
                                        return;

                                      setState(() => isLoading = true);

                                      try {
                                        final loginResponse =
                                            await LoginService().loginUser(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );

                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        await pref.setString(
                                            'token', loginResponse.token);
                                        await pref.setInt(
                                            'userId', loginResponse.data.id);
                                        await pref.setString(
                                            'userData',
                                            jsonEncode(
                                                loginResponse.data.toJson()));
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/dashboard",
                                            (route) => false,
                                            arguments: loginResponse);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e
                                                .toString()
                                                .replaceFirst(
                                                    'Exception: ', '')),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading) // ✅ Tip 2: Show spinner
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor)),
              ),
          ],
        ),
      ),
    );
  }
}
