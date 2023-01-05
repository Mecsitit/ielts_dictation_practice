import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ielts_dictation_practice/componets/game/quiz_brain2.dart';
import 'package:ielts_dictation_practice/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_brain1.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

class level1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _answered = 0;
  List<Widget> review = [];
  String typeAnswered = "";
  String CorrectAnswered = "";
  int _questionNumberprevious = 0;
  int _questionNumberActual = 1;
  String previousQ = "";
  bool resultsTile = false;
  int scor = 0;
  bool isAnswer = false;
  List<String> previousQuestionList = [];
  int _highScore = 0;
  List<String> worngWordsList = [];
  final int _duration = 20;
  bool isStarted = false;
  bool isEnd = false;

  // controllers
  late TextEditingController _controller;
  ScrollController _scrollController = new ScrollController();
  final CountDownController _tcontroller = CountDownController();
  int _t = 20;

  @override
  void initState() {
    super.initState();
    quizBrain.reset();
    checkFirstSeen();
    _controller = TextEditingController();
    _answered = 0;
    scor = 0;
    isAnswer = false;
    isStarted = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  NextQuestion() {
    PreviousQuestion();
    review.add(ContainerReview(
      _questionNumberprevious,
      previousQ,
      typeAnswered,
    ));
    if (_questionNumberActual == 30) {
      setState(() {
        resultsTile = true;
        _questionNumberActual = 1;
      });
      check();
    } else {
      setState(() {
        quizBrain.nextQuestion();
        _questionNumberActual++;
      });
    }
    ;
  }

  PreviousQuestion() {
    setState(() {
      _questionNumberprevious = _questionNumberActual;
      previousQ = quizBrain.getQuestionText()!;
    });
  }

  RightAnswer() {
    setState(() {
      scor = scor + 1;
      isAnswer = true;
    });
  }

  WrongAnswer() {
    setState(() {
      isAnswer = false;
      worngWordsList.add(CorrectAnswered);
      print(worngWordsList);
    });
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (scor >= _highScore) {
      setState(() {
        _highScore = scor;
      });
      prefs.setInt('highScore', scor);
    }
  }

  checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = (prefs.getInt('highScore') ?? 0);
      isAnswer = true;
    });
  }

  playAdio() {
    setState(() {
      isAnswer = true;
      _answered = _answered + 1;
    });
    print(isAnswer);
    if (_answered == 1) {
      _tcontroller.start();
      AssetsAudioPlayer.playAndForget(
        Audio("assets/audio/${quizBrain.getQuestionText()}.wav"),
      );
    }
    if (_answered <= 2) {
      setState(() {
        isAnswer = false;
      });
      AssetsAudioPlayer.playAndForget(
        Audio("assets/audio/${quizBrain.getQuestionText()}.wav"),
      );
    }
  }

  CheckAnswer() {
    setState(() {
      _answered = 0;
    });
    if(_questionNumberActual == 30){
      setState(() {
        isEnd = true;
      });
     print('_questionNumberActual === 20') ;
     {_onBasicAlertPressed(context);}
    };
    if (!_controller.text.isEmpty) {
      typeAnswered = _controller.text.toString();
      CorrectAnswered = quizBrain.getQuestionText().toString();
      print('$typeAnswered type answer');
      print('$CorrectAnswered correct answer');
      previousQuestionList.add(CorrectAnswered);
      print(previousQuestionList);
      if (typeAnswered == CorrectAnswered) {
        RightAnswer();
        print("rightAnswer---------->");
      } else {
        print("wrongAnswer---------->");
      }
    }
    _controller.clear();
    _tcontroller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background2.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Visibility(
                visible: isEnd == false,
                child: GestureDetector(
                  onTap: () {
                    playAdio();
                    if (isAnswer == true) {
                      playAdio();
                    }
                  },
                  child: Container(
                    // height: 250.0,
                    child: Column(
                      children: [
                        Center(
                          child: CircularCountDownTimer(
                            // Countdown duration in Seconds.
                            duration: _duration,

                            // Countdown initial elapsed Duration in Seconds.
                            initialDuration: 0,

                            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                            controller: _tcontroller,

                            // Width of the Countdown Widget.
                            width: MediaQuery.of(context).size.width / 3,

                            // Height of the Countdown Widget.
                            height: MediaQuery.of(context).size.height / 3,

                            // Ring Color for Countdown Widget.
                            ringColor: Colors.grey[300]!,

                            // Ring Gradient for Countdown Widget.
                            ringGradient: null,

                            // Filling Color for Countdown Widget.
                            fillColor: Colors.purpleAccent[100]!,

                            // Filling Gradient for Countdown Widget.
                            fillGradient: null,

                            // Background Color for Countdown Widget.
                            backgroundColor: Colors.purple[500],

                            // Background Gradient for Countdown Widget.
                            backgroundGradient: null,

                            // Border Thickness of the Countdown Ring.
                            strokeWidth: 10.0,

                            // Begin and end contours with a flat edge and no extension.
                            strokeCap: StrokeCap.round,

                            // Text Style for Countdown Text.
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),

                            // Format for the Countdown Text.
                            textFormat: CountdownTextFormat.S,

                            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                            isReverse: false,

                            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                            isReverseAnimation: false,

                            // Handles visibility of the Countdown Text.
                            isTimerTextShown: true,

                            // Handles the timer start.
                            autoStart: false,

                            // This Callback will execute when the Countdown Starts.
                            onStart: () {
                              // Here, do whatever you want
                              setState(() {
                                isStarted = true;
                              });
                              debugPrint('Countdown Started');
                            },

                            // This Callback will execute when the Countdown Ends.
                            onComplete: () {
                              setState(() {
                                isStarted = false;
                              });
                              print('Countdown Ended');
                              // Here, do whatever you want
                            },

                            // This Callback will execute when the Countdown Changes.
                            onChange: (String timeStamp) {
                              // Here, do whatever you want
                              debugPrint('Countdown Changed $timeStamp');
                            },
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return 'play';
                              } else {
                                _t = duration.inSeconds;
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: TextField(
                            controller: _controller,
                            enabled: isStarted,
                            decoration: const InputDecoration(
                              // fillColor: ,
                              border: OutlineInputBorder(),
                              // labelText: 'Enter Word',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: ElevatedButton(
                            onPressed: () {
                              CheckAnswer();
                              NextQuestion();
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                textStyle: const TextStyle(color: Colors.white)),
                            child: const Text('Check word'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                controller: _scrollController,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Container(
                      color: Colors.black87,
                      child: Column(
                        children: review,
                      )),
                ],
              ),
            ],
          ),
        )),
        // bottom nav bar
        Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            flex: 50,
                            child: Container(
                                child: const Center(
                                    child: Text(
                              "Level -1",
                              style: TextStyle(
                                  color: Color(0xFF1687A7),
                                  fontWeight: FontWeight.bold),
                            )))),
                        IconButton(
                          icon: const Icon(
                            Icons.home,
                            color: Color(0xFF1687A7),
                          ),
                          tooltip: "Home",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePageWidget()));
                            quizBrain.reset();
                            _questionNumberActual = 1;
                          },
                        ),
                        Expanded(
                            flex: 50,
                            child: Container(
                                child: Center(
                                    child: Text(
                              'Score - $scor',
                              style: TextStyle(
                                  color: Color(0xFF16A718),
                                  fontWeight: FontWeight.bold),
                            )))),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // priveyas question
  static ContainerReview(
    int i,
    String Q,
    String typeAnswered,
  ) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 180,
                            child: Text(
                              "${i}.${Q}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 180,
                            child: Text(
                              "${typeAnswered}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: Q == typeAnswered,
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          ),
                          Visibility(
                            visible: Q != typeAnswered,
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.close,
                                  color: Colors.pink,
                                  size: 24.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0,
                  child: Center(
                    child: Container(
                      margin:
                          new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                      height: 1.0,
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  getControllerString(TextEditingController controller) {
    return controller.text.toString();
  }

  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: 'Your Scor is a $scor',
      desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: const Text(
            "Home",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {  Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageWidget()));
          quizBrain.reset();
          _questionNumberActual = 1;
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // Navigator.pop(context);
          },
          // onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
