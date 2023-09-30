// ignore_for_file: unused_local_variable, unnecessary_null_comparison, deprecated_member_use, unnecessary_import, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, non_constant_identifier_names, unnecessary_cast, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/Client.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/userNavbar.dart';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import '../../main.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _mot_de_passe = TextEditingController();
  TextEditingController _nmot_de_passe = TextEditingController();
  TextEditingController _cmot_de_passe = TextEditingController();
  bool telephone = false;
  String _telephone = "";
  String _telephone1="";
  String selectedCountryCode = 'TN';
  List<Client> _Client = [];
  String _image = '';
  int _selectedIndex = 1;
  int _selectedIndex1 = 2;
  String Image_Path = ' ';
  int _id =0;
  String email = '';
  Future<void> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt('id')!;
    List<Client> client = [];
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Client'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'id': _id,
      }),
    );
    if (response.statusCode == 200) {
      final List<Client> client = jsonDecode(response.body)
          .map<Client>((json) => Client.fromJson(json))
          .toList();
      setState(() {
        _Client = client;
        if (_Client.isNotEmpty) {
          email = _Client.first.email;
          _image = _Client.first.photo;
          _telephone=_Client.first.telephone;
        }
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }
  Future<void> _save() async {
    print(_telephone);
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt('id')!;
    List<Client> client = [];
    String apiUrl = '$ip/polls/UpdateClient';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['id']= _id.toString() ;
    request.fields['telephone'] = _telephone1;
    request.fields['email'] = _email.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final String reponse = jsonData['Reponse'];
      if (reponse == "Failed") {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if( reponse =="Success"){
        Navigator.pushNamed(context, 'Parametres');
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
    else {
      throw Exception('Failed to update');
    }
  }
  Future<void> _changemotdepasse(String mot_de_passe, String nmot_de_passe, String cmot_de_passe) async {
    if (nmot_de_passe == cmot_de_passe) {
      final prefs = await SharedPreferences.getInstance();
      _id = prefs.getInt('id')!;
      List<Client> client = [];
      final response = await http.post(
        Uri.parse('$ip/polls/UpadateClientPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': _id,
          'mot_de_passe': mot_de_passe,
          'nmot_de_passe': nmot_de_passe,
        }),
      );
      if (response.statusCode == 200) {
        final _text = response.body.toString();
        if (_text == "secc") {
          Navigator.pushNamed(context, 'Parametres');
        } else {
          Fluttertoast.showToast(
              msg: _text,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        throw Exception('Failed to update');
      }
    } else {
      Fluttertoast.showToast(
          msg:  translation(context).edit_Profile_it_Profile_message1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
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
    _Client = arguments['Client'] as List<Client>;
    if (_Client.isNotEmpty) {
      _email.text = _Client.first.email;
      _telephone = _Client.first.telephone.toString();
      _image = _Client.first.photo;
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          'Parametres',
        );
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: MyAppBar(Title: translation(context).edit_Profile_title),
          ),
          endDrawer: MyDrawer(selectedIndex: _selectedIndex1),
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: _Client != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors
                                      .white, // You can set the background color of the CircleAvatar if needed
                                  radius: 70,
                                  child: ClipOval(
                                    child: Image.network(
                                      _image,
                                      width:
                                          300, // Set the desired width of the image
                                      height:
                                          350, // Set the desired height of the image
                                      fit: BoxFit
                                          .cover, // Adjust the image to cover the entire CircleAvatar
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 90,
                            color: Colors.grey[800],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    labelText:  translation(context).inscriotion_Email,
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                            ),
                                SizedBox(height: 10),
                                Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IntlPhoneField(
                                      initialValue: _telephone,
                                      decoration: InputDecoration(
                                        labelText: translation(context).inscriotion_telephone,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        errorText: telephone ? translation(context).inscriotion_message9 : null,
                                      ),
                                      initialCountryCode: selectedCountryCode,
                                      onChanged: (phone) {
                                        // Update the state of the phone variable
                                        setState(() {
                                          _telephone = phone.completeNumber;
                                          _telephone1= phone.completeNumber;
                                        });
                                      },
                                    )
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _save();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ), // Background color
                                    ),
                                    child: Text(translation(context)
                                        .edit_Profile_button1,
                                    textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 50,
                                  color: Colors.grey[800],
                                ),
                                TextField(
                                  controller: _mot_de_passe,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText:  translation(context).inscriotion_mtp,
                                    // errorText: 'Error message',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(Icons.key),
                                    // suffixIcon: Icon(
                                    //   Icons.error,
                                    // ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: _nmot_de_passe,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText:  translation(context).edit_Profile_textFiel1,
                                    prefixIcon: Icon(Icons.key),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: _cmot_de_passe,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText:  translation(context).edit_Profile_textField2,
                                    // errorText: 'Error message',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(Icons.key),
                                    // suffixIcon: Icon(
                                    //   Icons.error,
                                    // ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _changemotdepasse(
                                              _mot_de_passe.text,
                                              _nmot_de_passe.text,
                                              _cmot_de_passe.text);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red[900],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ), // Background color
                                        ),
                                        child: Text(translation(context)
                                            .edit_Profile_button2))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          bottomNavigationBar: UserNavBar(selectedIndex: _selectedIndex)),
    );
  }
}
