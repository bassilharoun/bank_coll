import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_cubit.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/states.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/BankCollApp/shared/dio_helper.dart';
import 'package:new_test_project/BankCollApp/shared/end_points.dart';
import 'package:new_test_project/models/client_model.dart';
import 'package:new_test_project/models/user_model.dart';

class AppLoginCubit extends Cubit<AppLoginStates>{
  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);




  List<ClientModel> clients = [];
  Future<List<ClientModel>> getClients(context)async{
    clients = [];
    emit(AppLoginGetClientsLoadingState());
    print("get clients started");
    try{
      String url = "http://192.168.1.64:8000/api/visitorClients/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjY0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE2ODI5NDA3ODcsImV4cCI6MTY4Mjk0NDM4NywibmJmIjoxNjgyOTQwNzg3LCJqdGkiOiJGanAxcU9JSG40Qm4zZnRyIiwic3ViIjoiMiIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.0i8gvrLGRMWMqU9phthfPOhBz49jl2wtzCBdSDQrxiY";
      var response = await Dio().get(
          url,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json"
              }
          )

      );
      if(response.statusCode == 200){
          response.data['data'].forEach((element){
            // print(element);
            clients.add(ClientModel.fromJson(element));
            print(clients.first.address);

          });
          // print(response.data['data']);
          // clients = (response.data['data']).map((e) => ClientModel.fromJson(e));
          emit(AppLoginGetClientsSuccessState());
          // TODO put the logout
          emit(AppLoginGetClientsErrorState());

      }
    } on DioError catch (e){
      print(e.response);
    }
    // print(clients[0]);
    return clients ;
  }

  Future<List<ClientModel>> getClientsWithoutLogin(context)async{
    clients = [];
    emit(AppLoginGetClientsLoadingState());
    print("get clients started");
    try{
      String url = "http://192.168.1.64:8000/api/visitorClients/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjY0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE2ODI5NDA3ODcsImV4cCI6MTY4Mjk0NDM4NywibmJmIjoxNjgyOTQwNzg3LCJqdGkiOiJGanAxcU9JSG40Qm4zZnRyIiwic3ViIjoiMiIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.0i8gvrLGRMWMqU9phthfPOhBz49jl2wtzCBdSDQrxiY";
      var response = await Dio().get(
          url,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json"
              }
          )

      );
      if(response.statusCode == 200){
        response.data['data'].forEach((element){
          // print(element);
          clients.add(ClientModel.fromJson(element));
          print(clients.first.address);

        });
        // print(response.data['data']);
        // clients = (response.data['data']).map((e) => ClientModel.fromJson(e));
        // TODO put the logout
        emit(AppLoginGetClientsErrorState());

      }
    } on DioError catch (e){
      print(e.response);
    }
    // print(clients[0]);
    return clients ;
  }

  // void userLogin({
  //   required String email ,
  //   required String password
  // })async{
  //   emit(AppLoginLoadingState());
  //   DioHelper.postData(
  //       url: "auth/login?email=${email}&password=${password}",
  //       ).then((value) {
  //     loginModel = LoginModel.fromJson(value.data);
  //     print(loginModel);
  //     print(loginModel);
  //     emit(AppLoginSuccessState());
  //   }).catchError((error){
  //     emit(AppLoginErrorState(error.toString()));
  //     print(error);
  //   });
  // }

  LoginModel? loginModel ;

  final dio = Dio();
  Response? response;
  Future userLogin({
    required String email ,
    required String password,
    required context
  })async{
    emit(AppLoginLoadingState());
    dio.post('http://192.168.1.64:8000/api/auth/login?email=${email}&password=${password}').then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(AppLoginSuccessState());
      getClients(context);
      print(loginModel!.user!.name);
      print(loginModel!.access_token);
      }).catchError((error){
        emit(AppLoginErrorState(error.toString()));
        print(error);
    });
  }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
    emit(AppChangePasswordVisibilityState());
  }
}