import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/error_screen.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/load_news.dart';
import 'info_screen.dart';
import '../utils/class.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scontroller = ScrollController();

  int _current = 0;

  List<Widget> imageSliders = [];
  final CarouselController _controller = CarouselController();

  bool? loading;

  int pageId = 1;

  getNews(int page) async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      var response = await dio.get("https://listelist.com/wp-json/wp/v2/posts?page=$page");
      if (page == 1) {
        news = response.data;
        setState(() {
          pageId += 1;
        });
        getNews(pageId);
      }
      else {
        news += response.data;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Api isteğinde hata oluştu")));
    }
    setState(() {
      loading = false;
    });
  }

  Widget loadSlider() {
    if (news.length <= 10) {
      imageSliders = news.map((e) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return InfoScreen(info: e); 
            }));
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ["jetpack_featured_media_url"] != null ?
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
        );
      }).toList();
    }
    return Column(
      children: [
        CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                  height: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height / 2 : MediaQuery.of(context).size.height / 4,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSliders.asMap().entries.map((entry) {
            return InkWell(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _scrollListener() {
    if (_scontroller.offset >= _scontroller.position.maxScrollExtent &&
        !_scontroller.position.outOfRange) {
      setState(() {
        pageId += 1;
        getNews(pageId);
      });
    }
    // if (_controller.offset <= _controller.position.minScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   setState(() {
    //     message = "reach the top";
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _scontroller.addListener(_scrollListener);
    getNews(pageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListeList"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ErrorPage(); 
              }));
            },
            icon: Icon(Icons.favorite_outlined),
          ),
        ],
      ),
      drawer: drawerWidget(widget: widget),
      body: SingleChildScrollView(
        controller: _scontroller,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              loadSlider(),
              SizedBox(height: 10),
              loadNews(context: context),
              SizedBox(height: 10),
              loading! ? CircularProgressIndicator() : SizedBox(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}