import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            height: size.height*0.06,
          ),
          Container(
            height: size.height*0.09,

            width: size.width,
            margin: EdgeInsets.only(left: size.height*0.009,right: size.height*0.009),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.transparent,
              ),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(169, 169, 207, 1),
                  // Color.fromRGBO(86, 149, 178, 1),
                  Color.fromRGBO(189, 201, 214, 1),
                  //Color.fromRGBO(118, 78, 232, 1),
                  Color.fromRGBO(175, 207, 240, 1),

                  // Color.fromRGBO(86, 149, 178, 1),
                  Color.fromRGBO(189, 201, 214, 1),
                  Color.fromRGBO(169, 169, 207, 1),
                ],
              ),

            ),


            child: Card(
              shape:  RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(40),),
              color: Colors.transparent,
              elevation: 60,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.menu_sharp)),
            const AutoSizeText("Campus Link",
            style: TextStyle(
              fontSize: 25
            )),
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
                ],
              ),
            ),
          ),
        ],
      ),
    ) ;
  }
}
