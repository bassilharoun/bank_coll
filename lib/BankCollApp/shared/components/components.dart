import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_cubit.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_states.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';

void navigateTo(context , widget) => Navigator.push(context,
    MaterialPageRoute(builder:  (context) => widget)) ;

void navigateAndFinish(context , widget) => Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder:  (context) => widget),
        (route) => false
) ;


Widget defaultTxtForm({
  required TextEditingController controller ,
  required TextInputType type ,
  Function(String)? onSubmit ,
  VoidCallback? onTap ,
  Function(String)? onChanged ,
  required String? Function(String?)? validate ,
  required String label ,
  IconData? prefix ,
  IconData? suffix = null ,
  bool isPassword = false,
  bool isClickable = true ,
  VoidCallback? onSuffixPressed ,

}) => TextFormField(
  validator: validate,
  obscureText: isPassword,
  controller: controller,
  decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: GestureDetector(
        child: Icon(suffix),
        onTap: onSuffixPressed,
      ),
  ),
  keyboardType: type,
  enabled: isClickable,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  onTap: onTap,

) ;


Widget defaultButton({
  double width = double.infinity ,
  Color background = defaultColor ,
  required VoidCallback function ,
  required String text ,
  bool isUpperCase = true,


}) => Container(
  width: width,
  child: MaterialButton(
    height: 50,
    onPressed: function,
    child: Text(isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(color: Colors.white),),
  ),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    color: background,
  ),
);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  Color color = defaultColor ,

}) => TextButton(onPressed: function
    ,child: Text(
      text.toUpperCase(),
      style: TextStyle(color: color , fontSize: 16),
    ));

void showToast({
  required String text ,
  required ToastStates state ,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates{SUCCESS , ERROR , WARNING}
Color? chooseToastColor(ToastStates state){
  Color? color ;
  switch(state){
    case ToastStates.SUCCESS:
      color = defaultColor;
      break;
    case ToastStates.ERROR:
      color = Colors.pink;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color ;

}

Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child:   Container(
    width: double.infinity,
    height: 1,
    color: defaultColor,
  ),
);

class BlurryAdd extends StatefulWidget {
  int isComment;
  int clientId;
  BlurryAdd(this.isComment,this.clientId);
  @override
  State<BlurryAdd> createState() => BlurryDialogStateAdd(isComment, clientId);
}


class BlurryDialogStateAdd extends State<BlurryAdd> {
  int isComment ;
  int clientId ;
  BlurryDialogStateAdd(this.isComment, this.clientId);

  var formKey = GlobalKey<FormState>();

  var commentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {} ,
      builder: (context, state) {
        return Container(
          child: isComment == 1 ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Icon(
                      Icons.add_comment_outlined, color: defaultColor, size: 40,),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Add Your comment"),
                          SizedBox(height: 15,),
                          TextFormField(
                            maxLines: 4,
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter comment!";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Comment",
                                prefixIcon: Icon(Icons.textsms_outlined)

                            ),

                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new TextButton(

                        child: ConditionalBuilder(
                            condition: state is AppAddCommentLoadingState,
                            builder: (context) => CircularProgressIndicator(color: defaultColor,),
                            fallback: (context) => Text("add", style: TextStyle(
                                color: defaultColor, fontWeight: FontWeight.bold),)
                        ),
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            AppCubit.get(context).postComment(clientId: clientId, date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(), time: DateFormat('hh:mm:ss').format(DateTime.now()).toString(), context: context, comment: commentController.text);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      new TextButton(
                        child: Text("cancel",style: TextStyle(color: Colors.grey),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )) :
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Icon(
                      Icons.add_location_alt_outlined, color: defaultColor, size: 40,),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Are you sure to pick your location now ?"),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: ConditionalBuilder(
                          condition: state is AppAddLocationLoadingState,
                          builder: (context) => CircularProgressIndicator(color: defaultColor,),
                          fallback: (context) =>Text("Pick", style: TextStyle(
                              color: defaultColor, fontWeight: FontWeight.bold),)
                        ),
                        onPressed: () {
                          AppCubit.get(context).getPosition().then((value) {
                            AppCubit.get(context).postLocation(location: "${AppCubit.get(context).address}", clientId: clientId, date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(), time: DateFormat('hh:mm:ss').format(DateTime.now()).toString(), context: context);
                            Navigator.pop(context);
                          });
                        },
                      ),
                      new TextButton(
                        child: Text("cancel",style: TextStyle(color: Colors.grey),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )),
        );
      } ,
    );
  }

}
