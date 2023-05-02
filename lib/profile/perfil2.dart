import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../Amigos/aceptarUsers.dart';
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
    Reference storageReference = FirebaseStorage.instance.ref().child('avatars/$fileName');
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
    await FirebaseFirestore.instance.collection('Users').doc(user?.uid).update({'Avatar': fileURL});
  }


  late Stream<DocumentSnapshot> _userStream;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _userStream = FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();
    super.initState();

  }
  Widget build(BuildContext context) {
    Usuario currentUser = widget.currentUser; //
    return Scaffold(

    body:StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        ////
        print('IDEEEE: ${snapshot.data?.id}');
        ////

        Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
        String? name = data?['FullName'];
        String? email = user?.email;
        return Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
              top: 50.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.supervised_user_circle, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => aceptarUsers())),
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 130.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.map, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => main_screen(currentUser: currentUser)),
                    );
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 350.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.chat, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(LineAwesomeIcons.angle_left), // Ajusta el tamaño del icono aquí
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),

            Positioned(
              left:0,
              top:0,
              bottom: 0,
              right: 0,
              child: data?['Avatar'] != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(data?['Avatar']),
                radius: 80,
              )
                  : CircleAvatar(
                backgroundImage: AssetImage('assets/avatar_prueba.jpg'), // Asegúrate de tener una imagen predeterminada en tu carpeta 'assets/images'
                radius: 80,
              ),
            ),
            Positioned(
              top: 320,
              right: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: chooseFile,
                    icon: Icon(Icons.photo_library),
                    label: Text('Galería'),
                  ),
                  ElevatedButton.icon(
                    onPressed: captureAndUploadImage,
                    icon: Icon(Icons.camera),
                    label: Text('Cámara'),
                  ),
                ],
              ),
            ),


            /* imagen de perfil */

      //    Positioned(child: Container),








            /* button */

          ],

        );
      },
    ),

    );
  }
}
