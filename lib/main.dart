import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  String _firstName;
  String _familyName;
  String _nickName;
  int _age;
  int _score = -1;
  final _formKey = GlobalKey<FormState>();
  final String _userPreferencesFile = 'UserPreferences.txt';
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController nickNameController;
  TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    FileHandler().readFile(_userPreferencesFile).then((String value) {
      print("Read User preferences - ${value}");
      if(value.length == 0) {
        value = ',,,';
      }
      final List<String> userInfo = value.split(',');
      firstNameController = TextEditingController(text: userInfo[0]);
      lastNameController = TextEditingController(text: userInfo[1]);
      nickNameController = TextEditingController(text: userInfo[2]);
      ageController = TextEditingController(text: userInfo[3]);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    firstNameController.dispose();
    lastNameController.dispose();
    nickNameController.dispose();
    ageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
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
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField (
                    controller: firstNameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _firstName = firstNameController.text;
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
                    controller: lastNameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _familyName = lastNameController.text;
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
                    controller: nickNameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your nickname';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _nickName = nickNameController.text;
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
                    controller: ageController,
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
                        _age = int.tryParse(ageController.text);
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
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Future<File> fh = FileHandler().writeFile(_userPreferencesFile, '${_firstName},${_familyName},${_nickName},${_age}');
                      fh.then((result) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Updated your details as - ${_firstName},${_familyName},${_nickName},${_age}')));
                      });
                      final score = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizCard()),
                      );
                      setState(() {
                        _score = score;
                      });
                      print('Your score - ${score}');
                    }
                  },
                  child: Text('Done')
              )
          ),
          _score >= 0 ? Container(
            margin: const EdgeInsets.all(10.0),
            child: Text(
              'Your quiz score is ${_score}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Open Sans',
              ),
            ),
          ) : Container(),
        ]
      ),
    );
  }
}

class QuizCard extends StatefulWidget {
  QuizCard({Key key}) : super(key: key);
  @override
  QuizCardState createState() {
    return QuizCardState();
  }
}

class Question {
  int _questionId = 0;
  String _question = '';
  List<String> _choices = [];
  String _correctAnswer = '';
  String _myGuess = '';
  Question(this._questionId, this._question, this._choices, this._correctAnswer);
  int getQuestionId() {
    return _questionId;
  }
  String getQuestion() {
    return _question;
  }
  List<String> getChoices() {
    return _choices;
  }
  bool isMyGuessCorrect() {
    return this._myGuess == this._correctAnswer;
  }
  void setMyGuess(String guess) {
    this._myGuess = guess;
  }
  String getMyGuess() {
    return _myGuess;
  }
}

class QuizManager {
  static final QuizManager _quizManager = QuizManager._internal();
  final List<Question> questions = [
    Question(0, 'Far-right protestors tried to storm the Parliament building in which country?', ['Australia','Britain','France','Germany'], 'Germany'),
    Question(1, 'Why did Shinzo Abe, prime minister of Japan, resign from office?', ['An extramarital affair','Fraud','Illness','Protests'], 'Illness'),
    Question(2, 'What did two commercial jet pilots reported seeing in the busy airspace near Los Angeles International Airport?', ['An attack drone','A man with a jetpack','A girl attached to a kite','A U.F.O'], 'A man with a jetpack'),
    Question(3, 'After more than seven decades of absence, jaguars are being reintroduced into the wetlands of which country?', ['Argentina','Belize','Colombia','Mexico'], 'Argentina'),
  ];
  factory QuizManager() {
    return _quizManager;
  }
  QuizManager._internal() {
    // Read the file to fill in questions
  }
  int getNumberOfQuestions() {
    return this.questions.length;
  }
  void updateQuestionGuess(int questionId, String myGuess) {
    this.questions[questionId].setMyGuess(myGuess);
  }
  Question getQuestion(int questionId) {
    return this.questions[questionId];
  }
  bool isMyGuessCorrect(int questionId) {
    return this.questions[questionId].isMyGuessCorrect();
  }
  String getMyGuess(int questionId) {
    return this.questions[questionId].getMyGuess();
  }
  int getScore() {
    return this.questions.where((question) => question.isMyGuessCorrect()).toList().length;
  }
}

class QuizCardState extends State<QuizCard> {
  int _questionId = 0;
  bool _didUserAnswer = false;
  Widget build(BuildContext context) {
    Question question = QuizManager().getQuestion(_questionId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      body: Center(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            // color: Colors.red[600],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      question.getQuestion(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                      ),
                  ),
                  ...question.getChoices().map((choice) => ListTile(
                  title: Text(
                      choice,
                      style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      ),
                  ),
                  leading: Radio(
                    value: '${choice}',
                    groupValue: QuizManager().getMyGuess(_questionId),
                    onChanged: (value) {
                      setState(() {
                        QuizManager().updateQuestionGuess(_questionId, value);
                        _didUserAnswer = QuizManager().getMyGuess(_questionId).length > 0;
                      });
                    },
                  ),)).toList(),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        onPressed: _questionId >= 1 ? () {
                          setState(() {
                            _didUserAnswer = QuizManager().getMyGuess(_questionId-1).length > 0;
                            _questionId = _questionId - 1;
                          });
                        } : null,
                        child: Text('Prev')
                      ),
                      RaisedButton(
                        onPressed: _questionId == QuizManager().getNumberOfQuestions()-1 ? ( // If this is the last question
                            _didUserAnswer ? () {  // If User has answered the last question, then on click show his score.
                              Navigator.pop(context, QuizManager().getScore());
                            } : null // If user has not answered the last question yet then disable 'Next' button.
                        ) : () { // If this is not the last question, then go to the next question.
                          setState(() {
                            _didUserAnswer = QuizManager().getMyGuess(_questionId+1).length > 0;
                            _questionId = _questionId + 1;
                          });
                        },
                        child: Text(_questionId == QuizManager().getNumberOfQuestions()-1 && _didUserAnswer ? 'End' : 'Next')
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class FileHandler {
  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(String fileName) async {
    final path = await localPath();
    return File('${path}/${fileName}');
  }

  Future<String> readFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      String contents = await file.readAsString();
      return contents;
    }
    catch(e) {
      return '';
    }
  }

  Future<File> writeFile(String fileName, String contents) async {
    final file = await localFile(fileName);
    return file.writeAsString(contents);
  }
}