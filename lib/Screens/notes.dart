

import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Constraints.dart';
import 'QuizScore.dart';
import 'QuizScreen.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/PdfViewer.dart';
import 'SubjectQuizScore.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  var checkALLPermissions = CheckPermission();
  bool permissionGranted=false;
  bool docExists=false;
  Directory? directory;
  bool fileAlreadyExists=false;
  DateTime currDate=DateTime.now();

  int ind=0;
  bool a=true;

  bool ispdfExpanded=false;
  final dio=Dio();

  double percent=0.0;
  String filePath="";
  //String selectedSubject="DBMS";

  List<bool>isExpanded=[];
  List<bool>isDownloaded=[];
  List<bool>isDownloading=[];


  List<bool> selected = List.filled(usermodel["Subject"].length, false);

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];


  List<PdfController> pdfControllers=[];
  List<Uint8List> imageBytes=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndRequestPermissions();
    checkExists();
    setState(() {
      selected[0]=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(size.width*0.09);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: size.height*0.11,
          flexibleSpace: SizedBox(
            height: size.height * 0.11,
            width: size.width * 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subjects.length,
              padding: EdgeInsets.only(top: size.height*0.01),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.016,
                          right: size.width * 0.016),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              var preIndex = index;

                              setState(() {
                                docExists=false;
                                selected =
                                    List.filled(subjects.length, false);
                                selected[index] = true;
                                // previousIndex = index;
                                print(subjects[index]);
                                selectedSubject = subjects[index];
                                checkExists();

                              });
                            },
                            child: Container(
                              height: size.height * 0.068,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   colors: [
                                  //     Color.fromRGBO(169, 169, 207, 1),
                                  //     // Color.fromRGBO(86, 149, 178, 1),
                                  //     Color.fromRGBO(189, 201, 214, 1),
                                  //     //Color.fromRGBO(118, 78, 232, 1),
                                  //     Color.fromRGBO(175, 207, 240, 1),
                                  //
                                  //     // Color.fromRGBO(86, 149, 178, 1),
                                  //     Color.fromRGBO(189, 201, 214, 1),
                                  //     Color.fromRGBO(169, 169, 207, 1),
                                  //   ],
                                  // ),
                                  shape: BoxShape.circle,
                                  border: selected[index]
                                      ? Border.all(
                                      color: Colors.greenAccent, width: 2)
                                      : Border.all(
                                      color: Colors.white,
                                      width: 1)),
                              child: Center(
                                child: AutoSizeText(
                                  "${subjects[index][0]}",
                                  style: GoogleFonts.openSans(
                                    fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: selected[index]
                                          ? Colors.greenAccent
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.006,
                          ),
                          AutoSizeText(
                            "${subjects[index]}",
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                                color: selected[index]
                                    ? Colors.greenAccent
                                    : Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: SizedBox(
          height: size.height*0.75,
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Divider(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.01,
                  thickness: MediaQuery.of(context).size.height * 0.003,
                  endIndent: 8,
                  indent: 8,
                ),
                docExists
                    ?
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: StreamBuilder
                    (
                    stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
                    {
                      return  snapshot.hasData
                          ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data["Total_Notes"],
                          itemBuilder: (context, index) {
                            Timestamp deadline=snapshot.data["Notes-${index+1}"]["Deadline"] ?? Timestamp(0, 0);
                            String? dir=directory?.path.toString().substring(0,19);
                            String path="$dir/Campus Link/${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";

                            File newPath=File("${path}${snapshot.data["Notes-${index+1}"]["File_Name"]}");
                            newPath.exists().then((value) async  {
                              if(!value)
                              {
                                if(mounted)
                                  {
                                    setState(() {
                                      isDownloaded[index]=false;
                                    });
                                  }

                              }
                              else{

                                  if(mounted)
                                    {
                                      setState(() {

                                        isDownloaded[index]=true;
                                      });
                                    }

                               /* pdfControllers.add(PdfController(document: PdfDocument.openFile("$path${snapshot.data["Notes-${index+1}"]["File_Name"]}")));
                                PdfDocument doc = await pdfControllers[index].document;
                                  print("..........index---- ${index}");
                                PdfPage page = await doc.getPage(1).whenComplete(() => print("..............Complettd}"));
                                  PdfPageImage? image = await page.render(
                                      width: 400,
                                      height: 400,
                                      format: PdfPageImageFormat.png,
                                      backgroundColor: "#FFFFFF");
                                  imageBytes.add(image!.bytes);
                                  print("........${imageBytes.length}");
                                  await page.close();*/

                              }
                            });
                            return Padding(
                              padding:  EdgeInsets.all(size.width*0.032),
                              child: Container(
                                width: size.width*0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: radiusGeomentry,
                                    border: Border.all(color:const Color.fromRGBO(56, 33, 101,1),width: 3)
                                ),
                                child: Column(

                                  children: [
                                    SizedBox(
                                      height: size.height*0.11,
                                      width: size.width*0.93,
                                      child: Padding(
                                          padding:  EdgeInsets.only(top:size.height*0.01,left:size.height*0.01,right:size.height*0.01),
                                          child: InkWell(
                                            onTap: (){
                                              if(isDownloaded[index])
                                              {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: PdfViewer(document: newPath.path,name:snapshot.data["Notes-${index+1}"]["File_Name"] ),
                                                    type: PageTransitionType.bottomToTopJoined,
                                                    duration: const Duration(milliseconds: 200),
                                                    alignment: Alignment.bottomCenter,
                                                    childCurrent: const Notes(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:BorderRadius.only(
                                                      topLeft: Radius.circular(size.width*0.02),
                                                      topRight: Radius.circular(size.width*0.02)),
                                                 /* image: DecorationImage(
                                                    image: NetworkImage("${snapshot.data["Notes-${index+1}"]["thumbnailURL"]}",
                                                    ),fit: BoxFit.cover,
                                                  )*/
                                              ),
                                              child:Center(
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),
                                                AutoSizeText(
                                                  selectedSubject,
                                                  style: GoogleFonts.courgette(
                                                      color: Colors.black,
                                                      fontSize: size.height*0.02,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  "Notes : ${index + 1}",
                                                  style: GoogleFonts.courgette(
                                                      color: Colors.black,
                                                      fontSize: size.height*0.023,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),),
                                          )
                                      ),
                                    ),
                                    AnimatedContainer(
                                      height: isExpanded[index] ? size.height*0.24 :size.height*0.14,
                                      width:size.width*0.98,
                                      duration: const Duration(milliseconds: 1),
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(56, 33, 101,1),
                                          borderRadius: BorderRadius.circular(size.width*0.068)

                                      ),
                                      child: SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: size.height*0.018,
                                            ),
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.only(
                                                    bottomLeft: Radius.circular(size.width*0.1),
                                                    bottomRight: Radius.circular(size.width*0.12)),),
                                              title: SizedBox(
                                                  height: size.height*0.088,
                                                  width: size.width*0.75,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      FittedBox(
                                                        fit:BoxFit.fill,
                                                        child: AutoSizeText(
                                                          snapshot.data["Notes-${index+1}"]["File_Name"]!=null
                                                              ?
                                                          snapshot.data["Notes-${index+1}"]["File_Name"].toString()
                                                              :
                                                          "",
                                                          style: GoogleFonts.exo(
                                                              fontSize: size.height*0.02,
                                                              color: Colors.white70,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                            maxLines: 1,),
                                                      ),
                                                      SizedBox(
                                                        height: size.height*0.0075,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          FittedBox(
                                                            fit: BoxFit.fill,
                                                            child: AutoSizeText(
                                                              snapshot.data["Notes-${index+1}"]["File_Size"]!=null
                                                                  ?
                                                              "Size:${(int.parse(snapshot.data["Notes-${index+1}"]["File_Size"].toString())/1048576).toStringAsFixed(2)} MB"
                                                                  :
                                                              "",
                                                              style: GoogleFonts.exo(
                                                                  fontSize: size.height*0.016,
                                                                  color: Colors.white70,
                                                                  fontWeight: FontWeight.w500),),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.fill,
                                                            child: AutoSizeText(
                                                              snapshot.data["Notes-${index+1}"]["Stamp"]!=null
                                                                  ?
                                                              "Date: ${(snapshot.data["Notes-${index+1}"]["Stamp"].toDate()).toString().split(" ")[0]}"
                                                                  :
                                                              "",
                                                              style: GoogleFonts.exo(
                                                                  fontSize: size.height*0.016,
                                                                  color: Colors.white70,
                                                                  fontWeight: FontWeight.w500),),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: size.height*0.008,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          /*AutoSizeText(
                                                            snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                                ?
                                                            "Status : Submit"
                                                                :
                                                            "Status : Panding",
                                                            style: GoogleFonts.exo(
                                                                fontSize: size.height*0.016,
                                                                color: Colors.white70,
                                                                fontWeight: FontWeight.w500),),*/
                                                          FittedBox(
                                                            fit:BoxFit.fill,
                                                            child: AutoSizeText(
                                                              snapshot.data["Notes-${index+1}"]["Stamp"]!=null
                                                                  ?
                                                              "Deadline : ${(snapshot.data["Notes-${index+1}"]["Stamp"].toDate()).toString().split(" ")[0]} ${snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")?"( Submit )":"( Pending )"}"
                                                                  :
                                                              "",
                                                              style: GoogleFonts.exo(
                                                                  fontSize: size.height*0.016,
                                                                  color: Colors.white70,
                                                                  fontWeight: FontWeight.w500),),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                              ),
                                              leading:Container(
                                                  height: size.width*0.07,
                                                  width: size.width*0.07,
                                                  decoration:  const BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    /*image:DecorationImage(
                                                image: fileAlreadyExists
                                                    ?
                                                const AssetImage("assets/icon/pdf.png"):
                                                const AssetImage("assets/icon/download-button.png"),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center, )*/
                                                  ),
                                                  child:isDownloaded[index]
                                                      ?
                                                  Image.asset("assets/icon/pdf.png")
                                                      :
                                                  isDownloading[index]
                                                      ?
                                                  Center(
                                                    child: Center(
                                                      child: CircularPercentIndicator(
                                                        percent: percent,
                                                        radius: size.width*0.035,
                                                        animation: true,
                                                        animateFromLastPercent: true,
                                                        curve: accelerateEasing,
                                                        progressColor: Colors.green,
                                                        center: Text((percent*100).toDouble().toStringAsFixed(0),style: GoogleFonts.openSans(fontSize: size.height*0.024),),
                                                        //footer: const Text("Downloading"),
                                                        backgroundColor: Colors.transparent,
                                                      ),
                                                    ),
                                                  )
                                                      :
                                                  InkWell(
                                                      onTap: ()
                                                      async {
                                                        setState(() {
                                                          isDownloading[index]=true;
                                                        });

                                                        String path="$dir/Campus Link/${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";

                                                        File newPath=File("$path${snapshot.data["Notes-${index+1}"]["File_Name"]}");
                                                        await newPath.exists().then((value) async {
                                                          if(!value)
                                                          {
                                                            print(".Start");
                                                            await dio.download(snapshot.data["Notes-${index+1}"]["Pdf_URL"],newPath.path,onReceiveProgress: (count, total) {
                                                              if(count==total){
                                                                setState(() {
                                                                  filePath=newPath.path;
                                                                  isDownloaded[index]=true;
                                                                  isDownloading[index]=false;
                                                                });
                                                              }
                                                              else{
                                                                setState(() {
                                                                  percent = (count/total);
                                                                });
                                                              }
                                                            },);
                                                          }
                                                          else{
                                                            print("..Already Exsist");
                                                          }
                                                        });

                                                      },
                                                      child: Icon(Icons.download,color: Colors.black87,size:size.width*0.1))

                                              ),

                                              // subtitle: AutoSizeText('DEADLIiNE',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                                              trailing:  SizedBox(
                                                height: size.width * 0.12,
                                                width: size.width * 0.12,
                                                child: FloatingActionButton(
                                                  backgroundColor:
                                                      (currDate.year>deadline.toDate().year ||
                                                          currDate.month>deadline.toDate().month ||
                                                          currDate.day>deadline.toDate().day ||
                                                          currDate.hour>deadline.toDate().hour ||
                                                          currDate.minute>deadline.toDate().minute ||
                                                          currDate.second>deadline.toDate().second) &&
                                                      (snapshot.data["Notes-${index+1}"]["Quiz_Created"]==true)
                                                      ?
                                                      Colors.red
                                                      :
                                                      Colors.lightBlueAccent,
                                                  elevation: 0,
                                                  onPressed: (){
                                                    setState(() {
                                                      isExpanded[index]= !isExpanded[index];
                                                    });

                                                  },
                                                  child:Image.asset("assets/icon/speech-bubble.png",
                                                    width: size.height*0.045,
                                                    height: size.height*0.045,),
                                                ),
                                              ),

                                            ),
                                            isExpanded[index]
                                                ?
                                            Padding(
                                                padding: EdgeInsets.only(top: size.height*0.014),
                                                child:  snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                    ?
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width*0.72,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          AutoSizeText(
                                                            "Score :${snapshot.data["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"].toString()}/10",
                                                            style: GoogleFonts.poppins(
                                                              color: Colors.white70,
                                                              fontSize: size.height*0.015
                                                            ),
                                                          ),
                                                          LinearProgressIndicator(
                                                            minHeight: size.height*0.01,
                                                            backgroundColor: Colors.black,
                                                            color: Colors.green,
                                                            //borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                            value: snapshot.data["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"]/10,
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                    SizedBox(height: size.height*0.015,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height: size.height * 0.046,
                                                          width: size.width * 0.34,
                                                          decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purpleAccent,
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                              border: Border.all(color: Colors.black, width: 2)
                                                          ),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.transparent,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                              ),

                                                              onPressed: (){

                                                              },
                                                              child: AutoSizeText(
                                                                "Submitted",
                                                                style: GoogleFonts.openSans(
                                                                    fontSize: size.height * 0.022,
                                                                    color: Colors.white
                                                                ),


                                                              )),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.046,
                                                          width: size.width * 0.34,
                                                          decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purpleAccent,
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      size.width * 0.035)),
                                                              border: Border.all(
                                                                  color: Colors.black, width: 2)
                                                          ),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors
                                                                      .transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(
                                                                          Radius.circular(size
                                                                              .width * 0.035)))
                                                              ),

                                                              onPressed: () {

                                                                Navigator.push(context,
                                                                    PageTransition(
                                                                        child: Quizscore(
                                                                          quizId: index + 1, selectedSubject: selectedSubject,),
                                                                        type: PageTransitionType
                                                                            .bottomToTopJoined,
                                                                        childCurrent: const Notes(),
                                                                        duration: const Duration(
                                                                            milliseconds: 300)
                                                                    )
                                                                );
                                                              },
                                                              child: FittedBox(
                                                                fit: BoxFit.cover,
                                                                child: AutoSizeText(
                                                                  "Leaderboard",
                                                                  style: GoogleFonts.openSans(
                                                                      fontSize: size.height * 0.022,
                                                                      color: Colors.white
                                                                  ),


                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                                    :
                                                snapshot.data["Notes-${index+1}"]["Quiz_Created"]==true
                                                    ?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&
                                                      snapshot.data["Notes-${index+1}"]["Submitted by"]
                                                          .contains("${usermodel["Email"]
                                                          .toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                      ?
                                                  Container(
                                                    height: size.height * 0.046,
                                                    width: size.width * 0.34,
                                                    decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            Colors.blue,
                                                            Colors.purpleAccent,
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                        border: Border.all(color: Colors.black, width: 2)
                                                    ),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.transparent,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                        ),

                                                        onPressed: (){

                                                        },
                                                        child: AutoSizeText(
                                                          
                                                          "Submitted",
                                                          style: GoogleFonts.openSans(
                                                              fontSize: size.height * 0.022,
                                                              color: Colors.white
                                                          ),


                                                        )),
                                                  )
                                                  :
                                                  Container(
                                                    height: size.height * 0.046,
                                                    width: size.width * 0.34,
                                                    decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            Colors.blue,
                                                            Colors.purpleAccent,
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                        border: Border.all(color: Colors.black, width: 2)
                                                    ),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.transparent,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                        ),

                                                        onPressed: (){

                                                          Navigator.push(context,
                                                              PageTransition(
                                                                  child: QuizScreen(subject: selectedSubject, notesId: index+1,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .bottomToTopJoined,
                                                                  childCurrent: const Notes(),
                                                                  duration: const Duration(
                                                                      milliseconds: 300)
                                                              )
                                                          );

                                                        },
                                                        child: AutoSizeText(

                                                          "Take Quiz",
                                                          style: GoogleFonts.openSans(
                                                              fontSize: size.height * 0.022,
                                                              color: Colors.white
                                                          ),


                                                        )),
                                                  ), 
                                                  Container(
                                                    height: size.height * 0.046,
                                                    width: size.width * 0.34,
                                                    decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            Colors.blue,
                                                            Colors.purpleAccent,
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                size.width * 0.035)),
                                                        border: Border.all(
                                                            color: Colors.black, width: 2)
                                                    ),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors
                                                                .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(
                                                                    Radius.circular(size
                                                                        .width * 0.035)))
                                                        ),

                                                        onPressed: () {
                                                          Navigator.push(context,
                                                              PageTransition(
                                                                  child: Quizscore(
                                                                    quizId: index + 1, selectedSubject: selectedSubject,),
                                                                  type: PageTransitionType
                                                                      .bottomToTopJoined,
                                                                  childCurrent: const Notes(),
                                                                  duration: const Duration(
                                                                      milliseconds: 300)
                                                              )
                                                          );
                                                        },
                                                        child: AutoSizeText(
                                                          "Leaderboard",
                                                          style: GoogleFonts.openSans(
                                                              fontSize: size.height * 0.022,
                                                              color: Colors.white
                                                          ),


                                                        )),
                                                  ),
                                                ],
                                              )
                                                    :
                                                Container(
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.45,
                                                  decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.blue,
                                                          Colors.purpleAccent,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                      border: Border.all(color: Colors.black, width: 2)
                                                  ),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                      ),

                                                      onPressed: (){

                                                      },
                                                      child: AutoSizeText(
                                                        "Unavailable",
                                                        style: GoogleFonts.openSans(
                                                            fontSize: size.height * 0.022,
                                                            color: Colors.white
                                                        ),


                                                      )),
                                                )
                                            ):
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          },),
                      )
                          :
                      const SizedBox(
                        child: Center(child: Text("No Data Found")),
                      );
                    },),
                )
                    :
                Center(
                    child: AutoSizeText("No data Found Yet",
                      style: GoogleFonts.poppins(
                          color: Colors.black26,
                          fontSize: size.height*0.03
                      ),))
              ],
            ),
          ),
        ),
      floatingActionButton: docExists
      ?
      Container(
        height: size.height * 0.046,
        width: size.width * 0.372,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.purpleAccent,
              ],
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(
                    size.width * 0.035)),
            border: Border.all(
                color: Colors.black, width: 2)
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .all(
                        Radius.circular(size
                            .width * 0.035)))
            ),

            onPressed: () {
              Navigator.push(context,
                  PageTransition(
                      child:  subjectQuizScore(subject: selectedSubject,),
                      type: PageTransitionType
                          .bottomToTopJoined,
                      childCurrent: const Notes(),
                      duration: const Duration(
                          milliseconds: 300)
                  )
              );
            },
            child: FittedBox(
              fit: BoxFit.cover,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.leaderboard_sharp,color: Colors.red),
                  SizedBox(
                    width: size.width*0.02,
                  ),
                  AutoSizeText(
                    "Leaderboard",
                    style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
            )),
      )
      :
      const SizedBox()


    );

  }
  Future<void> checkAndRequestPermissions() async {
    directory = await getExternalStorageDirectory();
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      String? dir = directory?.path.toString().substring(0, 19);
      String path = "$dir/Campus Link/${usermodel["University"].split(
          " ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"]
          .split(" ")[0]} ${usermodel["Branch"].split(
          " ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";
      Directory(path).exists().then((value) async {
        if (!value) {
          await Directory(path).create(recursive: true);
        }
      });
      setState(() {
        permissionGranted = true;
      });
    }
    else {

    }
  }

  Future<void>checkExists()
  async {
    await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject")
        .get().then((value) {
      if(value.exists)
      {
          setState(() {
            isExpanded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
            isDownloaded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
            isDownloading=List.generate(value.data()?["Total_Notes"], (index) =>  false);
            docExists=true;
          });
      }
      else{
        setState(() {
          docExists=false;
        });
      }

    });
  }

}

