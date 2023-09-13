import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PerfumeForm(),
      ),
    );
  }
}

class PerfumeForm extends StatefulWidget {
  const PerfumeForm({super.key});

  @override
  State<PerfumeForm> createState() => _PerfumeFormState();
}

class _PerfumeFormState extends State<PerfumeForm> {
  static const List<Map<String, List<String>>> _questions = [
    {
      'What are your favorite notes': [
        'Woody',
        'Floral',
        'Citrus',
        'Spicy',
      ],
    },
    {
      'What perfume longevity do you prefer?': [
        'Weak',
        'Moderate',
        'Long lasting',
        'Eternal'
      ]
    },
    {
      'What perfume sillage do you prefer?': [
        'Intimate',
        'Moderate',
        'Strong',
        'Enormous',
      ]
    },
    {
      'What gender perfume are you looking for?': [
        'Female',
        'Unisex',
        'Male',
      ]
    },
    {
      'What perfume category are you looking for?': [
        'Catalog',
        'Commercial',
        'Niche',
      ]
    },
  ];

  final _responses = <double>[];

  double _formProgress = 0.0;
  int _questionIndex = 0;

  bool _canContinue() {
    return _responses.length - 1 == _questionIndex &&
        _questionIndex < _questions.length - 1;
  }

  void _continue() {
    _questionIndex += 1;
    setState(() {});
  }

  void _showPerfumeScreen() {
    context.go('/perfume');
  }

  void _updateFormProgress() {
    _responses.add(_formProgress);

    if (_responses.length - 1 == _questionIndex) {
      _formProgress += 1 / _questions.length;
    } else if (_responses.length > _questionIndex) {
      _responses.removeLast();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions.elementAt(_questionIndex);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AnimatedProgressIndicator(progress: _formProgress),
        FormQuestion(
          onSelectedOption: _updateFormProgress,
          options: question.values.first,
          question: question.keys.first,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.black54;
              }),
            ),
            onPressed: _canContinue()
                ? _continue
                : _responses.length == 5
                    ? _showPerfumeScreen
                    : null,
            child: _formProgress != 1 && _questionIndex < _questions.length - 1
                ? const Text('Continue')
                : Text('Finish!'),
          ),
        ),
      ],
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
        tween: ColorTween(
            begin: AppTheme.violetPastel, end: AppTheme.salmonPastel),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
            begin: AppTheme.salmonPastel, end: AppTheme.orangePastel),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
            begin: AppTheme.orangePastel, end: AppTheme.yellowPastel),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
            begin: AppTheme.yellowPastel, end: AppTheme.greenApplePastel),
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.all(50.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: LinearProgressIndicator(
            backgroundColor: _colorAnimation.value?.withOpacity(0.5),
            minHeight: 10.0,
            value: _curveAnimation.value,
            valueColor: _colorAnimation,
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
    required this.options,
    required this.question,
  });

  final VoidCallback onSelectedOption;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.question,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 20.0),
        for (var bIndex = 0; bIndex < widget.options.length; bIndex++)
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                _selectedIndex = bIndex;
                widget.onSelectedOption.call();
              },
              style: ButtonStyle(
                backgroundColor:
                    _selectedIndex != null && _selectedIndex == bIndex
                        ? MaterialStateProperty.resolveWith(
                            (states) => Colors.deepPurple.shade300)
                        : MaterialStateProperty.resolveWith(
                            (states) => Colors.deepPurple.shade50),
                foregroundColor: MaterialStateProperty.resolveWith(
                  _selectedIndex != null && _selectedIndex == bIndex
                      ? (states) => Colors.white
                      : (states) => Colors.deepPurple,
                ),
              ),
              child: Text(widget.options.elementAt(bIndex)),
            ),
          ),
      ],
    );
  }
}
