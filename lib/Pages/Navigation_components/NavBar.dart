// ignore_for_file: implementation_imports, use_key_in_widget_constructors, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_constructors

// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  const NavBar({required this.selectedIndex});

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  late int _id = 0;
  late List<Client> _Client = [];
  late int id = 0;
  late String _nomprenom = '';
  late bool _session = false;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        {
          Navigator.pushNamed(context, 'reservation');
        }
        break;

      case 1:
        {
          Navigator.pushNamed(context, 'ListPost');
        }
        break;
      case 2:
        {
          if (_session == true) {
            Navigator.pushNamed(
              context,
              'Historique',
            );
          } else {
            Navigator.pushNamed(
              context,
              'Parametres',
            );
          }
        }
        break;
    }
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _session = true;
        getClient();
      });
    } else {
      if (widget.selectedIndex == 1)
        setState(() {
          widget.selectedIndex + 1;
        });
    }
  }

  Future<void> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      _id = prefs.getInt('id')!;
      final response = await http.post(
        Uri.parse('$ip/polls/Afficher_Client'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'id': _id,
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
        throw Exception('Failed to Client');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: translation(context).accueil,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: translation(context).post_title,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: _nomprenom != '' ? _nomprenom : translation(context).visture,
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
