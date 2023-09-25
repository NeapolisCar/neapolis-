// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, prefer_final_fields, annotate_overrides, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class DetailVoiture extends StatefulWidget {
  const DetailVoiture({Key? key}) : super(key: key);

  @override
  State<DetailVoiture> createState() => _DetailVoitureState();
}

class _DetailVoitureState extends State<DetailVoiture> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;
  DateTime? _dateRamasser;
  DateTime? _dateRevenir;
  String? _location_de_rammaser;
  String? _location_de_revenir;
  int _days = 1;
  String _numeroSeries = "";
  double _prixToutal = 0;
  double _prixJour = 0;
  double _prix = 0;
  double _caution = 0;
  String _modele = "";
  String _photo = "";
  bool _session = false;
  String _type = "";
  int _selectedIndex = 0;
  List<Client> _Client = [];
  int id = 0;
  String _numeroparmis = "";
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
          _session = true;
          if (_Client.isNotEmpty) {
            _numeroparmis = _Client.first.numeroparmis;
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception('Failed to load notifications');
      }
    }
  }

  void Dialog() {
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
                    Text(translation(context).details_voiture_RP1,
                        style: Theme.of(context).textTheme.headline6

                        // TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    Text(translation(context).details_voiture_RP2,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)
                        // TextStyle(fontSize: 16),
                        ),
                    Text(translation(context).result_reservation_regel_paraghraph2,
                        style: Theme.of(context).textTheme.headline6),
                    Text(translation(context).details_voiture_RP4,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
                    Text(translation(context).result_reservation_regel_paraghraph6,
                        style: Theme.of(context).textTheme.headline6),
                    Text(translation(context).details_voiture_RP6,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
                    Text(translation(context).details_voiture_RP7,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    SizedBox(height: 10),
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
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(translation(context).details_voiture_RAn),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _acceptRole
                      ? () {
                          Conferme();
                        }
                      : null, // Désactiver le bouton Accepter si la case à cocher n'est pas cochée
                  child: Text(translation(context).details_voiture_Rbutton),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void Conferme() {
    if (value1 == true) {
      setState(() {
        _prixToutal = _prixToutal + 120;
      });
    }
    if (_session == false) {
      Navigator.pushNamed(context, 'inscriptions', arguments: {
        'type': _type,
        'dateRamasser': _dateRamasser,
        'dateRevenir': _dateRevenir,
        'location_de_rammaser': _location_de_rammaser,
        'location_de_revenir': _location_de_revenir,
        'days': _days,
        'numeroSeries': _numeroSeries,
        'prixToutal': _prixToutal,
        'caution': _caution,
        'modele': _modele,
        'prixJour': _prixJour,
        'prix': _prix,
        'photo': _photo,
        'PLEIN ESSENCE': value1,
        'DEUXIÈME CONDUCTEUR': value2,
        'REHAUSSEUR ( 24-42 MOIS)': value3,
        'SYSTÈME DE NAVIGATION GPS': value4,
        'SIÈGE BÉBÉ ( 6-24 MOIS)': value5,
      });
    } else if (_numeroparmis == "") {
      Navigator.pushNamed(context, 'ContinueInscription', arguments: {
        'type': _type,
        'dateRamasser': _dateRamasser,
        'dateRevenir': _dateRevenir,
        'location_de_rammaser': _location_de_rammaser,
        'location_de_revenir': _location_de_revenir,
        'days': _days,
        'numeroSeries': _numeroSeries,
        'prixToutal': _prixToutal,
        'modele': _modele,
        'prixJour': _prixJour,
        'prix': _prix,
        'caution': _caution,
        'photo': _photo,
        'PLEIN ESSENCE': value1,
        'DEUXIÈME CONDUCTEUR': value2,
        'REHAUSSEUR ( 24-42 MOIS)': value3,
        'SYSTÈME DE NAVIGATION GPS': value4,
        'SIÈGE BÉBÉ ( 6-24 MOIS)': value5,
      });
    } else {
      Navigator.pushNamed(context, 'ResultReservation', arguments: {
        'type': _type,
        'dateRamasser': _dateRamasser,
        'dateRevenir': _dateRevenir,
        'location_de_rammaser': _location_de_rammaser,
        'location_de_revenir': _location_de_revenir,
        'days': _days,
        'numeroSeries': _numeroSeries,
        'prixToutal': _prixToutal,
        'modele': _modele,
        'prixJour': _prixJour,
        'prix': _prix,
        'caution': _caution,
        'photo': _photo,
        'PLEIN ESSENCE': value1,
        'DEUXIÈME CONDUCTEUR': value2,
        'REHAUSSEUR ( 24-42 MOIS)': value3,
        'SYSTÈME DE NAVIGATION GPS': value4,
        'SIÈGE BÉBÉ ( 6-24 MOIS)': value5,
      });
    }
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      getClient();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _type = arguments['type'] as String;
    _dateRamasser = arguments['dateRamasser'] as DateTime;
    _dateRevenir = arguments['dateRevenir'] as DateTime;
    _location_de_rammaser = arguments['location_de_rammaser'] as String;
    _location_de_revenir = arguments['location_de_revenir'] as String;
    _days = arguments['days'] as int;
    _numeroSeries = arguments['numeroSeries'] as String;
    _prixToutal = arguments['prixToutal'] as double;
    _caution = arguments['caution'] as double;
    _modele = arguments['modele'] as String;
    _photo = arguments['photo'] as String;
    _prixJour = arguments['prixJour'] as double;
    _prix = arguments['prix'] as double;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, 'listVoiture', arguments: {
        'type': "Reservation",
        'dateRamasser': _dateRamasser,
        'dateRevenir': _dateRevenir,
        'location_de_rammaser': _location_de_rammaser,
        'location_de_revenir': _location_de_revenir,
        'days': _days ,
        'prix': _prix,
        'index': 0
      });
      return true;
    },
    child :Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).details_voiture_Title),
      ),
      endDrawer: MyDrawer(selectedIndex: _selectedIndex),
      body: _photo != null
                    ?SingleChildScrollView(
                  child: Column(
                            children: [
                              Card(
                                margin: EdgeInsets.all(16),
                                elevation: 5, // This is similar to the spreadRadius in the boxShadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Color(0xfffffcfc),
                                shadowColor: Colors.grey.withOpacity(0.3),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          _modele,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Image.network(
                                        _photo,
                                        width: 289,
                                        height: 133,
                                      ),
                                      SizedBox(height: 10,),
                                      CheckboxListTile(
                                        secondary: Image.asset(
                                          "assets/images/img_pleinessence1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                        title: Text(translation(context).plein_essence),
                                        value: value1,
                                        onChanged: (newBool) {
                                          setState(() {
                                            value1 = newBool!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        secondary: Image.asset(
                                          "assets/images/img_deuxiemeconducteur.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                        title: Text(translation(context).deuxieme_conducteur),
                                        value: value2,
                                        onChanged: (newBool) {
                                          setState(() {
                                            value2 = newBool!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        secondary: Image.asset(
                                          "assets/images/img_rehausseur1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                        title: Text(translation(context).rehausdeue),
                                        value: value3,
                                        onChanged: (newBool) {
                                          setState(() {
                                            value3 = newBool!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        secondary: Image.asset(
                                          "assets/images/img_telechargement2150x1501.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                        title: Text(translation(context).syseeme_de_navigatio_gps),
                          value: value4,
                                        onChanged: (newBool) {
                                          setState(() {
                                            value4 = newBool!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        secondary: Image.asset(
                                          "assets/images/img_siegeauto1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                        title: Text(translation(context).siege_bebe),
                                        value: value5,
                                        onChanged: (newBool) {
                                          setState(() {
                                            value5 = newBool!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.all(16),
                                elevation: 5, // This is similar to the spreadRadius in the boxShadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.grey,
                                shadowColor: Colors.grey.withOpacity(0.3),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          translation(context)
                                                  .details_voiture_nbjours +
                                              _days.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context)
                                                  .details_voiture_taux +
                                              _prixJour.toString() +
                                              translation(context)
                                                  .details_voiture_dt,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          translation(context)
                                                  .details_voiture_PrixToutal +
                                              _prixToutal.toString() +
                                              translation(context)
                                                  .details_voiture_dt,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                        padding: EdgeInsets.only(
                                            top: 0, left: 16, right: 16),
                                        child: Container(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_session) {
                                                Conferme();
                                              } else {
                                                Dialog();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: Text(
                                                translation(context)
                                                    .liste_de_voitures_payez,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.36,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            ],
                          )
                ): Center(child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        ),
      )
    );
  }
}
