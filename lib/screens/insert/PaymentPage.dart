import 'package:flutter/material.dart';

import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class Payment extends StatelessWidget {
  List paymentInfo;
  Payment({Key key, @required this.paymentInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text('잠시만 기다려 주세요 ....', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
      userCode: 'imp66647766',
      data: PaymentData.fromJson({
        'pg':'kakaotalk',
        'payMethod':'card',
        'name':paymentInfo[3],
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
        'amount':paymentInfo[5],
        'buyerName':'${paymentInfo[0]}',
        'buyerTel':paymentInfo[1],
        'buyerEmail':paymentInfo[2],
        'buyerAddr':'서울시 강남구 신사동 661-16',
        'buyerPostcode':'06018',
        'appScheme':'example',
        'display': {
          'cardQuota':[2,3]
        },
        'custom_data':'123'
      }),
      callback: (Map<String, String> result){
        Navigator.pop(context);
      },
    );
  }
}
