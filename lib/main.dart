import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          // color: Colors.amber[600],
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "About you",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PersonalInformationForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Create a Form widget.
class PersonalInformationForm extends StatefulWidget {
  @override
  PersonalInformationFormState createState() {
    return PersonalInformationFormState();
  }
}

class PersonalInformationFormState extends State<PersonalInformationForm> {
  String _firstName = '';
  String _familyName = '';
  String _nickName = '';
  int _age = 1;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField (
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _firstName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                    ),
                  )
              ),
            ],
          ),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField (
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _familyName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Family Name',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                    ),
                  )
              ),
            ],
          ),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField (
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your nickname';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _nickName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nick Name',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                    ),
                  )
              ),
            ],
          ),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField (
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your age';
                      }
                      if(int.tryParse(value) <= 0) {
                        return 'Invalid age';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _age = int.tryParse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                    ),
                  )
              ),
            ],
          ),
          Container(
            height: 15,
          ),
          Container(
              child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    print("Hello world");
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                      _formKey.currentState.save();
                      print('${_firstName}, ${_familyName}, ${_nickName}, ${_age}');
                    }
                  },
                  child: Text('Done')
              )
          )
        ]
      ),
    );
  }
}