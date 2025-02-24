part of '../../../pages.dart';

class AttendancePage extends StatefulWidget {
  final XFile? image;
  const AttendancePage({super.key, this.image});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  XFile? image;
  String strAddress = '';
  String strDate = '';
  String strTime = '';
  String strDateTime = '';
  String strStatus = 'Attendance';
  bool isloading = false;
  int dateHour = 0;
  int dateMinute = 0;
  double dLat = 0.0;
  double dLong = 0.0;

  final controllerName = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  @override
  void initState() {
    setDateTime();
    setStatusAbsent();

    if (image != null) {
      isloading = true;
      getGeoLocationPosition();
    }

    super.initState();
  }

  //submit data absent to firebase
  Future<void> submitAbsen(String alamat, String nama, String status) async {
    showLoaderDialog(context);
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nama tidak boleh kosong'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showLoaderDialog(context);

    try {
      await dataCollection.add({
        'address': alamat,
        'name': nama,
        'description': status,
        'datetime': strDateTime
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text("Yeay! Attendance Report Successfuly",
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeAttendancePage()));
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text("Ups! $e", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //get realtime location
  Future<void> getGeoLocationPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      isloading = false;
      getAddressFromLongLat(position);
    });
  }

  //get address by lat long
  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      dLat = position.latitude;
      dLat = position.longitude;
      strAddress = "${place.street},"
          "${place.subLocality},"
          "${place.locality},"
          "${place.postalCode},"
          "${place.country},";
    });
  }

  //permission location
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationError("Location services are diabled.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showLocationError("Location permission denied.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showLocationError(
          "Location permission denied forever, we cannot access.");
      return false;
    }
    return true;
  }

  void showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      children: [
        Icon(Icons.error, color: Colors.red),
        Text(message),
      ],
    )));
  }

  //show progress dialog
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text("Checking the data..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setDateTime() async {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('dd/MMMM/YYYY');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHourFormat = DateFormat('HH');
    var dateMinuteFormat = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateFormat.format(dateNow);
      strDateTime = '$strDate | $strTime';

      dateHour = int.parse(dateHourFormat.format(dateNow));
      dateMinute = int.parse(dateMinuteFormat.format(dateNow));
    });
  }

  void setStatusAbsent() {
    if (dateHour < 8 || (dateHour == 8 && dateMinute < 30)) {
      strStatus = 'Atetendance';
    } else if (dateHour < 13) {
      strStatus = 'Late';
    } else {
      strStatus = 'Absent';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Attendance Menu",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.blueAccent,
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.face_retouching_natural_outlined,
                          color: Colors.white),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Please make a selfie photo!",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                  child: Text(
                    "Capture Photo",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraPage()));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    width: size.width,
                    height: 150,
                    child: DottedBorder(
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      color: Colors.blueAccent,
                      strokeWidth: 1,
                      dashPattern: const [5, 5],
                      child: SizedBox.expand(
                        child: FittedBox(
                          child: image != null
                              ? Image.file(File(image!.path), fit: BoxFit.cover)
                              : const Icon(
                                  Icons.camera_enhance_outlined,
                                  color: Colors.blueAccent,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: controllerName,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Your Name",
                      hintText: "Please enter your name",
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      labelStyle:
                          const TextStyle(fontSize: 14, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    "Your Location",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                isloading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent))
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 5 * 24,
                          child: TextField(
                            enabled: false,
                            maxLines: 5,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blueAccent),
                              ),
                              hintText:
                                  strAddress ?? (strAddress = 'Your Location'),
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              fillColor: Colors.transparent,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(30),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                          child: InkWell(
                            splashColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (image == null ||
                                  controllerName.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text("Please Fill all the forms!",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  backgroundColor: Colors.blueGrey,
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              } else {
                                submitAbsen(strAddress,
                                    controllerName.text.toString(), strStatus);
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Report Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
