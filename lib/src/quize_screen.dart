import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart' show AssetSource;

class QuizScreen extends StatefulWidget {
  final bool isArabic;
  const QuizScreen({super.key, required this.isArabic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const Color kJordanRed = Color(0xFFB71C1C);
  static const Color kJordanBlack = Color(0xFF111111);

  // ✅ أسئلة عربي
  final List<Map<String, Object>> _questionsAr = [
    {
      'question': 'أي موقع في الأردن يشتهر بالخزنة المنحوتة في الصخر؟',
      'answers': [
        {'text': 'البتراء', 'correct': true},
        {'text': 'جرش', 'correct': false},
        {'text': 'وادي رم', 'correct': false},
        {'text': 'العقبة', 'correct': false},
      ],
    },
    {
      'question': 'أي مكان معروف بالصحراء والرحلات بسيارات الدفع الرباعي؟',
      'answers': [
        {'text': 'وادي رم', 'correct': true},
        {'text': 'جرش', 'correct': false},
        {'text': 'البتراء', 'correct': false},
        {'text': 'إربد', 'correct': false},
      ],
    },
    {
      'question': 'أي موقع يحتوي على آثار رومانية وساحة الأعمدة البيضاوية؟',
      'answers': [
        {'text': 'جرش', 'correct': true},
        {'text': 'البتراء', 'correct': false},
        {'text': 'وادي رم', 'correct': false},
        {'text': 'الكرك', 'correct': false},
      ],
    },
    {
      'question':
          'ماذا يجب أن يأخذ السائح معه عند زيارة الأماكن السياحية في الصيف؟',
      'answers': [
        {'text': 'ماء وواقي شمس', 'correct': true},
        {'text': 'معطف شتوي فقط', 'correct': false},
        {'text': 'لا شيء', 'correct': false},
        {'text': 'مصباح يدوي فقط', 'correct': false},
      ],
    },
    {
      'question': 'لماذا يكون التابلت مفيدا عند مشاهدة الفيديوهات السياحية؟',
      'answers': [
        {'text': 'لأن شاشته أكبر وأسهل في المشاهدة', 'correct': true},
        {'text': 'لأنه لا يشغل فيديوهات', 'correct': false},
        {'text': 'لأنه لا يحتاج إنترنت', 'correct': false},
        {'text': 'لأنه أبطأ دائما', 'correct': false},
      ],
    },
  ];

  // ✅ أسئلة إنجليزي
  final List<Map<String, Object>> _questionsEn = [
    {
      'question':
          'Which place in Jordan is famous for Al-Khazneh (the Treasury)?',
      'answers': [
        {'text': 'Petra', 'correct': true},
        {'text': 'Jerash', 'correct': false},
        {'text': 'Wadi Rum', 'correct': false},
        {'text': 'Aqaba', 'correct': false},
      ],
    },
    {
      'question': 'Which place is known for deserts and 4x4 safari tours?',
      'answers': [
        {'text': 'Wadi Rum', 'correct': true},
        {'text': 'Jerash', 'correct': false},
        {'text': 'Petra', 'correct': false},
        {'text': 'Irbid', 'correct': false},
      ],
    },
    {
      'question': 'Which site includes Roman ruins and the Oval Plaza?',
      'answers': [
        {'text': 'Jerash', 'correct': true},
        {'text': 'Petra', 'correct': false},
        {'text': 'Wadi Rum', 'correct': false},
        {'text': 'Karak', 'correct': false},
      ],
    },
    {
      'question': 'What should a tourist bring when visiting in summer?',
      'answers': [
        {'text': 'Water and sunscreen', 'correct': true},
        {'text': 'Only a winter coat', 'correct': false},
        {'text': 'Nothing', 'correct': false},
        {'text': 'Only a flashlight', 'correct': false},
      ],
    },
    {
      'question': 'Why is a tablet useful for watching tourism videos?',
      'answers': [
        {
          'text': 'Because the screen is bigger and easier to watch',
          'correct': true
        },
        {'text': 'Because it cannot play videos', 'correct': false},
        {'text': 'Because it does not need internet', 'correct': false},
        {'text': 'Because it is always slower', 'correct': false},
      ],
    },
  ];

  List<Map<String, Object>> get _questions =>
      widget.isArabic ? _questionsAr : _questionsEn;

  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedIndex;

  late final AudioPlayer _sfxCorrect;
  late final AudioPlayer _sfxWrong;

  @override
  void initState() {
    super.initState();
    _sfxCorrect = AudioPlayer()..setVolume(0.9);
    _sfxWrong = AudioPlayer()..setVolume(0.9);
  }

  @override
  void dispose() {
    _sfxCorrect.dispose();
    _sfxWrong.dispose();
    super.dispose();
  }

  void _answerQuestion(int index, bool isCorrect) async {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedIndex = index;
      if (isCorrect) _score++;
    });

    if (isCorrect) {
      await _sfxCorrect.stop();
      await _sfxCorrect.play(AssetSource('sound_effect/correct.mp3'));
    } else {
      await _sfxWrong.stop();
      await _sfxWrong.play(AssetSource('sound_effect/wrong.mp3'));
    }

    await Future.delayed(const Duration(milliseconds: 900));
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedIndex = null;
      });
    } else {
      _showResult();
    }
  }

  void _restart() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _selectedIndex = null;
    });
  }

  void _showResult() {
    final passed = _score >= 3;

    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title:
              Text(widget.isArabic ? 'انتهى الاختبار 🎉' : 'Quiz Finished 🎉'),
          content: Text(
            widget.isArabic
                ? 'نتيجتك $_score من ${_questions.length}\n${passed ? "ممتاز معلوماتك عن الاردن قوية" : "جربي مرة ثانية لحتى تحسني نتيجتك"}'
                : 'Your score: $_score / ${_questions.length}\n${passed ? "Great! Your Jordan knowledge is strong." : "Try again to improve your score."}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restart();
              },
              child: Text(widget.isArabic ? 'إعادة' : 'Restart'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.isArabic ? 'إغلاق' : 'Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    final answers = q['answers'] as List<Map<String, Object>>;
    final shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.isArabic ? 'اختبار الأردن' : 'Jordan Quiz'),
          backgroundColor: kJordanRed,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isArabic
                    ? 'السؤال ${_currentQuestion + 1} من ${_questions.length}'
                    : 'Question ${_currentQuestion + 1} of ${_questions.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color ??
                      kJordanBlack,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  q['question'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(answers.length, (i) {
                final isCorrect = answers[i]['correct'] as bool;
                final isSelected = _selectedIndex == i;

                Color bgColor;
                if (_answered && isCorrect) {
                  bgColor = Colors.green;
                } else if (_answered && isSelected && !isCorrect) {
                  bgColor = Colors.red;
                } else {
                  bgColor = Theme.of(context).cardColor;
                }

                final fg = (bgColor == Theme.of(context).cardColor)
                    ? (Theme.of(context).textTheme.bodyLarge?.color ??
                        kJordanBlack)
                    : Colors.white;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_answered) return;
                      _answerQuestion(i, isCorrect);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      foregroundColor: fg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      answers[i]['text'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Text(
                widget.isArabic ? 'النتيجة $_score' : 'Score: $_score',
                textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
