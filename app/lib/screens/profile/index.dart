import 'package:flutter/material.dart';

class ProfileSceen extends StatefulWidget {
  const ProfileSceen({super.key});
  static const String name = "profile";
  static const String path = "/profile";

  @override
  State<ProfileSceen> createState() => _ProfileSceenState();
}

class _ProfileSceenState extends State<ProfileSceen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("profile"),
      ),
    );
  }
}
