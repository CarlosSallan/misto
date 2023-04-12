import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'models/user.dart';

class seguir extends StatefulWidget {
  const seguir({Key? key}) : super(key: key);

  @override
  State<seguir> createState() => _seguirState();
}

class _seguirState extends State<seguir> {





  List<User> _users = [

    User('Elliana Palacios', false),
    User('Kayley Dwyer', false),
  ];

  List<User> _foundedUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

      _foundedUsers = _users;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedUsers = _users.where((user) => user.FullName.toLowerCase().contains(search)).toList();
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: userList(),
    );
  }

  userComponent({required User user}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              children: [
                /*
                Container(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(user.image),
                    )
                ),*/
                SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.FullName, style: TextStyle(color:Color.fromRGBO(22,53,77,1.000), fontWeight: FontWeight.w500)),
                      SizedBox(height: 5,),
                      Text(user.FullName, style: TextStyle(color: Color.fromRGBO(22,53,77,1.000),)),
                    ]
                )
              ]
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                user.isFollowedByMe = !user.isFollowedByMe;
              });
            },
            child: AnimatedContainer(
                height: 45,
                width: 130,
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: user.isFollowedByMe ? Colors.blue[700] : Color(0xffffff),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: user.isFollowedByMe ? Colors.transparent : Colors.white,)
                ),
                child: Center(
                    child: Text(user.isFollowedByMe ? 'Solicitud enviada' : 'Enviar solicitud', style: TextStyle(color: user.isFollowedByMe ? Colors.white : Colors.blue , fontWeight: FontWeight.bold))
                )
            ),
          )
        ],
      ),
    );
  }

  Widget userList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Amistad').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.grey.shade600, //change your color here
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              title: Container(
                height: 38,
                child: TextField(
                  onChanged: (value) => onSearch(value),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade600,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none
                      ),
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500
                      ),
                      hintText: "Search users"
                  ),
                ),
              ),
            ),
            body: Container(
              color: Colors.white,
              child: (snapshot.data?.docs.length ?? 1) > 0 ? ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 1,
                  itemBuilder: (context, index) {
                    return Slidable(
                      enabled: false,
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: userComponent(user: _foundedUsers[index]),
                      actions: <Widget>[
                        new IconSlideAction(
                          caption: 'Archive',
                          color: Colors.transparent,
                          icon: Icons.archive,

                          onTap: () => print("archive"),
                        ),
                        new IconSlideAction(
                          caption: 'Share',
                          color: Colors.transparent,
                          icon: Icons.share,
                          onTap: () => print('Share'),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        new IconSlideAction(
                          caption: 'More',
                          color: Colors.transparent,
                          icon: Icons.more_horiz,
                          onTap: () => print('More'),
                        ),
                        new IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          onTap: () => print('Delete'),
                        ),
                      ],
                    );
                  }) : Center(child: Text("No users found", style: TextStyle(color: Colors.white),)),
            ),
          );
        },
      ),
    );
  }
}
