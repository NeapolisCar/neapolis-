// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_key_in_widget_constructors, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_constructors, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class MyDrawer extends StatefulWidget {
  final int selectedIndex;
  const MyDrawer({required this.selectedIndex});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late List<Client> _Client = [];
  late int id = 0;
  late String _nomprenom = 'Visture';
  late String _image = '';
  late bool _session = false;
  var whatsappUrl = "whatsapp://send?phone=${"+21698307590"}";
  final Uri phoneNumber = Uri.parse('tel:+21698307590');
  final String instagram = 'https://www.instagram.com/neapolis_cars/?igshid=MzRlODBiNWFlZA==';
  final String TikTok = 'https://www.tiktok.com/@neapolis.car';
  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _session = true;
      });
      getClient();
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
      id = prefs.getInt('id')!;
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
            _image = _Client.first.photo;
          }
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    }
  }


  void Dialog() {
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
                  child: Text(translation(context).details_voiture_RAn),
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
                    Navigator.pushNamed(context,'reservation');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                children: [
                  _image != ""
                      ? Center(
                          child: CircleAvatar(
                            backgroundColor: Colors
                                .white, // You can set the background color of the CircleAvatar if needed
                            radius: 50,
                            child: ClipOval(
                              child: Image.network(
                                _image,
                                width:
                                    300, // Set the desired width of the image
                                height:
                                    240, // Set the desired height of the image
                                fit: BoxFit
                                    .cover, // Adjust the image to cover the entire CircleAvatar
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/user.png',
                          ),
                          radius: 50,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_nomprenom),
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
                color: widget.selectedIndex == 0 ? Colors.red : Colors.white,
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.clipboardList,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(translation(context).drawer_button),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'reservation');
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
                color: widget.selectedIndex == 1 ? Colors.red : Colors.white,
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.carSide,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(translation(context).drawer_button2),
                onTap: () {
                  Navigator.pushNamed(context, 'ListPost');
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
                color: widget.selectedIndex == 2 ? Colors.red : Colors.white,
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.circleUser,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(translation(context).drawer_button3),
                onTap: () {
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
                },
              ),
            ),
          ),
          _session
              ? Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Container(
                    // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                      color:
                          widget.selectedIndex == 3 ? Colors.red : Colors.white,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(translation(context).parametres_button5),
                      onTap: () {
                        Dialog();
                      },
                    ),
                  ),
                )
              : Text(""),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Text(translation(context).drawer_text),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  TextButton.icon(
                    icon: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.green,
                      size: 30,
                    ),
                    label: Text(''),
                    onPressed: () {
                      launchUrl(phoneNumber);
                    },
                  ),
                  Text(translation(context).telephone),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  TextButton.icon(
                    icon: FaIcon(
                      FontAwesomeIcons.tiktok,
                      color: Colors.black,
                      size: 30,
                    ),
                    label: Text(''),
                      onPressed: ()async {
                        if (await canLaunch(TikTok)) {
                          await launch(TikTok);
                        } else {
                          throw 'Could not launch ${TikTok}';
                        }
                      },
                  ),
                  Text(translation(context).tikTok),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  TextButton.icon(
                    icon: FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.red,
                      size: 30,
                    ),
                    label: Text(''),
                      onPressed: ()async {
                        if (await canLaunch(instagram)) {
                          await launch(instagram);
                        } else {
                          throw 'Could not launch ${instagram}';
                        }
                      }
                  ),
                  Text(translation(context).instagram),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  TextButton.icon(
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      size: 30,
                    ),
                    label: Text(''),
                    onPressed: () async {
                      launch(whatsappUrl);
                    },
                  ),
                  Text(translation(context).whatsapp),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
