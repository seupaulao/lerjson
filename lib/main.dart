import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

// class Pessoa {
//   final String name;
//   final int age;
//   final String email;

//   Pessoa(this.name, this.age, this.email);

//   Pessoa.fromJson(Map<String, dynamic> json)
//       : name = json['name'] as String,
//         age = json['age'] as int,
//         email = json['email'] as String;

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'age': age,
//         'email': email,
//       };
// }

class _MyAppState extends State<MyApp> {
  // ignore: prefer_typing_uninitialized_variables
  var jsonData;
  // ignore: prefer_typing_uninitialized_variables
  var jsonBiblia;
  List<String> texto = [];
  List<String> textoOriginal = [];
  List<String> textoTransliterado = [];
  int numCapitulo = 5;
  int idLivro = 40;
  int numVersiculo = 1;

  Future<void> loadJsonAsset() async {
    // final String jsonString = await rootBundle.loadString('assets/data.json');
    // final data = jsonDecode(jsonString) as Map<String, dynamic>;

    final String biblia = await rootBundle.loadString('assets/blv.json');
    final String strBaseLivros =
        await rootBundle.loadString('assets/bases/baselivros.json');
    final String strBaseVersos =
        await rootBundle.loadString('assets/bases/baseversos.json');

    final dataBiblia = jsonDecode(biblia) as Map<String, dynamic>;
    final dataBaseLivros = jsonDecode(strBaseLivros) as List<dynamic>;
    final dataBaseVersos = jsonDecode(strBaseVersos) as Map<String, dynamic>;

    // print(dataBaseLivros[idLivro - 1]['abrev']);
    // print(dataBaseVersos['$idLivro']['qteversos'][numCapitulo - 1]);

    //ex: MAT
    String abrev = dataBaseLivros[idLivro - 1]['abrev'];
    //ex: MAT tem 48 versos capitulo 5
    int numVersos = dataBaseVersos['$idLivro']['qteversos'][numCapitulo - 1];

    setState(() {
      // jsonData = Pessoa.fromJson(data);
      jsonBiblia = dataBiblia;
      texto.clear();
      dataBiblia['$idLivro']['capitulos']['$numCapitulo']
          .forEach((key, value) => texto.add(value));
    });

    // texto.forEach((item) => print(item));

    //List<String> temp = [];

    // print(dataBiblia['1']['livro']);
    // print(dataBiblia['1']['capitulos'][numCapitulo]);
    // print(jsonBiblia['$idLivro']['capitulos']['$numCapitulo']);
    //temp.forEach((item) => print(item));
    // print(dataBiblia['19']['livro']);
    // print(dataBiblia['19']['capitulos']['1']['1']);
  }

  List<String> getTextoOriginal(
      int idLiv, int cap, int qteVersos, String abrev) {
    List<String> lista = [];

    return lista;
  }

  List<String> getTextoTransliterado(int cap, int qteVersos, String abrev) {
    List<String> lista = [];

    return lista;
  }

  void addCapitulo() {
    int qteCapitulos =
        int.parse(jsonBiblia['$idLivro']['qtecapitulos'].toString());
    setState(() {
      numCapitulo = numCapitulo > qteCapitulos ? 1 : numCapitulo + 1;
      texto.clear();
      jsonBiblia['$idLivro']['capitulos']['$numCapitulo']
          .forEach((key, value) => texto.add(value));
    });
  }

  void subCapitulo() {
    setState(() {
      numCapitulo = numCapitulo > 1 ? numCapitulo - 1 : 1;
      texto.clear();
      jsonBiblia['$idLivro']['capitulos']['$numCapitulo']
          .forEach((key, value) => texto.add(value));
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }
  /*
  *
GRK/HEB
TRANSLIT
BLV
  */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App leitor de JSON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Carregar JSON'),
        ),
        body: Column(children: [
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 50,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: subCapitulo, child: const Text('Anterior')),
                  ElevatedButton(
                      onPressed: addCapitulo, child: const Text('Proximo')),
                ]),
          ),
          const SizedBox(
            height: 25,
          ),
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: texto.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 70,
                    child: ListTile(
                      title: Text("${index + 1}. ${texto[index]}"),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 30),
          Container(height: 40, color: Colors.amber)
        ]),
      ),
    );
  }
}
