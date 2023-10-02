import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_car/Pages/Compounes/datepicker.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class ReservationVoiture extends StatefulWidget {
  const ReservationVoiture({Key? key}) : super(key: key);

  @override
  State<ReservationVoiture> createState() => _ReservationVoitureState();
}

class _ReservationVoitureState extends State<ReservationVoiture> {
  late String dropdownvalue = "";
  late String dropdownvalue2 = "";
  final List<String> _items = [
    "enfidha",
    "tunisie",
    "hammam_Sousse",
    "hammamet",
    "kelibia",
    "monastir_2",
    "nabeul",
    "rades",
    "sousse",
    "aeroport_enfidha",
    "aeroport_monastir",
  ];

  final List<String> _items2 = [
    "enfidha",
    "tunisie",
    "hammam_Sousse",
    "hammamet",
    "kelibia",
    "monastir",
    "nabeul",
    "rades",
    "sfax",
    "sousse",
    "aeroport_enfidha",
    "aeroport_monastir",
  ];
  late bool value1 = false;
  late double _prix = 0;
  TextEditingController _date_ramasser = TextEditingController();
  TextEditingController _date_revenir = TextEditingController();
  bool isDateTodayOrFuture(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.isAfter(tomorrow) ||
        date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            date.day == tomorrow.day;
  }

  bool isDateMin3DaysAfter(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return difference >= 3;
  }

  void checkDateConstraints(
      TextEditingController dateRamasser, TextEditingController dateRevenir) {
    if (dateRamasser.text == "") {
      Fluttertoast.showToast(
          msg: translation(context).reservation_voiture_message1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (dateRevenir.text == "") {
      Fluttertoast.showToast(
          msg: translation(context).reservation_voiture_message2,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (dropdownvalue == "") {
        Fluttertoast.showToast(
            msg: translation(context).reservation_voiture_message3,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (value1 = false) {
          if (dropdownvalue2 == "") {
            Fluttertoast.showToast(
                msg: translation(context).reservation_voiture_message4,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      } else {
        DateTime dateRamasser = DateTime.parse(_date_ramasser.text);
        DateTime dateRevenir = DateTime.parse(_date_revenir.text);
        bool isRamasserTodayOrFuture = isDateTodayOrFuture(dateRamasser);
        bool isRevenirMin3DaysAfterRamasser =
            isDateMin3DaysAfter(dateRamasser, dateRevenir);
        if (isRamasserTodayOrFuture) {
          if (isRevenirMin3DaysAfterRamasser) {
            final int difference = dateRevenir.difference(dateRamasser).inDays;
            switch (dropdownvalue) {
              case "monastir_2":
                {
                  setState(() {
                    _prix = 30;
                  });
                }
                break;
            }
            Navigator.pushNamed(
              context,
              'listVoiture',
              arguments: {
                'type': "Reservation",
                'dateRamasser': dateRamasser,
                'dateRevenir': dateRevenir,
                'location_de_rammaser': dropdownvalue,
                'location_de_revenir': value1 ? dropdownvalue : dropdownvalue2,
                'days': difference,
                'prix': _prix,
                'index': 0
              },
            );
          } else if (!isRevenirMin3DaysAfterRamasser) {
            Fluttertoast.showToast(
                msg: translation(context).reservation_voiture_message6,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (!isRamasserTodayOrFuture) {
          Fluttertoast.showToast(
              msg: translation(context).reservation_voiture_message7,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButton(
                  hint:
                      Text(translation(context).reservation_Transfer_address1),
                  value: dropdownvalue.isNotEmpty ? dropdownvalue : null,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                  items: _items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.location_pin),
                          Expanded(child: Text(translation(context).list(value),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ), )
                        ],
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                )),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
              title: Text(translation(context).reservation_voiture_choice1),
              value: value1,
              onChanged: (newBool) {
                setState(() {
                  value1 = newBool!;
                });
              }),
          Visibility(
            visible: !value1,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton(
                    hint: Text(
                        translation(context).reservation_Transfer_address1),
                    value: dropdownvalue2.isNotEmpty ? dropdownvalue2 : null,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownvalue2 = newValue!;
                      });
                    },
                    items:
                        _items2.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin),
                            Expanded(child: Text(translation(context).list(value),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ), )
                          ],
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Card(
              margin: const EdgeInsets.all(16),
              child:TextField(
                  controller: _date_ramasser,
                  decoration: InputDecoration(
                    icon:const Padding(
                      padding: EdgeInsets.only(left: 8.0), // Adjust the padding as needed
                      child: Icon(Icons.calendar_today),
                    ),
                    labelText: translation(context).reservation_voiture_daterammser,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {DateTime formattedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                      );
                      setState(() {
                        String formattedDateString =
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(formattedDate);
                        _date_ramasser.text = formattedDateString;
                      });
                      } else {}
                    }
                  }
              )
          ),
          const SizedBox(height: 10),
        Card(
            margin: const EdgeInsets.all(16),
            child:TextField(
                controller: _date_revenir,
                decoration: InputDecoration(
                icon:const Padding(
                    padding: EdgeInsets.only(left: 8.0), // Adjust the padding as needed
                    child: Icon(Icons.calendar_today),
                  ),
                    labelText: translation(context).reservation_voiture_daterevenir,
                ),
                readOnly: true,
                onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {DateTime formattedDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                );
                setState(() {
                String formattedDateString =
                DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(formattedDate);
                _date_revenir.text = formattedDateString;
                });
                } else {}
              }
            }
            )
            ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              checkDateConstraints(_date_ramasser, _date_revenir);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(301, 65),
              backgroundColor: const Color(0xffe61e1e),
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
      ),
    );
  }
}
