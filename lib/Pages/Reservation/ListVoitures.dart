// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Compounes/dropitem.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Classes/OptionsVoiture.dart';
import 'package:neapolis_car/Pages/Classes/Voituture.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class ListVoitures extends StatefulWidget {
  const ListVoitures({Key? key}) : super(key: key);

  @override
  State<ListVoitures> createState() => _ListVoituresState();
}

class _ListVoituresState extends State<ListVoitures> {
  List<Voiture> _voitures = [];
  List<Options> _Options = [];
  int? _idlisttransfer;
  int? _idlistexurion;
  String dropdownvalue = "prix_decroissant";
  final List<String> _items = [
    "prix_decroissant",
    "prix_croissant",
    "plus_de_demande",
  ];
  int _selectedIndex = 0;
  DateTime _dateRamasser = DateTime.now();
  bool _allez_retour = false;
  double _prixtoul = 0;
  String _type = "";
  bool _siege_bebe = false;
  String _nb_place = "";
  int _nb_bagage = 0;
  bool _session = false;
  String id = '';
  bool isInternet = false;

  Future<void> getData() async {
    while (_nb_bagage == 0) {
      await Future.delayed(Duration(seconds: 1));
    }
    fetchVoitures();
  }
  void Dialog(String numeroSeries, String modele, String photo) {
    bool _acceptRole = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translation(context).details_voiture_reglaTitle),
              elevation: 5,
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
                    Text(translation(context).details_voiture_RP4_1,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(fontWeightDelta: 5, color: Colors.red)),
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
                    Conferme(numeroSeries , modele , photo);
                  } : null,
                  child: Text(translation(context).details_voiture_Rbutton),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void Conferme(String numeroSeries, String modele, String photo) {
    if (modele == "mercidies") {
      _prixtoul = _prixtoul + 200;
    }
    if (_session == true) {
      if (_type == "Transfer") {
        Navigator.pushNamed(context, 'ResultTransfer', arguments: {
          'type': _type,
          'dateRamasser': _dateRamasser,
          'idlisttransfer':_idlisttransfer,
          'allez_retour': _allez_retour,
          'prixTransfer': _prixtoul,
          'SIÈGE BÉBÉ': _siege_bebe,
          'Nombre de place': _nb_place,
          'Nombre de bagages': _nb_bagage.toString(),
          'numeroSeries': numeroSeries,
          'modele': modele,
          'photo': photo,
        });
      } else {
        Navigator.pushNamed(context, 'ResultTransfer', arguments: {
          'type': _type,
          'dateRamasser': _dateRamasser,
          'idlistexurion':_idlistexurion,
          'prixTransfer': _prixtoul,
          'SIÈGE BÉBÉ': _siege_bebe,
          'Nombre de place': _nb_place,
          'Nombre de bagages': _nb_bagage.toString(),
          'numeroSeries': numeroSeries,
          'modele': modele,
          'photo': photo,
        });
      }
    } else {
      if (_type == "Transfer") {
        Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
          'type': _type,
          'dateRamasser': _dateRamasser,
          'idlisttransfer':_idlisttransfer,
          'allez_retour': _allez_retour,
          'prixTransfer': _prixtoul,
          'SIÈGE BÉBÉ': _siege_bebe,
          'Nombre de place': _nb_place,
          'Nombre de bagages': _nb_bagage.toString(),
          'numeroSeries': numeroSeries,
          'modele': modele,
          'photo': photo,
        });
      } else {
        Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
          'type': _type,
          'dateRamasser': _dateRamasser,
          'idlistexurion':_idlistexurion,
          'prixTransfer': _prixtoul,
          'SIÈGE BÉBÉ': _siege_bebe,
          'Nombre de place': _nb_place,
          'Nombre de bagages': _nb_bagage.toString(),
          'numeroSeries': numeroSeries,
          'modele': modele,
          'photo': photo,
        });
      }
    }
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _session = true;
      });
    }
  }

  Future<void> Information(
      String numeroSeries, String photo, String model) async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_OptionVoitures'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'numeroSeries': numeroSeries}), // Send data as JSON
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _Options = jsonData.map((json) {
          return Options.fromJson(json);
        }).toList();
      });
      return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model),
                    Image.network(
                      photo,
                      width: 152,
                      height: 99,
                    ),
                    // Add spacing between the TableRows
                    Table(
                      children: _Options.map((option) => TableRow(
                        children: [
                          Row(
                              children: [
                                Flexible(
                                    child: Text(option.title)
                                ),
                              ]
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              option.descriptions=="true"? SvgPicture.asset(
                                "assets/images/img_checkmark.svg",
                                width: 38,
                                height: 23,
                              ):
                              Flexible(
                                  child:Text(option.descriptions)
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),

                      ).toList(),
                    ),
                  ],
                ),
              ),
            )

        ),
      );
    } else {
      throw Exception('Failed to load Options');
    }
  }

  void sortVoituresByPrice() {
    _voitures.sort((a, b) => a.prixJour.compareTo(b.prixJour));
  }

  void desortVoituresByPrice() {
    _voitures.sort((a, b) => b.prixJour.compareTo(a.prixJour));
  }

  Future<void> fetchVoitures() async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Voitures1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nb_bagage': _nb_bagage,
        'date': _dateRamasser.toString(),
      }), // Send data as JSON
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _voitures = jsonData.map((json) {
          return Voiture.fromJson(json);
        }).toList();
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
    }
  }

  showSnackBar(String message){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  testInternet()async{
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
    getData();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _dateRamasser = arguments['dateRamasser'] as DateTime;
    if (arguments.containsKey('allez_retour')) {
      _allez_retour = arguments['allez_retour'] as bool;
      _idlisttransfer= arguments['idlisttransfer'] as int;
      _type = "Transfer";
    } else {
      _type = "Exurcion";
      _idlistexurion = arguments['idlistexurion'] as int;
    }
    _prixtoul = arguments['prixTransfer'] as double;
    _siege_bebe = arguments['SIÈGE BÉBÉ'] as bool;
    _nb_place = arguments['Nombre de place'] as String;
    _nb_bagage = int.parse(arguments['Nombre de bagages'] as String);
    return WillPopScope(
      onWillPop: () async {
        if(_type=="Transfer") {
          Navigator.pushNamed(context, 'DetailTransfer', arguments: {
            'type': _type,
            'dateRamasser': _dateRamasser,
            'idlisttransfer':_idlisttransfer,
            'allez_retour': _allez_retour,
            'prixTransfer': _prixtoul,
          });
        }
        else if (_type=="Exurcion"){
          Navigator.pushNamed(context, 'DetailTransfer', arguments: {
            'type': _type,
            'dateRamasser': _dateRamasser,
            'idlistexurion':_idlistexurion,
            'prixTransfer': _prixtoul,
          });
        }
      return true;
    },
      child:Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).liste_de_voitures_title),
      ),
      endDrawer: MyDrawer(selectedIndex: _selectedIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: dropitems(
                    items: _items,
                    icon: Icons.onetwothree_rounded,
                    margin: EdgeInsets.all(16),
                    text: translation(context).liste_de_voitures_tri,
                    onItemSelected: (selectedValue) {
                      setState(() {
                        dropdownvalue = selectedValue!; // ignore: unnecessary_non_null_assertion
                      });
                      if (dropdownvalue == "prix_decroissant") {
                        sortVoituresByPrice();
                      } else if (dropdownvalue == "prix_croissant") {
                        desortVoituresByPrice();
                      }
                    },
                  ),

                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _voitures != null
                        ? Column(
                      children: _voitures
                          .map(
                            (voiture) =>  InkWell(
                              onTap: () {
                                voiture.disponibilite ==
                                    "disponible"
                                    ? Dialog(
                                  voiture
                                      .numeroSeries,
                                  voiture.modele,
                                  voiture.photo,
                                )
                                    : null;
                              },
                              child:  Center(
                          child: Stack(
                            children: [
                              Card(
                                margin: EdgeInsets.fromLTRB(
                                    10, 10, 10, 10),
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
                                    Column(
                                        children: [
                                      Image.network(
                                        voiture.photo,
                                        width: 152,
                                        height: 99,
                                      ),
                                      SizedBox(height: 50),
                                      Text(
                                        voiture.modele == "mercidies"
                                            ? (_prixtoul = _prixtoul +
                                            200)
                                            .toString() +
                                            AppLocalizations.of(
                                                context)!
                                                .liste_de_voitures_prixToutal
                                            : (_prixtoul).toString() +
                                            AppLocalizations.of(
                                                context)!
                                                .liste_de_voitures_prixToutal,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      voiture.disponibilite ==
                                          "disponible"
                                          ? Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons
                                                .checkCircle,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                          SizedBox(width: 5),
                                          Text(AppLocalizations
                                              .of(context)!
                                              .liste_de_voitures_Disponible),
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons
                                                .cancel,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                          SizedBox(width: 5),
                                          Text(AppLocalizations
                                              .of(context)!
                                              .liste_de_voitures_NoDisponible),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Information(
                                              voiture.numeroSeries,
                                              voiture.photo,
                                              voiture.modele);
                                        },
                                        style:
                                        ElevatedButton.styleFrom(
                                          // primary: Colors.blue[700],

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                20.0),
                                          ), // Background color
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                              context)!
                                              .liste_de_voitures_PlusInfo,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(width: 15.0),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(voiture.marque),
                                            const SizedBox(width: 10,),
                                            Image.network(
                                              voiture.photoMarque,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          voiture.modele,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/img_seats1.png",
                                              width: 20,
                                              height: 24,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                voiture.nbSeats +
                                                    AppLocalizations.of(
                                                        context)!
                                                        .liste_de_voitures_SEATS,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                )),
                                            Image.asset(
                                              "assets/images/img_bags1.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                voiture.nbBags +
                                                    AppLocalizations.of(
                                                        context)!
                                                        .liste_de_voitures_BAGS,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/img_doors1.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                voiture.nbPorts +
                                                    AppLocalizations.of(
                                                        context)!
                                                        .liste_de_voitures_PORTES,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ))
                                          ],
                                        ),
                                        SizedBox(height: 35),
                                        ElevatedButton(
                                          onPressed: () {
                                            voiture.disponibilite ==
                                                "disponible"
                                                ? Dialog(
                                              voiture
                                                  .numeroSeries,
                                              voiture.modele,
                                              voiture.photo,
                                            )
                                                : null;
                                          },
                                          style: ElevatedButton
                                              .styleFrom(
                                            primary: Colors.red,
                                            onPrimary: Colors.black,
                                            shape:
                                            RoundedRectangleBorder(
                                              side: BorderSide.none,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                            EdgeInsets.all(0.0),
                                            child: Text(
                                              AppLocalizations.of(
                                                  context)!
                                                  .liste_de_voitures_payez,
                                              textAlign:
                                              TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Nunito',
                                                fontWeight:
                                                FontWeight.w400,
                                                letterSpacing: -0.36,
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
                        )),
                      )
                          .toList(),
                    )
                        : Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
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
