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
  final controllerName = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
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
        controllerName.text = fullName;
      });
    } catch (e) {
      print('Error Fetch User: $e');
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
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

  @override
  Widget build(BuildContext context) {
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
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text("Until"),
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
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
