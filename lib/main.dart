import 'package:dna_converter/ui/screens/main/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(DNAConverterApp());

class DNAConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DNA Converter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MainPage(),
    );
  }
}
