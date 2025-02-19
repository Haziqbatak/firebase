import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class Vision {
  Vision._();
  static final Vision instance = Vision._();

  FaceDetector faceDetector(FaceDetectorOptions? option) {
    return FaceDetector(options: option ?? FaceDetectorOptions());
  }
}
