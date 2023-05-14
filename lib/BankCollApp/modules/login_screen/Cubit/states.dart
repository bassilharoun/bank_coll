
abstract class AppLoginStates {}

class AppLoginInitialState extends AppLoginStates {}
class AppLoginLoadingState extends AppLoginStates {}
class AppLoginSuccessState extends AppLoginStates {}

class AppLoginErrorState extends AppLoginStates {
  final String error ;
  AppLoginErrorState(this.error);
}

class AppChangePasswordVisibilityState extends AppLoginStates {}

class AppLoginGetClientsLoadingState extends AppLoginStates {}
class AppLoginGetClientsSuccessState extends AppLoginStates {}
class AppLoginGetClientsErrorState extends AppLoginStates {}
