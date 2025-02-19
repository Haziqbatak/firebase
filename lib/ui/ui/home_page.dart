part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;
  final FirebaseService _auth = FirebaseService();

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;

    userId = user?.uid;
    userData = _auth.getUserData(userId! ?? '');
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('User Data not found'),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('welcome ${snapshot.data!['email']}'),
                Text('name -  ${snapshot.data!['first name']}'),
                Text('UID - $userId'),
                Text('Name = ${snapshot.data!['role']}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/home-attendance');
                      },
                      child: Text(
                        'home attendance',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/note');
                      },
                      child: Text(
                        'notes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Text(
                        'profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _signOut,
                  child: Text(
                    'sign out',
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
