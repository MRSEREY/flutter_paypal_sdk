import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congrats'),
      ),
      body: const Center(
        child: Text('Payment Success'),
      ),
    );
  }
}
