import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Pages/my_trips_p.dart';
import 'package:noomi_transport_app/Pages/trip_detail_p.dart';
import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/delivery_info_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/trip_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/custom_textfield_w.dart';

class NoShowP extends StatefulWidget {
  final int index;
  const NoShowP({super.key, required this.index});

  @override
  State<NoShowP> createState() => _NoShowPState();
}

bool switchValue = false, isSubmitNoShowPressed = false;
final noShowNotesController = TextEditingController();
final FocusNode _focusNode = FocusNode();

class _NoShowPState extends State<NoShowP> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final tripProvider = Provider.of<TripProv>(context, listen: false);
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    final deliveryInfo = Provider.of<DeliveryInfoProv>(context, listen: false);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TripDetailP(
                    index: widget.index,
                    tripId: tripProvider.trip!.id,
                    driverId: phoneProvider.driverId ?? '',
                  )),
        );
        return Future.value(false);
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar("No Show", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TripDetailP(
                          index: widget.index,
                          tripId: tripProvider.trip!.id,
                          driverId: phoneProvider.driverId ?? '',
                        )),
              );
            }),
            backgroundColor: Color(0xffE8EEEA),
            body: Visibility(
              replacement: NoInternetW(),
              visible: connectivity.isThereInternet,
              child: Container(
                height: height,
                width: width,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xff835FC1),
                          size: height*0.04,
                        ),
                        Text(
                          "You have to Call Dispatch before No Show",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize:15,
                              color: Color(0xff835FC1)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          "tel:${tripProvider.noomiAdminPhoneNumber}"));
                    },
                    child: Text(
                      tripProvider.trip!.clients.PhoneNumber,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xff835FC1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 5, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Did you call the Dispatch?",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color.fromARGB(255, 9, 6, 12)),
                        ),
                        Switch(
                          value: switchValue,
                          activeColor: Color(0xff7CA03E),
                          activeTrackColor: Color.fromARGB(255, 201, 210, 188),
                          onChanged: (value) {
                            setState(() {
                              switchValue = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  TextFormField2(
                      controller: noShowNotesController,
                      focusNode: _focusNode,
                      onEditingComplete: () {_focusNode.unfocus();},
                      textInputType: TextInputType.text,
                      detail: "Please explain the No-Show situation...",
                      title: "Notes"),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: CustomButton(
                        width: width - 32,
                        height: 50,
                        buttonColor: switchValue
                            ? Color(0xff7CA03E)
                            : Color.fromARGB(255, 142, 142, 136),
                        buttonTitle: "SUBMIT",
                        onPressed: () async {
                          switchValue = false;
                          tripProvider.trip!.status = 3;
                          deliveryInfo.sendDeliveryInfo(
                              driverId: phoneProvider.driverId ?? '',
                              tripId: tripProvider.trip!.id,
                              tripStatus: 3, // no show
                              note: noShowNotesController.text,
                              guardianFullName: '',
                              isOverridden: false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyTripsP()),
                          );
                          noShowNotesController.text = '';
                        }),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
