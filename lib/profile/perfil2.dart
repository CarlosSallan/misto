import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/Amigos/misAmigos.dart';
import 'package:misto/main_screen/main_screen.dart';
import 'package:misto/mensajes/friends_screen.dart';
import '../user.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class perfil2 extends StatefulWidget {
  final Usuario currentUser;

  const perfil2({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<perfil2> createState() => _perfil2State();
}

class _perfil2State extends State<perfil2> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedFileURL;

  Future chooseFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadedFileURL = null;
      });
      uploadFile(File(pickedFile.path));
    } else {
      print('No image selected');
    }
  }

  Future captureAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _uploadedFileURL = null;
      });
      uploadFile(File(pickedFile.path));
    } else {
      print('No image captured');
    }
  }

  Future uploadFile(File file) async {
    String fileName = '${Path.basename(file.path)}';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('avatars/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');

      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          updateAvatarURL(fileURL);
        });
      });
    });
  }

  void updateAvatarURL(String fileURL) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .update({'Avatar': fileURL});
  }

  late Stream<DocumentSnapshot> _userStream;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .snapshots();
    super.initState();
  }

  Widget build(BuildContext context) {
    Usuario currentUser = widget.currentUser;
    bool isSwitched = false;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          ////
          print('IDEEEE: ${snapshot.data?.id}');
          ////

          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;
          String? name = data?['FullName'];
          String? email = user?.email;
          return Scaffold(
              body: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: data?['Avatar'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data?['Avatar']),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/avatar_prueba.jpg'),
                          // Asegúrate de tener una imagen predeterminada en tu carpeta 'assets/images'
                          radius: 50,
                        ),
                ),

                Positioned(
                    top: 160,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: Text(
                          "hola, $name",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(22, 53, 77, 1.000)),
                        ),
                      ),
                    )),

                Positioned(
                  top: 210,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      height: 20, // altura de la barra
                      thickness: 2, // grosor de la barra
                      color: Color.fromRGBO(
                          22, 53, 77, 1.000), // color de la barra
                    ),
                  ),
                ),
                //imagen
                Positioned(
                  top: 240,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(228, 229, 234, 1.000),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconTheme(
                                data: IconThemeData(
                                    color: Color.fromRGBO(22, 53, 77, 1.000)),
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextButton(
                                onPressed: captureAndUploadImage,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  primary: Color.fromRGBO(22, 53, 77, 1.000),
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'Hacer foto perfil',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 310,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(228, 229, 234, 1.000),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconTheme(
                                data: IconThemeData(
                                    color: Color.fromRGBO(22, 53, 77, 1.000)),
                                child: Icon(Icons.photo_album),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextButton(
                                onPressed: chooseFile,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  primary: Color.fromRGBO(22, 53, 77, 1.000),
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'Subir foto perfil',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //amigos
                Positioned(
                  top: 370,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      height: 20, // altura de la barra
                      thickness: 2, // grosor de la barra
                      color: Color.fromRGBO(
                          22, 53, 77, 1.000), // color de la barra
                    ),
                  ),
                ),
                Positioned(
                  top: 410,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(228, 229, 234, 1.000),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconTheme(
                                data: IconThemeData(
                                    color: Color.fromRGBO(22, 53, 77, 1.000)),
                                child: Icon(Icons.supervised_user_circle_sharp),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextButton(
                                onPressed:() => Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => misAmigos())),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  primary: Color.fromRGBO(22, 53, 77, 1.000),
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'Mis amigos',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 470,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      height: 20, // altura de la barra
                      thickness: 2, // grosor de la barra
                      color: Color.fromRGBO(
                          22, 53, 77, 1.000), // color de la barra
                    ),
                  ),
                ),

                //ubi
                Positioned(
                  top: 500,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(228, 229, 234, 1.000),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconTheme(
                                data: IconThemeData(
                                    color: Color.fromRGBO(22, 53, 77, 1.000)),
                                child: Icon(Icons.location_on),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Ubicacion',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeColor: Colors.redAccent,
                                      inactiveTrackColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 50.0,
                  left: 10.0,
                  child: Material(
                    color: Color.fromRGBO(228, 229, 234, 1.000),
                    borderRadius: BorderRadius.circular(10.0),
                    child: IconButton(
                      icon: Icon(LineAwesomeIcons.angle_left),
                      // Ajusta el tamaño del icono aquí
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30.0,
                      // Ajusta el tamaño del botón aquí
                      padding: EdgeInsets.all(
                          8.0), // Ajusta el padding para aumentar el área de toque del botón
                    ),
                  ),
                ),
                Positioned(
                  top: 50.0,
                  left: 290.0,
                  child: Material(
                    color: Color.fromRGBO(228, 229, 234, 1.000),
                    borderRadius: BorderRadius.circular(10.0),
                    child: IconButton(
                      icon: Icon(Icons.edit,
                          color: Color.fromRGBO(22, 53, 77, 1.000)),
                      // Ajusta el tamaño del icono aquí
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30.0,
                      // Ajusta el tamaño del botón aquí
                      padding: EdgeInsets.all(
                          8.0), // Ajusta el padding para aumentar el área de toque del botón
                    ),
                  ),
                ),

                /* button */
              ],
            ),
          ));
        },
      ),
    );
  }


}
