import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'info_screen.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/class.dart';
import 'account_screen.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scontroller = ScrollController();

  List<Widget> imageSliders = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();

  bool? loading;

  int pageId = 1;

  getNews(int page) async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      var response = await dio.get("https://www.nginx.com/wp-json/wp/v2/posts?page=$page");
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

  Widget loadNews() {
    return Wrap(
      children: news.map((e) {
        return news.indexOf(e) > 10 ? InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return InfoScreen(info: e);
            }));
          },
          child: Container(
            width: 180,
            height: 220,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: e["yoast_head_json"]["twitter_image"] != null ?
                    Hero(
                      tag: "image ${news.indexOf(e)}",
                      child: Image.network(
                        e["yoast_head_json"]["twitter_image"],
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
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ) : SizedBox();
      }).toList(),
    );
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
            child: e["yoast_head_json"]["twitter_image"] != null ?
                        Hero(
                          tag: "image ${news.indexOf(e)}",
                          child: Image.network(
                            e["yoast_head_json"]["twitter_image"],
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
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
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
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
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
        getNews(pageId + 1);
        // loadNews();
        print("geldi");
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
    getNews(pageId + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haberler"),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.blueGrey[400],
                child: Icon(Icons.account_circle_outlined, size: 50),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.white, endIndent: 20, indent: 20, thickness: 2),
              Text(
                widget.user.name ?? "No name!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Divider(color: Colors.white, endIndent: 20, indent: 20, thickness: 2),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AccountPage(user: widget.user);
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.account_circle_outlined, size: 32, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.message_outlined, size: 32, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.blueGrey,
                            content: Text("Çıkış yapılsın mı?", textAlign: TextAlign.center),
                            contentTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                child: Text("Vazgeç"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blueGrey,
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  try {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.clear();
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return LoginPage(); 
                                    }));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Çıkış yapılırken bir hata oluştu!")));
                                  }
                                }, 
                                child: Text("Çıkış Yap"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.logout_outlined, size: 32, color: Colors.white),
                    ),
                  ),
                ],
              )
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     padding: EdgeInsets.all(10),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.white, width: 2),
              //       // borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Text(
              //       "Anasayfa",
              //       textAlign: TextAlign.center,
              //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           color: Colors.white,
              //         ),
              //       ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     padding: EdgeInsets.all(10),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.white, width: 2),
              //       // borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Text(
              //       "Hesabım",
              //       textAlign: TextAlign.center,
              //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           color: Colors.white,
              //         ),
              //       ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     padding: EdgeInsets.all(10),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.white, width: 2),
              //       // borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Text(
              //       "Çıkış Yap",
              //       textAlign: TextAlign.center,
              //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           color: Colors.white,
              //         ),
              //       ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scontroller,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              loadSlider(),
              SizedBox(height: 10),
              loadNews(),
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