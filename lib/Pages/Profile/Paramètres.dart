// ignore_for_file: unused_field, unnecessary_null_comparison, unused_local_variable, deprecated_member_use, unnecessary_import, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, file_names, use_build_context_synchronously, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/userNavbar.dart';
import 'package:neapolis_car/longuage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/main.dart';
import '../Navigation_components/MyDrawer.dart';

class Parametres extends StatefulWidget {
  const Parametres({Key? key}) : super(key: key);

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  late int id = 0;
  late String _nomprenom = '';
  late String _email = '';
  late String _image = '';
  late List<Client> _Client = [];
  final TextEditingController _description = TextEditingController();
  late String dropdownvalue = "";

  final List<String> _items = [
    "Franch",
    "Arabic",
    "English",
  ];
  late int _selectedIndex = 0;
  late int _selectedIndex1=0;
  Future<void> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id')!;
    if (id != null) {
      _selectedIndex1 = 2;
    }
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
          _email = _Client.first.email;
          _image = _Client.first.photo;
        }
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> send(String description) async {
    final response = await http.post(
      Uri.parse('$ip/polls/InsertReclamation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'description': description,
      }),
    );
    if (response.statusCode == 200) {}
  }

  void Problem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translation(context).parametres_message1),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _description,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        labelText: translation(context).historique_description,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[900],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(translation(context).parametres_Envoyer),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                  onPressed: () {
                    send(_description.text);
                    Navigator.of(context).pop(false);
                  },
                  child: Text(translation(context).historique_button2),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void Deconnect() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translation(context).parametres_message2),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation(context).parametres_message3,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[900],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(translation(context).historique_button2),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('id');
                    Navigator.pushNamed(
                      context,
                      'reservation',
                    );
                  },
                  child: Text(translation(context).parametres_button5),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void Languages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 300, // Set the desired width
            height: 300, // Set the desired height
            child: AlertDialog(
              title: Text(translation(context).parametres_button1),
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<Language>(
                      hint: Text(translation(context).parametres_button4),
                      onChanged: (Language? language) async {
                        if (language != null) {
                          Locale _locale =
                              await setLocale(language.languageCode);
                          Myapp.setLocale(
                              context, Locale(language.languageCode, ''));
                          // Navigator.pushNamed(context, 'Parametres');
                        }
                      },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                e.flag,
                                style: const TextStyle(fontSize: 30),
                              ),
                              Text(e.name),
                            ],
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getClient();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(
            context,
            'reservation',
          );
          return true;
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MyAppBar(Title: translation(context).parametres_title),
            ),
            endDrawer: MyDrawer(selectedIndex: _selectedIndex1),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _image != ''
                          ? Center(
                              child: CircleAvatar(
                                backgroundColor: Colors
                                    .white, // You can set the background color of the CircleAvatar if needed
                                radius: 70,
                                child: ClipOval(
                                  child: Image.network(
                                    _image,
                                    width:
                                        300, // Set the desired width of the image
                                    height:
                                        250, // Set the desired height of the image
                                    fit: BoxFit
                                        .cover, // Adjust the image to cover the entire CircleAvatar
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/user.jpg',
                                ),
                                radius: 70,
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 50,
                        color: Colors.grey[800],
                      ),
                      Visibility(
                        visible: _nomprenom != '',

                        child: Column(
                          children: [
                          Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                          child:
                            Text(
                                translation(context).parametres_Nom,
                                style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,

                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                          ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 100, 0),
                              child: Text(
                                _nomprenom,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  letterSpacing: 2.0,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0,250, 0),
                              child: Text(
                                translation(context).inscriotion_Email,
                                style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Text(
                                _email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  letterSpacing: 2.0,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          translation(context).parametres_compte,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation:
                            5, // This is similar to the spreadRadius in the boxShadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Color(0xfffffcfc),
                        shadowColor: Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _nomprenom != ""
                                  ? Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, 'Edite Profil',
                                                arguments: {'Client': _Client});
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, 'EditeProfil',
                                                arguments: {'Client': _Client});
                                          },
                                          child: Text(
                                            translation(context)
                                                .parametres_button2,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(""),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Problem();
                                    },
                                    icon: Icon(Icons.report),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Problem();
                                    },
                                    child: Text(
                                      translation(context).parametres_button3,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Handle "Modifier la langue" functionality here
                                    },
                                    icon: Icon(Icons.language),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Languages();
                                    },
                                    child: Text(
                                      translation(context).parametres_button4,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _nomprenom != ""
                                  ? Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Deconnect();
                                          },
                                          icon: Icon(Icons.logout),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Deconnect();
                                          },
                                          child: Text(
                                            translation(context)
                                                .parametres_button5,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(""),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
            bottomNavigationBar: _nomprenom != '' ? UserNavBar(selectedIndex: _selectedIndex) : NavBar(selectedIndex: 2)));
  }
}
