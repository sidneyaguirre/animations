import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PerfumeForm extends StatefulWidget {
  const PerfumeForm({super.key});

  @override
  State<PerfumeForm> createState() => _PerfumeFormState();
}

class _PerfumeFormState extends State<PerfumeForm> {
  static const List<Map<String, List<String>>> _questions = [
    {
      'What are your favorite notes?': [
        '🪵 Woody',
        '🪷 Floral',
        '🍋 Citrus',
        '🧂 Spicy',
      ],
    },
    {
      'What longevity do you prefer?': [
        '☁️ Weak',
        '🌥 Moderate',
        '⛅️ Long lasting',
        '☀️ Eternal'
      ]
    },
    {
      'What sillage do you prefer?': [
        '🔇 Intimate',
        '🔈 Moderate',
        '🔉 Strong',
        '🔊 Enormous',
      ]
    },
    {
      'What category are you looking for?': [
        '🗂 Catalog',
        '🛍️ Commercial',
        '🧧 Niche',
      ]
    },
  ];

  final _responses = <String>[];

  double _formProgress = 0.0;
  double _opacity = 1.0;
  int _questionIndex = 0;
  String? _response;

  void _showPerfumeScreen() {
    _responses.add(_response!);
    _formProgress += 1 / _questions.length;

    setState(() {});
    Future.delayed(const Duration(seconds: 1), () => context.go('/perfume'));
  }

  void _onSelectResponse(String value) {
    _response = value;
    setState(() {});
  }

  Future<void> _updateFormProgress() async {
    _opacity = 0.0;
    _responses.add(_response!);
    _response = null;
    _questionIndex += 1;
    _formProgress += 1 / _questions.length;
    setState(() {});
    
    await Future.delayed(const Duration(milliseconds: 300));

    _opacity = 1.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions.elementAt(_questionIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedProgressIndicator(progress: _formProgress),
              FormQuestion(
                onSelectedOption: (String value) {
                  _onSelectResponse.call(value);
                },
                opacity: _opacity,
                options: question.values.first,
                question: question.keys.first,
              ),
              Flexible(
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.only(top: 12),
                  width: 130,
                  child: ElevatedButton(
                    onPressed: _response != null &&
                            _questionIndex < _questions.length - 1
                        ? _updateFormProgress
                        : _response != null &&
                                _questionIndex == _questions.length - 1
                            ? _showPerfumeScreen
                            : null,
                    child: _questionIndex == _questions.length - 1
                        ? const Text('Finish')
                        : const Text('Continue'),
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

class FormQuestion extends StatefulWidget {
  const FormQuestion({
    super.key,
    required this.onSelectedOption,
    required this.opacity,
    required this.options,
    required this.question,
  });

  final Function(String) onSelectedOption;
  final double opacity;
  final List<String> options;
  final String question;

  @override
  State<FormQuestion> createState() => _FormQuestionState();
}

class _FormQuestionState extends State<FormQuestion> {
  int? _selectedIndex;

  @override
  void didUpdateWidget(covariant FormQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question != oldWidget.question) {
      _selectedIndex = null;
    }
  }

  List<Widget> _buildOptionCards() {
    final options = <Widget>[];
    for (var bIndex = 0; bIndex < widget.options.length; bIndex++) {
      final selected = _selectedIndex != null && _selectedIndex == bIndex;

      options.add(
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              _selectedIndex = bIndex;
              widget.onSelectedOption.call(widget.options.elementAt(bIndex));
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: selected
                    ? Colors.deepPurple.shade900
                    : Colors.deepPurple.shade100,
              ),
              height: 50,
              width: 300,
              child: Text(
                widget.options.elementAt(bIndex),
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.question,
            maxLines: 2,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          ..._buildOptionCards(),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.transparent, end: Colors.red),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.progress);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.all(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: LinearProgressIndicator(
            backgroundColor: _colorAnimation.value?.withOpacity(0.3),
            minHeight: 10.0,
            value: _curveAnimation.value,
            valueColor: _colorAnimation,
          ),
        ),
      ),
    );
  }
}
