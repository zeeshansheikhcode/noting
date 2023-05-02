import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noting/box/boxes.dart';
import 'package:noting/models/note_model.dart';
import 'package:noting/view_model/home_viewmodel.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async{
           HomeViewModel.showMyDialog(context);
          },
      child:const  Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_,)
        { var data = box.values.toList().cast<NotesModel>();
          return Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.h),
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: box.length,
              itemBuilder: (context,index)
              {
                return Padding(
                  padding:  EdgeInsets.only(bottom: 10.h),
                  child: Card(
                    color: HomeViewModel.colors[HomeViewModel.random.nextInt(4)],
                    child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Text(data[index].title.toString() ,
                                  style: TextStyle(fontSize: 20.sp , fontWeight: FontWeight.w500 , color: Colors.white),),
                               const Spacer(),
                                InkWell(
                                    onTap: (){
                                      HomeViewModel.delete(data[index]);
                                    },
                                    child:const Icon(Icons.delete , color: Colors.white,)),
                                SizedBox(width: 15.w,),
                                InkWell(
                                    onTap: (){
                                      HomeViewModel.editDialog(data[index], data[index].title.toString(), data[index].description.toString(),context);
                                    },
                                    child:const Icon(Icons.edit, color: Colors.white,)) ,

                              ],
                            ),
                            Text(data[index].description.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ),

                  );
                }     
              ),
            );
        },
      )
            
    );
    
  }
}