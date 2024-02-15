import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/profile_prov.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text(getStateName(-1)), value: "None"),
    DropdownMenuItem(child: Text(getStateName(0)), value: "Alabama"),
    DropdownMenuItem(child: Text(getStateName(1)), value: "Alaska"),
    DropdownMenuItem(child: Text(getStateName(2)), value: "Arizona"),
    DropdownMenuItem(child: Text(getStateName(3)), value: "Arkansas"),
    DropdownMenuItem(child: Text(getStateName(4)), value: "California"),
    DropdownMenuItem(child: Text(getStateName(5)), value: "Colorado"),
    DropdownMenuItem(child: Text(getStateName(6)), value: "Connecticut"),
    DropdownMenuItem(child: Text(getStateName(7)), value: "Delaware"),
    DropdownMenuItem(child: Text(getStateName(8)), value: "Florida"),
    DropdownMenuItem(child: Text(getStateName(9)), value: "Georgia"),
    DropdownMenuItem(child: Text(getStateName(10)), value: "Hawaii"),
    DropdownMenuItem(child: Text(getStateName(11)), value: "Idaho"),
    DropdownMenuItem(child: Text(getStateName(12)), value: "Illinois"),
    DropdownMenuItem(child: Text(getStateName(13)), value: "Indiana"),
    DropdownMenuItem(child: Text(getStateName(14)), value: "Iowa"),
    DropdownMenuItem(child: Text(getStateName(15)), value: "Kansas"),
    DropdownMenuItem(child: Text(getStateName(16)), value: "Kentucky"),
    DropdownMenuItem(child: Text(getStateName(17)), value: "Louisiana"),
    DropdownMenuItem(child: Text(getStateName(18)), value: "Maine"),
    DropdownMenuItem(child: Text(getStateName(19)), value: "Maryland"),
    DropdownMenuItem(child: Text(getStateName(20)), value: "Massachusetts"),
    DropdownMenuItem(child: Text(getStateName(21)), value: "Michigan"),
    DropdownMenuItem(child: Text(getStateName(22)), value: "Minnesota"),
    DropdownMenuItem(child: Text(getStateName(23)), value: "Mississippi"),
    DropdownMenuItem(child: Text(getStateName(24)), value: "Missouri"),
    DropdownMenuItem(child: Text(getStateName(25)), value: "MaiMontanane"),
    DropdownMenuItem(child: Text(getStateName(26)), value: "Nebraska"),
    DropdownMenuItem(child: Text(getStateName(27)), value: "Nevada"),
    DropdownMenuItem(child: Text(getStateName(28)), value: "New Hampshire"),
    DropdownMenuItem(child: Text(getStateName(29)), value: "New Jersey"),
    DropdownMenuItem(child: Text(getStateName(30)), value: "New Mexico"),
    DropdownMenuItem(child: Text(getStateName(31)), value: "New York"),
    DropdownMenuItem(child: Text(getStateName(32)), value: "North Carolina"),
    DropdownMenuItem(child: Text(getStateName(33)), value: "North Dakota"),
    DropdownMenuItem(child: Text(getStateName(34)), value: "Ohio"),
    DropdownMenuItem(child: Text(getStateName(35)), value: "Oklahoma"),
    DropdownMenuItem(child: Text(getStateName(36)), value: "Oregon"),
    DropdownMenuItem(child: Text(getStateName(37)), value: "Pennsylvania"),
    DropdownMenuItem(child: Text(getStateName(38)), value: "Rhode Island"),
    DropdownMenuItem(child: Text(getStateName(39)), value: "South Carolina"),
    DropdownMenuItem(child: Text(getStateName(40)), value: "South Dakota"),
    DropdownMenuItem(child: Text(getStateName(41)), value: "Tennessee"),
    DropdownMenuItem(child: Text(getStateName(42)), value: "Texas"),
    DropdownMenuItem(child: Text(getStateName(43)), value: "Utah"),
    DropdownMenuItem(child: Text(getStateName(44)), value: "Vermont"),
    DropdownMenuItem(child: Text(getStateName(45)), value: "Virginia"),
    DropdownMenuItem(child: Text(getStateName(46)), value: "Washington"),
    DropdownMenuItem(child: Text(getStateName(47)), value: "West Virginia"),
    DropdownMenuItem(child: Text(getStateName(48)), value: "Wisconsin"),
    DropdownMenuItem(child: Text(getStateName(49)), value: "Wyoming"),
  ];
  return menuItems;
}

class StateDropDown extends StatefulWidget {
  const StateDropDown({super.key});

  @override
  State<StateDropDown> createState() => _StateDropDownState();
}

class _StateDropDownState extends State<StateDropDown> {
  @override
  Widget build(BuildContext context) {
    ProfileProv profile = Provider.of<ProfileProv>(context);

    return SingleChildScrollView(
      child: DropdownButtonFormField(
        iconSize: 10,
        decoration: InputDecoration(
          labelStyle: TextStyle(
              color: Color(0xff95A1AC),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400),
          contentPadding: EdgeInsets.only(left: 5),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff7CA03E), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff7CA03E), width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff7CA03E), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff7CA03E), width: 2),
            borderRadius: BorderRadius.circular(120),
          ),
          filled: true,
          fillColor: Color(0xffFFFFFF),
        ),
        dropdownColor: Color(0xffFFFFFF),
        value: getStateName(profile.profile!.state),
        hint: Text(
          "Select State",
          style: TextStyle(
              color: Color(0xff95A1AC),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        onChanged: (String? newValue) {
          profile.setDropDownSelectedState(newValue!);
        },
        items: dropdownItems,
      ),
    );
  }
}

String getStateName(
  int caseNumber,
) {
  String stateName;
  switch (caseNumber) {
    case -1:
      stateName = "None";
      break;
    case 0:
      stateName = "Alabama";
      break;
    case 1:
      stateName = "Alaska";
      break;
    case 2:
      stateName = "Arizona";
      break;
    case 3:
      stateName = "Arkansas";
      break;
    case 4:
      stateName = "California";
      break;
    case 5:
      stateName = "Colorado";
      break;
    case 6:
      stateName = "Connecticut";
      break;
    case 7:
      stateName = "Delaware";
      break;
    case 8:
      stateName = "Florida";
      break;
    case 9:
      stateName = "Georgia";
      break;
    case 10:
      stateName = "Hawaii";
      break;
    case 11:
      stateName = "Idaho";
      break;
    case 12:
      stateName = "Illinois";
      break;
    case 13:
      stateName = "Indiana";
      break;
    case 14:
      stateName = "Iowa";
      break;
    case 15:
      stateName = "Kansas";
      break;
    case 16:
      stateName = "Kentucky";
      break;
    case 17:
      stateName = "Louisiana";
      break;
    case 18:
      stateName = "Maine";
      break;
    case 19:
      stateName = "Maryland";
      break;
    case 20:
      stateName = "Massachusetts";
      break;
    case 21:
      stateName = "Michigan";
      break;
    case 22:
      stateName = "Minnesota";
      break;
    case 23:
      stateName = "Mississippi";
      break;
    case 24:
      stateName = "Missouri";
      break;
    case 25:
      stateName = "Montana";
      break;
    case 26:
      stateName = "Nebraska";
      break;
    case 27:
      stateName = "Nevada";
      break;
    case 28:
      stateName = "New Hampshire";
      break;
    case 29:
      stateName = "New Jersey";
      break;
    case 30:
      stateName = "New Mexico";
      break;
    case 31:
      stateName = "New York";
      break;
    case 32:
      stateName = "North Carolina";
      break;
    case 33:
      stateName = "North Dakota";
      break;
    case 34:
      stateName = "Ohio";
      break;
    case 35:
      stateName = "Oklahoma";
      break;
    case 36:
      stateName = "Oregon";
      break;
    case 37:
      stateName = "Pennsylvania";
      break;
    case 38:
      stateName = "Rhode Island";
      break;
    case 39:
      stateName = "South Carolina";
      break;
    case 40:
      stateName = "South Dakota";
      break;
    case 41:
      stateName = "Tennessee";
      break;
    case 42:
      stateName = "Texas";
      break;
    case 43:
      stateName = "Utah";
      break;
    case 44:
      stateName = "Vermont";
      break;
    case 45:
      stateName = "Virginia";
      break;
    case 46:
      stateName = "Washington";
      break;
    case 47:
      stateName = "West_Virginia";
      break;
    case 48:
      stateName = "Wisconsin";
      break;
    case 49:
      stateName = "Wyoming";
      break;
    default:
      stateName = "select state";
  }
  return stateName;
}
