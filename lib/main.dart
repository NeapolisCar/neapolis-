// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';
import 'package:neapolis_car/Pages/Decorition/standartheme.dart';
import 'package:neapolis_car/Pages/Reservation/ContinueInscription.dart';
import 'package:neapolis_car/Pages/Reservation/DetailTransfer.dart';
import 'package:neapolis_car/Pages/Reservation/DetailVoiture.dart';
import 'package:neapolis_car/Pages/Profile/EditProfile.dart';
import 'package:neapolis_car/Pages/Profile/Historique.dart';
import 'package:neapolis_car/Pages/Reservation/Inscriptions.dart';
import 'package:neapolis_car/Pages/Reservation/Inscriptions2.dart';
import 'package:neapolis_car/Pages/Reservation/ListVoiture.dart';
import 'package:neapolis_car/Pages/Reservation/ListVoitures.dart';
import 'package:neapolis_car/Pages/Reservation/Login2.dart';
import 'package:neapolis_car/Pages/Reservation/Paiment.dart';
import 'package:neapolis_car/Pages/Profile/Param%C3%A8tres.dart';
import 'package:neapolis_car/Pages/Reservation/Remerciements.dart';
import 'package:neapolis_car/Pages/Reservation/Reservation.dart';
import 'package:neapolis_car/Pages/Reservation/ResultReservation.dart';
import 'package:neapolis_car/Pages/Reservation/WebViewPaiment.dart';
import 'package:neapolis_car/Pages/Reservation/login.dart';
import 'package:neapolis_car/Pages/Reservation/ReseultTransfer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neapolis_car/Pages/post.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;
const ip = "https://backend-liard-three.vercel.app";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Myapp());
}
class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
  static void setLocale(BuildContext context , Locale newLocale ){
    _MyappState? state= context.findAncestorStateOfType<_MyappState>();
    state?.setLocale(newLocale);
  }
}

class _MyappState extends State<Myapp> {
  Locale? _locale;
  setLocale(Locale locale){
    setState(() {
      _locale= locale;
    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((local) => setLocale(local));
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themes_App.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      debugShowCheckedModeBanner: false,
      initialRoute: 'reservation',
      routes: {
        'reservation': (context) => Reservation(),
        'listVoiture': (context) => ListVoiture(),
        'detailVoiture': (context) => DetailVoiture(),
        'login': (context) => Login(),
        'LoginTrnasfer': (context) => LoginTrnasfer(),
        'inscriptions': (context) => Inscription(),
        'InscriptionTransfer': (context) => InscriptionTransfer(),
        'ContinueInscription': (context) => ContinueInscription(),
        'Paiment': (context) => Piament(),
        'WebViewPaiment': (context) => WebViewPaiment(),
        'Remerciements': (context) => Remerciements(),
        'ResultReservation': (context) => ResultResrvation(),
        'ResultTransfer': (context) => ResultaTransfer(),
        'DetailTransfer': (context) => DetailTransfer(),
        'listVoitures': (context) => ListVoitures(),
        'ListPost': (context) => ListPost(),
        'Historique': (context) => Historique(),
        'Parametres': (context) => Parametres(),
        'EditeProfil': (context) => EditProfilePage(),
      },
    );
  }
}

