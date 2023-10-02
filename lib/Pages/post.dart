import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/post.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

import 'package:neapolis_car/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPost extends StatefulWidget {
  const ListPost({Key? key}) : super(key: key);

  @override
  State<ListPost> createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
  List<Post> _Posts = [];
  late final int _selectedIndex = 1;
  late String id = '';
  Future<void> fetchPost() async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Post'),
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
            _Posts = jsonData.map((json) {
              return Post.fromJson(json);
            }).toList();
          });
    }  break;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(Title: translation(context).post_title),
      ),
      endDrawer: MyDrawer(selectedIndex: _selectedIndex),
      body: _Posts != null
          ? ListView(
        padding: EdgeInsets.all(16),
              children: _Posts.map((post) => Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        post.photo,
                        // width: 152,
                        // height: 99,
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.jpg",
                      ),
                      ),
                      ExpansionTile(
                        childrenPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: Text(translation(context).post_type + post.type),
                        children: [
                          Text(post.descriptions),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(translation(context).post_date_depart +
                              post.date_depart.toString()),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(translation(context).post_date_fin +
                              post.date_fin.toString()),
                          Column(
                            children: [
                              TextButton.icon(
                                icon: FaIcon(
                                  FontAwesomeIcons.tiktok,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                label: Text(''),
                                onPressed: ()async {
                                  if (await canLaunch(post.lien)) {
                                    await launch(post.lien);
                                  } else {
                                    throw 'Could not launch ${post.lien}';
                                  }
                                }
                              ),
                              Text(translation(context).tikTok,
                              style: TextStyle(fontSize: 12),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))).toList(),
            )
          : const CircularProgressIndicator(),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
