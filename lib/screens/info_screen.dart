import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/class.dart';

class InfoScreen extends StatefulWidget {
  final info;
  const InfoScreen({super.key, required this.info});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info["yoast_head_json"]["title"]),
        actions: [
          IconButton(
            onPressed: () async {
              if (favoritedList.contains(widget.info["yoast_head_json"]["title"])) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Zaten listenizde kayıtlı")));
                favoritedList.remove(widget.info["yoast_head_json"]["title"]);
                favoritedList.remove(widget.info["content"]["rendered"]);
              }
              else {
                favoritedList.add(widget.info["yoast_head_json"]["title"]);
                favoritedList.add(widget.info["content"]["rendered"]);
              }
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String encodedList = json.encode(favoritedList);
              prefs.setString('myList', encodedList);
              String? savedList = prefs.getString('myList');
              if (savedList != null) {
                favoritedList = json.decode(savedList).cast<String>();
              }
              setState(() {});
            },
            icon: favoritedList.contains(widget.info["yoast_head_json"]["title"]) ? Icon(Icons.favorite_outlined) : Icon(Icons.favorite_outline_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.info["jetpack_featured_media_url"] != null ?
                    Hero(
                      tag: "image ${news.indexOf(widget.info)}",
                      child: Image.network(widget.info["jetpack_featured_media_url"], fit: BoxFit.fill),
                    ) : 
                    Hero(
                      tag: "network ${news.indexOf(widget.info)}",
                      child: Image.asset("assets/images/news_image.jpg", fit: BoxFit.fill)
                    ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.info["date"].toString().replaceAll("T", " "),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.info["yoast_head_json"]["author"],
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  HtmlWidget(
                    widget.info["content"]["rendered"],
                    onTapUrl: (p0) {
                      print(p0);
                      return true;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}