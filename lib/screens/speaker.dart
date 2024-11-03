import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';

class LetterRecognitionPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LetterRecognitionPage({Key? key}) : super(key: key);

  @override
  State<LetterRecognitionPage> createState() => _LetterRecognitionPageState();
}

class _LetterRecognitionPageState extends State<LetterRecognitionPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late Interpreter _interpreter;
  List<String> _labels = [];
  String _result = '';
  final List<String> letters = [
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

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeRecorder();
    _loadModel();
    _loadLabels();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/modeller/model.tflite');
  }

  Future<void> _loadLabels() async {
    final labelsData = await DefaultAssetBundle.of(context)
        .loadString('assets/modeller/labels.txt');
    _labels = labelsData.split('\n');
  }

  Future<void> _startRecording() async {
    await _recorder.startRecorder(toFile: 'temp.wav');
    setState(() {
      _isRecording = true;
      _result = 'Kayıt yapılıyor...';
    });
  }

  Future<void> _stopRecording(String expectedLetter) async {
    String? path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (path != null && path.isNotEmpty) {
      // Kayıt tamamlandı, şimdi sesi işle
      await _processAudio(path, expectedLetter);
    } else {
      setState(() {
        _result = 'Kayıt dosyası oluşturulamadı.';
      });
    }
  }

  Future<void> _processAudio(String path, String expectedLetter) async {
    final File audioFile = File(path);
    final input = await _loadAudioFile(audioFile);

    if (input.isEmpty) {
      setState(() {
        _result = 'Giriş dizisi boş. Lütfen sesi kaydedin ve tekrar deneyin.';
      });
      return;
    }

    // Model çıkış boyutunu kontrol et ve düzelt
    final output =
        List.generate(1, (_) => List.filled(29, 0.0)); // [1, 29] boyutlu dizi
    _interpreter.run(input.reshape([1, 40]), output); // 40 MFCC özellik boyutu

    // En yüksek olasılığa sahip sınıfı bulma
    int recognizedIndex = output[0].indexWhere(
        (score) => score == output[0].reduce((a, b) => a > b ? a : b));
    String recognizedLetter = _labels[recognizedIndex];

    // Çıktıdan en yüksek olasılığı bul

    setState(() {
      _result = recognizedLetter == expectedLetter
          ? 'Doğru!'
          : 'Yanlış. Cevap: $recognizedLetter';
    });
  }

  Future<List<double>> _loadAudioFile(File audioFile) async {
    try {
      Uint8List audioBytes = await audioFile.readAsBytes();

      // Burada ses kaydını işleyip model girişi için uygun hale getirin
      // MFCC çıkarımı burada yapılacak
      List<double> input = audioBytes.map((byte) => byte.toDouble()).toList();

      // Gerekli boyut ve format dönüşümünü burada gerçekleştirin
      // Modelin beklediği giriş şekline uygun olarak dönüşüm yapmalısınız.
      // Burada MFCC çıkarımı yapmanız gerekecek, bu örnekte basit bir dönüşüm var.
      return input.sublist(0, 40); // MFCC boyutu 40
    } catch (e) {
      // ignore: avoid_print
      print('Hata: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Harfleri Söyleyelim')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: letters.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: _isRecording
                      ? null
                      : () {
                          _startRecording();
                          Future.delayed(
                            const Duration(seconds: 3),
                            () => _stopRecording(letters[index]),
                          );
                        },
                  child: Text(letters[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Sonuç: $_result',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
