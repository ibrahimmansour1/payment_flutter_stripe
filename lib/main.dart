import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_flutter_stripe/key.dart';
import 'package:payment_flutter_stripe/payment_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final PaymentService _paymentService = PaymentService.instance;
  @override
  void initState() {
    _initializeStripe();
    super.initState();
  }

  _initializeStripe() async {
    Stripe.publishableKey = stripePublicKey;
    await Stripe.instance.applySettings();
  }

  _showPaymentSheet() async {
    await _paymentService.makePayment(amount: 20, currency: 'USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showPaymentSheet,
          child: const Text('Buy Now'),
        ),
      ),
    );
  }
}
