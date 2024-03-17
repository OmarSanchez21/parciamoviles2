import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:examen2/event.dart';

import 'listevent_view.dart';
//Omar Alexis Sanchez Perez 2022-0197
class addEventForm extends StatefulWidget{
  @override
  _addEventForm createState() => _addEventForm();
}
class _addEventForm extends State<addEventForm>{
  File? image;
  TextEditingController _titulo = TextEditingController();
  TextEditingController _descripcion = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState(){
    super.initState();
    loadEvento();
  }
  Future getImage() async{
    final imagesoure = await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Seleccione la imagen'),
            content: SingleChildScrollView(
              child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Tomar imagen'),
                  onTap: (){
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                GestureDetector(
                  child: Text('Selecciona la imagen'),
                  onTap: (){
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                )
              ],
              ),
            ),
          );
        });
    if(imagesoure != null){
      final XFile? pickedFile = await _imagePicker.pickImage(source: imagesoure);
      setState(() {
        if( pickedFile != null){
          image = File(pickedFile.path);
        }else {
          print('No se ha seleccionado una imagen');
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir un Nuevo Evento'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: getImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: image != null ? Image.file(image!, fit: BoxFit.cover,)
                        : Icon(Icons.camera)
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    _selectDate(context);
                  },
                  child: Text('Seleccione una fecha')),
              SizedBox(height: 20,),
              Text('Fecha Seleccionada: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              SizedBox(height: 20,),
              TextFormField(
                controller: _titulo,
                decoration: InputDecoration(
                  labelText: 'Titulo',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _descripcion,
                decoration: InputDecoration(
                    labelText: 'Descripcion',
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    _saveEventForm();
                  }, child: Text('Guardar Evento')),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListEventPage()));
                  }, child: Text('Ir al listado de eventos')),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _selectDate(BuildContext context) async{
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    if( pickedDate != null && pickedDate != _selectedDate){
      _selectedDate = pickedDate;
    }
  }
  void _saveEventForm() async{
    String titulo = _titulo.text;
    String descripcion = _descripcion.text;
    String? imagePath = image != null ? image!.path : null;
    
    Evento evento = Evento(
        titulo: titulo,
        descripcion: descripcion,
        imagePath: imagePath,
        date: _selectedDate);
    
    if(evento != null){
      listadoDeEvento.add(evento);
      await saveEvent();
      print('Evento GUARDADO');
      
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Evento Guardado'),
              content: Text('El evento fue guardado correctamente'),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('Aceptar'))
              ],
            );
          });
    }
  }
}