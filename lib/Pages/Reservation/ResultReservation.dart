// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

import 'package:neapolis_car/main.dart';

class ResultResrvation extends StatefulWidget {
  const ResultResrvation({Key? key}) : super(key: key);

  @override
  State<ResultResrvation> createState() => _ResultResrvationState();
}

class _ResultResrvationState extends State<ResultResrvation> {
  bool _DEUXIEME_CONDUCTEUR = false;
  bool _REHAUSSEUR = false;
  bool _SYSTEME_DE_NAVIGATION_GPS = false;
  bool _SIEGE_BEBE = false;
  bool _PLEIN_SSENCE = false;
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
  String _type = "";
  List<Client> _Client = [];
  int id = 0;
  final int _selectedIndex = 0;
  Future<void> getClient() async {
    final prefs = await SharedPreferences.getInstance();
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
        }
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }


  void Conferme() {
    Navigator.pushNamed(context, 'Paiment', arguments: {
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
      'caution': _caution,
      'prix':_prix,
      'photo': _photo,
      'PLEIN ESSENCE': _PLEIN_SSENCE,
      'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
      'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
      'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
      'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
    });
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
                        style: Theme.of(context).textTheme.headline6),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph1,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    Text(
                      translation(context).result_reservation_regel_paraghraph2,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph3,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    Text(
                      translation(context)
                              .result_reservation_regel_paraghraph4 +
                          _caution.toString() ,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5, color: Colors.red),
                    ),
                    Text( translation(context)
                        .result_reservation_regel_paraghraph4_1,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)
                    ),
                    Text(
                      translation(context).result_reservation_regel_paraghraph5,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5
                    ),
                    ),
                    Text(
                      translation(context).result_reservation_regel_paraghraph6,
                        style: Theme.of(context).textTheme.headline6
                    ),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph7,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph8,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
                    Text(
                      translation(context).result_reservation_regel_paraghraph9,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5),
                    ),
                    Text(
                      translation(context)
                          .result_reservation_regel_paraghraph10,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph11,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph12,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
                    Text(
                      translation(context)
                          .result_reservation_regel_paraghraph13,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph14,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5)),
                    Text(
                        translation(context)
                            .result_reservation_regel_paraghraph15,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
                    Text(
                      translation(context)
                          .result_reservation_regel_paraghraph16,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5),
                    ),
                    Text(
                      translation(context)
                          .result_reservation_regel_paraghraph17,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5),
                    ),
                    SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text(translation(context).details_voiture_RA,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .apply(fontWeightDelta: 5)),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[900],
                  ),
                  child: Text(translation(context).details_voiture_RAn,
                      style:Theme.of(context).textTheme.button),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _acceptRole
                      ? () {
                          Conferme();
                        }
                      : null,
                  child: Text(translation(context).details_voiture_Rbutton,
                      style:Theme.of(context).textTheme.button!
                  ),
                  style: Theme.of(context).elevatedButtonTheme.style,
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
    getClient();
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
    _prixJour = arguments['prixJour'] as double;
    _caution = arguments['caution'] as double;
    _prixToutal = arguments['prixToutal'] as double;
    _prix = arguments['prix'] as double;
    _modele = arguments['modele'] as String;
    _photo = arguments['photo'] as String;
    _PLEIN_SSENCE = arguments['PLEIN ESSENCE'] as bool;
    _DEUXIEME_CONDUCTEUR = arguments['DEUXIÈME CONDUCTEUR'] as bool;
    _REHAUSSEUR = arguments['REHAUSSEUR ( 24-42 MOIS)'] as bool;
    _SYSTEME_DE_NAVIGATION_GPS = arguments['SYSTÈME DE NAVIGATION GPS'] as bool;
    _SIEGE_BEBE = arguments['SIÈGE BÉBÉ ( 6-24 MOIS)'] as bool;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, 'detailVoiture', arguments: {
          'type': _type,
          'dateRamasser': _dateRamasser,
          'dateRevenir': _dateRevenir,
          'location_de_rammaser': _location_de_rammaser,
          'location_de_revenir': _location_de_revenir,
          'days': _days,
          'numeroSeries': _numeroSeries,
          'prixToutal': _prixToutal,
          'caution': _caution,
          'prixJour': _prixJour,
          'prix': _prix,
          'modele': _modele,
          'photo': _photo,
          'index': 0
        });
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MyAppBar(Title: translation(context).result_reservation_title),
        ),
        endDrawer: MyDrawer(selectedIndex: _selectedIndex),
        body: SingleChildScrollView(
            child: Column(
              children: [
                        Card(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Image.network(
                                  _photo,
                                  width: 289,
                                  height: 133,
                                  errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.jpg",
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/img_pleinessence1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context).plein_essence,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        _PLEIN_SSENCE
                                            ? SvgPicture.asset(
                                                "assets/images/img_checkmark.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/img_close.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/img_deuxiemeconducteur.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context)
                                              .deuxieme_conducteur,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        _DEUXIEME_CONDUCTEUR
                                            ? SvgPicture.asset(
                                                "assets/images/img_checkmark.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/img_close.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/img_rehausseur1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context).rehausdeue,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        _REHAUSSEUR
                                            ? SvgPicture.asset(
                                                "assets/images/img_checkmark.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/img_close.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/img_telechargement2150x1501.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context)
                                              .syseeme_de_navigatio_gps,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        _SYSTEME_DE_NAVIGATION_GPS
                                            ? SvgPicture.asset(
                                                "assets/images/img_checkmark.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/img_close.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/img_siegeauto1.png",
                                          width: 48,
                                          height: 33,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          translation(context).siege_bebe,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        _SIEGE_BEBE
                                            ? SvgPicture.asset(
                                                "assets/images/img_checkmark.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/img_close.svg",
                                                width: 48,
                                                height: 33,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        _PLEIN_SSENCE
                            ? Card(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                    translation(context).result_reservation_plienessence,
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
                                    translation(context).result_reservation_prix,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ): Text(""),
                        _prix > 0 ?  Card(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                        .result_reservation_prixlirision,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("gzgzf",
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
                                    _prix.toString() +
                                        translation(context)
                                            .result_reservation_DT,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : Text(""),
                Card(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                      top: 10, left: 16, right: 16),
                                  child: Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Dialog();
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
            ),
          ),
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
