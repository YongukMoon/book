import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'PaymentPage.dart';

class BookPage extends StatelessWidget {
  List Payment_data;
  var book_data;
  int number;

  User user;

  BookPage({Key key, @required this.user, this.number, this.book_data}) : super(key: key);

  String numberWithComma(int param) {
    return NumberFormat('###,###,###,###').format(param).replaceAll('', '');
  }

  @override
  Widget build(BuildContext context) {

    var data = book_data.docs[number];

    return Scaffold(
      appBar: AppBar(title: Text('도서')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text(data['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          Text('컴퓨터 > IT 개발 > 프로그래밍'),
          Text('저자: ${data['author']} | 판매처: ${data['publisher']}'),
          Text('판매가: ${numberWithComma(data['value'])}', style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
          Container(
            height: 400,
            child: Image.network(data['img_url']),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width/3,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                //
              },
              child: Row(
                children: [
                  Icon(Icons.info),
                  Text('상세정보'),
                ],
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width/3,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List paymentData = [];

                paymentData.add(user.displayName);
                paymentData.add(user.phoneNumber);
                paymentData.add(user.email);
                paymentData.add(data['name']);
                paymentData.add(data['isbn']);
                paymentData.add(data['value']);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Payment(paymentInfo:paymentData))
                );
              },
              child: Row(
                children: [
                  Icon(Icons.shopping_cart),
                  Text('바로 구매')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
