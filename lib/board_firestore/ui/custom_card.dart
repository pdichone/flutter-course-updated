import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {



    var snapshotData = snapshot.documents[index].data;
    var docId = snapshot.documents[index].documentID;

    TextEditingController nameInputController = TextEditingController(text: snapshotData["name"]);
    TextEditingController titleInputController = TextEditingController(text: snapshotData["title"]);
    TextEditingController descriptionInputController = TextEditingController(text: snapshotData["description"]);

    var timeToDate = new DateTime.fromMillisecondsSinceEpoch(snapshotData["timestamp"].seconds * 1000);
    var dateFormatted = new DateFormat("EEEE, MMM d").format(timeToDate);

    return Column(
        children: <Widget>[
          Container(
            height: 190,
            child: Card(
              elevation: 9,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(snapshotData["title"]),
                     subtitle: Text(snapshotData["description"]),
                     leading: CircleAvatar(
                         radius: 34,
                       child: Text(snapshotData["title"].toString()[0]),

                     ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(" By: ${snapshotData["name"]} "),
                        Text(dateFormatted),
                      ],
                    ),
                  ),

                  //Add Row with Edit and Update Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(icon: Icon(FontAwesomeIcons.edit, size: 15,),
                          onPressed: () async {
                           await showDialog(context: context,
                            child: AlertDialog(
                                contentPadding: EdgeInsets.all(10),
                              content: Column(
                                 children: <Widget>[
                                   Text("Please fill out the form to Update."),
                                   Expanded(
                                       child: TextField(
                                         autofocus: true,
                                         autocorrect: true,
                                         decoration: InputDecoration(
                                             labelText: "Your Name*"
                                         ),
                                         controller: nameInputController,

                                       )),

                                   Expanded(
                                       child: TextField(
                                         autofocus: true,
                                         autocorrect: true,
                                         decoration: InputDecoration(
                                             labelText: "Title*"
                                         ),
                                         controller: titleInputController,

                                       )),

                                   Expanded(
                                       child: TextField(
                                         autofocus: true,
                                         autocorrect: true,
                                         decoration: InputDecoration(
                                             labelText: "Description*",

                                         ),
                                         controller: descriptionInputController,

                                       )),


                                 ],
                              ),
                              actions: <Widget>[
                                FlatButton(onPressed: () {
                                  nameInputController.clear();
                                  titleInputController.clear();
                                  descriptionInputController.clear();

                                  Navigator.pop(context);
                                } ,
                                    child: Text("Cancel")),

                                FlatButton(onPressed: () {
                                  if( titleInputController.text.isNotEmpty &&
                                      nameInputController.text.isNotEmpty &&
                                      descriptionInputController.text.isNotEmpty) {

                                    Firestore.instance.collection("board")
                                      .document(docId)
                                      .updateData({
                                      "name" : nameInputController.text,
                                      "title" : titleInputController.text,
                                      "description" : descriptionInputController.text,
                                      "timestamp" : new DateTime.now()
                                    }).then((response) {
                                       Navigator.pop(context);
                                    });

//                                    Firestore.instance.collection("board")
//                                        .add({
//                                      "name" : nameInputController.text,
//                                      "title" : titleInputController.text,
//                                      "description" : descriptionInputController.text,
//                                      "timestamp" : new DateTime.now()
//                                    }).then((response) {
//                                      print(response.documentID);
//                                      Navigator.pop(context);
//                                      nameInputController.clear();
//                                      titleInputController.clear();
//                                      descriptionInputController.clear();
//
//                                    }).catchError((error) => print(error));
                                  }
                                },
                                    child: Text("Update"))
                              ],

                            ));

                          }),

                       SizedBox(height: 19,),

                      IconButton(icon: Icon(FontAwesomeIcons.trashAlt, size: 15,),
                          onPressed: () async {
                            var collectionReference = Firestore.instance.collection("board");
                            await collectionReference
                                  .document(docId)
                                  .delete();



                          })
                    ],
                  )

                  //Text(snapshot.documents[index].data["title"])
                ],
              ),
            ),
          ),


        ],


    );
  }
}
