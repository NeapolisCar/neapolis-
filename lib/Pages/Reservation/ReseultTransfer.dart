// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_final_fields, no_leading_underscores_for_local_identifiers, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neapolis_car/Pages/Classes/ListExurcion.dart';
import 'package:neapolis_car/Pages/Classes/ListTransfer.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

import '../../main.dart';

class ResultaTransfer extends StatefulWidget {
  const ResultaTransfer({Key? key}) : super(key: key);

  @override
  State<ResultaTransfer> createState() => _ResultaTransferState();
}

class _ResultaTransferState extends State<ResultaTransfer> {
  DateTime? _dateRamasser;
  String _numeroSeries = "";
  String _modele = "";
  String _photo = "";
  String _type = "";
  bool _allez_retour = false;
  double _prixtoul = 0;
  bool _siege_bebe = false;
  String _nb_place = "";
  String _nb_bagage = "";
  int id = 0;
  List<LisTransfer> _ListTransfer=[];
  List<ListExurcion> _ListExurcion=[];
  int? _idlisttransfer;
  int? _idlistexurion;
  String _address_depar="";
  String _address_fin="";
  int _selectedIndex = 0;
  void getData() async{
    while (_type=="") {
      await Future.delayed(const Duration(seconds: 1));
    }
    fetchDetails();
  }
  Future<void> fetchDetails() async {
    if (_type == "Transfer") {
      final response = await http.post(
          Uri.parse("$ip/polls/AfficherListTransfer1"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _ListTransfer = jsonData.map((json) {
            return LisTransfer.fromJson(json);
          }).toList();
        });
        setState(() {
          _address_depar= _ListTransfer.first.addressDepart;
          _address_fin= _ListTransfer.first.addressFin;
        });
      }
    }
    else if (_type == "Exurcion") {
      final response = await http.post(
        Uri.parse("$ip/polls/AfficherListExurcion1"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{'id': _idlistexurion}), // Send data as JSON
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          final listExurcion = jsonData.map((json) {
            return ListExurcion.fromJson(json);
          }).cast<ListExurcion>().toList();
          setState(() {
            _ListExurcion = listExurcion;
          });
          setState(() {
            _address_depar= _ListExurcion.first.addressDepart;
          });
        });
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
              elevation: 5,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation(context).details_voiture_RP1,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      translation(context).result_reservation_regel_paraghraph1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5),
                    ),
                    Text(
                      translation(context).result_reservation_regel_paraghraph2,
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
                      translation(context).result_reservation_regel_paraghraph6,
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
                          .result_reservation_regel_paraghraph17,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 5),
                    ),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[900],
                  ),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void Conferme() {
    switch (_type) {
      case "Transfer":
        {
          Navigator.pushNamed(context, 'Paiment', arguments: {
            'type': _type,
            'dateRamasser': _dateRamasser,
            'idlisttransfer': _idlisttransfer,
            'allez_retour': _allez_retour,
            'prixTransfer': _prixtoul,
            'SIÈGE BÉBÉ': _siege_bebe,
            'Nombre de place': _nb_place,
            'Nombre de bagages': _nb_bagage,
            'numeroSeries': _numeroSeries,
            'modele': _modele,
            'photo': _photo,
          });
        }
        break;
      case "Exurcion":
        {
          Navigator.pushNamed(context, 'Paiment', arguments: {
            'type': _type,
            'dateRamasser': _dateRamasser,
            'idlistexurion': _idlistexurion,
            'prixTransfer': _prixtoul,
            'SIÈGE BÉBÉ': _siege_bebe,
            'Nombre de place': _nb_place,
            'Nombre de bagages': _nb_bagage,
            'numeroSeries': _numeroSeries,
            'modele': _modele,
            'photo': _photo,
          });
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _type = arguments['type'] as String;
    switch (_type) {
      case "Transfer":
        {
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _idlisttransfer = arguments['idlisttransfer'] as int;
          _allez_retour = arguments['allez_retour'] as bool;
          _prixtoul = arguments['prixTransfer'] as double;
          _numeroSeries = arguments['numeroSeries'] as String;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _siege_bebe = arguments['SIÈGE BÉBÉ'] as bool;
          _nb_place = arguments['Nombre de place'] as String;
          _nb_bagage = arguments['Nombre de bagages'] as String;
        }
        break;
      case "Exurcion":
        {
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _idlistexurion = arguments['idlistexurion'] as int;
          _prixtoul = arguments['prixTransfer'] as double;
          _siege_bebe = arguments['SIÈGE BÉBÉ'] as bool;
          _numeroSeries = arguments['numeroSeries'] as String;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _nb_place = arguments['Nombre de place'] as String;
          _nb_bagage = arguments['Nombre de bagages'] as String;
        }
        break;
    }
    return WillPopScope(
        onWillPop: () async {
          switch (_type) {
            case "Transfer":
              {
                Navigator.pushNamed(context, 'listVoitures', arguments: {
                  'type': _type,
                  'dateRamasser': _dateRamasser,
                  'idlisttransfer': _idlisttransfer,
                  'allez_retour': _allez_retour,
                  'prixTransfer': _prixtoul,
                  'SIÈGE BÉBÉ': _siege_bebe,
                  'Nombre de place': _nb_place,
                  'Nombre de bagages': _nb_bagage,
                  'numeroSeries': _numeroSeries,
                  'modele': _modele,
                  'photo': _photo,
                });
              }
              break;
            case "Exurcion":
              {
                Navigator.pushNamed(context, 'listVoitures', arguments: {
                  'type': _type,
                  'dateRamasser': _dateRamasser,
                  'idlistexurion': _idlistexurion,
                  'prixTransfer': _prixtoul,
                  'SIÈGE BÉBÉ': _siege_bebe,
                  'Nombre de place': _nb_place,
                  'Nombre de bagages': _nb_bagage,
                  'numeroSeries': _numeroSeries,
                  'modele': _modele,
                  'photo': _photo,
                });
              }
              break;
          }
          return true;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: MyAppBar(Title: translation(context).result_transfer_title),
          ),
          endDrawer: MyDrawer(selectedIndex: _selectedIndex),
          body: _ListTransfer!=[] && _ListExurcion!=[]?  Column(
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
                              child:Padding(
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
                                    _photo!=""?Image.network(
                                      _photo,
                                      width: 289,
                                      height: 133,
                                    ):
                                    Image.asset("assets/images/default_image.jpg",
                                      width: 289,
                                      height: 133,
                                    ),
                                    SizedBox(
                                      height: 20,
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
                                            _siege_bebe
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
                                    SizedBox(height: 20,),
                                    _type=="Transfer"?
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(translation(context).historique_Addressdepar ),
                                            Text(_address_depar)
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text(translation(context).historique_Addressarriver),
                                            Text(_address_fin)
                                          ],
                                        )
                                      ],
                                    ):Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(translation(context).historique_Addressdepar),
                                        SizedBox(height: 10,),
                                        Text(_address_depar)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(top:10 ,left: 10),
                                        child: Text(
                                          translation(context)
                                              .details_voiture_PrixToutal,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          _prixtoul.toString() +
                                              translation(context)
                                                  .details_voiture_dt,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 16, right: 16),
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
                                  ),
                                ),
                              ],
                            )
                          ],
                ):CircularProgressIndicator(),
          bottomNavigationBar: NavBar(
            selectedIndex: _selectedIndex,
          ),
        )
    );
  }
}
