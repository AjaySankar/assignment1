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
                  PersonalInformationForm(),
                  // QuizCard(),
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
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                      _formKey.currentState.save();
                      print('${_firstName}, ${_familyName}, ${_nickName}, ${_age}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizCard()),
                      );
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
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            // color: Colors.red[600],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                        onPressed: _questionId == QuizManager().getNumberOfQuestions()-1 && _didUserAnswer ? () {
                          print('Your score - ${QuizManager().getScore()}');
                        } : () {
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
      ),
    );
  }
}