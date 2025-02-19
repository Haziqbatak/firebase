part of '../../pages.dart';

class HomeAttendancePage extends StatefulWidget {
  const HomeAttendancePage({super.key});

  @override
  State<HomeAttendancePage> createState() => _HomeAttendancePageState();
}

class _HomeAttendancePageState extends State<HomeAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/attendance');
                },
                child: Text('attendance'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/leave');
                },
                child: Text('permition'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                child: Text('history Page'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
