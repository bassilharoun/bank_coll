
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_cubit.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_states.dart';
import 'package:new_test_project/BankCollApp/modules/clients_screen/clients_screen.dart';
import 'package:new_test_project/BankCollApp/modules/comments_screen/comments_screen.dart';
import 'package:new_test_project/BankCollApp/modules/locations_screen/locations_screen.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';
import 'package:new_test_project/BankCollApp/shared/components/components.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/models/client_model.dart';

class ClientScreen extends StatelessWidget {
  ClientModel client ;
  ClientScreen(this.client);

  var dateController = TextEditingController();
  var amountController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is AppAddLocationSuccessState){
          showToast(text: "Location Added Successfully", state: ToastStates.SUCCESS);
        }
        if(state is AppAddLocationErrorState){
          showToast(text: "Something went wrong", state: ToastStates.ERROR);
        }
        if(state is AppAddCommentSuccessState){
          showToast(text: "Comment Added Successfully", state: ToastStates.SUCCESS);
        }
        if(state is AppAddCommentErrorState){
          showToast(text: "Something went wrong", state: ToastStates.ERROR);
        }

      },
      builder : (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Client Screen"),backgroundColor: defaultColor,),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0,left: 8.0, top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder.all(width: 1.5 ,color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                      children: [
                        buildTableRow(Text("NAME"),Text(client.name,style: TextStyle(fontSize: 20),)),
                        buildTableRow(Text("ADDRESS"),Text(client.address,style: TextStyle(fontSize: 20),)),
                        buildTableRow(Text("PHONE"),Text(client.phone,style: TextStyle(fontSize: 20),)),
                        buildTableRow(defaultTextButton(text: "LOCATION",function: (){
                          AppCubit.get(context).getInitClient(client.id).then((value) {
                            navigateTo(context, LocationsScreen(AppCubit.get(context).initClient!.locations));
                          });
                        }),IconButton(onPressed: (){
                          _showDialog(context, 0, client.id);
                        }, icon: Icon(Icons.add_location_alt_outlined,size: 35,color: defaultColor,))),
                        buildTableRow(defaultTextButton(text: "COMMENT",function: (){
                          AppCubit.get(context).getInitClient(client.id).then((value) {
                            navigateTo(context, CommentsScreen(AppCubit.get(context).initClient!.comments));
                          });
                        }),IconButton(onPressed: (){
                          _showDialog(context, 1, client.id);
                        }, icon: Icon(Icons.add_comment_outlined,color: defaultColor,size: 35,))),

                        buildTableRow( DropdownButton(
                            items: AppCubit.get(context).leftItems.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            value: AppCubit.get(context).leftdropdownvalue,
                            onChanged: (dynamic newValue){
                              AppCubit.get(context).changeLeftDropdown(newValue);
                            }
                            ),
                          Column(
                            children: [
                              DropdownButton(
                                  items: AppCubit.get(context).rightItems.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  value: AppCubit.get(context).rightdropdownvalue,
                                  onChanged: (dynamic newValue){
                                    AppCubit.get(context).changeRightDropdown(newValue);
                                  }
                              ),
                              if(AppCubit.get(context).rightdropdownvalue == "Kept PTP" || AppCubit.get(context).rightdropdownvalue == "PTP")...[
                                Form(
                                  key: formKey,
                                    child: Column(
                                  children: [
                                    defaultTxtForm(controller: dateController, type: TextInputType.datetime, validate: (val){
                                      if(val!.isEmpty){
                                        return "";
                                      }
                                    }, label: "PTP Date"),
                                    defaultTxtForm(controller: amountController, type: TextInputType.number, validate: (val){
                                      if(val!.isEmpty){
                                        return "";
                                      }
                                    }, label: "PTP Amount"),
                                  ],
                                ))
                              ]

                            ],
                          ),),

                        buildTableRow(Text("PICTURE"),
                            GestureDetector(
                              onTap: (){
                                AppCubit.get(context).getProfileImage();
                              },
                                child: AppCubit.get(context).profileImage == null ? Image.asset("assets/images/pic.png") : Container(
                                  height: 250,
                                    width: double.infinity,
                                    child: Image.file(AppCubit.get(context).profileImage!))
                            )
                        ),
                        buildTableRow(Text(""),Container()),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  defaultButton(function: (){
                    if(AppCubit.get(context).rightdropdownvalue == "Kept PTP" || AppCubit.get(context).rightdropdownvalue == "PTP"){
                      if(formKey.currentState!.validate()){
                        AppCubit.get(context).uploadImg(
                            AppCubit.get(context).profileImage!,
                            clientId: client.id,
                            context: context,
                        );
                        AppCubit.get(context).postStatus(
                            clientId: client.id,
                            type: AppCubit.get(context).leftdropdownvalue!,
                            result: AppCubit.get(context).rightdropdownvalue!,
                            ptpAmount: amountController.text,
                            ptpDate: dateController.text,
                            context: context,
                        ).then((value) {
                          Navigator.pop(context);
                          AppCubit.get(context).profileImage = null ;
                          showToast(text: "Success", state: ToastStates.SUCCESS);
                        });
                      }
                    }else if(AppCubit.get(context).profileImage != null){
                      AppCubit.get(context).uploadImg(
                          AppCubit.get(context).profileImage!,
                          clientId: client.id,
                          context: context,
                      );
                      AppCubit.get(context).postStatus(
                          clientId: client.id,
                          type: AppCubit.get(context).leftdropdownvalue!,
                          result: AppCubit.get(context).rightdropdownvalue!,
                          ptpAmount: amountController.text,
                          ptpDate: dateController.text,
                          context: context,
                      ).then((value) {
                        Navigator.pop(context);
                        AppCubit.get(context).profileImage = null ;
                        showToast(text: "Success", state: ToastStates.SUCCESS);
                      });
                    }

                  }, text: "SAVE"),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  buildTableRow(Widget lable, Widget data){
    return TableRow(children: [
      Container(height: 50,child: Center(child: lable)),
      Container(
        child: Align(
          alignment: Alignment.center,
            child: data),
      )

    ],
    );
  }
  _showDialog(BuildContext context,isComment, clientId)
  {
    BlurryAdd  alert = BlurryAdd(isComment, clientId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}


