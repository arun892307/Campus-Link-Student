import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';

class subjectQuizScore extends StatefulWidget {
   subjectQuizScore({Key? key,required this.subject}) : super(key: key);
  String subject;

  @override
  State<subjectQuizScore> createState() => _subjectQuizScoreState();
}

class _subjectQuizScoreState extends State<subjectQuizScore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:   Center(
            child: AutoSizeText(
              ' Leaderboard Quiz',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          leadingWidth: MediaQuery.of(context).size.width*0.08,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:  Icon(Icons.arrow_back,color: Colors.black,size: MediaQuery.of(context).size.width*0.08,),
          ),
        ),
        body: Container(
            decoration:  const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                ],
              ),
            ),
            child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}").snapshots(),
                  builder: (context, snapshot) {
                    print("${snapshot.data?.data()?["${usermodel["Email"]}"]}");
                    return  snapshot.hasData
                       ?
                       subjectQuizScore_2(snap: snapshot, subject: widget.subject,)
                        :
                        const SizedBox(
                          child: Center(child: Text("No Data Found")),
                        );
                  },
                ),


            ));
  }
}





class subjectQuizScore_2 extends StatefulWidget {
   subjectQuizScore_2({super.key,required this.snap,required this.subject});
   String subject;
   AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap;
  @override
  State<subjectQuizScore_2> createState() => _subjectQuizScore_2State();
}

class _subjectQuizScore_2State extends State<subjectQuizScore_2> {
  List<Map<String,dynamic>>result=[];
  List<Map<String,dynamic>>unattemptedStudents=[];
  late DocumentSnapshot<Map<String, dynamic>>? snapshot;
  bool load=false;
  Map<String,dynamic>allEmailsWithLink={};
  late QuerySnapshot<Map<String, dynamic>> allStudentsData;
  List<Map<String,dynamic>>allEmail=[];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
      snapshot=widget.snap.data;
    });
    fetchEmail().whenComplete(() {
      calculateResult().whenComplete(() {
        setState(() {
          load=true;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return load && result.isNotEmpty
            ?
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
              height: size.height * 0.32,
              child: Row(children: [
                SizedBox(
                  width: size.width * 0.07,
                ),
                SizedBox(
                    width: size.width * 0.214,
                    child: Column(children: [
                      SizedBox(
                          height: ((size.height * 0.12) + (size.width * 0.214)),
                          child: Stack(children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: size.width * 0.107,
                                  child: allEmailsWithLink[result[1]["Email"]]!="null"
                                      ?
                                  CircleAvatar(
                                    radius: size.width * 0.1,
                                    backgroundImage: NetworkImage("${allEmailsWithLink[result[1]["Email"]]}"),
                                  ):
                                  AutoSizeText(
                                    "${result[1]["Name"]}\n ${result[1]["Rollnumber"]}",
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            Positioned(
                                top: ((size.height * 0.12) -
                                    (size.width * 0.03)),
                                left: ((size.width * 0.107) -
                                    (size.width * 0.03)),
                                child: CircleAvatar(
                                    radius: size.width * 0.03,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                        radius: size.width * 0.026,
                                        child: const SizedBox(
                                            child: AutoSizeText(
                                              '2',
                                              textAlign: TextAlign.center,
                                            )))))
                          ])),
                      Center(
                          child: SizedBox(
                              width: size.width * 0.2,
                              child: AutoSizeText(
                                "${result[1]["Name"]}\n ${result[1]["Rollnumber"]}",
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                //minFontSize: size.width * 0.03,
                              ))),
                      AutoSizeText("${result[1]["Score"].toString()} / 10",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 10, 52, 84),
                              fontWeight: FontWeight.w500))
                    ])),
                SizedBox(
                  width: size.width * 0.069,
                ),
                SizedBox(
                    width: size.width * 0.294,
                    child: Column(children: [
                      SizedBox(
                          height:
                          ((size.height * 0.05) + (size.width * 0.294)),
                          child: Stack(children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: CircleAvatar(
                                  radius: size.width * 0.147,
                                  backgroundColor: Colors.black,
                                  child:  allEmailsWithLink[result[0]["Email"]]!="null"
                                      ?
                                  CircleAvatar(
                                    radius: size.width * 0.147,

                                    backgroundImage: NetworkImage("${allEmailsWithLink[result[0]["Email"]]}"),
                                  ):
                                  AutoSizeText(
                                    "${result[0]["Name"]}\n ${result[0]["Rollnumber"]}",
                                    textAlign: TextAlign.center,
                                  ),)),
                            Positioned(
                                top: ((size.height * 0.05) -
                                    (size.width * 0.03)),
                                left: ((size.width * 0.147) -
                                    (size.width * 0.03)),
                                child: CircleAvatar(
                                    radius: size.width * 0.03,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                        radius: size.width * 0.026,
                                        child: const SizedBox(
                                            child: AutoSizeText(
                                              '1',
                                              textAlign: TextAlign.center,
                                            )))))
                          ])),
                      Center(
                          child: SizedBox(
                              width: size.width * 0.24,
                              child: AutoSizeText(
                                "${result[0]["Name"]}\n ${result[0]["Rollnumber"]}",
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                //minFontSize: size.width * 0.03,
                              ))),
                      AutoSizeText("${result[0]["Score"].toString()} / 10",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 10, 52, 84),
                              fontWeight: FontWeight.w500))
                    ])),
                SizedBox(
                  width: size.width * 0.069,
                ),
                SizedBox(
                    width: size.width * 0.214,
                    child: Column(children: [
                      SizedBox(
                        height: ((size.height * 0.12) + (size.width * 0.214)),
                        child: Stack(children: [
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: size.width * 0.107,
                                child:  allEmailsWithLink[result[2]["Email"]]!="null"
                                    ?
                                CircleAvatar(
                                  radius: size.width * 0.1,
                                  backgroundImage: NetworkImage("${allEmailsWithLink[result[2]["Email"]]}"),
                                ):
                                AutoSizeText(
                                  result[2]["Name"],
                                  textAlign: TextAlign.center,
                                ),)),
                          Positioned(
                              top: ((size.height * 0.12) -
                                  (size.width * 0.03)),
                              left: ((size.width * 0.107) -
                                  (size.width * 0.03)),
                              child: CircleAvatar(
                                  radius: size.width * 0.03,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                      radius: size.width * 0.026,
                                      child: const SizedBox(
                                          child: AutoSizeText(
                                            '3',
                                            textAlign: TextAlign.center,
                                          )))))
                        ]),
                      ),
                      SizedBox(
                          width: size.width * 0.2,
                          child: AutoSizeText(
                            "${result[2]["Name"]}\n ${result[2]["Rollnumber"]}",
                            style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            //minFontSize: size.width * 0.03,
                          )),
                      AutoSizeText("${result[2]["Score"].toString()} / 10",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 10, 52, 84),
                              fontWeight: FontWeight.w500))
                    ]))
              ])),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoSizeText("Attempted Students : ${result.length}/${allStudentsData.docs.length}",
                style: GoogleFonts.poppins(
                    color: Colors.amber,
                    fontSize: size.height*0.015
                ),),
              AutoSizeText("Unattempted Students : ${unattemptedStudents.length}/${allStudentsData.docs.length}",
                style: GoogleFonts.poppins(
                    color: Colors.amber,
                    fontSize: size.height*0.015
                ),)
            ],
          ),
          SizedBox(
            height: size.height * 0.022,
          ),
          Column(
              children: [
                SizedBox(
                    height: size.height * 0.095*(result.length),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:result.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(size.height * 0.008),
                          child: SizedBox(
                            height: size.height * 0.08,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.1,
                                  child: Center(
                                      child: AutoSizeText(
                                          "${index+1}",
                                          style: TextStyle(
                                              fontSize: size.height*0.03,
                                              color: Colors.white
                                          )
                                      )),
                                ),
                                Container(
                                    height: size.height * 0.07,
                                    width: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(size.width * 0.08)),
                                      color: const Color.fromARGB(255, 228, 243, 247),
                                    ),
                                    child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: CircleAvatar(
                                              radius: size.width * 0.06,
                                              backgroundColor: Colors.black,
                                              child:  allEmailsWithLink[result[index]["Email"]]!="null"
                                                  ?
                                              CircleAvatar(
                                                radius: size.width * 0.1,
                                                backgroundImage: NetworkImage("${allEmailsWithLink[result[index]["Email"]]}"),
                                              ):
                                              AutoSizeText(
                                                result[index]["Name"],
                                                textAlign: TextAlign.center,
                                              ),),
                                          ),
                                          SizedBox(
                                              width: size.width * 0.45,
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    result[index]["Rollnumber"],
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.045),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  AutoSizeText(
                                                    result[index]["Name"],
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.036),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              )
                                          ),
                                          AutoSizeText("${result[index]["Score"].toString()} / 10",
                                              style: const TextStyle(
                                                  color:Color.fromARGB(255, 10, 52, 84),
                                                  fontWeight: FontWeight.w500)),
                                        ])),
                              ],
                            ),
                          ),
                        );
                      },

                    )
                ),
                Divider(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.03,
                  thickness: MediaQuery.of(context).size.height * 0.003,
                  endIndent: 8,
                  indent: 8,
                ),
                SizedBox(
                    height: size.height * 0.096*(unattemptedStudents.length),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:unattemptedStudents.length,
                      itemBuilder: (context, index) {

                        return Padding(
                          padding: EdgeInsets.all(size.height * 0.008),
                          child: SizedBox(
                            height: size.height * 0.08,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.1,
                                  child: Center(
                                      child: AutoSizeText(
                                        "${index+1}",
                                        style: TextStyle(
                                            fontSize: size.height*0.03,
                                            color: Colors.white
                                        ),
                                      )),
                                ),
                                Container(
                                    height: size.height * 0.07,
                                    width: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(size.width * 0.08)),
                                      color: const Color.fromARGB(255, 228, 243, 247),
                                    ),
                                    child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: CircleAvatar(
                                              radius: size.width * 0.06,
                                              backgroundColor: Colors.black,
                                              child:  allEmailsWithLink[unattemptedStudents[index]["Email"]]!="null"
                                                  ?
                                              CircleAvatar(
                                                radius: size.width * 0.1,
                                                backgroundImage: NetworkImage("${allEmailsWithLink[unattemptedStudents[index]["Email"]]}"),
                                              ):
                                              AutoSizeText(
                                                unattemptedStudents[index]["Name"][0],
                                                textAlign: TextAlign.center,
                                              ),),
                                          ),
                                          SizedBox(
                                              width: size.width * 0.45,
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    unattemptedStudents[index]["Name"],
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.045),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  AutoSizeText(
                                                    unattemptedStudents[index]["Roll-number"],
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.036),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              )
                                          ),
                                          const AutoSizeText("UA",
                                              style: TextStyle(
                                                  color:Colors.red,
                                                  fontWeight: FontWeight.w500)),
                                        ])),
                              ],
                            ),
                          ),
                        );
                      },

                    )
                )
              ])
        ],
      ),
    )
        :
        Container(
          height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.purpleAccent,
                  ],
                )
            ),
            child: const Center(child: Text("No Data Found")));
  }
  Future<void> calculateResult()
  async {
    result.clear();
    for(var email in  allEmail)
    {
      print("Email is present : $email");
      if(snapshot?.data()?["${email["Email"]}"]!=null)
      {
        Map<String,dynamic>data={};
        data["Name"]=email["Name"];
        data["Rollnumber"]=email["Roll-number"];
        data["Score"]=snapshot?.data()?["${email["Email"]}"]["Score"];
        data["Quiz-Time"]=snapshot?.data()?["${email["Email"]}"]["Time"];
        data["Email"]=email["Email"];
        result.add(data);
        unattemptedStudents.removeWhere((element) => element["Email"]==email["Email"]);
      }
      else{
        print("Note Present :${email["Email"]}");
      }
    }


    // Sort the map based on timeStamp and Quiz Sore ....

    print("....................Before$result");

    result.sort((a, b) {
      if(a["Score"]==b["Score"])
      {
        return a["Quiz-Time"].compareTo(b["Quiz-Time"]);
      }
      else{
        return a["Score"].compareTo(b["Score"]);
      }
    },);
    int s=0;
    int e=result.length-1;
    while(s<e)
    {
      var temp =result[s];
      result[s]=result[e];
      result[e]=temp;
      s++;
      e--;
    }



  }

  Future<void> fetchEmail()
  async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: usermodel["University"])
        .where("College",isEqualTo: usermodel["College"])
        .where("Branch",isEqualTo: usermodel["Branch"])
        .where("Course",isEqualTo: usermodel["Course"])
        .where("Year",isEqualTo: usermodel["Year"])
        .where("Section",isEqualTo: usermodel["Section"])
        .where("Subject",arrayContains: widget.subject).get().then((value) {

      setState(() {
        allStudentsData=value;
      });
    }).whenComplete(() {
      setState(() {


        for(int i=0;i<allStudentsData.docs.length;i++)
        {

          allEmailsWithLink["${allStudentsData.docs[i]["Email"]}"]=allStudentsData.docs[i]["Profile_URL"]!=null?"${allStudentsData.docs[i]["Profile_URL"]}":"null";
          unattemptedStudents.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

          allEmail.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

        }

      });
    });

  }


}

