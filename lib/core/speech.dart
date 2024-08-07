part of 'main.dart';

class Speech extends UnitSpeech {
  @override
  Future<void> init() async {
    await setLanguage();
    await api.setSpeechRate(0.4);
    await api.setVolume(1.0);
    await api.setPitch(0.9);
  }
}
