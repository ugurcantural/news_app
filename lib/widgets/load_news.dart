import 'package:flutter/material.dart';

import '../screens/info_screen.dart';
import '../utils/class.dart';

class loadNews extends StatelessWidget {
  const loadNews({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: news.map((e) {
        return news.indexOf(e) >= 10 ? InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return InfoScreen(info: e);
            }));
          },
          child: Container(
            width: 180,
            height: 180,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16/9,
                      child: e["jetpack_featured_media_url"] != null ?
                      Hero(
                        tag: "image ${news.indexOf(e)}",
                        child: Image.network(
                          e["jetpack_featured_media_url"],
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            else {
                              return Center(child: LinearProgressIndicator());
                            }
                          },
                        ),
                      ) :
                      Hero(
                        tag: "network ${news.indexOf(e)}",
                        child: Image.asset("assets/images/news_image.jpg", fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    e["yoast_head_json"]["title"],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ) : SizedBox();
      }).toList(),
    );
  }
}