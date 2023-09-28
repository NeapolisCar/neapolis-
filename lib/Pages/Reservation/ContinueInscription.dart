import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';


class ContinueInscription extends StatefulWidget {
  const ContinueInscription({Key? key}) : super(key: key);

  @override
  State<ContinueInscription> createState() => _ContinueInscriptionState();
}

class _ContinueInscriptionState extends State<ContinueInscription> {
  final TextEditingController _Numero_de_Permis = TextEditingController();
  final TextEditingController _Nom_Entreprise = TextEditingController();
  late String Image_Parmis_Path = '';
  late CameraController _controller;
  late XFile? image_Parmis;
  late bool _DEUXIEME_CONDUCTEUR = false;
  late bool _REHAUSSEUR = false;
  late bool _SYSTEME_DE_NAVIGATION_GPS = false;
  late bool _SIEGE_BEBE = false;
  late bool _PLEIN_SSENCE = false;
  late DateTime? _dateRamasser;
  late DateTime? _dateRevenir;
  late String? _location_de_rammaser;
  late String? _location_de_revenir;
  late int _days = 1;
  late String _numeroSeries = "";
  late double _prixToutal = 0;
  late double _prixJour = 0;
  late double _caution = 0;
  late String _modele = "";
  late String _photo = "";
  late String _type = "";
  late int _id =0;
  late int index = 0;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _type = arguments['type'] as String;
    switch (_type) {
      case "Reservation":
        {
          _dateRamasser = arguments['dateRamasser'] as DateTime;
          _dateRevenir = arguments['dateRevenir'] as DateTime;
          _location_de_rammaser = arguments['location_de_rammaser'] as String;
          _location_de_revenir = arguments['location_de_revenir'] as String;
          _days = arguments['days'] as int;
          _numeroSeries = arguments['numeroSeries'] as String;
          _prixJour = arguments['prixJour'] as double;
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
        }
        break;
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
      'caution': _caution,
      'photo': _photo,
      'PLEIN ESSENCE': _PLEIN_SSENCE,
      'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
      'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
      'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
      'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
    });
  }

  Future<void> insertClient() async {
    String apiUrl = '$ip/polls/ContinueInscriClient';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['id'] = _id as String;
    request.fields['numeroparmis'] = _Numero_de_Permis.text;
    request.fields['nomentrprise'] = _Nom_Entreprise.text;
    request.files.add(
        await http.MultipartFile.fromPath('photo_parmis', Image_Parmis_Path));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final String reponse = jsonData['Reponse'];
      if (reponse == "error") {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message11,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: translation(context).inscriotion_message12,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
          'photo': _photo,
          'PLEIN ESSENCE': _PLEIN_SSENCE,
          'DEUXIÈME CONDUCTEUR': _DEUXIEME_CONDUCTEUR,
          'REHAUSSEUR ( 24-42 MOIS)': _REHAUSSEUR,
          'SYSTÈME DE NAVIGATION GPS': _SYSTEME_DE_NAVIGATION_GPS,
          'SIÈGE BÉBÉ ( 6-24 MOIS)': _SIEGE_BEBE,
        });
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
    }
  }

  void suivent() {
    Verifier1();
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
            break;
          default:
            break;
        }
      }
    });
    final imageParmis =
        (await ImagePicker().pickImage(source: ImageSource.camera));
    if (imageParmis != null) {
      return imageParmis.path;
    }
  }

  Gallery_Parmis() async {
    final imageParmis =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (imageParmis != null) {
      return imageParmis.path;
    }
  }

  // ignore: non_constant_identifier_names
  void Verifier1() {
    if (Image_Parmis_Path.isEmpty) {
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message6,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (_Numero_de_Permis.text.isEmpty) {
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message8,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        insertClient();
      });
    }
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _id = prefs.getInt('id')!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child:
            MyAppBar(Title: translation(context).contunier_inscription_title),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              translation(context).contunier_inscription_text,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _Numero_de_Permis,
                      decoration: InputDecoration(
                        labelText: translation(context).inscriotion_numeroparmi,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: const Icon(Icons.numbers),
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                        prefixIcon: const Icon(Icons.factory),
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Image_Parmis_Path = await Gallery_Parmis();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              translation(context).inscriotion_photoParmi,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              Image_Parmis_Path = await Camera_Parmis();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        suivent();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          translation(context).reservation_voiture_button,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
              ],
            ),
          ],
        )),
      ),
    );
  }
}
