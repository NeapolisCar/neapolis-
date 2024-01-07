// ignore_for_file: deprecated_member_use, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class LoginTrnasfer extends StatefulWidget {
  const LoginTrnasfer({Key? key}) : super(key: key);

  @override
  State<LoginTrnasfer> createState() => _LoginTrnasferState();
}

class _LoginTrnasferState extends State<LoginTrnasfer> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mot_de_passe = TextEditingController();
  DateTime? _dateRamasser;
  String _numeroSeries = "";
  String _modele = "";
  String _photo = "";
  String _marquer="";
  String _type = "";
  bool _email1= false;
  bool password = false;
  int? _idlisttransfer;
  int? _idlistexurion;
  bool _allez_retour = false;
  double _prixtoul = 0;
  bool _siege_bebe = false;
  String _nb_place = "";
  String _nb_bagage = "";
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
        switch (responseData['Response']) {
          case "Activated":
            {
              final int id = responseData['id'];
              prefs.setInt('id', id);
              switch (_type) {
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
                      'marquer':_marquer
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
                      'marquer':_marquer
                    });
                  }
                  break;
              }
            }
            break;
          case "Deactivated":
            {
              Fluttertoast.showToast(
                  msg: translation(context).login_message2,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          case "Password Incorrect":
            {
              Fluttertoast.showToast(
                  msg: translation(context).login_message1,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
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
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
        }
      } else {
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
    switch (_type) {
      case "Transfer":
        {
          Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
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
            'marquer':_marquer
          });
        }
        break;
      case "Exurcion":
        {
          Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
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
            'marquer':_marquer
          });
        }
        break;
    }
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
    switch (_type) {
      case "Transfer":
        {
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _idlisttransfer= arguments['idlisttransfer'] as int;
          _allez_retour = arguments['allez_retour'] as bool;
          _numeroSeries = arguments['numeroSeries'] as String;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _prixtoul = arguments['prixTransfer'] as double;
          _siege_bebe = arguments['SIÈGE BÉBÉ'] as bool;
          _nb_place = arguments['Nombre de place'] as String;
          _nb_bagage = arguments['Nombre de bagages'] as String;
          _marquer =arguments['marquer'] as String;
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
          _marquer =arguments['marquer'] as String;
        }
        break;
    }
    return  WillPopScope(
        onWillPop: () async {
      switch (_type) {
        case "Transfer":
          {
            Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
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
              'marquer':_marquer
            });
          }
          break;
        case "Exurcion":
          {
            Navigator.pushNamed(context, 'InscriptionTransfer', arguments: {
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
              'marquer':_marquer
            });
          }
          break;
      }
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
                      errorText: password ? translation(context).inscriotion_message3 : null,
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
