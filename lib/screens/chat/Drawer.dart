import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_chek/utils/google_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = (GoogleAuthService()).getUser();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user?.photoURL ?? ""),
                  radius: 30, // Ukuran lingkaran, 50 terlalu besar
                ),
                const SizedBox(width: 10),
                Expanded(
                  // ✅ Ini agar teks tidak berada di tengah
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata kiri
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user?.displayName ?? "Anonym",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Konsultasi'),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await GoogleAuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
