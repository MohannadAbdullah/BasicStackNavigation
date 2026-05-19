import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/app_provider.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.7,
      minChildSize: 0.3,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: ListView(
            controller: controller,
            children: [
              // 🔹 السحب من الأعلى
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                "Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                trailing: Selector<AppProvider, bool>(
                  selector: (_, p) => p.isDarkMode,
                  builder: (context, isDarkMode, _) {
                    return Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<AppProvider>().toggleTheme();
                      },
                    );
                  },
                ),
              ),

              Divider(),

              // ℹ️ About App
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About App"),
                onTap: () {},
              ),

              Divider(),

              // 🔴 Logout
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pop(context);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
