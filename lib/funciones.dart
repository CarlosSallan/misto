import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> addUser(User? user, String nombre) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("Ejecutando addUser");
  CollectionReference users = firestore.collection('Users');

  String nombre2;

  if(nombre == ""){
    nombre2 = user?.displayName ?? "Usuario";

    for(int i=0; i<nombre2.length ; i++) {
      var char = nombre2[i];
      if(char == ' '){
        nombre = nombre2.substring(0, i);
      }
    }
  }
  //Conseguimos el nombre


  // Call the user's CollectionReference to add a new user
  return users.doc(user?.uid).set({
    'FullName': nombre,
    'Creado': new DateTime.now(),
    'Amigos': [],

  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
/*
Future<void> addAmigoForUser(User? user) {
  print("Creando nueva colección para usuario ${user?.uid}");
  CollectionReference userCollection = FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('myCollection');
  // Luego puedes agregar documentos a la nueva colección como lo harías en cualquier otra colección de Firestore:
  return userCollection.add({
    'createdAt': FieldValue.serverTimestamp(),
  }).then((value) => print("Documento agregado a Amigos"))
      .catchError((error) => print("Error al agregar documento a myCollection: $error"));
}
*/