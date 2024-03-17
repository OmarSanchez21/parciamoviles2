import 'dart:io';
import 'package:flutter/material.dart';
import 'event_view.dart';
import 'package:examen2/event.dart';

class ListEventPage extends StatefulWidget{
  @override
  _listEventPageState createState() => _listEventPageState();
}
class _listEventPageState extends State<ListEventPage>{
  @override
  Widget build( BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Eventos'),
        centerTitle: true,
      ),
      body: listadoDeEvento.isEmpty ? Center(
        child: Text('No hay evento registrado', style: TextStyle(fontSize: 20),),
      ): ListView.builder(
          itemCount: listadoDeEvento.length,
          itemBuilder: (context, index){
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              child: ListTile(
                title: Text(listadoDeEvento[index].titulo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Descripcion: ${listadoDeEvento[index].descripcion}'),
                    SizedBox(height: 20,),
                    Text('Fecha ${_formatDate(listadoDeEvento[index].date)}'),
                    SizedBox(height: 5,)
                  ],
                ),
                onTap: (){
                  _showEventDialog(listadoDeEvento[index]);
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => addEventForm()));
          },
        child: Icon(Icons.arrow_left),
        ),//Omar Alexis Sanchez Perez 2022-0197
    );
  }
  String _formatDate(DateTime date){
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEventDialog( Evento evento){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(evento.titulo),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Descripcon: ${evento.descripcion}'),
                SizedBox(height: 8,),
                Text('Fecha: ${_formatDate(evento.date)}'),
                SizedBox(height: 8,),
                evento.imagePath != null && evento.imagePath!.isNotEmpty
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(File(evento.imagePath!))
                    )
                  ),
                ) : Container(child: Text('No hay imagen guardada'),)
              ],
            ),
          );
        });
  }
}