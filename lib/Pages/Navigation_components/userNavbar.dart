// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import '../../main.dart';

class UserNavBar extends StatefulWidget {
  final int selectedIndex;
  UserNavBar({required this.selectedIndex});

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  late List<Client> _Client = [];
  late int id = 0;
  String _nomprenom = 'Visture';
  // ignore: unused_field
  late bool _session = false;

  @override
  void initState() {
    super.initState();
    _loadId();
  }

  Future<void> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      id = prefs.getInt('id')!;
      List<Client> client = [];
      final response = await http.post(
        Uri.parse('$ip/polls/Afficher_Client'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'id': id,
        }),
      );
      if (response.statusCode == 200) {
        final List<Client> client = jsonDecode(response.body)
            .map<Client>((json) => Client.fromJson(json))
            .toList();
        setState(() {
          _Client = client;
          if (_Client.isNotEmpty) {
            _nomprenom = _Client.first.nomprenom;
          }
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        {
          Navigator.pushNamed(context, 'Historique');
        }
        break;
      case 1:
        {
          Navigator.pushNamed(context, 'Parametres');
        }
        break;
    }
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _session = true;
      });
      getClient();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: translation(context).historique_title,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: _nomprenom ,
      ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
