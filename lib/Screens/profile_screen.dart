// screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profile_placeholder.png'), // Placeholder image; replace with user image
              child: const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 15, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Name and Email
            const Text(
              "Neo Matrix",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "NeoMat@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 30, thickness: 1.5, color: Colors.grey),

            // Profile Details Section
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text("About Me"),
              subtitle: const Text("Tell others about yourself"),
              onTap: () {
                // Handle "About Me" section action
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text("Privacy Settings"),
              subtitle: const Text("Control your privacy preferences"),
              onTap: () {
                // Handle "Privacy Settings" action
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text("Notifications"),
              subtitle: const Text("Manage notification settings"),
              onTap: () {
                // Handle "Notifications" action
              },
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Log Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                // Handle log-out action
              },
            ),
          ],
        ),
      ),
    );
  }
}
