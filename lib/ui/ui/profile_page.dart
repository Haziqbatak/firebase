part of '../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool isLoading = false;
  String? profileImage;
  File? imageFile;

  @override
  void initState() {
    _loadProfileData();
    _checkEmailVerified();
    super.initState();
  }

  void _checkEmailVerified() async {
    setState(() {
      isLoading = true;
    });

    User? user = _auth.currentUser;

    if (!user!.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email varification link has been sent"),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _sendEmailVerification() async {
    setState(() {
      isLoading = true;
    });

    User? user = _auth.currentUser;

    if (!user!.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email varification link has been sent"),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }

    if (imageFile != null) {
      _uploadImage(imageFile!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference reference =
        FirebaseStorage.instance.ref().child("profile/$userId");

    UploadTask uploadTask = reference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    await _auth.updateProfileImage(imageUrl);

    setState(() {
      profileImage = imageUrl;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully upload image"),
      ),
    );
  }

  void _updateProfile() async {
    setState(() {
      isLoading = true;
    });

    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    await _auth.updateProfile(firstName, lastName);

    setState(() {
      isLoading = false;
    });
  }

  void _loadProfileData() async {
    User? user = _auth.currentUser;
    String userId = user!.uid;
    Map<String, dynamic> userData = await _auth.getUserData(userId);

    firstNameController.text = userData['first_name'];
    lastNameController.text = userData['last_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : profileImage != null
                            ? NetworkImage(profileImage!)
                            : AssetImage('assets/images/barelang.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: "First Name"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: "Last Name"),
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (firstNameController.text.isNotEmpty &&
                          lastNameController.text.isNotEmpty) {
                        _updateProfile();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("First name and last name can't be empty"),
                          ),
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
            _auth.currentUser!.emailVerified
                ? Text("Email Verified")
                : isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _sendEmailVerification();
                        },
                        child: Text("Verify Email"),
                      ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/change-password');
              },
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}