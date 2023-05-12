import 'package:flutter/material.dart';

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
      ),
      body: Column(
        children: [
          widget.info["yoast_head_json"]["twitter_image"] != null ?
          Hero(
            tag: "image ${news.indexOf(widget.info)}",
            child: Image.network(widget.info["yoast_head_json"]["twitter_image"], fit: BoxFit.fill),
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
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.info["yoast_head_json"]["author"],
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.blueGrey,
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.info["yoast_head_json"]["description"],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}