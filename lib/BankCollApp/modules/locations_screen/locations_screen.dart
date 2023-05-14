import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_test_project/BankCollApp/shared/colors.dart';
import 'package:new_test_project/models/client_model.dart';

class LocationsScreen extends StatelessWidget {
  List<LocationModel> locations;
  LocationsScreen(this.locations);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        backgroundColor: defaultColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConditionalBuilder(
          condition: locations.isNotEmpty,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildLocationItem(locations[index]),
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemCount: locations.length,
          ),
          fallback: (context) => Center(child: Text("Empty!",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),),),
        ),
      ),
    );
  }

  buildLocationItem(LocationModel location){
    return Container(
      height: 130,
      child: Card(
        elevation: 15,
        color: defaultColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_sharp,color: Colors.white,),
                  SizedBox(width: 5,),
                  Text(location.location,style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.date_range,color: Colors.white,),
                  SizedBox(width: 5,),
                  Text(location.date,style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.access_time,color: Colors.white,),
                  SizedBox(width: 5,),
                  Text(location.time,style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}
