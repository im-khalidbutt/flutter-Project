import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final int index;
  const DetailsPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
      ),
      body: Center(
        child: Text('The Details page #$index'),
      ),
    );
  }
}
