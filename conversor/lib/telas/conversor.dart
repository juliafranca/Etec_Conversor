import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=d18b57f7";

class Conversor extends StatefulWidget {
  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/ dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/euro).toStringAsFixed(2);
  }

  void _apagar(){
  realController.text = "";
  dolarController.text = "";
  euroController.text = "";

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar os dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  //print(euro);
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(14.0),
                    child: Column(
                      
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 150.0, color:Colors.amberAccent,
                        ),
                        TextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: realController,
                          decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "R\$",
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                          onChanged: _realChanged,
                        ),
                        Divider(),
                        TextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: dolarController,
                            decoration: InputDecoration(
                              labelText: "Dólar",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "USD \$",
                            ),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25),
                          onChanged: _dolarChanged,
                        ),
                        Divider(),
                        TextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: euroController,
                          decoration: InputDecoration(
                            labelText: "Euros",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "EUR \€",
                          ),
                          style:
                          TextStyle(color: Colors.amber, fontSize: 25),
                          onChanged: _euroChanged,
                        ),
                        Divider(),
                        RaisedButton(
                          onPressed: _apagar,
                          child:
                          Text("Apagar dados"),
                          color: Colors.amberAccent,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }

  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }
}
