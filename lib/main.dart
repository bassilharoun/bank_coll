import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_cubit.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_states.dart';
import 'package:new_test_project/BankCollApp/modules/clients_screen/clients_screen.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/login_screen.dart';
import 'package:new_test_project/BankCollApp/shared/bloc_observer.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/BankCollApp/shared/local/cache_helper.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();


  await CacheHelper.init();

  token = CacheHelper.getData(key: 'token');
  Widget widget ;
  print(token);
  print("print token from maiiiiiiiiiiiiiiin");


    if(token != null){
      widget = ClientsScreen();
      print(token);
      print("+++++++++++=====++++++++++++++====");
    }
    else{
      widget = LoginScreen();
      print(token);
  }


  Position? position ;
  var address ;
  Future<Position> getLatAndLong() async {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }
  Future getPosition() async {
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

  final dio = Dio();
  const mySec = Duration(seconds:10);
  Timer.periodic(mySec, (Timer t) {
    // if(token != null){
    //   getPosition().then((value) {
    //     dio.post('http://192.168.1.64:8000/api/visitorLocation?lat=${position!.latitude}&lng=${position!.longitude}&token=${token}').then((value) {
    //     }).catchError((error){
    //       print(error);
    //     });
    //   });
    // }
  });




  // getPosition();


  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget{


  final Widget? startWidget ;
  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit(),),
        BlocProvider(create: (BuildContext context) => AppLoginCubit()..getClientsWithoutLogin(context),),
      ],
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){},
        builder: (context , state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: startWidget,
          );
        },
      ),
    );
  }

}