import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyRequestsLeavePage extends StatefulWidget {
  final String token;
  final bool isAdmin;

  MyRequestsLeavePage(this.token, this.isAdmin);

  @override
  _MyRequestsLeavePageState createState() => _MyRequestsLeavePageState();
}

class _MyRequestsLeavePageState extends State<MyRequestsLeavePage> {
  List<dynamic> leaveList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    final url = Uri.parse('http://localhost:8085/leaves/myRequests');

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
          leaveList = json.decode(response.body);
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
        title: Text('My leave Requests'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : leaveList.isEmpty
                  ? Center(child: Text('No days Off found !'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Start Time')),
                          DataColumn(label: Text('End Time')),
                          DataColumn(label: Text('Reason')),
                          widget.isAdmin
                              ? DataColumn(label: Text('Actions'))
                              : DataColumn(label: Text('')),
                        ],
                        rows: leaveList.map((leave) {
                          return DataRow(
                            cells: [
                              DataCell(Text(leave['id'].toString())),
                              DataCell(Text(
                                leave['status'],
                                style: TextStyle(
                                    color: leave['status'] == 'ACCEPTED'
                                        ? Colors.green
                                        : leave['status'] == 'REFUSED'
                                            ? Colors.red
                                            : Colors.orange,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(leave['date'])),
                              DataCell(Text(leave['startTime'])),
                              DataCell(Text(leave['endTime'])),
                              DataCell(Text(leave['reason'])),
                              widget.isAdmin
                                  ? DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              editRequest(leave['id']),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              deleteRequest(leave['id']),
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
