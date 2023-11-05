import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
class PsychoResult extends StatefulWidget{
  const PsychoResult({super.key, required this.response});
  final Map<String, String> response;
  @override
  State<PsychoResult> createState() =>_pieChart();

}
class _pieChart extends State<PsychoResult>{
  late Map<String, double> BigdataMap ;

  List<Color> BigColorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
  ];
  Map<String,double> AttendancedataMap={
    "May":55,
    "june":16,
    "july":36
  };
  List<Color> SmallPieChartcolorList=[
  const Color(0xffD95AF3),
  const Color(0xff3EE094),
  const Color(0xff3398F6),
];
  Map<String,double> MarksdataMap={
    "Maths":55,
    "DAA":16,
    "Compiler":36
  };
  Map<String,double> AssignmentdataMap={
    "Maths":55,
    "DAA":16,
    "Compiler":36

  };
  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  bool a=true;
  bool b=false;
  bool c=false;
  bool loaded=false;
  BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(21);
  List<String> character=['Visual',"Auditory","Kinesthetic"];
  List<String> visula=[
    "Learn best by seeing information.",
    "Can easily recall printed information in the form of numbers, words, phrases, or sentences.",
    "Can easily understand and recall information presented in pictures, charts, or diagrams.",
    "Have strong visualization skills and can look up (often up to the left) and “see” information.",
    "Can make “movies in their minds” of information they are reading.",
    "Have strong visual-spatial skills that involve sizes, shapes, textures, angles and dimensions.",
    "Pay close attention and learn to interpret body language (facial expressions, eyes, stance).",
    "Have keen awareness of aesthetics, the beauty of the physical environment, and visual media.",
  ];
  List<String> audi=[
    "Learn best by hearing information.",
    "Can accurately remember details of information heard in conversations or lecture.",
    "Have strong language skills that include well-developed vocabularies and appreciation of words.",
    "Have strong oral communication skills that enable them to carry on conversations and be articulate.",
    "Have “finely tuned ears” and may find learning a foreign language relatively easy.",
    "Hear tones, rhythms, and notes of music and often have exceptional musical talents.",
  ];
  List<String> kine=[
    "Learn best by using their hands (“Hands-on” learning) or by full body movement.",
    "Learn best by doing.",
    "Learn well in activities that involve performing (athletes, actors, dancers)",
    "Work well with their hands in areas such as repair work, sculpting, art, or working with tools.",
    "Are well-coordinated with a strong sense of timing and body movements.",
    "Often wiggle, tap their feet, or move their legs when they sit.",
    "Often were labeled as “hyperactive”.",

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),

            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: const Text("Learning style test result"),
        ),
        body: Padding(
          padding: EdgeInsets.all(size.width*0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height*0.01,
              ),
              Text("Overall Performance",style: GoogleFonts.exo2(fontSize: size.height*0.03,fontWeight: FontWeight.w500),),
              SizedBox(height:size.height*0.01),
              PieChart(
                dataMap: BigdataMap,
                  colorList: BigColorList,
                //gradientList: gradientList,
                chartRadius: size.height*0.2,
                animationDuration: const Duration(seconds: 2),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValuesInPercentage: true,
                ),
                initialAngleInDegree: -90,
                legendOptions: LegendOptions(
                  showLegends:true,
                  legendShape:BoxShape.rectangle,
                  legendTextStyle: GoogleFonts.exo(fontWeight:FontWeight.w600,fontSize: size.height*0.015)
                ),


              ),
              SizedBox(height: size.height*0.02),
              Text("Characteristics",style: GoogleFonts.exo2(fontSize: size.height*0.03,fontWeight: FontWeight.w500),),
              Expanded(
                  child: ListView.builder(
                    itemCount: character.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(character[index],style: GoogleFonts.exo2(fontSize: size.height*0.023,fontWeight: FontWeight.w500),),
                          Container(
                            height: size.height*0.3,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.black,width: 1.5)
                            ),
                            margin: EdgeInsets.symmetric(vertical: size.height*0.01),
                            padding: EdgeInsets.all(size.width*0.02),
                            child: ListView.builder(
                              itemCount: index==0 ? visula.length : index==1 ? audi.length : kine.length,
                              itemBuilder: (context, index1) {
                                return Padding(
                                  padding: EdgeInsets.only(top: size.height*0.01),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: size.height*0.008,),
                                          CircleAvatar(backgroundColor: Colors.black,radius: size.width*0.01,),
                                        ],
                                      ),
                                      SizedBox(width: size.width*0.02,),
                                      SizedBox(
                                        width: size.width*0.82,
                                        child: Text(
                                          index==0 ? visula[index1] : index==1 ? audi[index1] : kine[index1],
                                          style: GoogleFonts.exo2(fontSize: size.height*0.02,fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );

  }


  count(){
    List<int> visual=[3,4,6,7,9,13,16,20,22,32,39,43,44,48,49,51,52,54];
    List<int> auditory = [1,2,8,10,11,12,14,24,26,28,34,35,36,40,41,45,47,50];
    double vis=0;
    double audi = 0;
    double kine =0 ;
    for(int i=1;i<=54;i++){
      if(widget.response["Question $i"] == "Yes"){
        if(visual.contains(i)){
          vis++;
        }
        else{
          if(auditory.contains(i)){
            audi++;
          }
          else{
            kine++;
          }
        }
      }
    }
    setState(() {
      BigdataMap= {
        "Visual": vis,
        "Auditory": audi,
        "Kinesthetic": kine,

      };
      loaded=true;
    });
    print("vis: $vis , audi :  $audi, kine: $kine ");
  }
}
