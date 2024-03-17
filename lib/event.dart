import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Evento{
  final String titulo;
  final String descripcion;
  final String? imagePath;
  final DateTime date;

  Evento({required this.titulo, required this.descripcion,required this.imagePath,required this.date});

  Map<String, dynamic> toJson(){
    return{
      'titulo' : titulo,
      'descripcion' : descripcion,
      'imagePath' : imagePath,
      'date': date
    };
  }
  factory Evento.fromJson(Map<String, dynamic> json){
    return Evento(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      imagePath: json['imagePath'],
      date: json['date']
    );
  }
}

List<Evento> listadoDeEvento = [];

Future<void> saveEvent() async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventoJson = listadoDeEvento.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('eventos', eventoJson);
  }catch(error){
    print('Error guardando el evento $error}');
  }
}

Future<void> loadEvento() async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? eventoJson = prefs.getStringList('eventos');
    if(eventoJson != null){
      listadoDeEvento = eventoJson.map((e) => Evento.fromJson(jsonDecode(e))).toList();
    }
  }catch(error){
    print('Error al cargar los eventos $error');
  }
}

//Omar Alexis Sanchez Perez 2022-0197