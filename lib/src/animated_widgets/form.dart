import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
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
        '🪵 Woody',
        '🪷 Floral',
        '🍋 Citrus',
        '🧂 Spicy',
      ],
    },
    {
      'What perfume longevity do you prefer?': [
        '☁️ Weak',
        '🌥 Moderate',
        '⛅️ Long lasting',
        '☀️ Eternal'
      ]
    },
    {
      'What perfume sillage do you prefer?': [
        '🔇 Intimate',
        '🔈 Moderate',
        '🔉 Strong',
        '🔊 Enormous',
      ]
    },
    {
      'What gender perfume are you looking for?': [
        '🌔 Female',
        '🌗 Unisex',
        '🌖 Male',
      ]
    },
    {
      'What perfume category are you looking for?': [
        '🗂 Catalog',
        '🛍️ Commercial',
        '🧧 Niche',
      ]
    },
  ];

  final _responses = <String>[];

  double _formProgress = 0.0;
  int _questionIndex = 0;
  String? _response;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _response = null;
    setState(() {});
  }

  void _showPerfumeScreen() {
    _responses.add(_response!);
    context.go('/perfume');
  }

  void _onSelectResponse(String value) {
    _response = value;
    setState(() {});
  }

  void _updateFormProgress() {
    _responses.add(_response!);
    _questionIndex += 1;
    _formProgress += 1 / _questions.length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions.elementAt(_questionIndex);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedProgressIndicator(progress: _formProgress),
          FormQuestion(
            onSelectedOption: (String value) {
              _onSelectResponse.call(value);
            },
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
              onPressed:
                  _response != null && _questionIndex < _questions.length - 1
                      ? _updateFormProgress
                      : _responses.length < _questions.length
                          ? _showPerfumeScreen
                          : null,
              child:
                  _response != null && _questionIndex == _questions.length - 1
                      ? const Text('Finish')
                      : const Text('Continue!'),
            ),
          ),
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
        tween: ColorTween(begin: Colors.pink, end: Colors.red),
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.all(50.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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

class FormQuestion extends StatefulWidget {
  const FormQuestion({
    super.key,
    required this.onSelectedOption,
    required this.options,
    required this.question,
  });

  final Function(String) onSelectedOption;
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
              decoration: BoxDecoration(
                border: selected
                    ? Border.all(color: Colors.deepPurple.shade300, width: 2)
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: selected ? Colors.deepPurple.shade100 : Colors.white,
              ),
              alignment: Alignment.center,
              height: 50,
              width: 300,
              child: Text(
                widget.options.elementAt(bIndex),
                style: TextStyle(
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
        ..._buildOptionCards(),
      ],
    );
  }
}
