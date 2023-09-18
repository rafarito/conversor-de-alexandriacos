import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


String alexandriacos = ""; 
String celsius = "";
TextEditingController _caixaCelsius = TextEditingController();
TextEditingController _caixaAlexandriacos = TextEditingController();

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
      debugShowCheckedModeBanner: false, // alterar
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          inversePrimary: Colors.red
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alexandríacos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void toClipboard(String texto) async {
    await Clipboard.setData(ClipboardData(text: texto));
  }

  void _converter(){
    setState(() {
      alexandriacos = alexandriacos.replaceAll(",", ".");
      celsius = celsius.replaceAll(",", ".");
      if(alexandriacos != "" && celsius != ""){
        mostrarAviso(context, "Um dos campos deve estar vazio");
      }else if (alexandriacos == "" && celsius == ""){
        mostrarAviso(context, "prencha pelo menos um dos campos");
      }else if (alexandriacos == ""){
        alexandriacos = toAlexandriacos(celsius);
        _caixaAlexandriacos.text = alexandriacos;
      }else {
        celsius = toCelsius(alexandriacos);
        _caixaCelsius.text = celsius;
      }
    });
  }

  String toAlexandriacos(String scelsius){
    double celsius = double.parse(scelsius);
    double alexandriacos = (celsius * 2) + 69;
    return alexandriacos.toString();
  }

  String toCelsius(String salexandriacos){
    double alexandriacos = double.parse(salexandriacos);
    double celsius = (alexandriacos-69)/2;
    return celsius.toString();
  }

  void mostrarAviso(BuildContext context, String mensagem) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(mensagem),
      duration: const Duration(seconds: 2), // Duração do SnackBar em segundos
    ),
  );
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("°C: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              SizedBox(
                width: 200,
                child: TextField(
                        controller: _caixaCelsius,
                        onChanged: (text) => {
                          celsius = text
                        },
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(labelText: "digite algo", border: OutlineInputBorder()),                
                        ),
              ),
              IconButton(
                onPressed: (){toClipboard(celsius);mostrarAviso(context, "copiado com sucesso!");},
                icon: const Icon(Icons.copy),
              )
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("°A: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              SizedBox(
                width: 200,
                child: TextField(
                        controller: _caixaAlexandriacos,
                        onChanged: (text) => {
                          alexandriacos = text
                        },
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(labelText: "digite algo", border: OutlineInputBorder()),                
                        ),
              ),
              IconButton(
                onPressed: (){toClipboard(alexandriacos);mostrarAviso(context, "copiado com sucesso!");},
                icon: const Icon(Icons.copy),
              )
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          ElevatedButton(
            onPressed: () {_converter();},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              padding: const EdgeInsets.all(25)
            ),
            child: const Text("Converter"),
          ),
        ]
      ),
    );
  }
}
