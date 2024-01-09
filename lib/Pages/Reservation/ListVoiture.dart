// ignore_for_file: use_build_context_synchronously, duplicate_ignore, non_constant_identifier_names, file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/Marque.dart';
import 'package:neapolis_car/Pages/Compounes/dropitem.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Classes/Voituture.dart';
import 'package:neapolis_car/Pages/Classes/OptionsVoiture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neapolis_car/main.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import '../Compounes/Card.dart';
import '../Compounes/skeleton.dart';
import '../Compounes/constants.dart';

class ListVoiture extends StatefulWidget {
  const ListVoiture({Key? key}) : super(key: key);

  @override
  State<ListVoiture> createState() => _ListVoitureState();
}

class _ListVoitureState extends State<ListVoiture> {
  List<Voiture> _voitures = [];
  List<Marquer> _marquer =[];
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
  double _prix_session =0;
  bool isInternet = false;
  bool loading = true;

  Future<void> getData() async {
    while (_days == null || _dateRamasser == DateTime.now() ) {
      await Future.delayed(const Duration(seconds: 1));
    }
    fetchVoitures();
    fetchMarquer();
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
            final List<dynamic> jsonData = responseData['data'];
            setState(() {
              _Options = jsonData.map((json) {
                return Options.fromJson(json);
              }).toList();
            });
            return showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              builder: (context) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                          child: Text(option.title,
                                              style:Theme.of(context).textTheme.bodyText2)
                                      ),
                                    ]
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    option.descriptions=="true"? SvgPicture.asset(
                                      "assets/images/img_checkmark.svg",
                                      width: 38,
                                      height: 23,
                                    ):
                                    Flexible(
                                        child:Text(option.descriptions,
                                            style:Theme.of(context).textTheme.bodyText2)
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
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
  Future<void> fetchVoitures() async {
    final response = await http.post(
      Uri.parse('$ip/polls/AvailableCarsViewSet'),
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
            final List<dynamic> jsonData = responseData['data'];
            setState(() {
              _voitures =groupByModele(jsonData.map((json) {
                return Voiture.fromJson(json);
              }).toList());
              loading=false;
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

  Future<void> fetchMarquer() async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Marque'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
            final List<dynamic> jsonData = responseData['data'];
            setState(() {
              _marquer = jsonData.map((json) {
                return Marquer.fromJson(json);
              }).toList();
              loading=false;
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
              final String numeroSeries  = responseData['numerSeries'];
              final prixToutal = prixJour * _prix_session!;
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
            } break;
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

  String nom(id){
    final marque =_marquer.firstWhere((obj) => obj.id == id);
    return marque.nom;
  }
  String logo(id){
    final marque =_marquer.firstWhere((obj) => obj.id == id);
    return marque.logo;
  }
  List<Voiture> groupByModele(List<Voiture> voitures) {
    Map<String, Voiture> groupedMap = {};

    for (Voiture item in voitures) {
      groupedMap[item.modele] = item;
    }

    return groupedMap.values.toList();
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

  double calculateTotalPrice(DateTime startDate, DateTime endDate) {
    int days = (startDate.year -2024) *11;
    DateTime Eid1Start = DateTime(startDate.year , 4 , 5).subtract(Duration(days: days));
    DateTime Eid1End = DateTime(startDate.year , 6 , 10).subtract(Duration(days: days));
    DateTime Eid2Start = DateTime(startDate.year , 6 ,10).subtract(Duration(days: days));
    DateTime Eid2End = DateTime(startDate.year , 6 , 20).subtract(Duration(days: days));
    DateTime session1Start = DateTime(startDate.year, 6, 1);
    DateTime session1End = DateTime(startDate.year, 6, 20);
    DateTime session2Start = DateTime(startDate.year , 6 , 21);
    DateTime session2End = DateTime(startDate.year , 7,10 );
    DateTime session3Start = DateTime(startDate.year , 7 , 11);
    DateTime session3End = DateTime(startDate.year , 8 , 10);
    DateTime session4Start = DateTime(startDate.year , 8 , 11);
    DateTime session4End = DateTime(startDate.year , 9,15 );
    DateTime session5Start = DateTime(startDate.year , 12 , 15  );
    DateTime session5End = DateTime(startDate.year+1 , 1, 5);
    DateTime julyStart = DateTime(startDate.year, 7, 1);
    DateTime septemberEnd = DateTime(startDate.year, 9, 15);
    DateTime currentDay = startDate;
    double n = 0;
    if ((startDate.isAfter(session1Start) ||
        startDate.isAtSameMomentAs(session1Start)) &&
        (endDate.isBefore(session1End) ||
            endDate.isAtSameMomentAs(session1End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 1.5;
    } else if ((startDate.isAfter(session2Start) ||
        startDate.isAtSameMomentAs(session2Start)) &&
        (endDate.isBefore(session2End) ||
            endDate.isAtSameMomentAs(session2End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 2;
    } else if ((startDate.isAfter(session3Start) ||
        startDate.isAtSameMomentAs(session3Start)) &&
        (endDate.isBefore(session4End) ||
            endDate.isAtSameMomentAs(session4End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 2.2;
    }
    else if ((startDate.isAfter(session4Start) ||
        startDate.isAtSameMomentAs(session4Start)) &&
        (endDate.isBefore(session4End) ||
            endDate.isAtSameMomentAs(session4End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 1.9;
    }
    else if ((startDate.isAfter(session5Start) ||
        startDate.isAtSameMomentAs(session5Start)) &&
        (endDate.isBefore(session5End) ||
            endDate.isAtSameMomentAs(session5End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 1.5;
    } else if ((startDate.isAfter(session1Start) ||
        startDate.isAtSameMomentAs(session1Start)) &&
        (endDate.isBefore(session1End) ||
            endDate.isAtSameMomentAs(session1End))) {
      return (endDate
          .difference(startDate)
          .inDays + 1) * 1.5;
    } else  if ((startDate.isAfter(Eid1Start) || startDate.isAtSameMomentAs(Eid1Start)) &&
        (endDate.isBefore(Eid1End) || endDate.isAtSameMomentAs(Eid1End))) {
      return (endDate.difference(startDate).inDays + 1) * 1.5;
    } else if ((startDate.isAfter(Eid2Start) || startDate.isAtSameMomentAs(Eid2Start)) &&
        (endDate.isBefore(Eid2End) || endDate.isAtSameMomentAs(Eid2End))) {
      return (endDate.difference(startDate).inDays + 1) * 1.5;
    } else {
      while (currentDay.isBefore(endDate) ||
          currentDay.isAtSameMomentAs(endDate)) {
        if ((currentDay.isAfter(session1Start) ||
            currentDay.isAtSameMomentAs(session1Start)) &&
            (currentDay.isBefore(session1End) ||
                currentDay.isAtSameMomentAs(session1End))) {
          n += 1.5;
        } else if ((currentDay.isAfter(session2Start) ||
            currentDay.isAtSameMomentAs(session2Start)) &&
            (currentDay.isBefore(session2End) ||
                currentDay.isAtSameMomentAs(session2End))) {
          n += 2;
        } else if ((currentDay.isAfter(session3Start) ||
            currentDay.isAtSameMomentAs(session3Start)) &&
            (currentDay.isBefore(session3End) ||
                currentDay.isAtSameMomentAs(session3End))) {
          n += 2.2;
        }
        else if ((currentDay.isAfter(session4Start) ||
            currentDay.isAtSameMomentAs(session4Start)) &&
            (currentDay.isBefore(session4End) ||
                currentDay.isAtSameMomentAs(session4End))) {
          n += 1.9;
        }
        else if ((currentDay.isAfter(session5Start) ||
            currentDay.isAtSameMomentAs(session5Start)) &&
            (currentDay.isBefore(session5End) ||
                currentDay.isAtSameMomentAs(session5End))) {
          n += 1.5;
        }
        else if ((currentDay.isAfter(Eid1Start) ||
            currentDay.isAtSameMomentAs(Eid1Start)) &&
            (currentDay.isBefore(Eid1End) ||
                currentDay.isAtSameMomentAs(Eid1End))) {
          n += 1.5;}
        else if ((currentDay.isAfter(Eid2Start) ||
            currentDay.isAtSameMomentAs(Eid2Start)) &&
            (currentDay.isBefore(Eid2End) ||
                currentDay.isAtSameMomentAs(Eid2End))) {
          n += 1.5;}
        else {
          n += 1;
        }
        currentDay = currentDay.add(Duration(days: 1));
      }
      print('Total Price: $n');
      return n.toDouble();
    }
  }

  bool isSummerSeason(DateTime date) {
    // Define your summer season logic here (e.g., May to August)
    int month = date.month;
    return month >= 5 && month <= 8;
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
    _prix_session = calculateTotalPrice(_dateRamasser, _dateRevenir!);
    // print('Total Price: $totalPrice');
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
                        hintText: translation(context).liste_de_voitures_recharche,
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
                    child: (_voitures != null && _marquer!= null)?  Column(
                            children: _voitures
                                .map(
                                  (voiture) => InkWell(
                                      onTap: () {
                                        passage(
                                            voiture.prixJour,
                                            voiture.caution,
                                            voiture.modele,
                                            voiture.photo);
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
                                          Expanded(
                                          child:
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
                                                (voiture.prixJour * _prix_session!)
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                            .liste_de_voitures_Disponible,
                                                        ),
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
                                          ),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                          child:
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${nom(voiture.id_marquer)}",
                                                        style:Theme.of(context).textTheme.bodyText2,
                                                        overflow: TextOverflow.ellipsis),
                                                    const SizedBox(width: 10,),
                                                    Image.network(
                                                      logo(voiture.id_marquer),
                                                      width: 50,
                                                      height: 50,
                                                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.jpg",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  voiture.modele,
                                                  overflow: TextOverflow.ellipsis,
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
                                                        voiture.nbSeats.toString()+" "+
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_SEATS,
                                                        style: const TextStyle(
                                                          fontSize: 11,
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
                                                        voiture.nbBags.toString()+" " +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_BAGS,
                                                        style: const TextStyle(
                                                          fontSize: 11,
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
                                                        voiture.nbPorts.toString()+" " +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .liste_de_voitures_PORTES,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(height: 35),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    passage(
                                                            voiture.prixJour,
                                                            voiture.caution,
                                                            voiture.modele,
                                                            voiture.photo);
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
                                            )
                                          ],
                                        ),
                                      ),
                                  )
                            ).toList(),
                          ) :ListView.separated(
                      itemCount: 5,
                      itemBuilder: (context, index) => const NewsCardSkelton(),
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
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
