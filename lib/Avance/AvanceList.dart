import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AvanceEntity.dart';

class AvanceListScreen extends StatefulWidget {
  final String token;

  AvanceListScreen({required this.token});

  @override
  _AvanceListScreenState createState() => _AvanceListScreenState();
}

class _AvanceListScreenState extends State<AvanceListScreen> {
  late Future<List<Avance>> futureAvances;

  @override
  void initState() {
    super.initState();
    futureAvances = fetchAvances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Avances'),
      ),
      body: FutureBuilder<List<Avance>>(
        future: futureAvances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Amount: ${snapshot.data![index].amount}'),
                  subtitle: Text('Date: ${snapshot.data![index].dateAmount}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteAvance();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('No avances found');
          }
        },
      ),
    );
  }

  Future<List<Avance>> fetchAvances() async {
    final response = await http.get(
      Uri.parse('http://localhost:8085/api/avance/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Avance>((data) => Avance.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load avances');
    }
  }

  void _deleteAvance() async {}
}
