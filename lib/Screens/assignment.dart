import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/upload_assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Constraints.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/Image_viewer.dart';
import 'Chat_tiles/PdfViewer.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  var checkALLPermissions = CheckPermission();
  bool permissionGranted = false;
  bool docExists = false;
  Directory? directory;
  bool fileAlreadyExists = false;
  final dio = Dio();

  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  bool loaded = false;
  bool nodata = false;
  List<bool> selected = List.filled(usermodel["Subject"].length, false);

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject =" ";
  List<bool> isdownloaded = [];
  List<bool> downloding = [];
  String path = "";
  double percent=0.0;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
      selectedSubject = usermodel["Subject"][0];
      selected[0]=true;
      getdata();
    });

    checkAndRequestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            setState(() {
                              selected = List.filled(subjects.length, false);
                              selected[index] = true;

                              selectedSubject = subjects[index];
                              checkAndRequestPermissions();
                              getdata();
                              print(selectedSubject);
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
        height: size.height,
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
              SizedBox(
                height: size.height * 0.005,
              ),
              loaded && !nodata && permissionGranted
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: SizedBox(
                  height: size.height * 0.7,
                  width: size.width,
                  child: ListView.builder(
                    itemCount: snapshot.data()?["Total_Assignment"],
                    itemBuilder: (context, index) {
                      String newpath = "${path}Assignment-${index + 1}.${snapshot.data()?["Assignment-${index + 1}"]["Document-type"]}";
                      File(newpath).exists().then((value) {
                        if (value) {

                               isdownloaded[index] = true;

                        } else {

                              isdownloaded[index] = false;

                        }
                      });
                      return Padding(
                          padding: EdgeInsets.all( size.height*0.01),
                          child:  InkWell(
                            onTap: (){
                              if(isdownloaded[index]) {
                                if (snapshot.data()?["Assignment-${index +
                                    1}"]["Document-type"] == "pdf") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            PdfViewer(
                                              document:
                                              "${path}Assignment-${index +
                                                  1}.${snapshot
                                                  .data()?["Assignment-${index +
                                                  1}"]["Document-type"]}",
                                              name:
                                              "Assignment-${index + 1}",
                                            ),
                                      ));
                                }
                                else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Image_viewer(path: File(
                                              "${path}Assignment-${index +
                                                  1}.${snapshot
                                                  .data()?["Assignment-${index +
                                                  1}"]["Document-type"]}",),
                                            ),
                                      ));
                                }
                              }

                            },
                            child: Container(

                              height: size.height*0.235,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.black,width: 2)
                              ),
                              child: Column(
                                children: [
                                  Expanded(

                                    child: Container(

                                      height: size.height*0.12,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),

                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: size.height*0.008,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              isdownloaded[index]
                                              ?
                                                  SizedBox(
                                                   height:  size.height * 0.03,
                                                  )
                                                  :
                                              downloding[index]
                                                  ?
                                              Center(
                                                child:
                                                CircularPercentIndicator(
                                                  percent:
                                                  percent,
                                                  radius:
                                                  size.height * 0.04,
                                                  animation: true,
                                                  animateFromLastPercent:
                                                  true,
                                                  curve: accelerateEasing,
                                                  progressColor:
                                                  Colors.green,
                                                  center: Text(
                                                    (percent * 100)
                                                        .toStringAsFixed(
                                                        0),
                                                    style: GoogleFonts
                                                        .openSans(
                                                        fontSize: size
                                                            .height *
                                                            0.024),
                                                  ),
                                                  //footer: const Text("Downloading"),
                                                  backgroundColor:
                                                  Colors.transparent,
                                                ),
                                              )
                                              :

                                              CircleAvatar(
                                                backgroundColor:   Color.fromRGBO(60, 99, 100, 1),
                                                radius: size.height*0.02,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                    setState(() {
                                                      downloding[index] =
                                                      true;
                                                    });

                                                    await dio.download(
                                                      snapshot.data()?["Assignment-${index + 1}"]["Assignment"], newpath,
                                                      onReceiveProgress:
                                                          (count, total) {

                                                        if (count ==
                                                            total) {
                                                          setState(() {
                                                            print(
                                                                "completed");
                                                            isdownloaded[
                                                            index] =
                                                            true;
                                                            downloding[
                                                            index] =
                                                            false;
                                                          });
                                                        } else {
                                                          if(mounted){
                                                            setState(() {
                                                              percent =count/total;
                                                            });
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                      icon: Icon(Icons.file_download_sharp,size: size.height*0.023,color: Colors.white,)
                                                  ),
                                              ),
                                              SizedBox(
                                                width: size.width*0.02,
                                              )
                                            ],
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
                                            "Assignment : ${index+1}",
                                            style: GoogleFonts.courgette(
                                                color: Colors.black,
                                                fontSize: size.height*0.02,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only( left: size.height*0.01,right: size.height*0.008,top: size.height*0.006),
                                      height: size.height*0.107,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        color:  Color.fromRGBO(60, 99, 100, 1),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Assignment : ${index + 1}(${(int.parse(snapshot.data()!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.018,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Deadline :${snapshot.data()?["Assignment-${index + 1}"]["Last Date"]}",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.018,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Before :${snapshot.data()?["Assignment-${index + 1}"]["Time"].toString().substring(10, 15)}",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.018,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              // AutoSizeText(
                                              //   "Assign:${snapshot.data()?["Assignment-${index + 1}"]["Assign-Date"]}",
                                              //   style: GoogleFonts.courgette(
                                              //       color: Colors.black,
                                              //       fontSize: size.height*0.018,
                                              //       fontWeight: FontWeight.w400
                                              //   ),
                                              // ),

                                            ],
                                          ),
                                          // isdownloaded[index]
                                          //     ?
                                          // Container(
                                          //   height: size.height * 0.045,
                                          //   width: size.width * 0.2,
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.transparent,
                                          //       borderRadius:
                                          //       const BorderRadius.all(
                                          //           Radius.circular(20)),
                                          //       border: Border.all(
                                          //           color: Colors.black,
                                          //           width: 1)),
                                          //   child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //           shape:
                                          //           const RoundedRectangleBorder(
                                          //               borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius
                                          //                       .circular(
                                          //                       20))),
                                          //           backgroundColor:
                                          //           Colors.transparent),
                                          //       onPressed: () {
                                          //         if(snapshot.data()?["Assignment-${index + 1}"]["Document-type"]=="pdf"){
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                 builder:
                                          //                     (context) =>
                                          //                     PdfViewer(
                                          //                       document:
                                          //                       "${path}Assignment-${index + 1}.${snapshot.data()?["Assignment-${index + 1}"]["Document-type"]}",
                                          //                       name:
                                          //                       "Assignment-${index + 1}",
                                          //                     ),
                                          //               ));
                                          //         }
                                          //         else{
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                 builder:
                                          //                     (context) =>
                                          //                     Image_viewer(path:File("${path}Assignment-${index + 1}.${snapshot.data()?["Assignment-${index + 1}"]["Document-type"]}",),
                                          //                     ),
                                          //               ));
                                          //         }
                                          //       },
                                          //       child: AutoSizeText(
                                          //         "View",
                                          //         style: GoogleFonts.gfsDidot(
                                          //             fontWeight: FontWeight.w600,
                                          //             fontSize:
                                          //             size.height * 0.025),
                                          //       )),
                                          // )
                                          //     :
                                          // downloding[index]
                                          //     ?
                                          // Center(
                                          //   child:
                                          //   CircularPercentIndicator(
                                          //     percent:
                                          //     percent,
                                          //     radius:
                                          //     size.width * 0.04,
                                          //     animation: true,
                                          //     animateFromLastPercent:
                                          //     true,
                                          //     curve: accelerateEasing,
                                          //     progressColor:
                                          //     Colors.green,
                                          //     center: Text(
                                          //       (percent * 100)
                                          //           .toStringAsFixed(
                                          //           0),
                                          //       style: GoogleFonts
                                          //           .openSans(
                                          //           fontSize: size
                                          //               .height *
                                          //               0.024),
                                          //     ),
                                          //     //footer: const Text("Downloading"),
                                          //     backgroundColor:
                                          //     Colors.transparent,
                                          //   ),
                                          // )
                                          //     :
                                          // Container(
                                          //   height: size.height * 0.045,
                                          //   width: size.width * 0.25,
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.transparent,
                                          //       borderRadius:
                                          //       const BorderRadius.all(
                                          //           Radius.circular(20)),
                                          //       border: Border.all(
                                          //           color: Colors.black,
                                          //           width: 1)),
                                          //   child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //           shape:
                                          //           const RoundedRectangleBorder(
                                          //               borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius
                                          //                       .circular(
                                          //                       20))),
                                          //           backgroundColor:
                                          //           Colors.transparent),
                                          //       onPressed: () async {
                                          //         setState(() {
                                          //           downloding[index] =
                                          //           true;
                                          //         });
                                          //
                                          //         await dio.download(
                                          //           snapshot.data()?["Assignment-${index + 1}"]["Assignment"], newpath,
                                          //           onReceiveProgress:
                                          //               (count, total) {
                                          //
                                          //             if (count ==
                                          //                 total) {
                                          //               setState(() {
                                          //                 print(
                                          //                     "completed");
                                          //                 isdownloaded[
                                          //                 index] =
                                          //                 true;
                                          //                 downloding[
                                          //                 index] =
                                          //                 false;
                                          //               });
                                          //             } else {
                                          //               if(mounted){
                                          //                 setState(() {
                                          //                   percent =count/total;
                                          //                 });
                                          //               }
                                          //             }
                                          //           },
                                          //         );
                                          //       },
                                          //
                                          //       child: AutoSizeText(
                                          //         "Download",
                                          //         style: GoogleFonts.gfsDidot(
                                          //             fontWeight: FontWeight.w600,
                                          //             fontSize:
                                          //             size.height * 0.04),
                                          //       )),
                                          // ),

                                          Container(
                                            height: size.height * 0.045,
                                            width: size.width * 0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1)),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius
                                                                .circular(
                                                                20))),
                                                    backgroundColor:
                                                    Colors.transparent),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        child: AssigmentQuestion(
                                                            selectedSubject: selectedSubject,
                                                            assignmentNumber: index + 1,
                                                          deadline: "${snapshot.data()?["Assignment-${index + 1}"]["Last Date"]}",
                                                        ),
                                                        type: PageTransitionType
                                                            .bottomToTopJoined,
                                                        duration: const Duration(
                                                            milliseconds: 200),
                                                        childCurrent:
                                                        const Assignment(),
                                                      ));
                                                },
                                                child: AutoSizeText(
                                                  "Submit",
                                                  style: GoogleFonts.gfsDidot(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize:
                                                      size.height * 0.03),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )


                                ],
                              ),
                            ),
                          )
                      );
                    },
                  ),
                ),
              )
                  : const SizedBox(
                child: Center(child: Text("No Data Found")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getdata() async {
    await FirebaseFirestore.instance
        .collection("Assignment")
        .doc(
      "${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $selectedSubject",
    )
        .get()
        .then((value) {

      if (value.data() == null) {
        setState(() {
          nodata = true;
        });
      } else {
        setState(() {


          nodata = false;
          snapshot = value;
          isdownloaded = List.generate(
              snapshot.data()?["Total_Assignment"],
                  (index) => false);
          downloding = List.generate(
              snapshot.data()?["Total_Assignment"],
                  (index) => false);


        });
      }
    }).whenComplete(() {
      setState(() {
        loaded = true;
      });
    });
  }

  Future<void> checkAndRequestPermissions() async {
    directory = await getExternalStorageDirectory();

    var permission = await checkALLPermissions.isStoragePermission();
    if(!permission){
      if(await Permission.manageExternalStorage.request().isGranted){
        permission=true;
      }else{
        await Permission.manageExternalStorage.request().then((value) {
          bool check=value.isGranted;
          if(check){permission=true;}});
      }

    }
    if (permission) {
      String? dir = directory?.path.toString().substring(0, 19);
      path = "$dir/Campus Link/$selectedSubject/Assignment/";
      Directory(path).exists().then((value) async {
        if (!value) {
          await Directory(path)
              .create(recursive: true)
              .whenComplete(() => print(">>>>>created"));
        }
      });
      setState(() {
        permissionGranted = true;
      });
    } else {}
  }
}
