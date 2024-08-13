import 'package:flutter/material.dart';

import '../Avance/AvanceList.dart';
import '../Avance/avance.dart';
import '../Users/ListUsers.dart';

class AppDrawer extends StatefulWidget {
  final String token;

  AppDrawer(this.token);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('List of Users'),
            onTap: () {
              // Navigate to Users List Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UsersListScreen(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Make an Avance'),
            onTap: () {
              // Navigate to Make Avance Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateAvanceScreen(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Avance List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AvanceListScreen(token: widget.token)),
              );
            },
          ),
        ],
      ),
    );
  }
}
