// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class WebViewPaiment extends StatefulWidget {
  const WebViewPaiment({Key? key}) : super(key: key);

  @override
  State<WebViewPaiment> createState() => _WebViewPaimentState();
}

class _WebViewPaimentState extends State<WebViewPaiment> {
  late WebViewController controller;
  double progress = 0;
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
  String _modele = "";
  String _photo = "";
  String _type = "";
  bool _allez_retour = false;
  double _prixtoul = 0;
  bool _siege_bebe = false;
  String _nb_place = "";
  String _nb_bagage = "";
  int? _idlisttransfer;
  int? _idlistexurion;
  String _url = "";
  String _paymentRef = "";

  Future<void> Paiement(int id_demande) async {
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
        'type': "card",
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, 'Remerciements');
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
            final id_demande = responseData['reponse'];
            Fluttertoast.showToast(
                msg: translation(context).web_Paiemnet_message1,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Paiement(id_demande);
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
              'idlisttransfer':_idlisttransfer,
              'allez_retour': _allez_retour,
              // 'prixTransfer': _prixtoul,
              'SIÈGE BÉBÉ': _siege_bebe,
              'numeroSeries': _numeroSeries,
            }),
          );
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            final id_demande = responseData['reponse'];
            Fluttertoast.showToast(
                msg: translation(context).web_Paiemnet_message1,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Paiement(id_demande);
          }
        }
        break;
      case "Exurcion":
        {
          Fluttertoast.showToast(
              msg: _numeroSeries,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
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
              'idlistexurion':_idlistexurion,
              'SIÈGE BÉBÉ': _siege_bebe,
              'numeroSeries': _numeroSeries,
            }),
          );
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            final id_demande = responseData['reponse'];
            Fluttertoast.showToast(
                msg: translation(context).web_Paiemnet_message1,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Paiement(id_demande);
          }
          Fluttertoast.showToast(
              msg: translation(context).inscriotion_message11,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
    }
  }

  verify(String url) async {
    if (url == "https://dev.konnect.network/gateway/payment-failure?payment_ref=" +
            _paymentRef) {
      final response = await http.get(
        Uri.parse('https://api.preprod.konnect.network/api/v2/payments/' +
            _paymentRef),
      );
      switch (response.statusCode) {
        case 200:
          {
            Map<String, dynamic> data = json.decode(response.body);
            if (data['payment']['transactions'][0]['status'] == "success") {
              Fluttertoast.showToast(
                  msg: translation(context).web_Paiemnet_message2,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 10,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              PasseReservation();
            } else if (data['payment']['transactions'][0]['status'] ==
                "pending_payment") {
              Fluttertoast.showToast(
                  msg: translation(context).web_Paiemnet_message3,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 10,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              controller.loadUrl(_url);
            }
          }
          break;
        case 401:
          {
            Map<String, dynamic> data = json.decode(response.body);
            final message = data['errors']['message'];
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            controller.loadUrl(_url);
          }
          break;
        case 403:
          {
            Map<String, dynamic> data = json.decode(response.body);
            final message = data['errors']['message'];
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            controller.loadUrl(_url);
          }
          break;
        case 404:
          {
            Map<String, dynamic> data = json.decode(response.body);
            final message = data['errors']['message'];
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            controller.loadUrl(_url);
          }
          break;
        case 422:
          {
            Map<String, dynamic> data = json.decode(response.body);
            final message = data['errors']['message'];
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            controller.loadUrl(_url);
          }
          break;
        case 502:
          {
            Map<String, dynamic> data = json.decode(response.body);
            final message = data['errors']['message'];
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            controller.loadUrl(_url);
          }
          break;
      }
    }
  }
  void clickButton() async {
    await controller.runJavascript(
      "document.querySelector('button[name=\"bank_card\"]').click();",
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    super.didChangeDependencies();
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _type = arguments['type'] as String;
    switch (_type) {
      case "Reservation":
        {
          _url = arguments['url'] as String;
          _paymentRef = arguments['paymentRef'] as String;
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _dateRevenir = arguments['dateRevenir'] as DateTime;
          _location_de_rammaser = arguments['location_de_rammaser'] as String;
          _location_de_revenir = arguments['location_de_revenir'] as String;
          _days = arguments['days'] as int;
          _numeroSeries = arguments['numeroSeries'] as String;
          _prixJour = arguments['prixJour'] as double;
          _prixToutal = arguments['prixToutal'] as double;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _PLEIN_SSENCE = arguments['PLEIN ESSENCE'] as bool;
          _DEUXIEME_CONDUCTEUR = arguments['DEUXIÈME CONDUCTEUR'] as bool;
          _REHAUSSEUR = arguments['REHAUSSEUR ( 24-42 MOIS)'] as bool;
          _SYSTEME_DE_NAVIGATION_GPS =
          arguments['SYSTÈME DE NAVIGATION GPS'] as bool;
          _SIEGE_BEBE = arguments['SIÈGE BÉBÉ ( 6-24 MOIS)'] as bool;
        }
        break;

      case "Transfer":
        {
          _url = arguments['url'] as String;
          _paymentRef = arguments['paymentRef'] as String;
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _idlisttransfer= arguments['idlisttransfer'] as int;
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
          _url = arguments['url'] as String;
          _paymentRef = arguments['paymentRef'] as String;
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
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          switch (_type) {
            case "Reservation":
              {
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
                Navigator.pushNamed(context, 'Paiment', arguments: {
                  'type': _type,
                  'dateRamasser': _dateRamasser,
                  'idlisttransfer':_idlisttransfer,
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
                  'idlistexurion':_idlistexurion,
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
        }
      },
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.red[500],
                title: Text(translation(context).paiemnet_Title),
                leading: IconButton(
                    onPressed: () async {
                          switch (_type) {
                          case "Reservation":
                              {
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
                                Navigator.pushNamed(context, 'Paiment', arguments: {
                                      'type': _type,
                                      'dateRamasser': _dateRamasser,
                                      'idlisttransfer':_idlisttransfer,
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
                                    'idlistexurion':_idlistexurion,
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
                    },
                    icon: Icon(Icons.cancel)),
                actions: [
                  IconButton(
                      onPressed: () => controller.reload(),
                      icon: Icon(Icons.refresh)),
                ],
              ),
              body: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                  Expanded(
                    child: _url != null
                        ? WebView(
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: _url,
                            onWebViewCreated: (WebViewController controller) {
                              this.controller = controller;
                            },
                            onPageStarted: (url) {
                              verify(url);
                            },
                            onProgress: (progress) {
                              setState(() {
                                this.progress = progress / 100;
                              });
                            },
                      onPageFinished: (String url) {

                        // Evaluate the JavaScript code to click the element with the name "bank_card".
                        clickButton();
                        Fluttertoast.showToast(
                            msg: "error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  )
                ],
              )
          )
      ),
    );
  }
}
