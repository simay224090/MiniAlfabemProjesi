Mini Alfabem Projesi
İlkokul ve okul öncesi çocuklara yönelik geliştirmiş olduğumuz uygulama çocukların erken yaşta harfleri doğru bir şekilde öğrenip telaffuz etmesini sağlamak ve ileride harfleri söyleme konusunda zorluk ve engelleri aşmalarına yardımcı olmaya yöneliktir.

Kullanılan Teknoloji ve Kütüphaneler
Flutter: Uygulama arayüzü ve etkileşimli bileşenler oluşturmak için kullanılır.
flutter_sound:Flutter için ses kaydı ve çalma işlemleri yapabilen bir kütüphanedir.FlutterSoundRecorder sınıfı kullanılmıştır. Ses kaydetme, durdurma ve dosyaya yazma gibi işlevler gerçekleştirilir.
permission_handler: Uygulamanızda gerekli izinleri istemek ve kontrol etmek için kullanılan bir kütüphanedir. Mikrofon izni almak için Permission.microphone.request() metodu ile kullanılır. Bu, ses kaydı için gere tflite_flutter: TensorFlow Lite modellerini Flutter uygulamalarında kullanabilmek için geliştirilmiş bir kütüphanedir. TensorFlow Lite modeli yüklemek ve çalıştırmak için Interpreter sınıfı kullanılmıştır. Ses kaydı ile elde edilen verileri işlemek için makine öğrenimi modeli kullanılır.

 Özellikler
- **Harfleri Dinleyelim Butonu**: Çocuklar harflerin doğru telaffuzlarını dinler.
- **Harfleri Seslendirelim Butonu**: Çocuklar, harfleri seslendirerek doğru veya yanlış olup olmadığını öğrenir.
- **Harf Testi Butonu**: Rastgele harf sesleri dinletilir ve çocuklar duydukları harfi yanıtlar.
