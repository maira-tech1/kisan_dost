import 'package:whisper_cpp_flutter_plus/whisper_cpp_flutter_plus.dart' as whisper;

class WhisperModelManager {
  WhisperModelManager({
    required this.modelName,
    required this.modelUrl,
  });

  final String modelName;
  final String modelUrl;

  final whisper.WhisperModelManager _manager = whisper.WhisperModelManager();

  Future<String> ensureModelDownloaded(
    void Function(double progress)? onProgress,
  ) async {
    final local = await _manager.find(modelName);
    if (local != null) {
      return local.path;
    }

    await for (final progress in _manager.download(Uri.parse(modelUrl), modelName)) {
      onProgress?.call(progress.fraction ?? 0.0);
    }

    final downloaded = await _manager.find(modelName);
    if (downloaded == null) {
      throw Exception('Whisper model "$modelName" could not be downloaded.');
    }
    return downloaded.path;
  }

  void close() {
    _manager.close();
  }
}
