// ignore_for_file: deprecated_member_use, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class Piament extends StatefulWidget {
  const Piament({Key? key}) : super(key: key);

  @override
  State<Piament> createState() => _PiamentState();
}

class _PiamentState extends State<Piament> {
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
  double _prix = 0;
  String _numeroSeries = "";
  double _prixToutal = 0;
  double _prixJour = 0;
  String _modele = "";
  String _photo = "";
  String _type = "";
  bool _allez_retour = false;
  double _prixtoul = 0;
  bool _siege_bebe = false;
  String _nb_place = "";
  String _nb_bagage = "";
  List<Client> _Client = [];
  int id = 0;
  String _nomprenom = 'Visture';
  int? _idlisttransfer;
  int? _idlistexurion;
  double _caution = 0;
  var whatsappUrl = "whatsapp://send?phone=${"+21698307590"}";
  final Uri phoneNumber = Uri.parse('tel:+21698307590');
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
        var responseData = json.decode(response.body);
        switch (responseData['Reponse']) {
          case "Success":
            {
              final List<Client> client = responseData['data']
                  .map<Client>((json) => Client.fromJson(json))
                  .toList();
              setState(() {
                _Client = client;
                if (_Client.isNotEmpty) {
                  _nomprenom = _Client.first.nomprenom;
                }
              });
            }
            break;
          case "Not Exist":
            {
              Fluttertoast.showToast(
                  msg: translation(context).inscriotion_message11,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          case "Faild":
            {
              Fluttertoast.showToast(
                  msg: translation(context).inscriotion_message11,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          case "Deactivated":
            {
              prefs.remove('id');
            }
            break;
        }
      } else {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        throw Exception('Failed to load data from the API');
      }
    }
  }

  Future<void> Paiment() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id')!;
    final response = await http.post(
      Uri.parse('$ip/polls/Effect_paiment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'amount': _type == "Reservation" ? _prixToutal : _prixtoul,
        'token': "TND",
        'description': "paiment de $_type",
      }),
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      switch (responseData['Reponse']){
        case "Success":
          {
            final data = responseData['data'];
            final url = data['payUrl'];
            final paymentRef = data['paymentRef'];
            switch (_type) {
              case "Reservation":
                {
                  Navigator.pushNamed(context, 'WebViewPaiment', arguments: {
                    'paymentRef': paymentRef,
                    'url': url,
                    'type': _type,
                    'dateRamasser': _dateRamasser,
                    'dateRevenir': _dateRevenir,
                    'location_de_rammaser': _location_de_rammaser,
                    'location_de_revenir': _location_de_revenir,
                    'days': _days,
                    'caution': _caution,
                    'prix':_prix,
                    'numeroSeries': _numeroSeries,
                    'prixToutal': _prixToutal,
                    'modele': _modele,
                    'prixJour': _prixJour,
                    'photo': _photo,
                    'PLEIN ESSENCE': _PLEIN_SSENCE,
                    'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
                    'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
                    'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
                    'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
                  });
                }
                break;

              case "Transfer":
                {
                  Navigator.pushNamed(context, 'WebViewPaiment', arguments: {
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
                    'url': url,
                    'paymentRef': paymentRef,
                  });
                }
                break;
              case "Exurcion":
                {
                  Navigator.pushNamed(context, 'WebViewPaiment', arguments: {
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
                    'url': url,
                    'paymentRef': paymentRef,
                  });
                }
                break;
            }
          }
          break;
        case "error":
          {
            Fluttertoast.showToast(
                msg: translation(context).paiement_message2,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        case "Faild":
          {
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
      }
    } else {
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message11,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> Paiement_cash(int id_demande) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id')!;
    final response = await http.post(
      Uri.parse('$ip/polls/InsertPiaemnt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'prix': _type == "Reservation" ? _prixToutal : _prixtoul,
        'id_demande': id_demande,
        'type': "cash",
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      switch(responseData['Reponse']){
        case "Success":
        {
          Navigator.pushNamed(context, 'Remerciements');
        }
        break;
        case "error":
          {
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          break;
        case "Faild":
          {
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
    }
    else{
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

  Future<void> PasseReservation() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id')!;
    switch (_type) {
      case "Reservation":
        {
          final response = await http.post(
            Uri.parse('$ip/polls/Insert_reservation'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id_Client': id,
              'etat': "paiment",
              'type': _type,
              'dateRamasser': _dateRamasser.toString(),
              'dateRevenir': _dateRevenir.toString(),
              'location_de_rammaser': _location_de_rammaser,
              'location_de_revenir': _location_de_revenir,
              'numeroSeries': _numeroSeries,
              'PLEIN ESSENCE': _PLEIN_SSENCE,
              'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
              'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
              'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
              'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
            }),
          );
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            switch(responseData['Reponse']){
              case "Success":
                {
                  final id_demande = responseData['id'];
                  Fluttertoast.showToast(
                      msg: translation(context).web_Paiemnet_message1,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Paiement_cash(id_demande);
                }
                break;
              case "error":
                {
                  Fluttertoast.showToast(
                      msg: translation(context).inscriotion_message11,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                break;
              case "Faild":
                {
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
          }else{
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
        break;
      case "Transfer":
        {
          final response = await http.post(
            Uri.parse('$ip/polls/Insert_transfer'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id_Client': id,
              'type': _type,
              'etat': "en cour",
              'date_de_depart': _dateRamasser.toString(),
              'idlisttransfer': _idlisttransfer,
              'allez_retour': _allez_retour,
              // 'prixTransfer': _prixtoul,
              'SIÈGE BÉBÉ': _siege_bebe,
              'numeroSeries': _numeroSeries,
            }),
          );
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            switch(responseData['Reponse']){
              case "Success":
                {
                  final id_demande = responseData['id'];
                  Fluttertoast.showToast(
                      msg: translation(context).web_Paiemnet_message1,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Paiement_cash(id_demande);
                }
                break;
              case "error":
                {
                  Fluttertoast.showToast(
                      msg: translation(context).inscriotion_message11,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                break;
              case "Faild":
                {
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
          }else{
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
        break;
      case "Exurcion":
        {
          final response = await http.post(
            Uri.parse('$ip/polls/Insert_exurcion'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id_Client': id,
              'type': _type,
              'etat': "en cour",
              'date_de_depart': _dateRamasser.toString(),
              'idlistexurion': _idlistexurion,
              'SIÈGE BÉBÉ': _siege_bebe,
              'numeroSeries': _numeroSeries,
            }),
          );
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            switch(responseData['Reponse']){
              case "Success":
                {
                  final id_demande = responseData['id'];
                  Fluttertoast.showToast(
                      msg: translation(context).web_Paiemnet_message1,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Paiement_cash(id_demande);
                }
                break;
              case "error":
                {
                  Fluttertoast.showToast(
                      msg: translation(context).inscriotion_message11,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                break;
              case "Faild":
                {
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
          }else
            {
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
    }
  }
  void Dialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translation(context).paiemnet_Dilog_title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation(context).paiemnet_SLT +
                          _nomprenom +
                          translation(context).paiemnet_CR,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      translation(context).paument_messsage3
                    ),
                    SizedBox(height: 10),
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
                                PasseReservation();
                              },
                            ),
                            Text(translation(context).telephone),
                          ],
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
                                PasseReservation();
                              },
                            ),
                            Text(translation(context).whatsapp),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: [],
            );
          },
        );
      },
    );
  }

  late int _selectedIndex = 0;

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
    switch (_type) {
      case "Reservation":
        {
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
        }
        break;

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
          _numeroSeries = arguments['numeroSeries'] as String;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _siege_bebe = arguments['SIÈGE BÉBÉ'] as bool;
          _nb_place = arguments['Nombre de place'] as String;
          _nb_bagage = arguments['Nombre de bagages'] as String;
        }
        break;
    }
    return WillPopScope(
      onWillPop: () async {
        switch (_type) {
          case "Reservation":
            {
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
                'photo': _photo,
                'caution':_caution,
                'prix': _prix,
                'PLEIN ESSENCE': _PLEIN_SSENCE,
                'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
                'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
                'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
                'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
              });
            }
            break;

          case "Transfer":
            {
              Navigator.pushNamed(context, 'ResultTransfer', arguments: {
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
              Navigator.pushNamed(context, 'ResultTransfer', arguments: {
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
          child: MyAppBar(Title: translation(context).paiemnet_Title),
        ),
        body: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Text(
                translation(context).paiemnet_text,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  Paiment();
                },
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      Paiment();
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(16.0),
                            child: Image.asset(
                                'assets/images/img_visamastericon29.png'),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    Paiment();
                                    // PasseReservation();
                                  },
                                  child: Text(
                                      translation(context).paiemnet_button1,
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  Dialog();
                },
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Dialog();
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(16.0),
                            child:
                                Image.asset('assets/images/img_tlcharg1.png'),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Dialog();
                                  },
                                  child: Text(
                                    translation(context).paiemnet_button2,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ],
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
