// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';

import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class DetailTransfer extends StatefulWidget {
  const DetailTransfer({Key? key}) : super(key: key);

  @override
  State<DetailTransfer> createState() => _DetailTransferState();
}

class _DetailTransferState extends State<DetailTransfer> {
   String dropdownvalue = "1";
  String dropdownvalue2 = "1";
  final List<String> _items = ["1", "2", "3", "4"];
  bool value1 = false;
  String _type = "";
  DateTime? _dateRamasser;
  int? _idlisttransfer;
  int? _idlistexurion;
  bool _allez_retour = false;
  double _prixtoul = 0;
  final int _selectedIndex = 0;
  void Conferme() {
    if (_type == "Transfer") {
      Navigator.pushNamed(context, 'listVoitures', arguments: {
        'type': _type,
        'dateRamasser': _dateRamasser,
        'idlisttransfer':_idlisttransfer,
        'allez_retour': _allez_retour,
        'prixTransfer': _prixtoul,
        'SIÈGE BÉBÉ': value1,
        'Nombre de place': dropdownvalue,
        'Nombre de bagages': dropdownvalue2
      });
    } else {
      Navigator.pushNamed(context, 'listVoitures', arguments: {
        'type': _type,
        'dateRamasser': _dateRamasser,
        'idlistexurion':_idlistexurion,
        'prixTransfer': _prixtoul,
        'SIÈGE BÉBÉ': value1,
        'Nombre de place': dropdownvalue,
        'Nombre de bagages': dropdownvalue2
      });
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
    _dateRamasser = arguments['dateRamasser'] as DateTime;
    _prixtoul = arguments['prixTransfer'] as double;
    if (arguments.containsKey('allez_retour')) {
      _allez_retour = arguments['allez_retour'] as bool;
      _type = "Transfer";
      _idlisttransfer= arguments['idlisttransfer'] as int;
    } else {
      _type = "Exurcion";
      _idlistexurion = arguments['idlistexurion'] as int;
    }
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, 'reservation');
      return true;
    },
    child :Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).details_transfer_Title),
      ),
      endDrawer: MyDrawer(selectedIndex: _selectedIndex),
      body: Column(
                    children: [
                  Card(
                    margin: EdgeInsets.all(16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Color(0xfffffcfc),
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              translation(context).details_transfer_text,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          CheckboxListTile(
                            secondary: Image.asset(
                              "assets/images/img_siegeauto1.png",
                              width: 48,
                              height: 33,
                            ),
                            title: Text(translation(context).siege_bebe),
                            value: value1,
                            onChanged: (newBool) {
                              setState(() {
                                value1 = newBool!;
                              });
                            },
                          ),
                          SizedBox(height: 25),
                          Text(translation(context).details_transfer_nbplace),
                          SizedBox(height: 5),
                          Card(
                            margin: const EdgeInsets.all(16),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:  Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: DropdownButton(
                                      hint: Text(translation(context)
                                          .details_transfer_nbplace),
                                      itemHeight: 50,
                                      items: _items.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Text(item),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                      value: dropdownvalue,
                                      isExpanded:
                                          true, // Set isExpanded to true
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 25),
                          Text(translation(context).details_transfer_nbbages),
                          SizedBox(height: 5),
                      Card(
                        margin: const EdgeInsets.all(16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:  Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: DropdownButton(
                                      hint: Text(translation(context)
                                          .details_transfer_nbbages),
                                      itemHeight: 50,
                                      items: _items.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Text(item),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue2 = newValue!;
                                        });
                                      },
                                      value: dropdownvalue2,
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                          ]
                      )
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Conferme();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(301, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      primary: Color(0xffe61e1e),
                    ),
                    child: Text(
                      translation(context).reservation_voiture_button,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        ),
      )
    );
  }
}
