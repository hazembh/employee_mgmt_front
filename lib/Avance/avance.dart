import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AvanceList.dart';

class CreateAvanceScreen extends StatefulWidget {
  final String token;

  CreateAvanceScreen({required this.token});

  @override
  _CreateAvanceScreenState createState() => _CreateAvanceScreenState();
}

class _CreateAvanceScreenState extends State<CreateAvanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customMontantController =
      TextEditingController();
  String? _selectedUsername;
  List<String> _usernames = []; // List to hold usernames
  String? _selectedMontant;
  bool _isCustomMontant = false; // Track if custom montant is selected

  // Predefined montant values
  final List<String> montantValues = [
    '10',
    '20',
    '50',
    '100',
    '150',
    '200',
    '300',
    'Custom'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsernames(); // Fetch usernames on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Avance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown for usernames
              DropdownButtonFormField<String>(
                value: _selectedUsername,
                hint: Text('Select Username'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUsername = newValue;
                  });
                },
                items: _usernames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a username';
                  }
                  return null;
                },
              ),

              // Dropdown for predefined montant or custom input
              DropdownButtonFormField<String>(
                value: _selectedMontant,
                hint: Text('Select Montant'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMontant = newValue;
                    _isCustomMontant = newValue == 'Custom';
                  });
                },
                items:
                    montantValues.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a montant';
                  }
                  if (value == 'Other' &&
                      _customMontantController.text.isEmpty) {
                    return 'Please enter a custom montant';
                  }
                  return null;
                },
              ),

              // Custom Montant input field
              if (_isCustomMontant)
                TextFormField(
                  controller: _customMontantController,
                  decoration:
                      InputDecoration(labelText: 'Enter Custom Montant'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter montant';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Avance'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch the list of usernames from the server
  void _fetchUsernames() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8085/list'), // Adjust the URL to your API endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _usernames = jsonResponse
            .map<String>((user) => user['userName'] as String)
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load usernames')),
      );
    }
  }

  // Submit the form data to the server
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final montant = _isCustomMontant
          ? double.parse(_customMontantController.text)
          : double.parse(_selectedMontant!);

      final response = await http.post(
        Uri.parse('http://localhost:8085/api/avance/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'username': _selectedUsername,
          'montant': montant,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avance created successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AvanceListScreen(
                    token: widget.token,
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create Avance')),
        );
      }
    }
  }
}
