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
  final controllerName = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  @override
  void initState() {
    super.initState();
  }

  void setDateTime() async {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('dd/MMMM/YYYY');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHour = DateFormat('HH');
    var dateMinute = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateFormat.format(dateNow);
      strDateTime = '$strDate | $strTime';

      dateHour = int.parse(dateHour.format(dateNow)) as DateFormat;
      dateMinute = int.parse(dateMinute.format(dateNow)) as DateFormat;
    });
  }

  void setStatusAbsent() {
    if (dateHour < 8 || (dateHour == 8 && dateMinute < 30)) {
      strStatus = 'Atetendance';
    } else if((dateHour > 8 && dateHour < 17) || (dateHour == 8 && dateMinute > 30)) {
      strStatus = 'Late';
    } else{
      strStatus = 'Absent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
      ),
      body: Center(),
    );
  }
}
