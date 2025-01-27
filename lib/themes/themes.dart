part of 'shared.dart';

final imageLogo = AssetImage('assets/images/monas.jpg');
final imageGoogle = 'assets/icon/google.jpg';
final imageFacebook = 'assets/icon/facebook.png';

final welcomeText = 'Welcome Back 👋';
final subWelcomeText = 'Have a nice day! \n Let\'s start your day!';

final colorPrimary = '1D1C36FF'.toColor();
final colorWhite = 'FEFEFEFE'.toColor();


final hintEmail = 'Email';
final hintName = 'Name';
final hintPassword = 'Password';
final hintConfirmPassword = 'Confirm Password';
final hintForgotPassword = 'ForgotPassword';
final hintSignIn = 'Sign In';
final hintSignUp = 'Sign Up';
final hintOtherSignInOption = 'Other Sign in Option';
final hintGoogle = 'Google';
final hintFacebook = 'Facebook';
final hintDoesntHaveAccount = 'Doesnt Have an account?';

TextStyle welcomeTextStyle = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

TextStyle subWelcomeTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

TextStyle hintTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
