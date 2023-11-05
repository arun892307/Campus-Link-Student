import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/pieChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import 'loadingscreen.dart';

class PsychometricTest extends StatefulWidget {
  const PsychometricTest({super.key});

  @override
  State<PsychometricTest> createState() => _PsychometricTestState();
}

class _PsychometricTestState extends State<PsychometricTest> {
  var count=1;
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  List<String> currentChoice= [];
  PageController pageQuestionController = PageController();
  List<String> options = [];
  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTest();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loaded ?
    Scaffold(
      backgroundColor: const Color.fromRGBO(17, 22, 44, 1),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white70,)),
        title: AutoSizeText('Learning Style Test',
          style: GoogleFonts.poppins(
              fontSize: size.width*0.055,
              color: Colors.white70,
              fontWeight: FontWeight.w600
          ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height:size.height*0.02),

          SizedBox(
            height: size.height*0.78,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width*0.03),
                  child: Row(
                    children: [
                      Text('Question $count',style: TextStyle(fontSize:size.width*0.1,fontWeight:FontWeight.w600,color: Colors.white70),),
                      Text('/${snapshot.data()!["Questions"].length}',style: TextStyle(fontSize:size.width*0.07,fontWeight:FontWeight.w600,color: Colors.white60),),
                    ],
                  ),
                ),
                SizedBox(height: size.height*0.02,),
                SizedBox(
                  height: size.height*0.005,
                  width: size.width*0.90,
                  child: ListView.builder(
                    scrollDirection:Axis.horizontal ,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data()!["Questions"].length ,
                    itemBuilder:(context, index,) {
                      return Padding(
                        padding: EdgeInsets.all(size.width*0.005),
                        child: SizedBox(
                          width: (size.width*0.9-(size.width*0.01*(snapshot.data()!["Questions"].length-1)))/snapshot.data()!["Questions"].length,

                          child: Divider(
                            color: (index+1)<count? Colors.green:(index+1)==count?Colors.red:Colors.white70,
                            thickness: size.height*0.005,
                            height: size.height*0.005,


                          ),
                        ),
                      );
                    },),
                ),
                SizedBox(
                  height: size.height*0.6,
                  child: PageView.builder(
                    controller: pageQuestionController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data()?["Questions"].length,
                    itemBuilder: (context, index1) {
                      options.clear();

                      options= List.generate(snapshot.data()?["Questions"][index1]['Options'].length, (index2) => snapshot.data()?["Questions"][index1]['Options'][index2]);
                      return  Padding(
                        padding:  EdgeInsets.all(size.width*0.04),
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width*1,
                              child: AutoSizeText(
                                "${index1+1}.\t ${snapshot.data()!["Questions"][index1]['Question']}",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width*0.06,
                                  color: Colors.white70,
                                ),
                              ),),
                            SizedBox(
                              height: size.height*0.03,
                            ),
                            SizedBox(

                              height: size.height*0.081 * snapshot.data()?["Questions"][index1]['Options'].length,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data()?["Questions"][index1]['Options'].length,
                                itemBuilder:(context, index) {
                                  return Padding(
                                    padding:  EdgeInsets.symmetric(vertical: size.height*0.008,horizontal: size.width*0.04),
                                    child: Container(
                                      width: size.width*0.95,
                                      height: size.height*0.065,
                                      decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(size.width*0.02),
                                        border: Border.all(
                                          color: options[index]==currentChoice[index1]?Colors.green:Colors.white70,
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(options[index],style: TextStyle(
                                          color: options[index]==currentChoice[index1]?Colors.green:Colors.white70,
                                        ),),
                                        trailing:   Radio(
                                          value: options[index],
                                          fillColor: MaterialStateColor.resolveWith((states) => options[index]==currentChoice[index1]?Colors.green:Colors.white70,),
                                          groupValue: currentChoice[index1],
                                          onChanged: (value) {
                                            setState(() {
                                              currentChoice[index1] =options[index];

                                            });
                                          },
                                        ),
                                        onTap: (){
                                          setState(() {
                                            currentChoice[index1] =options[index];

                                          });
                                        },
                                      ),
                                    ),
                                  );

                                },),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
      floatingActionButton: SizedBox(
        width: size.width*0.92,

        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    count> 1?count--:null;
                    pageQuestionController.animateToPage(count-1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                  });

                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width*0.4,size.height*0.045),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                child:Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    SizedBox(width: size.width*0.02,),
                    Text("Previous",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.white),),
                  ],
                ),


              ),
              count== snapshot.data()!["Questions"].length
                  ?
              Container(
                height: size.height*0.045,
                width: size.width*0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                      PageTransition(
                          child: const loading(text: "Please wait...\n We are submiting your feedback."),
                          type: PageTransitionType.bottomToTopJoined,
                          childCurrent: const PsychometricTest(),
                          duration: const Duration(milliseconds: 200)
                      ),
                    );
                    submitResponce().then((value) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          PageTransition(
                              child: PsychoResult(response: value),
                              type: PageTransitionType.bottomToTopJoined,
                            childCurrent: const PsychometricTest(),
                            duration: const Duration(milliseconds: 100)
                          )
                      );

                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child:Text("Submit",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.black),),


                ),
              )
                  :
              Container(
                height: size.height*0.045,
                width: size.width*0.4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.purpleAccent],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white,width: 1.5)
                ),
                child: ElevatedButton(
                  onPressed: (){
                    if(currentChoice[count-1] != ""){
                      setState(() {
                        count< snapshot.data()!["Questions"].length?count++:null;
                        pageQuestionController.animateToPage(count-1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width*0.4, size.height*0.045),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Next",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.black),),
                      const Icon(Icons.arrow_forward_ios,color: Colors.black,)
                    ],
                  ),


                ),
              ),
            ]
        ),
      ),
    )
        :
    const loading(text: "Please wait.");
  }
  fetchTest() async {

    await FirebaseFirestore.instance.collection("Test").doc("LS1").get().then((value) =>
    snapshot =value
    ).whenComplete((){
      currentChoice = List.generate(snapshot.data()!["Questions"].length, (index) => "");
      setState(() {
        loaded=true;
      });
    });

  }

  Future<Map<String,String>> submitResponce() async {
    Map<String,String> feedback={};
    for(int i=0; i < snapshot.data()!["Questions"].length; i++){
      print(currentChoice[i]);
      feedback['Question ${i+1}']=currentChoice[i];
      print(feedback);
    }

    await FirebaseFirestore
        .instance
        .collection("Test")
        .doc("LS1")
        .update({
      "Submitted By" : FieldValue.arrayUnion([usermodel["Email"]]),
      usermodel["Email"].toString().split('@')[0] : feedback
    });

    return feedback;
  }
}
