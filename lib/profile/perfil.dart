import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class perfil extends StatefulWidget {
  const perfil({Key? key}) : super(key: key);

  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
        "Perfil",
        style: TextStyle(
        color: Colors.black, // Establecer el color del título en negro
        fontSize: 24.0, // Establecer el tamaño de la fuente del título en 24
    ),
    ),
    leading: IconButton(
    icon: Icon(LineAwesomeIcons.angle_left),
    onPressed: () => Navigator.of(context).pop(),
    color: Colors.black, // Establecer el color del icono en negro
    ),
    backgroundColor: Colors.white, // Establecer el color de fondo en blanco
    foregroundColor: Colors.black, // Establecer el color del título y el icono en negro
    ),

      body: Column(
        children: [
        Expanded(
        flex: 1,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/avatar_prueba.jpg'),
              ),
              SizedBox(height: 30.0),
              Text(
                'Nombre de la persona',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
            flex: 3,
            child: Container(
              // Aquí va el contenido de la segunda sección
              color: Colors.grey,
            ),
          )

        ],
      ),
    );
  }
}
