import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_flutter_stripe/key.dart';

class PaymentService {
  PaymentService._();

  static final PaymentService instance = PaymentService._();

  Future<bool> makePayment({
    required int amount,
    required String currency,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(
        amount: _changeToDollarInstedOfCents(amount),
        currency: currency,
      );
      if (paymentIntent == null) {
        log('Error creating payment intent');
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent,
          merchantDisplayName: 'Bla Bla',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      log('Payment successful');
      return true;
    } catch (e) {
      log('Error making payment: $e');
      return false;
    }
  }

  Future<String?> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount,
        'currency': currency,
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      debugPrint('Create payment intent error: $e');
      return null;
    }
  }

  _changeToDollarInstedOfCents(int amount) {
    return amount * 100;
  }
}
