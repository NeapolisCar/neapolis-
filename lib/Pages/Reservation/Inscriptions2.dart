// ignore_for_file: deprecated_member_use, prefer_final_fields, non_constant_identifier_names, avoid_print, unnecessary_cast, use_build_context_synchronously, prefer_const_constructors, prefer_const_declarations, prefer_interpolation_to_compose_strings

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camera/camera.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';


class InscriptionTransfer extends StatefulWidget {
  const InscriptionTransfer({Key? key}) : super(key: key);

  @override
  State<InscriptionTransfer> createState() => _InscriptionTransferState();
}

class _InscriptionTransferState extends State<InscriptionTransfer> {
  TextEditingController _nomprenom = TextEditingController();
  TextEditingController _cin = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _Nom_Entreprise = TextEditingController();
  TextEditingController _Payes_Region = TextEditingController();
  TextEditingController _Num_Vol = TextEditingController();
  TextEditingController _Ville = TextEditingController();
  TextEditingController _Region_Department = TextEditingController();
  TextEditingController _Numero_nom_rue = TextEditingController();
  String token ="";
  String _telephone = "";
  String selectedCountryCode = 'TN';
  bool cin = false;
  bool email = false;
  bool nom = false;
  bool nmpermi = false;
  bool nmvol = false;
  bool telephone = false;
  bool _value6 = false;
  String _Image_Cin_passpor_Path = '';
  String Image_Path = ' ';
  late CameraController _controller;
  XFile image_CIN_Passport=XFile('assets/images/default_image.jpg');
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
  int? _idlisttransfer;
  int? _idlistexurion;
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
  int index = 0;
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
  continueStep() {
    if (currentStep < 2) {
      if (currentStep == 0) {
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
        }
        else if (_nomprenom.text.isEmpty ||
            _nomprenom.text.contains(RegExp(r'[0-9]'))) {
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
        }
        else if (_telephone.isEmpty) {
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
        } else {
          setState(() {
            currentStep = currentStep + 1;
          });
        }
      }
      else if (currentStep == 1) {
        if (_Num_Vol.text.isEmpty && _value6) {
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
          insertClient();
        }
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

  String getImageNameFromPath(String path) {
    List<String> pathParts = path.split('/');
    return pathParts.last;
  }
  void Login1() {
    switch (_type) {
      case "Reservation":
        {
          Navigator.pushNamed(context, 'LoginTrnasfer', arguments: {
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
          Navigator.pushNamed(context, 'LoginTrnasfer', arguments: {
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
          Navigator.pushNamed(context, 'login', arguments: {
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
            print("acces was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
    final image_CIN_Passport =
        (await ImagePicker().pickImage(source: ImageSource.camera)) as XFile?;
    if (image_CIN_Passport != null) {
      return image_CIN_Passport!.path; // ignore: unnecessary_non_null_assertion
    }
  }

  Gallery_CIN_Passport() async {
    final image_CIN_Passport =
        (await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?;
    if (image_CIN_Passport != null) {
      return image_CIN_Passport.path;
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
            print("acces was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
    setState(() async {
    });
    return image.path;
    }

  Gallery() async {
    image = ((await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?)!;
    return image.path;
    }

  Future<void> insertClient() async {
    String apiUrl = '$ip/polls/InserClientTranfer';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['nomprenom'] = _nomprenom.text;
    request.fields['cin'] = _cin.text;
    request.fields['paye'] = _Payes_Region.text;
    request.fields['numerorue'] = _Numero_nom_rue.text;
    request.fields['telephone'] = _telephone;
    request.fields['ville'] = _Ville.text;
    request.fields['region'] = _Region_Department.text;
    request.fields['email'] = _email.text;
    request.fields['token'] = token;
    request.files.add(await http.MultipartFile.fromPath(
        'photo_cin_passport', _Image_Cin_passpor_Path));
    if (Image_Path != ' ') {
      request.files.add(await http.MultipartFile.fromPath('photo', Image_Path));
    } else {
      request.files
          .add(http.MultipartFile('photo', http.ByteStream.fromBytes([]), 0));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final String reponse = jsonData['Reponse'].toString();
      if (reponse == "error") {
        Fluttertoast.showToast(
            msg: "Error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (reponse == "email déjà utilisé") {
        Fluttertoast.showToast(
            msg: "email déjà utilisé",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        prefs.setInt('id', int.parse(reponse) );
        Fluttertoast.showToast(
            msg: "Secc",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
      }
    } else {
      Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  Widget ControlsBuilder(context , details){
    return  Column(
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
              fontSize: 18,
              color: Color.fromRGBO(12, 30, 196, 1),
            ),
          ),
        ),
      ],
    );
  }
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegExp.hasMatch(email);
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
  void initState() {
    super.initState();
    initNotifications();
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
          if(_type=="Transfer") {
            Navigator.pushNamed(context, 'listVoitures', arguments: {
              'type': _type,
              'dateRamasser': _dateRamasser,
              'allez_retour': _allez_retour,
              'idlisttransfer': _idlisttransfer,
              'prixTransfer': _prixToutal,
              'SIÈGE BÉBÉ': _siege_bebe,
              'Nombre de place': _nb_place,
              'Nombre de bagages': _nb_bagage,
            });
          }
          else if (_type=="Exurcion"){
            Navigator.pushNamed(context, 'listVoitures', arguments: {
              'type': _type,
              'dateRamasser': _dateRamasser,
              'idlistexurion': _idlistexurion,
              'prixTransfer': _prixToutal,
              'SIÈGE BÉBÉ': _siege_bebe,
              'Nombre de place': _nb_place,
              'Nombre de bagages': _nb_bagage,
            });
          }
      return true;
    },
    child :Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).inscriotion_Title),
      ),
      body:Stepper(
      currentStep: currentStep ,
      // onStepContinue: continueStep(),
      // onStepCancel:cancelStep() ,
      type: StepperType.horizontal,
      // onStepTapped:onStepTapped ,
      controlsBuilder:ControlsBuilder,
      elevation: 0,
      steps: [
        Step(title:Text(""),
        isActive: currentStep>=0 ,
        state: currentStep>=0 ? StepState.complete: StepState.disabled,
        content:SingleChildScrollView(
        child: Column(
        children: [
          SizedBox(
            height: 20,
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
          SizedBox(
          height: 10,
          ),
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
          SizedBox(
          height: 10,
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
          SizedBox(
          height: 10,
            ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () async {
                _Image_Cin_passpor_Path = await Gallery_CIN_Passport();
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        translation(context).inscriotion_photoCIN_PASSPORT,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        _Image_Cin_passpor_Path = await Camera_CIN_Passport();
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
          SizedBox(
          height: 10,
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

          SizedBox(
          height: 10,
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
          SizedBox(
          height: 10,
          ),
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
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              )
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
                  Padding(
                  padding: EdgeInsets.only(left: 16),
                    child:  Image_Path!=""?
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
        ),
      )
    );
  }
}

