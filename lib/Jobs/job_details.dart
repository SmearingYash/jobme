import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobme/Jobs/jobs_screen.dart';
import 'package:jobme/Services/global_methods.dart';

class JobDetailsScreen extends StatefulWidget {

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();

  final String uploadedBy;
  final String jobId;

  const JobDetailsScreen({
    required this.jobId,
    required this.uploadedBy,
});

}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  final FirebaseAuth _auth =FirebaseAuth.instance;

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationJobProvider;
  String? emailJobProvider;
  int applicants=0;
  bool isDeadlineAvailable = false;

  void getJobData() async
  {
    final DocumentSnapshot userDoc =await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if(userDoc ==null)
      {
        return;
      }
    else
      {
        setState(() {
          authorName = userDoc.get('name');
          userImageUrl = userDoc.get('userImage');
        });
      }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
                      .collection('jobs')
                      .doc(widget.jobId).get();
    if(jobDatabase ==null)
      {
        return;
      }
    else
      {
        setState(() {
          jobTitle =jobDatabase.get('jobTitle');
          jobDescription =jobDatabase.get('jobDescription');
          recruitment =jobDatabase.get('recruitment');
          emailJobProvider =jobDatabase.get('email');
          locationJobProvider =jobDatabase.get('location');
          applicants=jobDatabase.get('applicants');
          postedDateTimeStamp=jobDatabase.get('createdAt');
          deadlineDateTimeStamp=jobDatabase.get('deadlineDateTimeStamp');
          deadlineDate=jobDatabase.get('deadLineDate');
          var postDate=postedDateTimeStamp!.toDate();
          postedDate ='${postDate.year}-${postDate.month}-${postDate.day}';
        });

        var date =deadlineDateTimeStamp!.toDate();
        isDeadlineAvailable =date.isAfter(DateTime.now());

      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget()
  {
    return Column(
      children: const [
        SizedBox(height: 10,),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.lightBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2,0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.lightBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2,0.9],
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close,size: 40,color: Colors.white,),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JobScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle ==null
                                ?
                                ''
                                :
                                jobTitle!,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape:BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ?
                                        'https://static.vecteezy.com/system/resources/previews/002/318/271/original/user-profile-icon-free-vector.jpg'
                                        :
                                      userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName ==null
                                        ?
                                        ''
                                        :
                                        authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    locationJobProvider!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                            ),
                            const SizedBox(width: 6,),
                            const Text(
                              'Applicants',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10,),
                            const Icon(Icons.how_to_reg_sharp,color: Colors.grey,),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                            ?
                            Container()
                            :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                const Text(
                                  'Recruitment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        User? user = _auth.currentUser;
                                        final _uid =user!.uid;
                                        if(_uid==widget.uploadedBy)
                                          {
                                            try{
                                              FirebaseFirestore.instance.collection('jobs')
                                                  .doc(widget.jobId)
                                                  .update({'recruitment':true});
                                            }catch(error)
                                        {
                                          GlobalMethod.showErrorDialog(error: 'Action cannot be performed', ctx: context,);
                                        }
                                          }
                                        else{
                                          GlobalMethod.showErrorDialog(error: 'You cannot perform this action', ctx: context,);
                                        }
                                        getJobData();
                                      },
                                      child: const Text(
                                        'ON',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment ==true ? 1 : 0 ,
                                      child: const Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 40,),
                                    TextButton(
                                      onPressed: (){
                                        User? user = _auth.currentUser;
                                        final _uid =user!.uid;
                                        if(_uid==widget.uploadedBy)
                                        {
                                          try{
                                            FirebaseFirestore.instance.collection('jobs')
                                                .doc(widget.jobId)
                                                .update({'recruitment':false});
                                          }catch(error)
                                          {
                                            GlobalMethod.showErrorDialog(error: 'Action cannot be performed', ctx: context,);
                                          }
                                        }
                                        else{
                                          GlobalMethod.showErrorDialog(error: 'You cannot perform this action', ctx: context,);
                                        }
                                        getJobData();
                                      },
                                      child: const Text(
                                        'OFF',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment ==false ? 1 : 0 ,
                                      child: const Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.red,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                        dividerWidget(),
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          jobDescription == null
                              ?
                              ''
                              :
                              jobDescription!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontWeight:FontWeight.bold,
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        dividerWidget(),

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            isDeadlineAvailable
                                ?
                                'Actively recruiting,send request'
                                :
                                'Deadline Passed Away',
                            style: TextStyle(
                              color: isDeadlineAvailable
                                  ?
                                  Colors.green
                                  :
                                  Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
