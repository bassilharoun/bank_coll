class LoginModel {
  dynamic access_token ;
  dynamic token_type ;
  dynamic expires_in ;
  UserData? user ;

  LoginModel.fromJson(Map<String , dynamic> json){
    access_token = json['access_token'];
    token_type = json['token_type'];
    user = json['user'] != null ? UserData.fromJson(json['user']): null;
  }
}

class UserData{
  dynamic id ;
  dynamic name ;
  dynamic email ;
  dynamic phone ;
  dynamic email_verified_at ;
  dynamic created_at ;
  dynamic updated_at ;


  UserData.fromJson(Map<String , dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    email_verified_at = json['email_verified_at'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

}