import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../box/boxes.dart';
import '../models/note_model.dart';
class HomeViewModel 
{
 static final titleController = TextEditingController();
 static final descriptionController = TextEditingController();
 static List<Color> colors = [Colors.purple , Colors.black38, Colors.green, Colors.blue , Colors.red] ;
 static Random random = Random(3);
 
 static void delete(NotesModel notesModel)async{
      await notesModel.delete() ;
    }

  static Future<void> editDialog(NotesModel notesModel, String title, String description,BuildContext context)async{

    titleController.text = title ;
    descriptionController.text = description ;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title:const Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    style:const TextStyle(color: Colors.black),
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                   SizedBox(height: 20.h,),
                  TextFormField(
                    style:const TextStyle(color: Colors.black),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: ()async{
                 notesModel.title = titleController.text.toString();
                 notesModel.description = descriptionController.text.toString();
                 notesModel.save();
                 descriptionController.clear() ;
                 titleController.clear() ;
                 Navigator.pop(context);
              }, child:const Text('Edit')),
            ],
          );
        }
    ) ;
  }

   static Future<void> showMyDialog(BuildContext context)async{

      return showDialog(
          context: context,
          builder:(context){
            return AlertDialog(
              title:const Text('Add NOTES'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      style:const TextStyle(color: Colors.black),
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: 'Enter title',
                          border: OutlineInputBorder()
                      ),
                    ),
                     SizedBox(height: 20.h,),
                    TextFormField(
                      style:const TextStyle(color: Colors.black),
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Enter description',
                          border: OutlineInputBorder()
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text('Cancel')),

                TextButton(onPressed: (){
                  final data = NotesModel(title: titleController.text,
                      description: descriptionController.text) ;

                  final box = Boxes.getData();
                  box.add(data);
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                }, 
                child:const Text('Add')),
              ],
            );
          }
      ) ;
    }

}