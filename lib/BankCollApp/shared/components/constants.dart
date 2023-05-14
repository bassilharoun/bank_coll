import 'package:new_test_project/BankCollApp/modules/login_screen/login_screen.dart';
import 'package:new_test_project/BankCollApp/shared/components/components.dart';
import 'package:new_test_project/BankCollApp/shared/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
      token = null ;
      navigateAndFinish(context, LoginScreen());
    }
  });
}

dynamic token ;