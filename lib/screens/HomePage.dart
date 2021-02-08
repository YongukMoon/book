import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'insert/SearchPage.dart';
import 'insert/WebViewPage.dart';
import 'insert/BookPage.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  final User user;
  var books;

  HomePage({Key key, this.user, this.books}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;
  int _numberOfTabs;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String numberWithComma(int param) {
    return NumberFormat('###,###,###,###').format(param).replaceAll('', '');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _numberOfTabs = 3;
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  final nameHolder = TextEditingController();
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    Widget homeTab = SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 210,
            child: Swiper(
              autoplay: true,
              pagination: SwiperPagination(),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Image(
                    image: AssetImage('assets/images/we_make_book1.png'),
                  ),
                  onTap: () {
                    //
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ink('공지 사항', Icons.search, 'https://naver.com'),
                ink('전체 게시판', Icons.text_fields, 'https://naver.com'),
                ink('활동 계획 게시판', Icons.share, 'https://naver.com'),
                ink('Q&A 게시판', Icons.question_answer, 'https://naver.com'),
                ink('도서 추천 게시판', Icons.book, 'https://naver.com'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    '추천하는 온오프믹스 모임',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    color: Color(0xFF105AA1),
                    height: 2.5,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  metting(
                      context,
                      '데브옵스를 위한 쿠버네티스',
                      '보안프로젝트',
                      true,
                      'assets/images/we_make_book1.png',
                      'https://www.naver.com',
                      57,
                      false),
                  metting(
                      context,
                      'IT인을 위한 LEK 통합로그시스템 구축과 활용',
                      '보안프로젝트',
                      false,
                      'assets/images/we_make_book2.jpg',
                      'https://www.naver.com',
                      100,
                      true)
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget booksTab = Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '인기 작품들 ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Picks 추천 [sample] ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: widget.books.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var book = widget.books.docs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookPage(
                            user: widget.user,
                            book_data: widget.books,
                            number: index)),
                  );
                },
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: 140,
                    height: 140,
                    child: Row(
                      children: [
                        Image.network(book['img_url']),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book['name'],
                                style: TextStyle(fontSize: 15),
                              ),
                              Spacer(),
                              Text(book['author'],
                                  style: TextStyle(color: Colors.grey)),
                              Text(book['publisher']),
                              Text('${numberWithComma(book['value'])}원',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: slidePage(),
        key: _scaffoldKey,
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Column(
                    children: [
                      appBarAbove(),
                      appBarBelow(),
                    ],
                  ),
                ),
                leading: Container(),
                expandedHeight: 140,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.blueAccent,
                  indicatorWeight: 6,
                  tabs: [
                    Tab(text: "Home"),
                    Tab(text: "인기 도서 목록"),
                    Tab(text: "추천 강의 영상"),
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              homeTab,
              booksTab,
              lectureTab(),
              // Container(color: Colors.green),
            ],
          ),
        ));
  }

  Widget appBarAbove() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, right: 4.5, left: 4.5),
      child: Container(
        height: 36,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, size: 28, color: Colors.blueAccent),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 8),
                width: 100,
                child: Image(
                  image: AssetImage('assets/images/bp.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget appBarBelow() {
    return Padding(
      padding: EdgeInsets.only(top: 0, right: 17, left: 17),
      child: TextField(
        controller: nameHolder,
        autocorrect: true,
        onChanged: (text) {
          _keyword = text;
        },
        decoration: InputDecoration(
          suffixIcon: Container(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _keyword = nameHolder.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchPage(_keyword, widget.books)));
                    nameHolder.clear();
                  },
                )
              ],
            ),
          ),
          hintText: '무조건 돈이 되는 공부를 하라',
          hintStyle: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget slidePage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text('보안프로젝트'),
                    Spacer(),
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.power_settings_new),
                      onPressed: () async {
                        //
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              child: Center(
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(widget.user.photoURL))),
                  ),
                  title: Text(widget.user.displayName),
                  subtitle: Text(widget.user.email),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    color: Color(0xFFF2F2F2),
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '인프런/강의 추천',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                  ),
                  ListTile(
                    title: Text('IT인을 위한 LEK 통합로그시스템 구축과 활용'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                  title: 'IT인을 위한 LEK 통합로그시스템 구축과 활용',
                                  baseUrl: 'https://naver.com',
                                )),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('IOS 모바일 앱 모의 해킹(입문자)'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      //
                    },
                  ),
                  ListTile(
                    title: Text('플러터(Flutter) 앱 개발 입문부터 프로젝트 완성까지'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      //
                    },
                  ),
                  RaisedButton(
                    child: Text('강의 목록 바로 가기'),
                    color: Colors.white,
                    onPressed: () {
                      //
                    },
                  ),
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text('Settings'),
                            ),
                            ListTile(
                              leading: Icon(Icons.help),
                              title: Text('Developer Blog'),
                              onTap: () {
                                //
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ink(String title, IconData icon, String url) {
    return InkWell(
      child: Column(
        children: [
          Icon(icon, size: 50),
          Text(title, style: TextStyle(fontSize: 12))
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                      title: title,
                      baseUrl: url,
                    )));
      },
    );
  }

  Widget metting(
      BuildContext context,
      String title,
      String organizer,
      bool status,
      String imageUrl,
      String siteUrl,
      int percent,
      bool participation) {
    double percnetBar = 166 * percent / 100;
    return Container(
      height: 210,
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //
            },
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Image(
                  width: 170,
                  height: 80,
                  image: AssetImage(imageUrl),
                ),
                Container(
                  height: 30,
                  width: 80,
                  color: Color(0xFF646464),
                  child: Center(
                    child: status
                        ? Text(
                            '모집 중',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text('모집 종료',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black), text: title),
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(height: 10, width: percnetBar, color: Colors.blue),
              Container(
                  height: 10, width: 166 - percnetBar, color: Colors.grey),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                status ? Text('투표 중') : Text('투표 종료'),
                Spacer(),
                Text('$percent% '),
                participation ? Text('참여') : Text('미참여')
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List> gets() async {
    String url = 'https://www.googleapis.com/youtube/v3/search?';
    String query = 'q=보안프로젝트';
    String key = env['GOOGLE_YOUTUBE_KEY'];
    String part = 'snippet';
    String maxResults = '7';
    String type = 'video';

    List jsonData = [];

    url = '$url$query&key=$key&part=$part&maxResults=$maxResults&type=$type';

    // await http.get(
    //   url,
    //   headers: {"Accept": "application/json"},
    // ).then((value) {
    //   var data = json.decode(value.body);
    //   for (var c in data['items']) {
    //     jsonData.add(c);
    //   }
    // });

    return jsonData;
  }

  FutureBuilder lectureTab() {
    return FutureBuilder(
      future: gets(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                            text: '인기 강의들 ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'picks 추천 [sample]',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 90,
                          child: Row(
                            children: [
                              Container(
                                  width: 150,
                                  child: Image.network(snapshot.data[index]
                                          ['snippet']['thumbnails']['medium']
                                      ['url'])),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index]['snippet']['title'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Text(
                                      snapshot.data[index]['snippet']
                                          ['channelTitle'],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data[index]['snippet']
                                          ['publishTime'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }
      },
    );
  }
}
