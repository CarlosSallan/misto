import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';


class profileTest extends StatefulWidget{
  static const String id = 'profile';
  const profileTest({Key? key}) : super(key: key);

  @override
  State<profileTest> createState() => _profileTestState();
}

class _profileTestState extends State<profileTest> {
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[

          SizedBox(
            height: 250,
          ),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.white,
            radius: 120,
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                      child: Text('Editar', style: TextStyle(fontSize: 20.0),),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(22,53,77,1.000),
                        shadowColor: Color.fromRGBO(22,53,77,1.000),
                        elevation: 5,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
                    onPressed: () => Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => customizePage())),
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          Row(
            children: [
              SizedBox(
                width: 100,
              ),
              Expanded(
                child: Container(
                  height: 70,
                  child: TextField(
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
                ),
              ),
              SizedBox(
                width: 100,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: TextField(
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
                ),
              ),
              SizedBox(
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
  return OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(40)),
      borderSide: BorderSide(
        color:Colors.white,
        width: 0,
      )
  );
}

OutlineInputBorder myfocusborder(){
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      borderSide: BorderSide(
        color:Colors.white,
        width: 0,
      )
  );
}

class customizePage extends StatelessWidget {
  const customizePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(22, 53, 77, 1.0),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FluttermojiCircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Spacer(),
                    FluttermojiSaveWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: false,
                  theme: FluttermojiThemeData(
                      boxDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ), //Border.all
                        borderRadius: BorderRadius.circular(15),
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