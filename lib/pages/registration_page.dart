import 'package:flutter/material.dart';
import 'package:database_final/controller/database_controller.dart';
import 'package:intl/intl.dart';
import 'package:database_final/model/user.dart';

import 'main_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  DatabaseController databaseController = DatabaseController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // 檢查兩次輸入的密碼是否相同
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  // 密碼相同，進行註冊
                  final user = _register();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(user: user),
                    ),
                  );
                } else {
                  // 密碼不相同，顯示錯誤訊息
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Passwords do not match'),
                  ));
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orangeAccent),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> _register() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    databaseController.userRegister(_nameController.text, _emailController.text,
        _passwordController.text, _phoneController.text, "客戶", formattedDate);
    final user = databaseController.userLogIn(
        _emailController.text, _passwordController.text);
    return user;
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _phoneController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   super.dispose();
  // }
}
