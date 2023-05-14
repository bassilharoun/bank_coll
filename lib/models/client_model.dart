class ClientModel{
  dynamic id ;
  dynamic name ;
  dynamic phone ;
  dynamic address ;
  List<CommentModel> comments = [];
  List<LocationModel> locations = [];


  ClientModel.fromJson(Map<String , dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    json['comments'].forEach((element){
      comments.add(CommentModel.fromJson(element));
    });
    json['location'].forEach((element){
      locations.add(LocationModel.fromJson(element));
    });
  }

}

class CommentModel{
  dynamic id;
  dynamic comment;
  dynamic client_id;
  dynamic visitor_id;
  dynamic date;
  dynamic time;

  CommentModel.fromJson(Map<String , dynamic> json){
    id = json['id'];
    comment = json['comment'];
    client_id = json['client_id'];
    visitor_id = json['visitor_id'];
    date = json['date'];
    time = json['time'];
  }
}

class LocationModel{
  dynamic id;
  dynamic location;
  dynamic client_id;
  dynamic visitor_id;
  dynamic date;
  dynamic time;

  LocationModel.fromJson(Map<String , dynamic> json){
    id = json['id'];
    location = json['location'];
    client_id = json['client_id'];
    visitor_id = json['visitor_id'];
    date = json['date'];
    time = json['time'];
  }
}