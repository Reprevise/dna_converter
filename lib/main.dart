import 'package:dna_converter/ui/screens/main/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DNAConverterApp());

class DNAConverterApp extends StatelessWidget {
  const DNAConverterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "DNA Converter",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
