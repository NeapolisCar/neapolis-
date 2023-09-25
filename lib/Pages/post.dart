import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neapolis_car/Pages/Classes/post.dart';
import 'package:neapolis_car/Pages/Navigation_components/MyDrawer.dart';
import 'package:neapolis_car/Pages/Navigation_components/NavBar.dart';
import 'package:neapolis_car/Pages/Navigation_components/AppBar.dart';
import 'package:neapolis_car/Pages/Classes/language_constants.dart';

import 'package:neapolis_car/main.dart';

class ListPost extends StatefulWidget {
  const ListPost({Key? key}) : super(key: key);

  @override
  State<ListPost> createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
  List<Post> _Posts = [];
  late int _selectedIndex = 1;
  late String id = '';
  Future<void> fetchPost() async {
    final response = await http.post(
      Uri.parse('$ip/polls/Afficher_Post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _Posts = jsonData.map((json) {
          return Post.fromJson(json);
        }).toList();
      });
    } else {
      throw Exception('Failed to load Post');
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
              children: _Posts.map((post) => Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        post.photo,
                        // width: 152,
                        // height: 99,
                      ),
                      ExpansionTile(
                        childrenPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: Text(translation(context).post_type + post.type),
                        children: [
                          Text(post.descriptions),
                          SizedBox(
                            height: 10,
                          ),
                          Text(translation(context).post_date_depart +
                              post.date_depart.toString()),
                          SizedBox(
                            height: 10,
                          ),
                          Text(translation(context).post_date_fin +
                              post.date_fin.toString()),
                        ],
                      ),
                    ],
                  ))).toList(),
            )
          : CircularProgressIndicator(),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
