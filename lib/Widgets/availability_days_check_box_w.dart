import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/availability.dart';
import '../Provider/profile_prov.dart';

class AvailabilityDaysCheckBoxW extends StatefulWidget {
  @override
  _AvailabilityDaysCheckBoxWState createState() =>
      _AvailabilityDaysCheckBoxWState();
}

class _AvailabilityDaysCheckBoxWState extends State<AvailabilityDaysCheckBoxW> {
  @override
  Widget build(BuildContext context) {
    ProfileProv profile = Provider.of<ProfileProv>(context, listen: false);
    ProfileProv notifiedProfile =
        Provider.of<ProfileProv>(context, listen: true);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dayCheckBox('S', Availability.sunday, notifiedProfile, profile),
          _dayCheckBox('M', Availability.monday, notifiedProfile, profile),
          _dayCheckBox('T', Availability.tuesday, notifiedProfile, profile),
          _dayCheckBox('W', Availability.wednesday, notifiedProfile, profile),
          _dayCheckBox('T', Availability.thursday, notifiedProfile, profile),
          _dayCheckBox('F', Availability.friday, notifiedProfile, profile),
          _dayCheckBox('S', Availability.saturday, notifiedProfile, profile),
        ],
      ),
    );
  }

  Widget _dayCheckBox(String dayLetter, int dayFlag,
      ProfileProv notifiedProfile, ProfileProv profile) {
    return SizedBox(
      width: 45,
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Transform.scale(
                scale: 0.7,
                child: Checkbox(
                  activeColor: Color(0xff7CA03E),
                  value: (notifiedProfile.availableDays & dayFlag) != 0,
                  onChanged: (value) {},
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Text(dayLetter,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
