// ignore_for_file: use_build_context_synchronously, duplicate_ignore, non_constant_identifier_names, file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Compounes/dropitem.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Classes/Voituture.dart';
import 'package:neapolis_car/Pages/Classes/OptionsVoiture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neapolis_car/main.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class ListVoiture extends StatefulWidget {
  const ListVoiture({Key? key}) : super(key: key);

  @override
  State<ListVoiture> createState() => _ListVoitureState();
}

class _ListVoitureState extends State<ListVoiture> {
  List<Voiture> _voitures = [];
  // ignore: non_constant_identifier_names
  List<Options> _Options = [];
  late String dropdownvalue = "prix_decroissant";
  final List<String> _items = [
    "prix_decroissant",
    "prix_croissant",
  ];
  final _selectedIndex = 0;
  DateTime _dateRamasser = DateTime.now();
  DateTime? _dateRevenir;
  String? _location_de_rammaser;
  String? _location_de_revenir;
  int? _days;
  double _prix = 0;
  String _type = "";
  bool isInternet = false;

  Future<void> getData() async {
    while (_days == null || _dateRamasser == DateTime.now()) {
      await Future.delayed(const Duration(seconds: 1));
    }
    fetchVoitures();
  }

  Future<void> Information(
      String numeroSeries, String photo, String model) async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_OptionVoitures'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'numeroSeries': numeroSeries}), // Send data as JSON
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _Options = jsonData.map((json) {
          return Options.fromJson(json);
        }).toList();
      });
      return showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          builder: (context) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
              ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(model),
                        Image.network(
                          photo,
                          width: 152,
                          height: 99,
                        ),
                        // Add spacing between the TableRows
                        Table(
                          children: _Options.map((option) => TableRow(
                            children: [
                              Row(
                                  children: [
                          Flexible(
                                   child: Text(option.title)
                              ),
                                  ]
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  option.descriptions=="true"? SvgPicture.asset(
                                    "assets/images/img_checkmark.svg",
                                    width: 38,
                                    height: 23,
                                  ):
                                  Flexible(
                                    child:Text(option.descriptions)
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),

                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                )
                ),
              );
    } else {
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message11,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Failed to load Options');
    }
  }

  Future<void> fetchVoitures() async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Voitures'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'date': _dateRamasser.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _voitures = jsonData.map((json) {
          return Voiture.fromJson(json);
        }).toList();
      });
    } else {
      Fluttertoast.showToast(
          msg: translation(context).inscriotion_message11,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Failed to load voitures');
    }
  }

  Future<void> passage( double prixJour, double caution, String modele, String photo) async {
    final response = await http.post(
      Uri.parse('$ip/polls/getNumeroSeries'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'modele':modele,
          'date': _dateRamasser.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if(jsonData.containsKey('numerSeries'))
      {
          final String numeroSeries  = jsonData['numerSeries'];
          final prixToutal = prixJour * _days!;
          Navigator.pushNamed(context, 'detailVoiture', arguments: {
              'type': _type,
              'dateRamasser': _dateRamasser,
              'dateRevenir': _dateRevenir,
              'location_de_rammaser': _location_de_rammaser,
              'location_de_revenir': _location_de_revenir,
              'days': _days,
              'numeroSeries': numeroSeries,
              'prixToutal': prixToutal + _prix,
              'caution': caution,
              'prixJour': prixJour,
              'prix': _prix,
              'modele': modele,
              'photo': photo,
              'index': 0
          });
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
    } else {
      Fluttertoast.showToast(
          // ignore: use_build_context_synchronously
          msg: translation(context).inscriotion_message11,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

  }

  void sortVoituresByPrice() {
    _voitures.sort((a, b) => a.prixJour.compareTo(b.prixJour));
  }

  void desortVoituresByPrice() {
    _voitures.sort((a, b) => b.prixJour.compareTo(a.prixJour));
  }

  void searchAndUpdateByModel(String model) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _originalVoitures = _voitures;
    setState(() {
      if (model.isEmpty) {
        fetchVoitures();
      } else {
        _voitures = _originalVoitures
            .where((voiture) => voiture.modele.contains(model))
            .toList();
      }
    });
  }
  showSnackBar(String message){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  testInternet()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
        showSnackBar("Aucune Connexion Internet");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    testInternet();
    getData();

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
    _prix = arguments['prix'] as double;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, 'reservation');
          return true;
        },
      child :Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).liste_de_voitures_title),
      ),
      endDrawer: MyDrawer(selectedIndex: _selectedIndex),
      body:  Column(
              children: [
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: TextField(
                      onChanged: (value) {
                        searchAndUpdateByModel(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Recharche',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: dropitems(
                    items: _items,
                    icon: Icons.onetwothree_rounded,
                    margin: const EdgeInsets.all(16),
                    text: translation(context).liste_de_voitures_tri,
                    onItemSelected: (selectedValue) {
                      setState(() {
                        dropdownvalue = selectedValue;
                      });
                      if (dropdownvalue == "prix_decroissant") {
                        sortVoituresByPrice();
                      } else if (dropdownvalue == "prix_croissant") {
                        desortVoituresByPrice();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    // ignore: unnecessary_null_comparison
                    child: _voitures != null
                        ? Column(
                            children: _voitures
                                .map(
                                  (voiture) => InkWell(
                                      onTap: () {
                                        voiture.disponibilite ==
                                            "disponible"
                                            ? passage(
                                            voiture.prixJour,
                                            voiture.caution,
                                            voiture.modele,
                                            voiture.photo)
                                            : null;
                                      },
                                      child:  Card(
                                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        elevation:
                                            5, // This is similar to the spreadRadius in the boxShadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        color: const Color(0xfffffcfc),
                                        shadowColor: Colors.grey.withOpacity(0.3),
                                        child: Row(
                                          children: [
                                            Column(
                                                children: [
                                              Image.network(
                                                voiture.photo,
                                                width: 152,
                                                height: 99,
                                                errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.jpg",
                                                ),
                                              ),
                                              const SizedBox(height: 50),
                                              Text(
                                                (voiture.prixJour * _days!)
                                                        .toString() +
                                                    translation(context)
                                                        .liste_de_voitures_prixToutal,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(_days.toString() +
                                                  translation(context)
                                                      .liste_de_voitures_jours),
                                              voiture.disponibilite == "disponible"
                                                  ? Row(
                                                      children: [
                                                        const FaIcon(
                                                          FontAwesomeIcons
                                                              // ignore: deprecated_member_use
                                                              .checkCircle,
                                                          color: Colors.green,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(AppLocalizations.of(context)!
                                                            .liste_de_voitures_Disponible),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        const FaIcon(
                                                          // ignore: deprecated_member_use
                                                          FontAwesomeIcons.cancel,
                                                          color: Colors.red,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(AppLocalizations.of(
                                                                context)!
                                                            .liste_de_voitures_NoDisponible),
                                                      ],
                                                    ),
                                              const SizedBox(height: 10),
                                              TextButton(
                                                onPressed: () {
                                                  Information(
                                                      voiture.numeroSeries,
                                                      voiture.photo,
                                                      voiture.modele);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  // primary: Colors.blue[700],

                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20.0),
                                                  ), // Background color
                                                ),
                                                child: Text(
                                                  translation(context)
                                                      .liste_de_voitures_PlusInfo,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            const SizedBox(width: 15.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(voiture.marque),
                                                    const SizedBox(width: 10,),
                                                    Image.network(
                                                      voiture.photoMarque,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  voiture.modele,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/img_seats1.png",
                                                      width: 20,
                                                      height: 24,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        voiture.nbSeats +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_SEATS,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                    Image.asset(
                                                      "assets/images/img_bags1.png",
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        voiture.nbBags +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_BAGS,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/img_doors1.png",
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        voiture.nbPorts +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_PORTES,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(height: 35),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    voiture.disponibilite ==
                                                            "disponible"
                                                        ? passage(
                                                            voiture.prixJour,
                                                            voiture.caution,
                                                            voiture.modele,
                                                            voiture.photo)
                                                        : null;
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.black, backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Text(
                                                      translation(context)
                                                          .liste_de_voitures_payez,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily: 'Nunito',
                                                        fontWeight: FontWeight.w400,
                                                        letterSpacing: -0.36,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                  )
                            ).toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
      ),
    )
    );
  }
}
