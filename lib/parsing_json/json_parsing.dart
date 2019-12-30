import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonParsingSimple extends StatefulWidget {
  @override
  _JsonParsingSimpleState createState() => _JsonParsingSimpleState();
}

class _JsonParsingSimpleState extends State<JsonParsingSimple> {
  Future data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data =  getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Parsing Json"),
       ),

      body: Center(
         child: Container(
             child: FutureBuilder(
                 future: getData(),
                 builder: (context, AsyncSnapshot snapshot) {
                   if (snapshot.hasData) {
                     return createListView(snapshot.data, context);
                     //return Text(snapshot.data[0]['userId'].toString());
                   }
                   return CircularProgressIndicator();

                 }),
         ),
      ),

    );
  }

  Future getData() async {
     Future data;


     String url = "https://jsonplaceholder.typicode.com/posts";
     Network network = Network(url);

     data =  network.fetchData();
//     data.then((value) {
//         print(value[0]['title']);
//     });


     return data;
  }

  Widget createListView(List data, BuildContext context) {
     return Container(
        child: ListView.builder(
          itemCount: data.length,
            itemBuilder: (context, int index) {
             return Column(
                mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Divider(height: 5.0,),
                  ListTile(
                      title: Text("${data[index]["title"]}"),
                    subtitle: Text("${data[index]["body"]}"),
                    leading: Column(
                       children: <Widget>[
                          CircleAvatar(
                             backgroundColor: Colors.black26,
                            radius: 23,
                            child: Text("${data[index]["id"]}"),
                          )
                       ],
                    ),
                  )

               ],
             );
        }),
     );

  }
}

class Network {
   final String url;

  Network(this.url);

  Future fetchData() async {
     print("$url");
     Response response = await get(Uri.encodeFull(url));

     if (response.statusCode == 200) {
       //Ok
      // print(response.body[0]);
         return json.decode(response.body);
     }else {
        print(response.statusCode);
     }




  }


}

