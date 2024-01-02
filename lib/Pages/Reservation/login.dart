// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_final_fields, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mot_de_passe = TextEditingController();
  bool password =false;
  bool _email1 = false;
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
  bool value1 = false;
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegExp.hasMatch(email);
  }
  void Logins(String email, String mot_de_passe, BuildContext context) async {
    if (!isValidEmail(_email.text)) {
      setState(() {
        _email1= true;
      });
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message2,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (_mot_de_passe.text.isEmpty){
      setState(() {
        password= true;
      });
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message3,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          }
      );

      final response = await http.post(
        Uri.parse('$ip/polls/Verification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'mot_de_passe': mot_de_passe,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        final prefs = await SharedPreferences.getInstance();
        final responseData = jsonDecode(response.body);
        switch (responseData['Response'].toString()) {
          case "Activated":
            {
              final int id = responseData['id'];
              prefs.setInt('id', id);
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
                'caution': _caution,
                'prix': _prix,
                'photo': _photo,
                'PLEIN ESSENCE': _PLEIN_SSENCE,
                'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
                'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
                'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
                'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
              });
            }
            break;
          case "Deactivated":
            {
              Fluttertoast.showToast(
                  msg: translation(context).login_message2,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 200,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          case "Password Incorrect":
            {
              setState(() {
                password = true;
              });
              Fluttertoast.showToast(
                  msg: translation(context).login_message1,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 200,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          case "Not Exist":
            {
              Fluttertoast.showToast(
                  msg: translation(context).login_message3,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 200,
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
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 200,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
        }
      }
      else {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }


  void Inscription1() {
          Navigator.pushNamed(context, 'inscriptions', arguments: {
            'type': _type,
            'dateRamasser': _dateRamasser,
            'dateRevenir': _dateRevenir,
            'location_de_rammaser': _location_de_rammaser,
            'location_de_revenir': _location_de_revenir,
            'days': _days,
            'numeroSeries': _numeroSeries,
            'prixToutal': _prixToutal,
            'prix': _prix,
            'modele': _modele,
            'prixJour': _prixJour,
            'caution': _caution,
            'photo': _photo,
            'PLEIN ESSENCE': _PLEIN_SSENCE,
            'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
            'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
            'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
            'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
          });
  }

  @override
  void initState() {
    super.initState();
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
          _prixToutal = arguments['prixToutal'] as double;
          _prix = arguments['prix'] as double;
          _caution = arguments['caution'] as double;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _PLEIN_SSENCE = arguments['PLEIN ESSENCE'] as bool;
          _DEUXIEME_CONDUCTEUR = arguments['DEUXIÈME CONDUCTEUR'] as bool;
          _REHAUSSEUR = arguments['REHAUSSEUR ( 24-42 MOIS)'] as bool;
          _SYSTEME_DE_NAVIGATION_GPS =
          arguments['SYSTÈME DE NAVIGATION GPS'] as bool;
          _SIEGE_BEBE = arguments['SIÈGE BÉBÉ ( 6-24 MOIS)'] as bool;
    return  WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, 'detailVoiture', arguments: {
        'type':_type,
        'dateRamasser':_dateRamasser,
        'dateRevenir':_dateRevenir,
        'location_de_rammaser':_location_de_rammaser,
        'location_de_revenir':_location_de_revenir,
        'days':_days,
        'prix':_prix,
        'numeroSeries':_numeroSeries,
        'prixToutal':_prixToutal,
        'caution':_caution,
        'modele':_modele,
        'photo':_photo,
        'prixJour':_prixJour
      });
      return true;
    },
    child :Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).login_Title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100.0),
            SizedBox(
              width: 380,
              height: 70,
              child: Text(
                translation(context).login_text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 50.0),
                  Image.asset(
                    'assets/images/img_logoneapolisv444_97x137.png',
                    width: 150,
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).login_Title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: translation(context).inscriotion_Email,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      errorText: _email1 ? translation(context).inscriotion_message2 : null,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    controller: _mot_de_passe,
                    decoration: InputDecoration(
                      labelText: translation(context).inscriotion_mtp,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.key),
                      errorText: password ? translation(context).login_message1 : null,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //         onPressed: () {},
                  //         child: Text("Mot de passe oublié?")),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: value1,
                        onChanged: (newBool) {
                          setState(() {
                            value1 = newBool!;
                          });
                        },
                      ),
                      Text(translation(context).login_text1),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Logins(_email.text, _mot_de_passe.text, context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 45),
                      primary: Colors.red[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // Background color
                    ),
                    child: Text(translation(context).login_Title),
                  ),
                  SizedBox(height: 32.0),
                  Text(translation(context).login_text2),
                  TextButton(
                    onPressed: () {
                      Inscription1();
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue[700],

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Background color
                    ),
                    child: Text(
                      translation(context).login_button1,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(12, 30, 196, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
