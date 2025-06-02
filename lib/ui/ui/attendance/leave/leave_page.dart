part of '../../../pages.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String strAddress = '';
  String strDate = '';
  String strTime = '';
  String strDateTime = '';
  int dateHour = 0;
  int dateMinute = 0;
  double dLat = 0.0;
  double dLong = 0.0;
  final nameController = TextEditingController();
  final fromController = TextEditingController();
  final untilController = TextEditingController();
  String dropValueCategories = 'Please Choose';
  var categoryList = <String>[
    "Please Choose",
    "Sick",
    "Permission",
    "Other",
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

    if (userId == "Unknown") {
      return;
    }
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      print("User Doc: ${userDoc.data()}");
      // fisrt_name last_name
      String firstName = userDoc['first_name'];
      String lastName = userDoc['last_name'];
      String fullName = '$firstName $lastName';

      setState(() {
        nameController.text = fullName;
      });
    } catch (e) {
      print('Error Fetch User: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave'),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.home_filled, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Please fill the Form Below',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                //form name
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: nameController,
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    "Leave Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: DropdownButton(
                      value: dropValueCategories,
                      onChanged: (value) {
                        setState(() {
                          dropValueCategories = value.toString();
                        });
                      },
                      items: categoryList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      //from
                      Expanded(
                        child: Row(
                          children: [
                            const Text("From"),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: fromController,
                                onTap: () async {
                                  DateTime? pickDateTime = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                    initialDate: DateTime.now(),
                                  );
                                  if (pickDateTime != null) {
                                    fromController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickDateTime);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      //until
                      Expanded(
                        child: Row(
                          children: [
                            const Text("Until"),
                            Expanded(
                              child: TextField(
                                controller: untilController,
                                onTap: () async {
                                  DateTime? pickDateTime = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                    initialDate: DateTime.now(),
                                  );
                                  if (pickDateTime != null) {
                                    untilController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickDateTime);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: size.width * 0.8,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                          child: InkWell(
                            splashColor: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              if (nameController.text.isEmpty ||
                                  dropValueCategories == 'Pleade Choose' ||
                                  fromController.text.isEmpty ||
                                  untilController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Please fill all the form',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                submitAbsent(
                                  nameController.text.toString(),
                                  dropValueCategories.toString(),
                                  fromController.text.toString(),
                                  untilController.text.toString(),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> submitAbsent(
      String name, String status, String from, String until) async {
    showLoaderDialog(context);

    String userId = FirebaseAuth.instance.currentUser?.uid ?? "Unknown";
    print("USER ID = $userId");

    if (userId == "unknown") {
      print("ERROR: USER ID NOT FOUND");
      return;
    }

    DocumentReference userDocRef = firestore.collection("users").doc(userId);
    CollectionReference attendanceCollection =
        userDocRef.collection('attendance');

    attendanceCollection.add({
      'address': "",
      'name': name,
      'description': status,
      'datetime': strDateTime,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((result) {
      print("Data berhasil disimpan dengan ID = ${result.id}");
      setState(() {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 19,
                ),
                Text(
                  "Yeayy, berhasil di submit, report or successed",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.greenAccent,
            behavior: SnackBarBehavior.floating,
            shape: StadiumBorder(),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeAttendancePage(),
          ),
        );
      });
    }).catchError((error) {
      print("Error menyimpan data $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 19,
              ),
              Text(
                "Upps... $error",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
        ),
      );
    });
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text("Please Wait ..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
