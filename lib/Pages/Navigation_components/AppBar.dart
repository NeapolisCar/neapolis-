// ignore_for_file: file_names, non_constant_identifier_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  final String Title;
  const MyAppBar({required this.Title});

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[500],
        elevation: 0, // Remove the elevation/shadow
        // toolbarHeight: 220,
        leading: Positioned(
          top: 0,
          left: 20,
          child: Image.asset("assets/images/logo-neapolisV444.png",
            width: 100,
            height: 200,
          ),
        ),
        title: Text(widget.Title),

        bottom: PreferredSize(
          preferredSize:
          Size.fromHeight(1.0), // Set the height of the bottom line
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Set your desired color here
                  width: 1.0, // Set the width of the bottom line
                ),
              ),
            ),
          ),
        ),
    );
  }
}
