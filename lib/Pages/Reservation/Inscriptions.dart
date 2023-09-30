// ignore_for_file: unused_field, unused_local_variable, deprecated_member_use, unnecessary_import, prefer_final_fields, non_constant_identifier_names, unnecessary_cast, prefer_const_declarations, prefer_const_constructors, use_build_context_synchronously, annotate_overrides, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, file_names, avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:neapolis_car/main.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  TextEditingController _nomprenom = TextEditingController();
  TextEditingController _cin = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mot_de_passe = TextEditingController();
  TextEditingController _cmot_de_passe = TextEditingController();
  TextEditingController _Numero_de_Permis = TextEditingController();
  TextEditingController _Nom_Entreprise = TextEditingController();
  TextEditingController _Payes_Region = TextEditingController();
  TextEditingController _Num_Vol = TextEditingController();
  TextEditingController _Ville = TextEditingController();
  TextEditingController _Region_Department = TextEditingController();
  TextEditingController _Numero_nom_rue = TextEditingController();
  String token ="";
  String selectedCountryCode = 'TN';
  bool cin = false;
  bool email = false;
  bool nom = false;
  bool nmpermi = false;
  bool nmvol = false;
  bool telephone = false;
  bool _value6 = false;
  String _telephone = "";
  String Image_Cin_passpor_Path = '';
  String Image_Parmis_Path = '';
  String Image_Path = ' ';
  late CameraController _controller;
  XFile image_CIN_Passport=XFile('assets/images/default_image.jpg');
  XFile image_Parmis=XFile('assets/images/default_image.jpg');
  XFile image=XFile('assets/images/default_image.jpg');
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
  double _caution = 0;
  String _modele = "";
  String _photo = "";
  String _type = "";
  double _prix = 0;
  late int index = 0;
  int currentStep=0;
  Future<void> handleBackgroundMessage(RemoteMessage message) async{
    print('Title${message.notification?.title}');
    print('Body${message.notification?.body}');
    print('Payload${message.data}');

  }
  final _firebaseMessaging= FirebaseMessaging.instance;
  Future<void> initNotifications() async{
      await _firebaseMessaging.requestPermission();
      setState(() async {
        token = (await _firebaseMessaging.getToken())!;
      });
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      }
  continueStep(){
    if(currentStep<3){
      if(currentStep==0) {
          if (_cin.text.isEmpty) {
            setState(() {
              cin= true;
            });
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message1,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (!isValidEmail(_email.text)) {
            setState(() {
              email= true;
            });
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message2,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }  else if (Image_Cin_passpor_Path.isEmpty) {
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message5,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (Image_Parmis_Path.isEmpty) {
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message6,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (_nomprenom.text.isEmpty || _nomprenom.text.contains(RegExp(r'[0-9]'))) {
            setState(() {
              nom= true;
            });
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message7,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (_Numero_de_Permis.text.isEmpty) {
            setState(() {
              nmpermi= true;
            });
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message8,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          else {
            setState(() {
              currentStep = currentStep+1;
            });
          }
        }
      else if (currentStep==1){
        if (_telephone.isEmpty) {
          setState(() {
            telephone = true;
          });
          Fluttertoast.showToast(
              msg: translation(context).inscriotion_message9,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        else if (_Num_Vol.text.isEmpty && _value6)
          {
            setState(() {
              nmvol= true;
            });
            Fluttertoast.showToast(
                msg: "Vérifiez votre Numero de vol",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        else {
          setState(() {
            currentStep = currentStep+1;
          });
        }
      }
      else if (currentStep==2){
          insertClient();

      }
    }
  }
  cancelStep(){
    if(currentStep>0){
      setState(() {
        currentStep = currentStep-1;
      });
    }
  }
  void Login1() {
          Navigator.pushNamed(context, 'login', arguments: {
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
            'PLEIN ESSENCE': _PLEIN_SSENCE,
            'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
            'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
            'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
            'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
          });
  }

  Camera_CIN_Passport() async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          default:
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
        }
      }
    });
    final image_CIN_Passport =
        (await ImagePicker().pickImage(source: ImageSource.camera)) as XFile?;
    if (image_CIN_Passport != null) {
      return image_CIN_Passport.path;
    }
  }

  Gallery_CIN_Passport() async {
    final image_CIN_Passport =
        (await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?;
    if (image_CIN_Passport != null) {
      return image_CIN_Passport.path;
    }
  }

  Camera_Parmis() async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          default:
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
        }
      }
    });
    final image_Parmis =
        (await ImagePicker().pickImage(source: ImageSource.camera)) as XFile?;
    if (image_Parmis != null) {
      return image_Parmis.path;
    }
  }

  Gallery_Parmis() async {
    final image_Parmis =
        (await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?;
    if (image_Parmis != null) {
      return image_Parmis.path;
    }
  }

  Camera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          default:
            Fluttertoast.showToast(
                msg: translation(context).inscriotion_message11,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
        }
      }
    });
    setState(() async {
      final image =
          (await ImagePicker().pickImage(source: ImageSource.camera)) as XFile?;
    });
    if (image != null) {
      return image.path;
    }
  }

  Gallery() async {
    image =
        ((await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?)!;
    if (image != null) {
      return image.path;
    }
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }
  String getImageNameFromPath(String path) {
    List<String> pathParts = path.split('/');
    return pathParts.last;
  }
  bool isStrongPassword(String password) {
    // Define criteria for a strong password
    final minLength = 8; // Minimum length
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigits = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialCharacters =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return password.length >= minLength &&
        hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters;
  }



Widget ControlsBuilder(context , details){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                cancelStep();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  translation(context).inscriotion_button1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.36,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () {
                continueStep();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  translation(context).reservation_voiture_button,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.36,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translation(context).inscriotion_button3),
            TextButton(
              onPressed: () {
                Login1();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), // Background color
              ),
              child: Text(
                translation(context).login_Title,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(12, 30, 196, 1),
                ),
              ),
            ),
          ],
        )
      ],
    )
   ;
}
onStepTapped(int value){
    currentStep= value;
}
  Future<void> insertClient() async {
    showDialog(
        context: context,
        builder: (context){
          return Center(child:CircularProgressIndicator());
        }
    );
    String apiUrl = '$ip/polls/InserClient';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['nomprenom'] = _nomprenom.text;
    request.fields['numeroparmis'] = _Numero_de_Permis.text;
    request.fields['nomentrprise'] = _Nom_Entreprise.text;
    request.fields['cin'] = _cin.text;
    request.fields['paye'] = _Payes_Region.text;
    request.fields['numerorue'] = _Numero_nom_rue.text;
    request.fields['telephone'] = _telephone;
    request.fields['ville'] = _Ville.text;
    request.fields['region'] = _Region_Department.text;
    request.fields['email'] = _email.text;
    request.fields['token'] = token;
    request.files.add(
        await http.MultipartFile.fromPath('photo_parmis', Image_Parmis_Path));
    request.files.add(await http.MultipartFile.fromPath(
        'photo_cin_passport', Image_Cin_passpor_Path));
    if (Image_Path != ' ') {
      request.files.add(await http.MultipartFile.fromPath('photo', Image_Path));
    } else {
      request.files
          .add(http.MultipartFile('photo', http.ByteStream.fromBytes([]), 0));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.of(context).pop();      final prefs = await SharedPreferences.getInstance();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final String reponse = jsonData['Reponse'].toString();
      if (reponse == "error") {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (reponse == "email déjà utilisé") {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message13,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {

        prefs.setInt('id', int.parse(reponse));
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message12,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
                'prix': _prix,
                'caution': _caution,
                'photo': _photo,
                'PLEIN ESSENCE': _PLEIN_SSENCE,
                'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
                'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
                'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
                'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
              });
            }
            break;
        }
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message10,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void initState() {
    super.initState();
    initNotifications();
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
          _prix = arguments['prix'] as double;
          _caution = arguments['caution'] as double;
          _prixToutal = arguments['prixToutal'] as double;
          _modele = arguments['modele'] as String;
          _photo = arguments['photo'] as String;
          _PLEIN_SSENCE = arguments['PLEIN ESSENCE'] as bool;
          _DEUXIEME_CONDUCTEUR = arguments['DEUXIÈME CONDUCTEUR'] as bool;
          _REHAUSSEUR = arguments['REHAUSSEUR ( 24-42 MOIS)'] as bool;
          _SYSTEME_DE_NAVIGATION_GPS =
          arguments['SYSTÈME DE NAVIGATION GPS'] as bool;
          _SIEGE_BEBE = arguments['SIÈGE BÉBÉ ( 6-24 MOIS)'] as bool;
    String Image_Cin;
    return WillPopScope(
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
    child : Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).inscriotion_Title),
      ),
      body:
      Stepper(
        currentStep: currentStep ,
        type: StepperType.horizontal,
        controlsBuilder:ControlsBuilder,
        elevation: 0,
        steps: [
        Step(
          title:Text(""),
          isActive: currentStep>=0 ,
          state: currentStep>=0 ? StepState.complete: StepState.disabled,
          content:SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _cin,
                      decoration: InputDecoration(
                        labelText: translation(context).inscriotion_CIN,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.info_outline),
                        errorText: cin ? translation(context).inscriotion_message1 : null,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: translation(context).inscriotion_Email+"*",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.email),
                        errorText: email ? translation(context).inscriotion_message2 : null,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nomprenom,
                      decoration: InputDecoration(
                        labelText: translation(context).inscriotion_nom+"*",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.person),
                        errorText: nom ? translation(context).inscriotion_message7 : null,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _Numero_de_Permis,
                      decoration: InputDecoration(
                        labelText:
                        translation(context).inscriotion_numeroparmi,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.numbers),
                        errorText: nmpermi? translation(context).inscriotion_message8 : null,
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Image_Cin_passpor_Path = await Gallery_CIN_Passport();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                               Image_Cin_passpor_Path!=""?
                              Expanded(
                                child: Text(
                                  "Image ${getImageNameFromPath(Image_Cin_passpor_Path)}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ):
                              Text(
                                translation(context).inscriotion_photoCIN_PASSPORT,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () async {
                                Image_Cin_passpor_Path = await Camera_CIN_Passport();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    elevation: 3, // Add elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Image_Parmis_Path = await Gallery_Parmis();
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image_Parmis_Path!=""?
                                  Expanded(
                                  child: Text(
                                      "Image ${getImageNameFromPath(Image_Parmis_Path)}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ):
                            Text(
                              translation(context).inscriotion_photoParmi,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () async {
                                Image_Parmis_Path = await Camera_Parmis();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            ),
        Step(title: Text(''),
          isActive: currentStep>=1,
          state: currentStep>1 ? StepState.complete: StepState.disabled,
          content:SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: IntlPhoneField(
                      // controller: _telephone,
                      decoration: InputDecoration(
                        labelText:translation(context).inscriotion_telephone,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorText: telephone ? translation(context).inscriotion_message9 : null,
                      ),
                      initialCountryCode: selectedCountryCode,
                      onChanged: (phone) {
                        setState(() {
                          _telephone= phone.completeNumber;
                        });
                      },
                      onCountryChanged: (phoneCountry) {
                        selectedCountryCode = phoneCountry.code;
                        // Handle the selected country code change here
                      },
                    )
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _Nom_Entreprise,
                    decoration: InputDecoration(
                      labelText:
                          translation(context).inscriotion_nomEnreprise,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.factory),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _Payes_Region,
                    decoration: InputDecoration(
                      labelText: translation(context).inscriotion_paye,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.landscape),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _Ville,
                    decoration: InputDecoration(
                      labelText: translation(context).inscriotion_ville,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.landscape),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text(translation(context).inscriotion_choixe1),
                  value: _value6,
                  onChanged: (newValue) {
                    setState(() {
                      _value6 = newValue ?? false;
                    });
                  },
                ),
                Visibility(
                    visible: _value6,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _Num_Vol,
                        decoration: InputDecoration(
                          labelText:
                              translation(context).inscriotion_numVol,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(Icons.airplane_ticket_outlined),
                          errorText: nmvol ? translation(context).inscriotion_message1 : null,
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
        Step(title: Text(''),
            isActive: currentStep>=2,
          state: currentStep>2 ? StepState.complete: StepState.disabled,
            content:SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _Region_Department,
                            decoration: InputDecoration(
                              labelText: translation(context).inscriotion_region,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.home_work_outlined),
                              // suffixIcon: Icon(
                              //   Icons.error,
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _Numero_nom_rue,
                            decoration: InputDecoration(
                              labelText: translation(context).inscriotion_Num_rue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.home_work_outlined),
                              // suffixIcon: Icon(
                              //   Icons.error,
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () async {
                              Image_Path = await Gallery();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                      Image_Path!=""?
                                      Expanded(
                                      child: Text(
                                          "Image ${getImageNameFromPath(Image_Path)}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ): Text(
                                      translation(context).inscriotion_photo,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () async {
                                      Image_Path = await Camera();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
            )
          ],
        )
      )
    );
  }
}
