import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';
import 'package:new_test_project/models/client_model.dart';

class CommentsScreen extends StatelessWidget {
  List<CommentModel> comments ;
  CommentsScreen(this.comments);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: defaultColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConditionalBuilder(
          condition: comments.isNotEmpty,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildCommentItem(context, comments[index]),
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemCount: comments.length,
          ),
          fallback: (context) => Center(child: Text("Empty!",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),),),
        ),
      ),
    );
  }

  buildCommentItem(context, CommentModel comment){
    return Card(
      elevation: 15,
      color: defaultColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.comment_outlined,color: Colors.white,),
                SizedBox(width: 5,),
                Container(
                    width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width /4 ,
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(comment.comment,style: TextStyle(fontSize: 16),),
                      ),
                      color: Colors.blue[200],
                    )
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.date_range,color: Colors.white,),
                SizedBox(width: 5,),
                Text(comment.date,style: TextStyle(color: Colors.white,fontSize: 18),),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.access_time,color: Colors.white,),
                SizedBox(width: 5,),
                Text(comment.time,style: TextStyle(color: Colors.white,fontSize: 18),),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
