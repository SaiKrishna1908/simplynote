import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/main.dart';

class CustomDrawer extends Drawer {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final email = GetIt.I<AuthService>().firebaseAuth.currentUser?.email;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColor.lighten(AppColor.appSecondaryColor, 0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColor.appAccentColor,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: AppColor.appPrimaryColor,
                  ),
                ),
                Text(
                  email!,
                  style: const TextStyle(
                    color: AppColor.appAccentColor,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              goRouter.go('/home');
            },
          ),
          ListTile(
            title: const Text('Business'),
            onTap: () {
              goRouter.pop();
            },
          ),
          ListTile(
            title: const Text('School'),
            onTap: () {
              goRouter.pop();
            },
          ),
        ],
      ),
    );
  }
}
