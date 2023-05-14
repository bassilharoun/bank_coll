import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_test_project/BankCollApp/modules/clients_screen/clients_screen.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/cubit.dart';
import 'package:new_test_project/BankCollApp/modules/login_screen/Cubit/states.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';
import 'package:new_test_project/BankCollApp/shared/components/components.dart';
import 'package:new_test_project/BankCollApp/shared/components/constants.dart';
import 'package:new_test_project/BankCollApp/shared/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLoginCubit, AppLoginStates>(
      listener: (context, state)  {
        if(state is AppLoginGetClientsSuccessState){
          CacheHelper.saveData(
              key: 'token',
              value: AppLoginCubit.get(context).loginModel!.access_token).then((value) {
              token = AppLoginCubit.get(context).loginModel!.access_token ;
              navigateAndFinish(context, ClientsScreen());
          });
        }
      },
      builder: (context, state)  {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "Please login to your account",
                    style: TextStyle(fontSize: 24,
                    color: Colors.grey[500]),
                  ),
                  SizedBox(height: 25,),
                  defaultTxtForm(controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (val){
                        if(val!.isEmpty){
                          return "Enter your email !";
                        }
                      },
                      label: "Email Address",
                    prefix: Icons.email_outlined
                  ),
                  SizedBox(height: 5,),
                  defaultTxtForm(controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (value){
                        if(value!.isEmpty){
                          return "Password is too short !";
                        }
                      },
                      label: 'Password',
                      isPassword: AppLoginCubit.get(context).isPassword,
                      prefix: Icons.lock_open_outlined,
                      suffix: AppLoginCubit.get(context).suffix,
                      onSuffixPressed: (){
                        AppLoginCubit.get(context).changePasswordVisibility();
                      }
                  ),
                  SizedBox(height: 40,),
                  ConditionalBuilder(
                    condition: state is AppLoginLoadingState,
                    builder: (context)=> Center(child: CircularProgressIndicator(color: defaultColor,),),
                    fallback: (context) => defaultButton(function: (){
                      if(formKey.currentState!.validate()){
                        AppLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text, context: context);
                      }
                    }, text: "LOGIN"),
                  ),
                  SizedBox(height: 5,),
                  Center(child: defaultTextButton(function: (){}, text: "REGISTER NOW", color: Colors.grey))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
