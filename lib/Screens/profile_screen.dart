import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../measurements_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImage;
  bool _isLoggedIn = true;
  String _aboutMeText = "";
  bool _isViewingAboutMe = false;
  bool _isViewingSettings = false;
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _aboutMeText =
          prefs.getString('aboutMe') ?? "Tell others about yourself!";
      _selectedLanguage = prefs.getString('language') ?? "English";
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aboutMe', _aboutMeText);
    await prefs.setString('language', _selectedLanguage);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ref.read(measurementsProvider.notifier).clearMeasurements();

    setState(() {
      _aboutMeText = "Tell others about yourself!";
      _profileImage = null;
      _selectedLanguage = "English";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All data cleared!")),
    );
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return _buildLoginScreen();
    }

    if (_isViewingAboutMe) {
      return _buildAboutMeScreen();
    }

    if (_isViewingSettings) {
      return _buildSettingsScreen(ref);
    }

    return _buildProfileScreen();
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/default_profile.jpg')
                            as ImageProvider,
                  ),
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text("About Me"),
              subtitle: const Text("View your personal journey"),
              onTap: () {
                setState(() {
                  _isViewingAboutMe = true;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text("Settings"),
              subtitle: const Text("Manage your preferences"),
              onTap: () {
                setState(() {
                  _isViewingSettings = true;
                });
              },
            ),
            const SizedBox(height: 20),
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
              onPressed: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _handleLogin,
          child: const Text("Log In"),
        ),
      ),
    );
  }

  Widget _buildAboutMeScreen() {
    TextEditingController controller =
        TextEditingController(text: _aboutMeText);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Me"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isViewingAboutMe = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Write something about yourself...",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _aboutMeText = controller.text;
                  _isViewingAboutMe = false;
                });
                _savePreferences();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsScreen(WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isViewingSettings = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              items: ["English", "Spanish", "French"]
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _savePreferences();
                }
              },
              decoration: const InputDecoration(
                labelText: "Select Language",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.green),
              title: const Text("Help Center"),
              subtitle: const Text("Get assistance with the app"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Help Center coming soon!")),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _clearData(context, ref),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear All Data"),
            ),
          ],
        ),
      ),
    );
  }
}
