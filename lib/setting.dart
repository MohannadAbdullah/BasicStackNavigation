import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.7,
      minChildSize: 0.3,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: ListView(
            controller: controller,
            children: [
              // 🔹 خط صغير فوق
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              // 🌙 Dark Mode
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text("Dark Mode"),
                trailing: Switch(
                  value: provider.isDarkMode,
                  onChanged: (value) {
                    provider.toggleTheme();
                  },
                ),
              ),

              Divider(),

              // 🔒 مثال إضافي
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About App"),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}