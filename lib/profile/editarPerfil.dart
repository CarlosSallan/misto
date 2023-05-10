import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/Amigos/misAmigos.dart';
import '../user.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class editarPerfil extends StatefulWidget {
  const editarPerfil({Key? key}) : super(key: key);

  @override
  State<editarPerfil> createState() => _editarPerfilState();
}

class _editarPerfilState extends State<editarPerfil> {



  late Stream<DocumentSnapshot> _userStream;

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();
  final User? user = FirebaseAuth.instance.currentUser;
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


  @override
  void initState() {
    _userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .snapshots();
    super.initState();
    super.initState();
    _userStream =
        FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();

  }

  final ButtonStyle style =
  ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  Widget build(BuildContext context) {

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

                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _textFieldController,
                                  focusNode: _focusNode,
                                  readOnly: isTextFieldEnable,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: myinputborder(),
                                    focusedBorder: myfocusborder(),
                                    hintText: 'Nombre de usuario',
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.02),
                                ),
                                TextField(
                                  controller: _textFieldController2,
                                  focusNode: _focusNode,
                                  readOnly: isTextFieldEnable,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: myinputborder(),
                                    focusedBorder: myfocusborder(),
                                    hintText: 'Contraseña',
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.02),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(22, 53, 77, 1.000),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [

                                        Expanded(
                                          flex: 3,
                                          child: TextButton(
                                            onPressed: (){
                                              setState(){
                                                if (isTextFieldEnable) {
                                                  isTextFieldEnable = false;
                                                } else {
                                                  isTextFieldEnable = true;
                                                }
                                                print(isTextFieldEnable);
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              primary: Color.fromRGBO(228, 229, 234, 1.000),
                                              padding: EdgeInsets.all(15.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: Text(
                                              'Cambiar',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
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


                    //amigos




                    //ubi


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





                  ],
                ),
              ));
        },
      ),
    );
  }
  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
      //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0,
        ));
  }

}
