import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum DropdownOptions { dna, mRNA, tRNA }

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _dnaField = TextEditingController(text: "");
  final List<String> _stopCodes = ['UAA', 'UAG', 'UGA'];
  final _maxAttempts = 3;
  // DropdownOptions _selectedOption = DropdownOptions.dna;
  String _displayMRNA = "";
  String _mRNA = "";
  String _codons = "";
  String _antiCodons = "";
  bool _hasStartCode = false;
  bool _hasStopCode = false;

  @override
  void dispose() {
    _dnaField.dispose();
    super.dispose();
  }

  _clearText() {
    if (_dnaField.text.isNotEmpty) {
      setState(() {
        _dnaField.text = "";
      });
    }
  }

  // String _optionsToString(DropdownOptions option) {
  //   switch (option) {
  //     case DropdownOptions.dna:
  //       return "DNA";
  //     case DropdownOptions.mRNA:
  //       return "mRNA";
  //     case DropdownOptions.tRNA:
  //       return "tRNA";
  //   }
  // }

  void _calculateResult() {
    if (_dnaField.text.isEmpty) return;
    _calculateMRNA();
    _getCodons();
    _calculateAntiCodons();
    setState(() {});
    // switch (_selectedOption) {
    //   case DropdownOptions.dna:
    //     _calculateMRNA();
    //     _getCodons();
    //     _calculateAntiCodons();
    //     setState(() {});
    //     break;
    //   default:
    // }
  }

  void _calculateMRNA() {
    String dna = _dnaField.text.toUpperCase();
    String mRNA = "";
    for (int i = 0; i < dna.length; i++) {
      String character = dna[i];
      if (character == "G") {
        mRNA += "C";
      } else if (character == "T") {
        mRNA += "A";
      } else if (character == "A") {
        mRNA += "U";
      } else if (character == "C") {
        mRNA += "G";
      }
    }
    final RegExp exp = RegExp(r".{1,3}");
    Iterable<Match> matches = exp.allMatches(mRNA);
    String spacedMRNA = "";
    for (Match match in matches) {
      spacedMRNA += "${match.group(0)} ";
    }
    _displayMRNA = spacedMRNA;
    _mRNA = mRNA;
  }

  bool _startsWithMethionine(String value) {
    if (value.startsWith("AUG")) return true;
    return false;
  }

  bool _endsWithAStopAcid(String value) {
    for (String stopCode in _stopCodes) {
      if (value.endsWith(stopCode)) return true;
    }
    return false;
  }

  void _getCodons() {
    print(_mRNA);
    String editedRNA = _mRNA;
    if (_hasStartCode) {
      if (!_startsWithMethionine(editedRNA)) {
        int attempts = 0;
        do {
          if (attempts >= _maxAttempts) break;
          editedRNA = editedRNA.substring(1);
          attempts++;
        } while (!_startsWithMethionine(editedRNA));
      }
    }
    if (_hasStopCode) {
      if (!_endsWithAStopAcid(editedRNA)) {
        int attempts = 0;
        do {
          if (attempts >= _maxAttempts) break;
          editedRNA = editedRNA.substring(0, editedRNA.length - 1);
          attempts++;
        } while (!_endsWithAStopAcid(editedRNA));
      }
    }
    final RegExp exp = RegExp(r".{1,3}");
    Iterable<Match> matches = exp.allMatches(editedRNA);
    String codons = "";
    for (Match match in matches) {
      codons += "${match.group(0)}-";
    }
    if (codons.endsWith("-")) {
      codons = codons.substring(0, codons.length - 1);
    }
    _codons = codons;
  }

  void _calculateAntiCodons() {
    String antiCodons = "";
    for (int i = 0; i < _codons.length; i++) {
      String character = _codons[i];
      switch (character) {
        case "G":
          antiCodons += "C";
          break;
        case "U":
          antiCodons += "A";
          break;
        case "A":
          antiCodons += "U";
          break;
        case "C":
          antiCodons += "G";
          break;
        case "-":
          antiCodons += "-";
          break;
      }
      // if (character == "G") {
      //   antiCodons += "C";
      // } else if (character == "U") {
      //   antiCodons += "A";
      // } else if (character == "A") {
      //   antiCodons += "U";
      // } else if (character == "C") {
      //   antiCodons += "G";
      // } else if (character == "-") {
      //   antiCodons += "-";
      // }
    }
    _antiCodons = antiCodons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        title: Text(
          "DNA Converter",
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        children: <Widget>[
          TextFormField(
            controller: _dnaField,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Sequence",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _clearText(),
                alignment: const Alignment(0.0, 0.0),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
            enableSuggestions: false,
            inputFormatters: [UpperCaseTextFormatter()],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) => _calculateResult(),
          ),
          const SizedBox(height: 10),
          // Text(
          //   "What are you converting from?",
          //   style: GoogleFonts.openSans(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16.0,
          //   ),
          // ),
          // DropdownButton<DropdownOptions>(
          //   items: DropdownOptions.values.map((DropdownOptions value) {
          //     return DropdownMenuItem<DropdownOptions>(
          //       value: value,
          //       child: Text(_optionsToString(value)),
          //     );
          //   }).toList(),
          //   value: _selectedOption,
          //   onChanged: (value) {
          //     if (value == null) return;
          //     setState(() {
          //       _selectedOption = value;
          //     });
          //   },
          // ),
          SwitchListTile(
            title: const Text("Has start code"),
            subtitle: const Text("Can it start with 'AUG'?"),
            value: _hasStartCode,
            onChanged: (value) {
              setState(() {
                _hasStartCode = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Has stop code"),
            subtitle: const Text("Can it end in 'UAA', 'UAG', 'UGA'?"),
            value: _hasStopCode,
            onChanged: (value) {
              setState(() {
                _hasStopCode = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            "Result",
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            "mRNA:",
            style:
                GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            _displayMRNA,
            style: GoogleFonts.notoSans(fontSize: 16),
          ),
          const SizedBox(height: 25),
          Text(
            "Codons:",
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            _codons,
            style: GoogleFonts.notoSans(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Anticodon:",
            style:
                GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            _antiCodons,
            style: GoogleFonts.notoSans(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
