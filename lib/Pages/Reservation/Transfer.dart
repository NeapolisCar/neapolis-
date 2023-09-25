// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neapolis_car/Pages/Classes/ListExurcion.dart';
import 'package:neapolis_car/Pages/Classes/ListTransfer.dart';
import 'package:neapolis_car/Pages/Compounes/datepicker.dart';
import 'package:neapolis_car/Pages/Compounes/dropitem.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  bool value1 = false;
  bool value2 = false;
  bool _Transfer = false;
  TextEditingController _date_ramasser = TextEditingController();
  String dropdownvalue3 = "";
  String dropdownvalue4 = "";
  String dropdownvalue5 = "";
  ListExurcion? _Exurcion;
  List<Map<String, dynamic>>? jsonDataList;
  int? idlisttransfer;
  int? idlistexurion;
  List<LisTransfer> _ListTransfer=[];
  List<ListExurcion> _ListExurcion=[];
  List<String> _items3 = [];
  List<String> _items4 = [];
  final List<String> _items5 = ["transfer", "exurcion"];
  void InsertList(){
    String Addres="";
    for (var  item in _ListTransfer) {
      if (Addres!= item.addressDepart){
        Addres=item.addressDepart;
        setState(() {
          _items3.add(item.addressDepart);
          _items4.add(item.addressDepart);
        });
      }
    }
  }
  Future<void> fatcheLisTransfer()async{
    final response = await http.post(Uri.parse("$ip/polls/AfficherListTransfer"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _ListTransfer = jsonData.map((json) {
          return LisTransfer.fromJson(json);
        }).toList();
      });

      InsertList();
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
  Future<void> fatchListExurcion()async{
    final response = await http.post(Uri.parse("$ip/polls/AfficherListExurcion"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        final listExurcion = jsonData.map((json) {
          return ListExurcion.fromJson(json);
        }).cast<ListExurcion>().toList();
        setState(() {
          _ListExurcion= listExurcion;
        });
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
      throw Exception('Failed to load data from the API');
    }
  }
  bool isDateTodayOrFuture(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.isAfter(tomorrow) ||
        date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            date.day == tomorrow.day;
  }
  void ChangeList1() {
    if( dropdownvalue3 != "Tunisie" &&  dropdownvalue3!="Hammamet")
      {
        setState(() {
          _items4 = ["Hammamet", "Tunisie"];
        });
  }  else{
      setState(() {
        _items4=[];
      });
      String Addres="";
      for (var  item in _ListTransfer) {
        if (Addres!= item.addressDepart){
          Addres=item.addressDepart;
          setState(() {
            _items4.add(item.addressDepart);
          });
        }
      }
        setState(() {
         _items4= _items4.where((item) => item !=dropdownvalue3 ).toList();
        });
    }
  }
  void ChangeList2() {
    if( dropdownvalue4 != "Tunisie" || dropdownvalue4!="Hammamet")
    {
      setState(() {
        _items3 = ["Hammamet", "Tunisie"];
      });
    }  else{
      setState(() {
        _items3=[];
      });
      String Addres="";
      for (var  item in _ListTransfer) {
        if (Addres!= item.addressDepart){
          Addres=item.addressDepart;
          setState(() {
            _items3.add(item.addressDepart);
          });
        }
      }
      setState(() {
        _items3= _items3.where((item) => item !=dropdownvalue4 ).toList();
      });
    }
  }
  void checkDateConstraints2(TextEditingController _date_ramasser) {
    if (_date_ramasser.text == "") {
      Fluttertoast.showToast(
          msg: translation(context).reservation_Transfer_message1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      DateTime dateRamasser = DateTime.parse(_date_ramasser.text);
      bool isRamasserTodayOrFuture = isDateTodayOrFuture(dateRamasser);
      if (!isRamasserTodayOrFuture) {
        Fluttertoast.showToast(
            msg: translation(context).reservation_Transfer_message2,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        final Transfers = _ListTransfer.where((transfer) {
          return transfer.addressDepart == dropdownvalue3 && transfer.addressFin == dropdownvalue4;
        }).first;
        Navigator.pushNamed(context, 'DetailTransfer', arguments: {
          'type': "Transfer",
          'dateRamasser': dateRamasser,
          'idlisttransfer':Transfers.id,
          'allez_retour': value2,
          'prixTransfer': Transfers.prix
        });
      }
    }
  }
  void checkDateConstraints3(TextEditingController _date_ramasser) {
    DateTime dateRamasser = DateTime.parse(_date_ramasser.text);
    bool isRamasserTodayOrFuture = isDateTodayOrFuture(dateRamasser);
    if (!isRamasserTodayOrFuture) {
      Fluttertoast.showToast(
          msg: translation(context).reservation_Transfer_message2,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Navigator.pushNamed(context, 'DetailTransfer', arguments: {
        'type': "Exurcion",
        'dateRamasser': dateRamasser,
        'idlistexurion': _Exurcion!.id,
        'prixTransfer': _Exurcion!.prix
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fatcheLisTransfer();
    fatchListExurcion();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        dropitems(
          items: _items5,
          icon: Icons.car_crash_outlined,
          margin: const EdgeInsets.all(16),
          text: translation(context).reservation_Transfer_type,
          onItemSelected: (selectedValue) {
            dropdownvalue5 = selectedValue;
            if (selectedValue == "transfer") {
              setState(() {
                _Transfer = true;
              });
            } else if (selectedValue == "exurcion") {
              setState(() {
                _Transfer = false;
              });
            }
          },
        ),
        Visibility(
          visible: _Transfer,
          child: Column(
              children: [
              Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child:
                DropdownButton(
                  hint: Text(translation(context).reservation_Transfer_address1),
                  value: dropdownvalue3.isNotEmpty ? dropdownvalue3 : null,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownvalue3 = newValue!;
                    });
                    ChangeList1();
                  },
                  items: _items3.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.location_pin),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                )
              ),
              ),
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child:
                    DropdownButton(
                      hint: Text(translation(context).reservation_Transfer_address1),
                      value: dropdownvalue4.isNotEmpty ? dropdownvalue4 : null,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue4 = newValue!;
                        });
                        ChangeList2();
                      },
                      items: _items4.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Row(
                            children: [
                              const Icon(Icons.location_pin),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                    ),
                  ),
                ),
            const SizedBox(height: 10),
            CheckboxListTile(
                title: Text(translation(context).reservation_Transfer_value1),
                value: value2,
                onChanged: (newBool) {
                  setState(() {
                    value2 = newBool!;
                  });
                }),
          ]),
        ),
        Visibility(
          visible: !_Transfer,
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton<ListExurcion>(
            hint: Text(translation(context).reservation_Transfer_address1),
            value: _Exurcion,
            onChanged: (newValue) {
              setState(() {
                _Exurcion= newValue;
              });
            },
            items: _ListExurcion.map<DropdownMenuItem<ListExurcion>>((ListExurcion value) {
              return DropdownMenuItem(
                value: value,
                child: Row(
                  children: [
                    const Icon(Icons.location_pin),
                    Text(value.addressDepart),
                  ],
                ),
              );
            }).toList(),
            isExpanded: true,
          ),
            ),
          ),
        ),
        datepicker(
          date: _date_ramasser,
          margin: const EdgeInsets.all(16),
          text: translation(context).reservation_Transfer_date1,
          onDateSelected: (selectedDate) {
            _date_ramasser = selectedDate as TextEditingController;
          },
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () {
            if (_Transfer) {
              checkDateConstraints2(_date_ramasser);
            } else {
              checkDateConstraints3(_date_ramasser);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(301, 65), backgroundColor: const Color(0xffe61e1e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            translation(context).reservation_voiture_button,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ));
  }
}
