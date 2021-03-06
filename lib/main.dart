import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  String _age;
  int _score = -1;
  final _formKey = GlobalKey<FormState>();
  final String _scoreFile = 'score.txt';
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController nickNameController;
  TextEditingController ageController;

  // Read user pref and autofill the form.
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController = TextEditingController(text: prefs.getString('First Name') ?? '');
      lastNameController = TextEditingController(text: prefs.getString('Family Name') ?? '');
      nickNameController = TextEditingController(text: prefs.getString('Nick Name') ?? '');
      ageController = TextEditingController(text: prefs.getString('Age') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
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
                        _age = ageController.text;
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
          _score >= 0 ? // Once the quiz has ended and returned the score, store user pref and score.
          Container(
            child: RaisedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('First Name', _firstName);
                prefs.setString('Family Name', _familyName);
                prefs.setString('Nick Name', _nickName);
                prefs.setString('Age', _age);
                FileHandler().writeFile(_scoreFile, '${_score}').then(
                        (value) => Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Saved your details!')
                            )
                        )
                );
              },
              child: Text('Save')
            )
          ) :
          Container(
              child: RaisedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final score = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionScreen()),
                      ) ?? -1;
                      setState(() {
                        _score = score;
                      });
                      // print('Your score - ${score}');
                    }
                  },
                  child: Text('Start Quiz')
              )
          ),
          _score >= 0 ? // Conditionally render user score text.
          Container(
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

// Reads questions from assets
Future<String>_loadFromAsset() async {
  return await rootBundle.loadString("assets/quiz.json");
}

// Returns the parsed JSON
Future parseJson() async {
  String jsonString = await _loadFromAsset();
  return json.decode(jsonString);
}

/*
  * Reads questions from the assets and passes them to the quiz manager.
  * Shows a loading spinner while reading questions.
  * Displays the first question once it is done with reading questions.
*/

class QuestionScreen extends StatelessWidget {
  Future<dynamic> _getQuestions = parseJson();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: FutureBuilder<dynamic>(
                future: _getQuestions,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    QuizManager().loadQuestions((snapshot.data));
                    if(QuizManager().getNumberOfQuestions() > 0) {
                      children = <Widget>[
                        QuizCard()
                      ];
                    }
                    else {
                      children = <Widget>[
                        Center(
                          child: Text(
                            "Oops!.. No questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        )
                      ];
                    }
                  }
                  else if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  }
                  else {
                    children = <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Loading quiz...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            )
          ),
        ),
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

/*
  * Question class to hold current state of a question displayed in the quiz card
 */
class Question {
  int _questionId = 0;
  String _question = '';
  List<String> _choices = [];
  String _correctAnswer = '';
  String _myGuess = '';

  Question(this._questionId, this._question, this._choices, this._correctAnswer);

  Question.fromJson(Map<String, dynamic> json)
      : _questionId = json['id'],
        _question = json['question'],
        _choices = json['choices'],
        _correctAnswer = json['answer'];

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

/* Singleton class for QuizManager as there can be only one manager for a Quiz
  * Create quiz cards.
  * Serves the next/prev question card.
  * Update the user guess for a given question.
  * Verifies if a question's guess is correct.
  * Calculates the final quiz score.
*/

class QuizManager {
  static final QuizManager _quizManager = QuizManager._internal();
  List<Question> questions = []; // List of question cards
  factory QuizManager() {
    return _quizManager;
  }
  QuizManager._internal() {
    // Singleton constructor
  }
  void loadQuestions(final Map<String, dynamic> questions) {
    this.questions = []; // Clear existing questions to refresh the quiz.
    if(!questions.containsKey('payload') || !(questions['payload'] is List) || questions['payload'].length == 0){
      return;
    }
    questions['payload'].forEach((question) =>
        this.questions.add(
            Question(
                question['id'] ?? -1,
                question['question'] ?? '',
                question['choices'].cast<String>().toList() ?? [],
                question['answer'] ?? ''
            )
        )
    );
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

/*
  * State of the quiz card.
*/
class QuizCardState extends State<QuizCard> {
  int _questionId = 0; // ID question displayed to the user
  bool _didUserAnswer = false; // Is the question answered or not
  Widget build(BuildContext context) {
    Question question = QuizManager().getQuestion(_questionId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            question.getQuestion(),
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Open Sans',
            ),
        ),
        ...question.getChoices().map((choice) => RadioListTile<String>(
          title: Text(
            choice,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Open Sans',
            ),
          ),
          value: '${choice}',
          groupValue: QuizManager().getMyGuess(_questionId),
          onChanged: (String value) {
            setState(() {
              QuizManager().updateQuestionGuess(_questionId, value);
              _didUserAnswer = QuizManager().getMyGuess(_questionId).length > 0;
            });
          },
        )).toList(),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: _didUserAnswer ? 1.0 : 0.0, // Show 'Next' button when user has answered the question.
              child: RaisedButton(
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
                child: Text(
                    _questionId == QuizManager().getNumberOfQuestions()-1
                        && _didUserAnswer // If the last question is answered, then change button from 'Next' to 'End'
                        ? 'End' : 'Next'
                )
              ),
            )
          ],
        )
      ],
    );
  }
}

// File handling utilities to read or write to a file
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