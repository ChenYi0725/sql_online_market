import 'package:flutter/material.dart';
import 'package:database_final/controller/database_controller.dart';
import '../model/user.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseController databaseController = DatabaseController();
  late Future<dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = databaseController.singleUserData(widget.user.id);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(), // 导航到登录页面
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                _logout();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<dynamic>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          } else {
            var userData = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(userData['user_name']),
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(userData['email']),
                      ),
                      ListTile(
                        title: const Text('Phone'),
                        subtitle: Text(userData['phone']),
                      ),
                      ListTile(
                        title: const Text('Role'),
                        subtitle: Text(userData['role']),
                      ),
                      ListTile(
                        title: const Text('Registration Date'),
                        subtitle: Text(userData['registration_date'] != null
                            ? userData['registration_date'].substring(0, 10)
                            : 'N/A'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 30,
                        height: 20,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: _confirmLogout,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                maximumSize: MaterialStateProperty.all<Size>(
                                  const Size(100, 40),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16, // 设置字体大小
                                  fontWeight: FontWeight.bold, // 设置字体粗细
                                  color: Colors.white, // 设置字体颜色
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
