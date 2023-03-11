import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage(data, {Key? key}) : super(key: key);

  String? get response => data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [Text(data!)],
          ),
        ));
  }
}
