import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/models/client_model.dart';
import 'app_states.dart';
import 'package:http/http.dart' as http;

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);



  ClientModel? initClient ;
  Future<ClientModel> getInitClient(clientId)async{
    emit(AppGetInitClientLoadingState());
    try{
      String url = "http://192.168.1.64:8000/api/client/${clientId}/?token=${token}";
      var response = await Dio().get(
          url,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json"
              }
          )

      );
      if(response.statusCode == 200){
          // print(element);
          initClient = ClientModel.fromJson(response.data['data']) ;
          print(initClient!.name);
          print("-------------------------");

        // print(response.data['data']);
        // clients = (response.data['data']).map((e) => ClientModel.fromJson(e));
        emit(AppGetInitClientSuccessState());
      }
    } on DioError catch (e){
      print(e.response);
    }
    // print(clients[0]);
    return initClient! ;
  }


  Response? response;
  postLocation({
    required int clientId ,
    required String date ,
    required String time ,
    required BuildContext context,
    required String location,
  })async{
    final dio = Dio();
    // emit(AppAddLocationLoadingState());
    dio.post('http://192.168.1.64:8000/api/visiting?location=${location}&client_id=${clientId}&date=${date}&time=${time}&token=${token}').then((value) {
      emit(AppAddLocationSuccessState());
    }).catchError((error){
      emit(AppAddLocationErrorState());
      print(error);
    });
  }

  postComment({
    required int clientId ,
    required String date ,
    required String time ,
    required BuildContext context,
    required String comment,
  })async{
    final dio = Dio();
    emit(AppAddCommentLoadingState());
    dio.post('http://192.168.1.64:8000/api/comment?comment=${comment}&client_id=${clientId}&date=${date}&time=${time}&token=${token}').then((value) {
      emit(AppAddCommentSuccessState());
    }).catchError((error){
      emit(AppAddCommentErrorState());
      print(error);
    });
  }

  liveLocation({
    required dynamic lat ,
    required dynamic long ,
    required String time ,
    required BuildContext context,
    required String comment,
  })async{

  }

  Position? position ;
  var address ;
  Future<Position> getLatAndLong() async {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }

  Future getPosition() async {
    emit(AppAddLocationLoadingState());
    bool services ;
    LocationPermission per ;
    services = await Geolocator.isLocationServiceEnabled();
    print(services);
    per = await Geolocator.checkPermission();
    if(per == LocationPermission.denied){
      per = await Geolocator.requestPermission();
    }
    if(per != LocationPermission.denied && services == true){
      position = await getLatAndLong();
      List<Placemark> placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
      address = "${placemarks.first.locality}, ${placemarks.first.administrativeArea}" ;
      print(address);
      print("-----------------------++");
      print(address);
      print("Lat : ${position!.latitude} , Long : ${position!.longitude}");
      print("------------------");
    }
    print(per);
    print("------------------");
  }

  String? leftdropdownvalue = "Visit" ;

  var leftItems = [
    "Call",
    "Visit",
  ];

  changeLeftDropdown(String? newValue){
    leftdropdownvalue = newValue;
    emit(AppChangeDropdown());
  }

  /////////////////////////////////////////////////
  String? rightdropdownvalue = "Follow Up" ;

  var rightItems = [
    "Kept PTP",
    "PTP",
    "Broken",
    "Follow Up",
    "Unreachable Home Add",
    "Unreachable Work Add",
    "Closed mobile numb",
    "No Answer",
    "Wrong Mobile",
    "Contact Home Numb",
    "Contact Work Numb",
    "Contact Reference",
    "Traveled Abroad",
    "In Jail",
    "Sick In Hospital",
    "Passed Away",
    "No Commitment",
    "New Data",
    "Paid",
  ];

  changeRightDropdown(String? newValue){
    rightdropdownvalue = newValue;
    emit(AppChangeDropdown());
  }

  File? profileImage ;
  var pickedFile ;
  var picker = ImagePicker() ;
  Future<void> getProfileImage()async{
    pickedFile = await picker.getImage(source: ImageSource.camera);

    if(pickedFile != null){
      profileImage = File(pickedFile.path);
      print(pickedFile);
      print(pickedFile.path);
      print(profileImage);
      print("-----------------------------");
      emit(AppProfileImagePickedSuccessState());
    }else{
      print('No image selected');
    }
  }

  Future<void> postStatus({
    required int clientId ,
    required String type,
    required String result,
    required String ptpAmount ,
    required String ptpDate ,
    required BuildContext context,
  })async{
    final dio = Dio();
    emit(AppAddStatusLoadingState());
    dio.post('http://192.168.1.64:8000/api/status?type=${type}&result=${result}&ptp_date=${ptpDate}&ptp_amount=${ptpAmount}&client_id=${clientId}&token=${token}').then((value) {
      print(value.data);
      emit(AppAddStatusSuccessState());
    }).catchError((error){
      emit(AppAddStatusErrorState());
      print(error);
    });
  }

  // postImg({
  //   required int clientId ,
  //   required dynamic img,
  //   required BuildContext context,
  // })async{
  //
  //   final dio = Dio();
  //   emit(AppAddStatusLoadingState());
  //   dio.post(
  //       'http://192.168.1.64:8000/api/image?client_id=${clientId}&visitor_id=${AppLoginCubit.get(context).loginModel!.user!.id}',
  //
  //   ).then((value) {
  //     emit(AppAddStatusSuccessState());
  //   }).catchError((error){
  //     emit(AppAddStatusErrorState());
  //     print(error);
  //   });
  // }

  dynamic uploadedImage ;
  Future<void> uploadImg(File file,{
  required int clientId ,
  required BuildContext context,
  }) async {
    emit(AppUploadImgLoadingState());
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    dio.post('http://192.168.1.64:8000/api/image?client_id=${clientId}&token=${token}', data: data)
        .then((response) {
      emit(AppUploadImgSuccessState());
      print(response) ;
    } )
        .catchError((error) {
      emit(AppUploadImgErrorState());
      print(error);
    });
  }


}


