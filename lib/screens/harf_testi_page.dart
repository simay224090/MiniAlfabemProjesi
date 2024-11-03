import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HarfTestiPage extends StatefulWidget {
  const HarfTestiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HarfTestiPageState createState() => _HarfTestiPageState();
}

class _HarfTestiPageState extends State<HarfTestiPage> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _letters = [
    'A',
    'B',
    'C',
    'Ç',
    'D',
    'E',
    'F',
    'G',
    'Ğ',
    'H',
    'I',
    'İ',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'Ö',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'U',
    'Ü',
    'V',
    'Y',
    'Z'
  ];
  String _currentLetter = '';
  String _feedbackMessage = '';
  String _answerStatus = ''; // "correct", "incorrect" veya ""

  final Random _random = Random();

  Future<void> _playLetterSound(String letter) async {
    await _audioPlayer
        .play(AssetSource('testsounds/${letter.toUpperCase()}.wav'));
  }

  void _checkAnswer() {
    String userAnswer =
        _controller.text.toUpperCase(); // Kullanıcının girdiği yanıtı al
    if (userAnswer == _currentLetter) {
      setState(() {
        _answerStatus = 'correct';
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _answerStatus = '';
          _generateNewLetter();
        });
      });
    } else {
      setState(() {
        _answerStatus = 'incorrect';
        _feedbackMessage =
            'Yanlış, doğru cevap: $_currentLetter\nGirdiğiniz Harf: $userAnswer';
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _answerStatus = '';
        });
      });
    }
    _controller.clear();
  }

  void _generateNewLetter() {
    String newLetter;
    do {
      newLetter = _letters[_random.nextInt(_letters.length)];
    } while (newLetter == _currentLetter);

    setState(() {
      _currentLetter = newLetter;
    });
    _playLetterSound(_currentLetter);
  }

  @override
  void initState() {
    super.initState();
    _generateNewLetter();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/harftest.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Harf Testi',
                style: TextStyle(
                  shadows: [Shadow(color: Colors.black87, blurRadius: 5)],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyFont',
                  color: Color.fromARGB(255, 17, 17, 14),
                ),
              ),
            ),
          ),
          // Geri butonu ekleme
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 14, 14, 14),
                size: 50.0,
              ),
              onPressed: () {
                // Ana sayfaya geri dönme işlemi
                Navigator.pop(context); // Bu sayfadan geri döner
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                const Text(
                  'Dinlediğiniz harfi girin:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Harf Giriniz',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: const Text('Cevabı Kontrol Et'),
                ),
                const SizedBox(height: 20),
                Text(
                  _feedbackMessage,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 26, 29, 31),
                      fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
          if (_answerStatus == 'correct')
            Center(
              child: Card(
                color: Colors.green.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        _currentLetter,
                        style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_answerStatus == 'incorrect')
            Center(
              child: Card(
                color: Colors.red.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.close, color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'YANLIŞ: $_currentLetter',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _playLetterSound(_currentLetter),
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}
