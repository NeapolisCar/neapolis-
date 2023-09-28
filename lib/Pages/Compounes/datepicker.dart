// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class datepicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  TextEditingController date = TextEditingController();
  EdgeInsets margin =EdgeInsets.zero;
  String text ="";
  datepicker({super.key, 
    required this.date,
    required this.margin,
    required this.text,
    required this.onDateSelected,
});

  @override
  State<datepicker> createState() => _datepickerState(date: date ,margin: margin , text: text);
}

class _datepickerState extends State<datepicker> {
  TextEditingController date = TextEditingController();
  EdgeInsets margin =EdgeInsets.zero;
  String text ="";
  _datepickerState({
    required this.date,
    required this.margin,
    required this.text
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      
      child:TextField(
          controller: date,
          decoration: InputDecoration(
            icon:const Padding(
              padding: EdgeInsets.only(left: 8.0), // Adjust the padding as needed
              child: Icon(Icons.calendar_today),
            ),
            labelText: text,
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
                date.text = formattedDateString;
              });
              } else {}
            }
          }
      )
    );
  }
}
