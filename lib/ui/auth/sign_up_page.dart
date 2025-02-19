part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscureText = true;
  bool isLoading = false;

  final FirebaseService _auth = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  List<String>? role;
  String? selectedRole;

  @override
  void initState() {
    role = ['user', 'admin'];
    selectedRole = role![0];
    super.initState();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      User? user =
          (await _auth.signUp(emailController.text, passwordController.text));

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'first_name': firstName.text,
          'last_name': lastName.text,
          'email': emailController.text,
          'role': selectedRole!.toUpperCase(),
        });

        Navigator.pushReplacementNamed(context, '/home');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registrasi berhasil ${user.email}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // Container(
                  // //   width: MediaQuery.of(context).size.width * 0.9,
                  // //   height: 200,
                  // //   decoration: BoxDecoration(
                  // //     borderRadius: BorderRadius.circular(10),
                  // //     image: DecorationImage(
                  // //       image: AssetImage(imageGoogle),
                  // //       fit: BoxFit.cover,
                  // //     ),
                  // //   ),
                  // // ),
                  // // const SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      welcomeText,
                      style: welcomeTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      subWelcomeText,
                      style: subWelcomeTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: hintEmail,
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: hintPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          icon: isObscureText
                              ? const Icon(
                                  Icons.visibility_off,
                                )
                              : const Icon(
                                  Icons.visibility,
                                ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: isObscureText ? true : false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        } else if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: hintConfirmPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          icon: isObscureText
                              ? const Icon(
                                  Icons.visibility_off,
                                )
                              : const Icon(
                                  Icons.visibility,
                                ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: isObscureText ? true : false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        } else if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        } else if (value != passwordController.text) {
                          return 'Password tidak sama';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text("Role")),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: DropdownButton(
                      value: selectedRole,
                      items: role!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedRole = value;
                          },
                        );
                        print(selectedRole);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _signUp();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              hintSignUp,
                              style: hintTextStyle,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      hintOtherSignInOption,
                      style: subWelcomeTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage(imageGoogle),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              hintGoogle,
                              style: welcomeTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage(imageFacebook),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              hintFacebook,
                              style: welcomeTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          hintConfirmPassword,
                          style: subWelcomeTextStyle,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/sign-in');
                          },
                          child: Text(
                            hintSignIn,
                            style: welcomeTextStyle.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
