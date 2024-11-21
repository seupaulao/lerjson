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

class Pessoa {
  final String name;
  final int age;
  final String email;

  Pessoa(this.name, this.age, this.email);

  Pessoa.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'email': email,
      };
}

class _MyAppState extends State<MyApp> {
  // ignore: prefer_typing_uninitialized_variables
  var jsonData;
  // ignore: prefer_typing_uninitialized_variables
  var jsonBiblia;
  List<String> texto = [];
  int numCapitulo = 1;
  int idLivro = 1;
  int numVersiculo = 1;

  Future<void> loadJsonAsset() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    final String biblia = await rootBundle.loadString('assets/blv.json');
    final dataBiblia = jsonDecode(biblia) as Map<String, dynamic>;
    setState(() {
      jsonData = Pessoa.fromJson(data);
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
          Expanded(
            child: texto.isEmpty
                ? const Text('SEM DADOS')
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: texto.length,
                    prototypeItem: ListTile(title: Text(texto.first)),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(texto[index]),
                      );
                    }),
          )
        ]),
        //   floatingActionButton: FloatingActionButton(onPressed: addCapitulo),
      ),
    );
  }
}
