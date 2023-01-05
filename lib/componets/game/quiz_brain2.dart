import 'dart:math';
import '../../pages/question.dart';
import 'question.dart';

class QuizBrain {
  int _questionNumber = Random().nextInt(50);
  List<int> _questionNum=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49];

  final List<word> _questionBank =
  [word("achieve"),
    word("administration"),
    word("affect"),
    word("analysis"),
    word("approach"),
    word("appropriate"),
    word("area"),
    word("aspects"),
    word("assistance"),
    word("assume"),
    word("authority"),
    word("available"),
    word("benefit"),
    word("category"),
    word("community"),
    word("complex"),
    word("concerning"),
    word("conclusion"),
    word("conduct"),
    word("consequence"),
    word("consistent"),
    word("constitutional"),
    word("consumer"),
    word("context"),
    word("create"),
    word("culture"),
    word("data"),
    word("definition"),
    word("destructive"),
    word("discovery"),
    word("distinction"),
    word("economic"),
    word("element"),
    word("environment"),
    word("error"),
    word("equation"),
    word("establish"),
    word("estimate"),
    word("evaluation"),
    word("evidence"),
    word("factors"),
    word("feature"),
    word("final"),
    word("financial"),
    word("focus"),
    word("function"),
    word("global"),
    word("identify"),
    word("impact"),
    word("income"),
  ];

  void nextQuestion() {

    if (_questionNum.length  >1) {
      _questionNum.remove(_questionNumber);
      _questionNumber=Random().nextInt(_questionNum.length);
      _questionNumber=_questionNum[_questionNumber];
    }
  }

  String? getQuestionText() {
    return _questionBank[_questionNumber].wordtext ;
  }

  bool isFinished() {
    if (_questionNum.length==1) {
      print('Now returning true');
      return true;
    } else {
      return false;
    }
  }

  void reset() { _questionNumber = Random().nextInt(50);
  _questionNum=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49];
  }
}
