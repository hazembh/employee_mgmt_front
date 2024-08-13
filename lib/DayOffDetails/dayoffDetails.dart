import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyRequestsPage extends StatefulWidget {
  final String token;
  final String role;

  MyRequestsPage(this.token, this.role);

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  List<dynamic> daysOffList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDaysOffRequests();
  }

  Future<void> fetchDaysOffRequests() async {
    final url = Uri.parse('http://localhost:8085/daysOff/myRequests');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer ${widget.token}', // Use the token from the widget
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          daysOffList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void editRequest(String id) {
    // Handle edit action
    print('Edit request with ID: $id');
  }

  void deleteRequest(String id) {
    // Handle delete action
    print('Delete request with ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Days Off Requests'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : daysOffList.isEmpty
                  ? Center(child: Text('No days Off found !'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Start Date')),
                          DataColumn(label: Text('End Date')),
                          widget.role == '(Admin)'
                              ? DataColumn(label: Text('Actions'))
                              : DataColumn(label: Text('')),
                        ],
                        rows: daysOffList.map((daysOff) {
                          return DataRow(
                            cells: [
                              DataCell(Text(daysOff['id'].toString())),
                              DataCell(Text(
                                daysOff['status'],
                                style: TextStyle(
                                    color: daysOff['status'] == 'ACCEPTED'
                                        ? Colors.green
                                        : daysOff['status'] == 'REFUSED'
                                            ? Colors.red
                                            : Colors.orange,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(daysOff['startDate'])),
                              DataCell(Text(daysOff['endDate'])),
                              widget.role == '(Admin)'
                                  ? DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              editRequest(daysOff['id']),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              deleteRequest(daysOff['id']),
                                        ),
                                      ],
                                    ))
                                  : DataCell(Row()),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
    );
  }
}
