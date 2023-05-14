import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_test_project/BankCollApp/app_cubit/app_cubit.dart';
import 'package:new_test_project/BankCollApp/modules/client_screen/client_screen.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/states.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';
import 'package:new_test_project/BankCollApp/shared/components/components.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/models/client_model.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLoginCubit, AppLoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    signOut(context);

                  }, child: const Text("Sign out",style: TextStyle(fontSize: 24),))
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: defaultColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConditionalBuilder(
              condition: true,
              builder: (context) => ListView.separated(
                itemBuilder: (context, index) => clientItem(context,AppLoginCubit.get(context).clients[index]),
                separatorBuilder: (context, index) => SizedBox(height: 15,),
                itemCount: AppLoginCubit.get(context).clients.length,
              ),
              fallback: (context) => CircularProgressIndicator(color: defaultColor,),
            ),
          ),

        );
      },
    );
  }

  clientItem(context, ClientModel client){
    return GestureDetector(
      onTap: (){
        AppCubit.get(context).getInitClient(client.id).then((value) {
          navigateTo(context, ClientScreen(value));
        });
      },
      child: Container(
        height: 120,
        child: Card(
          elevation: 15,
          color: defaultColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name, style: TextStyle(fontSize: 18,color: Colors.white),),
                    SizedBox(height: 15,),
                    Text(client.address, style: TextStyle(fontSize: 16,color: Colors.white),),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[500],
                  backgroundImage: NetworkImage("https://th.bing.com/th/id/OIP.YCGQ25lthu82-vALQSw9gwHaHa?pid=ImgDet&rs=1"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
