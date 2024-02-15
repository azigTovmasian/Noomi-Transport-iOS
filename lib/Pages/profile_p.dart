import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noomi_transport_app/Pages/signin_p.dart';
import 'package:noomi_transport_app/Pages/time_off_request_p.dart';
import 'package:noomi_transport_app/Widgets/error_refresh_w.dart';
import 'package:provider/provider.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/profile_prov.dart';
import '../Widgets/availability_days_check_box_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/custom_textfield_w.dart';
import '../Widgets/no_internet_w.dart';
import '../Widgets/pop_up_dialog_w.dart';
import '../Widgets/progress_indicator_w.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import '../Widgets/state_drop_down_w.dart';
import 'Privacy_policy_p.dart';
import 'my_trips_p.dart';
import 'package:path/path.dart' as path;

class ProfileP extends StatefulWidget {
  const ProfileP({super.key});

  @override
  State<ProfileP> createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  File? imageFile;
  bool isTimeOffRequestPressed = false,
      isSaveProfilePressed = false,
      isEmailValidated = true,
      isEPhoneNumValidated = true;
  bool formChanged = false;
  bool isImageChanged = false;

  @override
  void initState() {
    String driverId =
        Provider.of<PhoneProv>(context, listen: false).driverId ?? '';
    Provider.of<ProfileProv>(context, listen: false).fetchProfileData(
      driverId,
    );

    super.initState();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // Create a new file with the desired name
      final directory = await getApplicationDocumentsDirectory();
      final newPath = path.join(directory.path,
          '${Provider.of<ProfileProv>(context, listen: false).profile!.firstName + Provider.of<ProfileProv>(context, listen: false).profile!.lastName}');
      final newFile = File(image.path).renameSync(newPath);

      setState(() {
        imageFile = newFile;
      });

      if (imageFile != null) {
        Provider.of<ProfileProv>(context, listen: false).setIsImagePicked(true);
      }
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {}
  }

  void handleFormChange() {
    setState(() {
      formChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ProfileProv profile = Provider.of<ProfileProv>(context, listen: false);
    ProfileProv notifiedProfile =
        Provider.of<ProfileProv>(context, listen: true);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);

    PhoneProv phoneProv = Provider.of<PhoneProv>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (formChanged) {
          // Show confirmation dialog if changes are made
          bool discardChanges = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'),
              content: Text(
                  'You have unsaved changes. Are you sure you want to discard them?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false to not pop
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true to pop
                  },
                  child: Text('Discard'),
                ),
              ],
            ),
          );
          if (discardChanges) {
            profile.setIsImagePicked(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyTripsP()),
            );
          }
          return Future.value(false);
        } else {
          profile.setIsImagePicked(false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyTripsP()),
          );
          return Future.value(false);
        }

        // profile.setIsImagePicked(false);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyTripsP()),
        // );
        // return Future.value(false);
      },
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    iconSize: 34,
                    icon: Icon(
                      color: Color(0xff7CA03E),
                      Icons.arrow_back_rounded,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyTripsP()),
                      );
                      profile.setIsImagePicked(false);
                    },
                  ),
                  backgroundColor: Colors.white,
                  title: Text(
                    "Edit Your Profile",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      color: Color(0xff7CA03E),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Color(0xff7CA03E),
                        size: 35,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Log out"),
                              content:
                                  Text("Are you sure you want to log out?"),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Color(0xff7CA03E)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Color(0xff7CA03E)),
                                  ),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Provider.of<PhoneProv>(context,
                                            listen: false)
                                        .saveDriverId('');
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignInP()),
                                      );
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                  centerTitle: true,
                  elevation: 2,
                ),
                backgroundColor: Color(0xffE8EEEA),
                body: Visibility(
                  replacement: NoInternetW(),
                  visible: connectivity.isThereInternet,
                  child: Visibility(
                    visible: !notifiedProfile.isLoading,
                    child: notifiedProfile.errorMessage.isNotEmpty
                        ? ErrorAndRefreshW(
                            errorMessage: profile.errorMessage,
                            onRefreshPressed: () async {
                              String driverId =
                                  Provider.of<PhoneProv>(context, listen: false)
                                          .driverId ??
                                      '';
                              await Provider.of<ProfileProv>(context,
                                      listen: false)
                                  .fetchProfileData(
                                driverId,
                              );
                            })
                        : Container(
                            height: height,
                            width: width,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 22, 0, 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: (notifiedProfile.profile!
                                                .profileImage.isNotEmpty &&
                                            !notifiedProfile.isImagePicked)
                                        ? CircleAvatar(
                                            radius: 60,
                                            backgroundImage: AssetImage(
                                                'assets/images/default_profile.png'),
                                            child: Image.network(
                                              profile.profile!.profileImage,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : notifiedProfile.isImagePicked &&
                                                imageFile != null
                                            ? Image.file(
                                                imageFile!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/default_profile.png',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 16),
                                  child: InkWell(
                                    onTap: () async {
                                      pickImage();
                                      setState(() {
                                         isImageChanged = true;
                                      });
                                    },
                                    child: Text(
                                      'Change Photo',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xff835FC1),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomTextFieldW(
                                  textInputType: TextInputType.text,
                                  enable: true,
                                  controller: profile.firstNameController,
                                  text: 'First Name',
                                  fillColor: Color(0xffFFFFFF),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[a-zA-Z\s]')), // Allow only alphabet characters
                                  ],
                                  onChanged: (value) {
                                    handleFormChange;
                                  },
                                ),
                                CustomTextFieldW(
                                  textInputType: TextInputType.text,
                                  enable: true,
                                  controller: profile.lastNameController,
                                  text: 'Last Name',
                                  fillColor: Color(0xffFFFFFF),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[a-zA-Z\s]')), // Allow only alphabet characters
                                  ],
                                ),
                                CustomTextFieldW(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      isEmailValidated = false;
                                      return 'Please enter your email address';
                                    }
                                    if (!RegExp(
                                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                        .hasMatch(value)) {
                                      isEmailValidated = false;

                                      return 'Please enter a valid email address';
                                    }
                                    isEmailValidated = true;

                                    return null;
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  enable: true,
                                  fillColor: Color(0xffFFFFFF),
                                  controller: profile.emailController,
                                  text: 'Email Address',
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                CustomTextFieldW(
                                  textInputType: TextInputType.text,
                                  enable: true,
                                  fillColor: Color(0xffFFFFFF),
                                  controller: profile.streetController,
                                  text: 'Street Address',
                                ),
                                CustomTextFieldW(
                                  textInputType: TextInputType.text,
                                  enable: true,
                                  fillColor: Color(0xffFFFFFF),
                                  controller: profile.cityController,
                                  text: 'City',
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: width * 0.5,
                                      child: CustomTextFieldW(
                                        textInputType: TextInputType.number,
                                        enable: true,
                                        fillColor: Color(0xffFFFFFF),
                                        controller: profile.zipController,
                                        text: 'Zip Code',
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 16, 0),
                                        child: SizedBox(
                                            width: width * 0.45,
                                            child: StateDropDown())),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                CustomTextFieldW(
                                  textInputType: TextInputType.text,
                                  enable: true,
                                  fillColor: Color(0xffFFFFFF),
                                  controller: profile.contactNameController,
                                  text: 'Emergency Contact Name',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[a-zA-Z\s]')), // Allow alphabet characters and spaces
                                    // Allow only alphabet characters
                                  ],
                                ),
                                CustomTextFieldW(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      isEPhoneNumValidated = false;
                                      return 'Please enter your phone number';
                                    }
                                    // Remove any non-numeric characters except '+' and spaces
                                    value = value.replaceAll(
                                        RegExp(r'[^\d+\s]'), '');

                                    if (!RegExp(r'^\+1\d{10}$')
                                        .hasMatch(value)) {
                                      if (value.length > 12) {
                                        isEPhoneNumValidated = false;
                                        // 12 is the length of a valid US phone number with country code
                                        return 'Please enter a phone number that is 12 digits or less';
                                      }
                                      isEPhoneNumValidated = false;
                                      return 'Please enter a valid US phone number with country code (+1)';
                                    }
                                    isEPhoneNumValidated = true;
                                    return null;
                                  },
                                  textInputType: TextInputType.phone,
                                  enable: true,
                                  fillColor: Color(0xffFFFFFF),
                                  controller:
                                      profile.contactPhoneNumberController,
                                  text: 'Emergency Contact Number',
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("Availability Days",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700)),
                                ),
                                AvailabilityDaysCheckBoxW(),
                                SizedBox(
                                  height: 25,
                                ),
                                CustomButton(
                                    width: width - 32,
                                    height: height * 0.065,
                                    buttonColor: Color(0xff835FC1),
                                    buttonTitle: "Time OFF REQUEST",
                                    onPressed: () {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TimeOffRequestP()),
                                        );
                                      });
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomButton(
                                    width: width - 32,
                                    height: height * 0.065,
                                    buttonColor: (isEPhoneNumValidated &&
                                            isEmailValidated)
                                        ? const Color(0xff7CA03E)
                                        : const Color.fromARGB(
                                            255, 142, 142, 136),
                                    buttonTitle: "SAVE",
                                    onPressed: (isEPhoneNumValidated &&
                                            isEmailValidated)
                                        ? () async {
                                            profile.setIsSaving(true);
                                            File? urlImageFile = imageFile;
                                            if (urlImageFile == null) {
                                              urlImageFile =
                                                  await downloadProfileImage(
                                                      profile);
                                            }
                                            await profile.updateProfile(
                                              driverId:
                                                  phoneProv.driverId ?? '',
                                              firstName: profile
                                                  .firstNameController.text,
                                              state: getStateNumber(profile
                                                  .dropDownSelectedState),
                                              lastName: profile
                                                  .lastNameController.text,
                                              city: profile.cityController.text,
                                              emergencyName: profile
                                                  .contactNameController.text,
                                              emergencyPhone: profile
                                                  .contactPhoneNumberController
                                                  .text,
                                              email:
                                                  profile.emailController.text,
                                              zipCode:
                                                  profile.zipController.text,
                                              address1:
                                                  profile.streetController.text,
                                              imageFile:isImageChanged? urlImageFile:null,
                                            );
                                            profile.setIsSaving(false);
                                            PopUpDialogW(
                                              onPressed: () {
                                                if (notifiedProfile
                                                    .isSentSuccessfully) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyTripsP()),
                                                  );
                                                  Provider.of<ProfileProv>(
                                                          context,
                                                          listen: false)
                                                      .setIsImagePicked(false);
                                                } else {
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              context: context,
                                              title: 'Driver Profile',
                                              body: notifiedProfile
                                                      .isSentSuccessfully
                                                  ? 'Your profile data has been updated successfully!'
                                                  : profile.errorMessage,
                                            );
                                          }
                                        : () {},
                                  ),
                                ),

                                // Padding(
                                //   padding: const EdgeInsets.all(16),
                                //   child: CustomButton(
                                //     width: width - 32,
                                //     height: height * 0.065,
                                //     buttonColor: (isEPhoneNumValidated &&
                                //             isEmailValidated)
                                //         ? Color(0xff7CA03E)
                                //         : Color.fromARGB(255, 142, 142, 136),
                                //     buttonTitle: "SAVE",
                                //     onPressed: (isEPhoneNumValidated &&
                                //             isEmailValidated)
                                //         ? () async {
                                //             profile.setIsSaving(true);
                                //             if (imageFile == null) {
                                //               final File urlImageFile =
                                //                   await downloadProfileImage(
                                //                       profile);
                                //               imageFile = urlImageFile;
                                //             } else {
                                //               imageFile = imageFile;
                                //             }
                                //             await profile.updateProfile(
                                //               driverId:
                                //                   phoneProv.driverId ?? '',
                                //               firstName: profile
                                //                   .firstNameController.text,
                                //               state: getStateNumber(profile
                                //                   .dropDownSelectedState),
                                //               lastName: profile
                                //                   .lastNameController.text,
                                //               city: profile.cityController.text,
                                //               emergencyName: profile
                                //                   .contactNameController.text,
                                //               emergencyPhone: profile
                                //                   .contactPhoneNumberController
                                //                   .text,
                                //               email:
                                //                   profile.emailController.text,
                                //               // zipCode: int.parse(
                                //               //     profile.zipController.text),
                                //               zipCode:
                                //                   profile.zipController.text,
                                //               address1:
                                //                   profile.streetController.text,
                                //               imageFile: imageFile,
                                //             );
                                //             profile.setIsSaving(false);
                                //             PopUpDialogW(
                                //                 onPressed: () {
                                //                   notifiedProfile
                                //                           .isSentSuccessfully
                                //                       ? Navigator
                                //                           .pushReplacement(
                                //                           context,
                                //                           MaterialPageRoute(
                                //                               builder:
                                //                                   (context) =>
                                //                                       MyTripsP()),
                                //                         )
                                //                       : Navigator.of(context)
                                //                           .pop();
                                //                   if (notifiedProfile
                                //                       .isSentSuccessfully) {
                                //                     Provider.of<ProfileProv>(
                                //                             context,
                                //                             listen: false)
                                //                         .setIsImagePicked(
                                //                             false);
                                //                   }
                                //                 },
                                //                 context: context,
                                //                 title: 'Driver Profile',
                                //                 body: notifiedProfile
                                //                         .isSentSuccessfully
                                //                     ? 'Your profile data has been updated successfully!'
                                //                     : profile.errorMessage);
                                //           }
                                //         : () {},
                                //   ),
                                // ),

                                SizedBox(
                                  height: 40,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyP()),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(180),
                                      topRight: Radius.circular(180),
                                    ),
                                    child: Container(
                                      width: width * 0.2,
                                      height: 35,
                                      child: Center(
                                        child: Icon(
                                          color: Color(0xff7CA03E),
                                          Icons.privacy_tip_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width,
                                  height: 30,
                                  child: Center(
                                    child: Text("Privacy Policy",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ),
                                )
                              ]),
                            ),
                          ),
                    replacement: ProgressIndicatorW(),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: notifiedProfile.isSaving,
            child: Container(
              color: Colors.transparent.withOpacity(0.7),
              child: Center(child: ProgressIndicatorW()),
            ),
          ),
        ],
      ),
    );
  }

// Function to check if the email is in a valid format
  bool isValidEmail(String email) {
    String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailRegex).hasMatch(email);
  }

  Future<File> downloadProfileImage(ProfileProv profile) async {
    var response = await http.get(Uri.parse(profile.profile!.profileImage));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/image.jpg');
    file.writeAsBytesSync(response.bodyBytes);
    final urlImageFile = file;
    return urlImageFile;
  }

  int getStateNumber(String stateName) {
    Map<String, int> stateMap = {
      "None": -1,
      "Alabama": 0,
      "Alaska": 1,
      "Arizona": 2,
      "Arkansas": 3,
      "California": 4,
      "Colorado": 5,
      "Connecticut": 6,
      "Delaware": 7,
      "Florida": 8,
      "Georgia": 9,
      "Hawaii": 10,
      "Idaho": 11,
      "Illinois": 12,
      "Indiana": 13,
      "Iowa": 14,
      "Kansas": 15,
      "Kentucky": 16,
      "Louisiana": 17,
      "Maine": 18,
      "Maryland": 19,
      "Massachusetts": 20,
      "Michigan": 21,
      "Minnesota": 22,
      "Mississippi": 23,
      "Missouri": 24,
      "Montana": 25,
      "Nebraska": 26,
      "Nevada": 27,
      "New Hampshire": 28,
      "New Jersey": 29,
      "New Mexico": 30,
      "New York": 31,
      "North Carolina": 32,
      "North Dakota": 33,
      "Ohio": 34,
      "Oklahoma": 35,
      "Oregon": 36,
      "Pennsylvania": 37,
      "Rhode Island": 38,
      "South Carolina": 39,
      "South Dakota": 40,
      "Tennessee": 41,
      "Texas": 42,
      "Utah": 43,
      "Vermont": 44,
      "Virginia": 45,
      "Washington": 46,
      "West_Virginia": 47,
      "Wisconsin": 48,
      "Wyoming": 49,
    };
    int? stateNumber = stateMap[stateName];
    return stateNumber!;
  }
}
