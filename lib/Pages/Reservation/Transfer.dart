// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neapolis_car/Pages/Classes/Gallery.dart';
import 'package:neapolis_car/Pages/Classes/ListExurcion.dart';
import 'package:neapolis_car/Pages/Classes/ListTransfer.dart';
import 'package:neapolis_car/Pages/Compounes/datepicker.dart';
import 'package:neapolis_car/Pages/Compounes/dropitem.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/main.dart';


// import 'package:translator/translator.dart';
import 'package:intl/intl.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  bool value1 = false;
  bool value2 = false;
  bool _Transfer = false;
  bool _Exurion= false;
  TextEditingController _date_ramasser = TextEditingController();
  String dropdownvalue3 = "";
  String dropdownvalue4 = "";
  String dropdownvalue5 = "";
  ListExurcion? _Exurcion;
  // final translator = GoogleTranslator();
  List<Map<String, dynamic>>? jsonDataList;
  int? idlisttransfer;
  int? idlistexurion;
  List<LisTransfer> _ListTransfer=[];
  List<ListExurcion> _ListExurcion=[];
  List<String> _items3 = [];
  List<String> _items4 = [];
  List<Gallery> gallery =[];
  List<String> images =[];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  final List<String> _items5 = ["transfer", "exurcion"];
  void InsertList(){
    String Addres="";
    for (var  item in _ListTransfer) {
      if (Addres!= item.addressDepart){
        Addres=item.addressDepart;
        setState(() {
          _items3.add(item.addressDepart );
          _items4.add(item.addressDepart );
        });
      }
    }
  }

  Future<void> fatcheLisTransfer()async {
    final response = await http.post(Uri.parse("$ip/polls/AfficherListTransfer"));
    if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    switch (responseData['Reponse']) {
      case "Success":
        {
          final List<dynamic> jsonData = responseData['data'];
          setState(() {
            _ListTransfer = jsonData.map((json) {
              return LisTransfer.fromJson(json);
            }).toList();
          });
          InsertList();
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
  Future<void> fatchListExurcion()async{
    final response = await http.post(Uri.parse("$ip/polls/AfficherListExurcion"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
        final List<dynamic> jsonData = responseData['data'];
        setState(() {
          final listExurcion = jsonData.map((json) {
            return ListExurcion.fromJson(json);
          }).cast<ListExurcion>().toList();
          _ListExurcion = listExurcion;
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
  Future<void> fatchGallery()async{
    final response = await http.post(Uri.parse("$ip/polls/Afficher_Gallery"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      switch (responseData['Reponse']) {
        case "Success":
          {
            final List<dynamic> jsonData = responseData['data'];
            setState(() {
              final gallers = jsonData.map((json) {
                return Gallery.fromJson(json);
              }).cast<Gallery>().toList();
              setState(() {
                gallery= gallers;
              });
              setState(() {
                images = gallery
                    .where((galleryItem) => galleryItem.listExurcion == gallery.first.listExurcion)
                    .map((galleryItem) => galleryItem.photo)
                    .toList();
              });
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
  void changeimage(int id){
    setState(() {
      images = gallery
          .where((galleryItem) => galleryItem.listExurcion == id)
          .map((galleryItem) => galleryItem.photo)
          .toList();
    });
  }
  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.network(urlImage, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.jpg",
        ),
      ),
    );
  }
  bool isDateTodayOrFuture(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.isAfter(tomorrow) ||
        date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            date.day == tomorrow.day;
  }
  void ChangeList(String type){
    if (type == "transfer") {
      setState(() {
        _Transfer = true;
        _Exurion= false;
      });
    } else if (type == "exurcion") {
      setState(() {
        _Transfer = false;
        _Exurion=true;
        _Exurcion= _ListExurcion.first;
      });
    }
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
    if(dropdownvalue3=="")
    {
      if (dropdownvalue4 != "Tunisie" || dropdownvalue4 != "Hammamet") {
        setState(() {
          _items3 = ["Hammamet", "Tunisie"];
        });
      } else {
        setState(() {
          _items3 = [];
        });
        String Addres = "";
        for (var item in _ListTransfer) {
          if (Addres != item.addressDepart) {
            Addres = item.addressDepart;
            setState(() {
              _items3.add(item.addressDepart);
            });
          }
        }
        setState(() {
          _items3 = _items3.where((item) => item != dropdownvalue4).toList();
        });
      }
    }
    else if (dropdownvalue4 != "Tunisie" || dropdownvalue4 != "Hammamet"){
      setState(() {
        _items3 = ["Hammamet", "Tunisie"];
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
        print(Transfer);
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
    fatchGallery();
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
            ChangeList(dropdownvalue5);
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
                      hint: Text(translation(context).reservation_Transfer_address2),
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
          ]
          ),
        ),
        Visibility(
          visible: _Exurion,
          child:Column(
            children: [
              Card(
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
                      changeimage(newValue!.id);
                    },
                    items: _ListExurcion.map<DropdownMenuItem<ListExurcion>>((ListExurcion value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin),
                            Expanded(child:Text(value.addressDepart,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ), )
                          ],
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(16),
                child:Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              print(currentIndex);
                            },
                            child: CarouselSlider(
                              items: images
                                  .map(
                                    (item) => Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                                  .toList(),
                              carouselController: carouselController,
                              options: CarouselOptions(
                                scrollPhysics: const BouncingScrollPhysics(),
                                autoPlay: true,
                                aspectRatio: 2,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () => carouselController.animateToPage(entry.key),
                                  child: Container(
                                    width: currentIndex == entry.key ? 17 : 7,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3.0,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: currentIndex == entry.key
                                            ? Colors.red
                                            : Colors.teal),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ]),),
            ],
          )

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
