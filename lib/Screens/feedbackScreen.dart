import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class feedbackQuiz extends StatefulWidget {
  const feedbackQuiz({super.key,});
  @override
  State<feedbackQuiz> createState() => _feedbackQuizState();
}

class _feedbackQuizState extends State<feedbackQuiz> {
  var count=1;

  List<String> currentChoice= [];
  var currentSubject='';
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  late DocumentSnapshot<Map<String, dynamic>> teacherBackTrack;
  PageController pageController = PageController();
  PageController pageQuestionController = PageController();
  int weekNumber=0;
  List<String>options=[];
  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    final firstJan = DateTime(now.year, now.month, 1);
    weekNumber = weeksBetween( firstJan,now);
    fetchFeedback();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(


        color: Color.fromRGBO(17, 22, 44, 1),
      ),
      child:
      loaded
          ?
      PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: size.height*0.1,
              titleSpacing: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Subject for feedback',style: TextStyle(fontSize: size.width*0.05,color: Colors.white70),),

                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SizedBox(

              height: size.height*0.6,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: usermodel["Subject"].length,
                itemBuilder:(context, index) {
                return Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height*0.008,horizontal: size.width*0.04),
                  child: Container(
                    width: size.width*0.95,
                    height: size.height*0.065,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(size.width*0.02),
                      border: Border.all(
                        color: usermodel["Subject"][index]==currentSubject?Colors.green:Colors.white70,
                      ),
                    ),
                    child: ListTile(
                      title: Text(usermodel["Subject"][index],style: TextStyle(
                        color: usermodel["Subject"][index]==currentSubject?Colors.green:Colors.white70,
                      ),),
                      trailing:   Radio(

                        fillColor: MaterialStateColor.resolveWith((states) => usermodel["Subject"][index]==currentSubject?Colors.green:Colors.white70,),
                        value: usermodel["Subject"]![index],
                        groupValue: currentSubject,
                        onChanged: (value) {
                          setState(() {
                            currentSubject =usermodel["Subject"][index];

                          });
                        },
                      ),
                      onTap: (){
                        setState(() {
                          currentSubject =usermodel["Subject"][index];

                        });
                      },
                    ),
                  ),
                );

              },),
            ),
            floatingActionButton: Container(
              height: size.height * 0.048,
              width: size.width * 0.25,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.purpleAccent],
                  ),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black, width: 2)),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    if(currentSubject != ""){
                      backtrack().whenComplete(() async {
                        late DocumentSnapshot<Map<String, dynamic>> doc;
                        await FirebaseFirestore
                            .instance
                            .collection("Teachers Feedback")
                            .doc(teacherBackTrack.data()!["Email"])
                            .collection("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $currentSubject")
                            .doc("${DateTime.now().month}-$weekNumber").get().then((value) {
                          doc=value;
                        }).whenComplete(() {
                          if(doc.data() == null){
                            pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear);
                            setState(() {});

                          }
                          else{
                            if(! doc.data()?['Submitted By'].contains(usermodel['Email'])){
                              pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);

                            }
                            else{
                              InAppNotifications.instance
                                ..titleFontSize = 14.0
                                ..descriptionFontSize = 14.0
                                ..textColor = Colors.black
                                ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                ..shadow = true
                                ..animationStyle = InAppNotificationsAnimationStyle.scale;
                              InAppNotifications.show(
                                // title: '',
                                duration: const Duration(seconds: 2),
                                description: "You already submitted last week feedback for $currentSubject. Come back next week.",
                                // leading: const Icon(
                                //   Icons.error_outline_outlined,
                                //   color: Colors.red,
                                //   size: 55,
                                // )
                              );
                            }
                            setState(() {});
                          }



                        });
                      });

                    }
                  },
                  child: AutoSizeText("Next",style: GoogleFonts.poppins(
                    fontSize: size.width*0.044,
                    fontWeight: FontWeight.w500,
                  ),)),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white70,)),
              title: AutoSizeText('Feedback',
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
                            Text('/${snapshot.data()!["Feedback Questions"].length}',style: TextStyle(fontSize:size.width*0.07,fontWeight:FontWeight.w600,color: Colors.white60),),
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
                          itemCount: snapshot.data()!["Feedback Questions"].length ,
                          itemBuilder:(context, index,) {
                            return Padding(
                              padding: EdgeInsets.all(size.width*0.005),
                              child: SizedBox(
                                width: (size.width*0.9-(size.width*0.01*(snapshot.data()!["Feedback Questions"].length-1)))/snapshot.data()!["Feedback Questions"].length,

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
                          itemCount: snapshot.data()?["Feedback Questions"].length,
                          itemBuilder: (context, index1) {
                            options.clear();

                            options= List.generate(snapshot.data()?["Feedback Questions"][index1]['Options'].length, (index2) => snapshot.data()?["Feedback Questions"][index1]['Options'][index2]);
                            return  Padding(
                              padding:  EdgeInsets.all(size.width*0.04),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: size.width*1,
                                      child: AutoSizeText(
                                          "${index1+1}.\t ${snapshot.data()!["Feedback Questions"][index1]['Question']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: size.width*0.06,
                                          color: Colors.white70,
                                        ),
                                      ),),
                                  SizedBox(
                                    height: size.height*0.03,
                                  ),
                                  SizedBox(

                                    height: size.height*0.081 * snapshot.data()?["Feedback Questions"][index1]['Options'].length,
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data()?["Feedback Questions"][index1]['Options'].length,
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
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
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
                        minimumSize: Size(size.width*0.01,size.height*0.045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child:Row(
                        children: [
                          const Icon(Icons.arrow_back),
                          SizedBox(width: size.width*0.02,),
                          Text("Previous",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.white),),
                        ],
                      ),


                    ),
                    count== snapshot.data()!["Feedback Questions"].length
                        ?
                    Container(
                      height: size.height*0.04,
                      width: size.width*0.35,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context,
                              PageTransition(
                                  child: const loading(text: "Please wait...\n We are submiting your feedback."),
                                  type: PageTransitionType.bottomToTopJoined,
                                  childCurrent: const feedbackQuiz(),
                                duration: const Duration(milliseconds: 200)
                              ),
                          );
                          submitResponce().whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);

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
                      height: size.height*0.04,
                      width: size.width*0.3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          if(currentChoice[count-1] != ""){
                            setState(() {
                              count< snapshot.data()!["Feedback Questions"].length?count++:null;
                              pageQuestionController.animateToPage(count-1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child:Text("Next",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.black),),


                      ),
                    ),
                  ]
              ),
            ),
          ),
        ],
      )
          :
      const loading(text: "Loading Question please wait....")
    );
  }
  fetchFeedback() async {

    await FirebaseFirestore.instance.collection("Feedback").doc("Feedback").get().then((value) =>
    snapshot =value
    ).whenComplete((){
      currentChoice = List.generate(snapshot.data()!["Feedback Questions"].length, (index) => "");
      setState(() {
        loaded=true;
      });
    });

  }
  Future<void> backtrack() async {
    await FirebaseFirestore.instance.collection("Teachers back track").doc(
      "${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $currentSubject"
    ).get().then((value){
      teacherBackTrack=value;
    }).whenComplete((){
      print("back track ${teacherBackTrack.data()?['Email']}");
    });

  }
  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  Future<void> submitResponce() async {
    Map<String,String> feedback={};
    for(int i=0; i < snapshot.data()!["Feedback Questions"].length; i++){
    print(currentChoice[i]);
    feedback['Question ${i+1}']=currentChoice[i];
    print(feedback);
  }

    final doc = await FirebaseFirestore
        .instance
        .collection("Teachers Feedback")
        .doc(teacherBackTrack.data()!["Email"])
        .collection("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $currentSubject")
        .doc("${DateTime.now().month}-$weekNumber").get();



    doc.data() == null
        ?
    await FirebaseFirestore
        .instance
        .collection("Teachers Feedback")
        .doc(teacherBackTrack.data()!["Email"])
        .collection("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $currentSubject")
        .doc("${DateTime.now().month}-$weekNumber").set({
      "Submitted By" : FieldValue.arrayUnion([usermodel["Email"]]),
      "Feedback" : FieldValue.arrayUnion([feedback])
    })
        :
    await FirebaseFirestore
        .instance
        .collection("Teachers Feedback")
        .doc(teacherBackTrack.data()!["Email"])
        .collection("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $currentSubject")
        .doc("${DateTime.now().month}-$weekNumber").update({
      "Submitted By" : FieldValue.arrayUnion([usermodel["Email"]]),
      "Feedback" : FieldValue.arrayUnion([feedback])
    });


  }

}
