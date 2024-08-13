import 'dart:convert';
import 'package:flutter/material.dart';
import '../UserDetails.dart';
import 'package:http/http.dart' as http;

class UsersListScreen extends StatefulWidget {
  final String token;

  UsersListScreen({required this.token});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late Future<List<User>> futureUsers;
  List<User> allUsers = []; // Store all users
  List<User> filteredUsers = []; // Store filtered users
  String searchQuery = ''; // Store the search query

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filteredUsers = allUsers
                      .where((user) => user.userName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // Store the fetched users for filtering
                  allUsers = snapshot.data!;
                  filteredUsers = searchQuery.isEmpty
                      ? allUsers
                      : allUsers
                          .where((user) => user.userName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredUsers[index].userName),
                        subtitle: Text(
                          'Role: ${filteredUsers[index].role.map((e) => e.roleName).toString()}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Implement edit functionality here
                                _editUser(filteredUsers[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Implement delete functionality here
                                _deleteUser();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Text('No users found');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Service to fetch users
  Future<List<User>> fetchUsers(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:8085/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _editUser(User user) {
    // Implement your edit user logic here
    // For example, you can navigate to an edit screen and pass the user data
  }

  void _deleteUser() async {}
}
