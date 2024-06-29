import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ko4k/authentication_module/presentation_layer/screens/authentication_screen.dart';
import 'package:ko4k/core/constants/local_data_base_constances.dart';
import 'package:ko4k/main.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: (){
              preferences.remove(LocalDataBaseConstants.kCurrentRole);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
            },
              child: Icon(Icons.radar , color: Colors.black,size: 100,)),
        ],
      ),
    );
  }
}
