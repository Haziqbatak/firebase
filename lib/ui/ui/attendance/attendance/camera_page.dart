part of '../../../pages.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableLandmarks: true,
    enableClassification: true,
    enableTracking: true,
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  void loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Camera unavailable')));
    }
  }

// permission location
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Location services are disabled. Please enable the services.",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Location permission denied.",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Location permission denied forever, we cannot access.",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  // face detection
  Future<void> processImage(InputImage inputImage) async {
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.of(context).pop(true);
        if (faces.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AttendancePage(image: image),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.face_retouching_natural_outlined,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Ups, make sure that you're face is clearly visible!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.blueGrey,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // set loading
    showLoaderDialog(BuildContext context) {
      AlertDialog alertDialog = AlertDialog(
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      );

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => alertDialog,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Camera"),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: size.height,
            width: size.width,
            child: controller == null
                ? Center(
                    child: Text("Camera Error"),
                  )
                : !controller!.value.isInitialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(controller!),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Lottie.asset(
              'assets/raw/face_id_ring.json',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Make sure you're in a well-lit area so your face is clearly visible.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.blueAccent, // Button color
                        child: InkWell(
                          splashColor: Colors.blue, // Splash color
                          onTap: () async {
                            final hasPermission =
                                await handleLocationPermission();
                            try {
                              if (controller != null) {
                                if (controller!.value.isInitialized) {
                                  controller!.setFlashMode(FlashMode.off);
                                  image = await controller!.takePicture();
                                  setState(() {
                                    if (hasPermission) {
                                      showLoaderDialog(context);
                                      final inputImage =
                                          InputImage.fromFilePath(image!.path);
                                      Platform.isAndroid
                                          ? processImage(inputImage)
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AttendancePage(
                                                          image: image)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Please allow the permission first!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        backgroundColor: Colors.blueGrey,
                                        shape: StadiumBorder(),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  });
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Ups, $e",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                backgroundColor: Colors.blueGrey,
                                shape: const StadiumBorder(),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          },
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
