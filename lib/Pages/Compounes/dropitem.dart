// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, no_logic_in_create_state, must_be_immutable, camel_case_types, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class dropitems extends StatefulWidget {
  final ValueChanged<String> onItemSelected;
  IconData icon;
  List<String> items = [];
  EdgeInsets margin = EdgeInsets.zero;
  String text = "";
  bool value =false;
  dropitems({
    required this.items,
    required this.icon,
    required this.margin,
    required this.text,
    required this.onItemSelected,
  });

  @override
  State<dropitems> createState() =>
      _dropitemsState(items: items, icon: icon, margin: margin, text: text);
}

class _dropitemsState extends State<dropitems> {
  List<String> items = [];
  IconData icon;
  EdgeInsets margin = EdgeInsets.zero;
  String text = "";
  _dropitemsState(
      {required this.items,
      required this.icon,
      required this.margin,
      required this.text});
  String itemsselected = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child:
            DropdownButton(
              hint: Text(text),
              value: itemsselected.isNotEmpty ? itemsselected : null,
              onChanged: (newValue) {
                setState(() {
                  itemsselected = newValue!;
                });
                widget.onItemSelected(itemsselected);
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(

                  value: value,
                  child: Row(
                    children: [
                      Icon(icon),
                      Text(translation(context).list(value)),
                    ],
                  ),
                );
              }).toList(),
              isExpanded: true,
            ),
      ),
    );
  }
}
