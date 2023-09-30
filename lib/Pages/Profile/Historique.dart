// ignore_for_file: deprecated_member_use, unused_local_variable, unnecessary_null_comparison, prefer_final_fields, use_build_context_synchronously, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/userNavbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/Demande.dart';
import 'package:neapolis_car/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class Historique extends StatefulWidget {
  const Historique({Key? key}) : super(key: key);

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  late String button = "Anneluer";
  late bool value = false;
  late int id = 0;
  bool isInternet = false;
  List<Demande> _demande = [];
  final TextEditingController _description = TextEditingController();
  Future<void> _fetchDemande(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_demande_Client'),
      body: jsonEncode(
        <String, dynamic>{
          'id': id,
        },
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _demande = jsonData.map((json) {
          if (json['type'] == "Reservation") {
            json['address_depart'] = ' ';
            json['address_fin'] = ' ';
          } else if (json['type'] == "Transfer") {
            json['dateDeRevinier'] = ' ';
          }
          return Demande.fromJson(json);
        }).toList();
      });
    } else {
      throw Exception('Failed to load voitures');
    }
  }

  late int _selectedIndex = 0;
  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        id = prefs.getInt('id')!;
      });
      _fetchDemande(id);
    } else {
      Navigator.pushNamed(context, 'login');
    }
  }

  void Dialog(int id) {
    bool _acceptRole = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translation(context).details_voiture_reglaTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation(context).historique_message1,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
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
                    CheckboxListTile(
                      title: Text(translation(context).details_voiture_RA),
                      value: _acceptRole,
                      onChanged: (newValue) {
                        setState(() {
                          _acceptRole = newValue ?? false;
                        });
                      },
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
                    // Effectuer une action lorsque le bouton Annuler est pressé
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
                  onPressed: _acceptRole
                      ? () {
                          Annule(id);
                          Navigator.of(context).pop(false);
                        }
                      : null,
                  child: Text(translation(context).historique_button1),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> Annule(int id_demande) async {
    final prefs = await SharedPreferences.getInstance();
    final id_client = prefs.getInt('id')!;
    final response = await http.post(
      Uri.parse('$ip/polls/InserAnnulation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'id_demande': id_demande,
        'descriptions': _description.text
      }),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _demande = jsonData.map((json) {
          if (json['type'] == "Reservation") {
            json['address_depart'] = ' ';
            json['address_fin'] = ' ';
          } else if (json['type'] == "Transfer") {
            json['dateDeRevinier'] = ' ';
          }
          return Demande.fromJson(json);
        }).toList();
      });
      Navigator.pushNamed(context, 'Historique');
    } else {
      throw Exception('Failed to load voitures');
    }
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  testInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
        showSnackBar("Aucune Connexion Internet");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    testInternet();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
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
        child: MyAppBar(Title: translation(context).historique_title),
      ),
      endDrawer: MyDrawer(selectedIndex: 2),
      body: SingleChildScrollView(
                    child: _demande != null
                        ? Column(
                            children: _demande
                                .map(
                                  (demande) => Center(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 0, 10.0, 20.0),
                                      child: Stack(
                                        children: [
                                          Card(
                                            elevation:
                                                5, // This is similar to the spreadRadius in the boxShadow
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            color: Color(0xfffffcfc),
                                            shadowColor:
                                                Colors.grey.withOpacity(0.3),
                                            child: Row(
                                              children: [
                                                Column(children: [
                                                  demande.photo!=""?
                                                  Image.network(
                                                    demande.photo,
                                                    width: 152,
                                                    height: 99,
                                                  ):Image.asset("assets/images/default_image.jpg",
                                                    width: 152,
                                                    height: 99,
                                                  ),
                                                  SizedBox(height: 50),
                                                  Text(
                                                    AppLocalizations.of(
                                                                context)!
                                                            .historique_Prix +
                                                        (demande.prix)
                                                            .toString() +
                                                        AppLocalizations.of(
                                                                context)!
                                                            .liste_de_voitures_prixToutal,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  ]
                                                ),
                                                SizedBox(width: 15.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 15),
                                                    Text(
                                                      demande.modele,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .historique_demande,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(demande.type,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                    SizedBox(height: 15),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(AppLocalizations
                                                                .of(context)!
                                                            .historique_depart),
                                                        Text(
                                                            demande
                                                                .date_de_depart,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ))
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    demande.type ==
                                                            "Reservation"
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .historique_fin),
                                                              Text(
                                                                  DateTime.parse(demande
                                                                      .date_de_revinier).toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ))
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .historique_Addressdepar),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  demande
                                                                      .address_depart,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                              SizedBox(
                                                                  height: 10),
                                                             demande.type=="Transfer" ?
                                                                 Column(
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Text(AppLocalizations
                                                                         .of(context)!
                                                                         .historique_Addressarriver),
                                                                     Text(demande
                                                                         .address_fin)
                                                                   ],
                                                                 )
                                                             :
                                                              Text(''),
                                                            ],
                                                          ),
                                                    SizedBox(height: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        demande.etat ==
                                                                "en attend"
                                                            ? Dialog(demande.id)
                                                            : null;
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: demande.etat ==
                                                                "en attend"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        onPrimary: Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Text(
                                                          demande.etat ==
                                                                  "en attend"
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .historique_button2
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .historique_button3,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Nunito',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing:
                                                                -0.36,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
      bottomNavigationBar: UserNavBar(selectedIndex: _selectedIndex),
      )
    );
  }
}
