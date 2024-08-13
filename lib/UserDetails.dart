import 'package:flutter/material.dart';
import 'dart:convert';

import 'DayOffDetails/dayoffDetails.dart';
import 'Drawer/drawer.dart';
import 'Leave/MyLeaveRequest.dart';

// Model classes

class UserDetails {
  final User user;
  final String jwtToken;

  UserDetails({
    required this.user,
    required this.jwtToken,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      user: User.fromJson(json['user']),
      jwtToken: json['jwtToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'jwtToken': jwtToken,
    };
  }
}

class User {
  final String userName;
  final String email;
  final String userPassword;
  final String? phoneNumber;
  final String? creationAccountDate;
  final int daysOff;
  final String? address; // Fixed typo from 'adress' to 'address'
  final int leaveHour;
  final int salary;
  final List<Role> role;
  final int fixSalary;

  User({
    required this.userName,
    required this.email,
    required this.userPassword,
    this.phoneNumber,
    this.creationAccountDate,
    required this.daysOff,
    this.address,
    required this.leaveHour,
    required this.salary,
    required this.role,
    required this.fixSalary,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var roleList = json['role'] as List;
    List<Role> roleObjects = roleList.map((i) => Role.fromJson(i)).toList();

    return User(
      userName: json['userName'],
      email: json['email'],
      userPassword: json['userPassword'],
      phoneNumber: json['phoneNumber'],
      creationAccountDate: json['creationAccountDate'],
      daysOff: json['daysOff'],
      address: json['address'],
      leaveHour: json['leaveHour'],
      salary: json['salary'],
      role: roleObjects,
      fixSalary: json['fixSalary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'userPassword': userPassword,
      'phoneNumber': phoneNumber,
      'creationAccountDate': creationAccountDate,
      'daysOff': daysOff,
      'address': address,
      'leaveHour': leaveHour,
      'salary': salary,
      'role': role.map((r) => r.toJson()).toList(),
      'fixSalary': fixSalary,
    };
  }
}

class Role {
  final String roleName;
  final String roleDescription;
  final int idrole;

  Role({
    required this.roleName,
    required this.roleDescription,
    required this.idrole,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleName: json['roleName'],
      roleDescription: json['roleDescription'],
      idrole: json['idrole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
      'roleDescription': roleDescription,
      'idrole': idrole,
    };
  }
}

// UserDetailsScreen widget

class UserDetailsScreen extends StatelessWidget {
  final UserDetails userDetails;

  UserDetailsScreen({required this.userDetails});

  @override
  Widget build(BuildContext context) {
    bool isAdmin =
        userDetails.user.role.map((role) => role.roleName).toString() ==
            '(Admin)';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white10,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.monetization_on,
                color: Colors.green,
                size: 40,
              ),
              SizedBox(
                  width: 8), // Add some spacing between the icon and the text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Fix Salary: ${userDetails.user.fixSalary} DT ',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Salary: ${userDetails.user.salary} DT',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      drawer: isAdmin ? AppDrawer(userDetails.jwtToken) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${userDetails.user.userName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Email: ${userDetails.user.email}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Phone Number: ${userDetails.user.phoneNumber ?? ''}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Creation Date: ${userDetails.user.creationAccountDate ?? ''}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyRequestsPage(
                              userDetails.jwtToken,
                              userDetails.user.role
                                  .map((role) => role.roleName)
                                  .toString()),
                        ));
                  },
                  child: Text(
                    'Days Off: ${userDetails.user.daysOff} days',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Address: ${userDetails.user.address ?? ''}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyRequestsLeavePage(
                              userDetails.jwtToken,isAdmin
                             ),
                        ));
                  },
                  child: Text(
                    'Leave Hours: ${userDetails.user.leaveHour} hours',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
