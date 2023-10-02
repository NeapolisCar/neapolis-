import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class Remerciements extends StatefulWidget {
  const Remerciements({Key? key}) : super(key: key);

  @override
  State<Remerciements> createState() => _RemerciementsState();
}

class _RemerciementsState extends State<Remerciements> {
  late final int _selectedIndex = 0;
  late List<Client> _Client = [];
  late int id = 0;
  late String _nomprenom = 'Visture';
  late String _email = '';
  late String _image = '';
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
                  _email = _Client.first.email;
                  _image = _Client.first.photo;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClient();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          child: MyAppBar(Title: translation(context).remerciments_title),
        ),
        endDrawer: MyDrawer(selectedIndex: _selectedIndex),
        body: Center(
          child: Container(
            width: 348,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Text(
                translation(context).remerciements_text1,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
