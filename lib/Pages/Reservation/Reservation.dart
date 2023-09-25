// ignore_for_file: use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Reservation/ReservationVoiture.dart';
import 'package:neapolis_car/Pages/Reservation/Transfer.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

class Reservation extends StatefulWidget {
  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final int _selectedIndex = 0;
  int indexPage = 0;
  bool isInternet = false;
  final controller = PageController();

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
    testInternet();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
      child :Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MyAppBar(Title: translation(context).drawer_button),
        ),
        endDrawer: MyDrawer(selectedIndex: _selectedIndex),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      indexPage = 0;
                    });
                    controller.animateToPage(
                      indexPage,
                      duration: Duration(milliseconds: 50),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: indexPage == 0 ? Colors.red : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      translation(context).buttonText1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: indexPage == 0 ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      indexPage = 1;
                    });
                    controller.animateToPage(
                      indexPage,
                      duration: Duration(milliseconds: 50),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        indexPage == 1 ? Colors.red : Colors.white),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      translation(context).buttonText2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: indexPage == 1 ? Colors.black : Colors.black,
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
            flex: 1,
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (int pageIndex) {
                if (pageIndex == 0) {
                  setState(() {
                    indexPage = 0;
                  });
                } else if (pageIndex == 1) {
                  setState(() {
                    indexPage = 1;
                  });
                }
              },
              children: [
                ReservationVoiture(),
                Transfer()
              ],
            ),
            flex: 6,
          ),
        ]),
        bottomNavigationBar:NavBar(selectedIndex: _selectedIndex)
    )
    );

  }
}
