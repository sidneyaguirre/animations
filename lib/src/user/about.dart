import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListOfElements extends StatefulWidget {
  const ListOfElements({super.key});

  @override
  State<ListOfElements> createState() => _ListOfElementsState();
}

class _ListOfElementsState extends State<ListOfElements> {
  String _imagePath = 'https://randomfox.ca/images/15.jpg';

  @override
  void initState() {
    super.initState();

    _getImage();
  }

  Future<void> _getImage() async {
    var apiResponse = await http.get(Uri.parse('https://randomfox.ca/floof/'));
    var result = jsonDecode(apiResponse.body);
    _imagePath = result['image'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: CircleAvatar(
            foregroundImage: NetworkImage(
              _imagePath,
            ),
            key: ValueKey<String>(_imagePath),
            maxRadius: 400,
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _getImage,
        icon: Icon(Icons.shuffle),
        label: Text('next'),
      ),
    );
  }
}
