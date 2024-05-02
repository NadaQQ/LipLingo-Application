import 'package:flutter/material.dart';
//import 'package:flutter/url_launcher.dart';

import 'package:liplingo/view/help.dart';
import 'SignIn.dart';
import 'editProfile.dart';

import 'package:liplingo/utils/reusableWidgets.dart';
import 'package:liplingo/controller/userController.dart';
import '../model/userModel.dart';

class AccountSettingsScreen extends StatelessWidget {

  //Initialize Controller
  UserController _userController = new UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        toolbarHeight: 60,
        leadingWidth: 75,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Set background color for the body
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User Photo, Username, and Edit Profile Button
                _buildUserProfileSection(context),

                // Space
                SizedBox(height: 60),

                // Clickable Options - Clear Text Data, Contact Us, Help
                _buildClickableOption(
                    context, 'Clear Text Data', Icons.clear, () => showDeleteSavedTextDialog(context)),
                SizedBox(height: 16), // Add space between options
                _buildClickableOption(context, 'Contact Us', Icons.mail, _onContactUs),
                SizedBox(height: 16), // Add space between options
                _buildClickableOption(context, 'Help', Icons.help, () => _onHelp(context)),

                // Space
                SizedBox(height: 60),

                // Clickable Options - Log Out, Delete Account
                _buildClickableOption(context, 'Log Out', Icons.logout, () => showLogoutConfirmation(context)),

                SizedBox(height: 16), // Add space between options
                _buildClickableOption(context, 'Delete Account', Icons.delete, () => showDeleteAccountDialog(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return FutureBuilder<Users?>(
      future: _userController.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {

          var _userData = snapshot.data;
          String username = (_userData!.firstName + " " + _userData.lastName) ?? 'Full Name';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(userData: _userData,)),
              );
            },
            child: Container(
              padding: EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.0),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/AppBar_Profile.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }


  Widget _buildClickableOption(BuildContext context, String text, IconData icon,
      VoidCallback onTapCallback) {
    Color textColor = Colors.black; // Default text color
    Color iconColor = Colors.black; // Default icon color

    // Customize text and icon colors for "Delete Account" and "Log Out"
    if (text == 'Delete Account' || text == 'Log Out') {
      textColor = Colors.red;
      iconColor = Colors.red;
    }

    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor, // Set icon color
            ),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: textColor, // Set text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContactUs() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'lipLingo@gmail.com',
      queryParameters: {'subject': 'Contact Us'},
    );

    final String emailUri = emailLaunchUri.toString();

    try {
      //await launch(emailUri);
    } catch (e) {
      print('Error launching email client: $e');
    }
  } // remove try-catch if it workes on physical emulator

  void _onHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Confirm Deletion?",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 10),
                    Text("Are you sure you would like to delete your account?",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(width: 1, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 27.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.red[700],
                          ),
                          child: Text("Delete",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          onPressed: () {
                            try {
                              //Delete account and navigate to sign in screen
                              _userController.deleteAccount();
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignInScreen()), // Navigate to your SignIn screen
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account deleted successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );

                            } catch (error) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Unable to delete account."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ])),
        );
      },
    );
  }


  void showDeleteSavedTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Confirm Deletion?",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 10),
                    Text(
                        "Are you sure you would like to delete all your saved texts?",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(width: 1, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 27.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.red[700],
                          ),
                          child: Text("Delete",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          onPressed: () {
                            try {
                              _userController.clearSavedTextList();
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Saved text list has been cleared!"),
                                backgroundColor: Colors.green,
                              ),);

                            } catch(error){
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Unable to delete saved text lists."),
                                backgroundColor: Colors.red,
                              ),);
                            }
                          },
                        ),
                      ],
                    )
                  ])),
        );
      },
    );
  }

}