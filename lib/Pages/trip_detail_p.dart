import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Widgets/error_refresh_w.dart';
import 'package:noomi_transport_app/Widgets/progress_indicator_w.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/delivery_info_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/trip_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/copy_address.dart';
// import '../Widgets/google-map_w.dart';
import '../Widgets/no_internet_w.dart';
import '../Widgets/trip_detail_status_w.dart';
import 'guardian_info_p.dart';
import 'my_trips_p.dart';
import 'no_show_p.dart';
import 'package:intl/intl.dart';

class TripDetailP extends StatefulWidget {
  final int index;
  final int tripId;
  final String driverId;
  const TripDetailP(
      {super.key,
      required this.index,
      required this.tripId,
      required this.driverId});

  @override
  State<TripDetailP> createState() => _TripDetailPState();
}

class _TripDetailPState extends State<TripDetailP> {
  bool isStartPressed = false,
      isNoShowPressed = false,
      isPickUpPressed = false,
      isCompletePressed = false;
  ScrollController _Comment1ScrollController = ScrollController();
  ScrollController _Comment2ScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final notifiedTripProvider = Provider.of<TripProv>(context);
    final tripProvider = Provider.of<TripProv>(context, listen: false);
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    final deliveryInfoProv =
        Provider.of<DeliveryInfoProv>(context, listen: false);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);
    DateTime pickupTime = tripProvider.trips[widget.index].pickupTime;
    DateTime dropoffTime = tripProvider.trips[widget.index].dropoffTime;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyTripsP()),
        );
        return false;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar("Trip No. ${widget.index + 1}", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyTripsP()),
              );
            }),
            backgroundColor: Color(0xffE8EEEA),
            body: Visibility(
              replacement: NoInternetW(),
              visible: connectivity.isThereInternet,
              child: Visibility(
                  visible: !notifiedTripProvider.isLoading,
                  child: notifiedTripProvider.tripDetailErrorMessage.isNotEmpty
                      ? ErrorAndRefreshW(
                          errorMessage: tripProvider.tripDetailErrorMessage,
                          onRefreshPressed: () {})
                      : Container(
                          width: width,
                          height: height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Stack(
                                          children: [
                                            TripDetailStatusW(
                                                width,
                                                Color(0xFFA1C953),
                                                'Started',
                                                notifiedTripProvider
                                                        .trip?.status ==
                                                    1,
                                                Color(0xffFFFFFF)),
                                            TripDetailStatusW(
                                                width,
                                                Color(0xff7CA03E),

                                                //   Color(0xFFF1F754),
                                                'In Progress',
                                                notifiedTripProvider
                                                        .trip?.status ==
                                                    2,
                                                Color(0xffFFFFFF)),

                                            //  Color(0xff4B4E45)),
                                            TripDetailStatusW(
                                                width,
                                                //  Color(0xFFF1F754),
                                                Color.fromARGB(
                                                    255, 209, 174, 70),

                                                //   Color(0xFF835FC1),
                                                'No Show',
                                                notifiedTripProvider
                                                        .trip?.status ==
                                                    3,
                                                //  Color(0xff4B4E45)),
                                                Colors.white),
                                            //   Color(0xffFFFFFF)),
                                            TripDetailStatusW(
                                                width,
                                                Color(0xff7CA03E),

                                                //  Color(0xFF95A1AC),
                                                'Completed',
                                                notifiedTripProvider
                                                        .trip?.status ==
                                                    4,
                                                Color(0xffFFFFFF)),
                                            TripDetailStatusW(
                                                width,
                                                Color.fromARGB(
                                                    255, 255, 98, 103),
                                                'Canceled',
                                                notifiedTripProvider
                                                        .trip?.status ==
                                                    5,
                                                Color(0xffFFFFFF)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20,
                                              height <= 600.0
                                                  ? 3
                                                  : height * 0.03,
                                              0,
                                              0),
                                          child: Text(
                                            "${tripProvider.trips[widget.index].clients.FirstName} ${tripProvider.trips[widget.index].clients.LastName} ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color:
                                                  Color.fromARGB(255, 6, 5, 5),
                                              fontSize: height * 0.025,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 5, 0, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  'tel:${tripProvider.trip!.clients.PhoneNumber}'));
                                            },
                                            child: Text(
                                              tripProvider
                                                  .trip!.clients.PhoneNumber,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: height * 0.025,
                                                  color: Color(0xff835FC1)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 5, 18, 0),
                                          child: Text(
                                            '#Of Pass: ${tripProvider.trip!.numOfPassengers.toString()}',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 35, 34, 36)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, height <= 600.0 ? 5 : 15, 16, 0),
                                      // child: Flexible(
                                      child: Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 12,
                                              color: Color.fromARGB(
                                                  67, 102, 111, 121),
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 12, 12, 2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.location_pin,
                                                          color:
                                                              Color(0xff7CA03E),
                                                          size: 24,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(6,
                                                                      0, 6, 0),
                                                          child: Text(
                                                            'Pick up',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: height *
                                                                  0.022,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(),
                                                    child: Text(
                                                      "${DateFormat('h:mm a').format(pickupTime)}",
                                                      // DateFormat('HH:mm')
                                                      //     .format(tripProvider
                                                      //         .trip!
                                                      //         .pickupTime),
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.black,
                                                        fontSize:
                                                            height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 12, 2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                25, 0, 0, 2),
                                                    child: InkWell(
                                                      onLongPress: () {
                                                        copyToClipboard(context,
                                                            textToCopy: tripProvider
                                                                .trip!
                                                                .pickupLocation);
                                                      },
                                                      onTap: () {
                                                        openMaps(
                                                            tripProvider.trip!
                                                                .pickupLocation,
                                                            context);
                                                      },
                                                      child: Container(
                                                        height: height * 0.025,
                                                        width: width - 85,
                                                        child: Text(
                                                          tripProvider.trip!
                                                              .pickupLocation,
                                                          maxLines:
                                                              3, // Set the maximum number of lines for the text
                                                          overflow: TextOverflow
                                                              .ellipsis, // Truncate text with ellipsis if it overflows
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize:
                                                                height * 0.016,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Color(
                                                                0xff4B4E45),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              height: 1,
                                              decoration: BoxDecoration(
                                                color: Color(0xffE8EEEA),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 10, 12, 2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.location_pin,
                                                          color:
                                                              Color(0xff835FC1),
                                                          size: 24,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(6,
                                                                      0, 6, 0),
                                                          child: Text(
                                                            'Drop off',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: height *
                                                                  0.022,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "${DateFormat('h:mm a').format(dropoffTime)}",
                                                      // DateFormat('HH:mm')
                                                      //     .format(tripProvider
                                                      //         .trip!
                                                      //         .dropoffTime),
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.black,
                                                        fontSize:
                                                            height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 12, 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  25, 4, 0, 2),
                                                      child: InkWell(
                                                        onLongPress: () {
                                                          copyToClipboard(
                                                              context,
                                                              textToCopy:
                                                                  tripProvider
                                                                      .trip!
                                                                      .dropoffLocation);
                                                        },
                                                        onTap: () {
                                                          openMaps(
                                                              tripProvider.trip!
                                                                  .dropoffLocation,
                                                              context);
                                                        },
                                                        child: Container(
                                                          height:
                                                              height * 0.025,
                                                          width: width - 85,
                                                          child: Text(
                                                            tripProvider.trip!
                                                                .dropoffLocation,
                                                            maxLines:
                                                                3, // Set the maximum number of lines for the text
                                                            overflow: TextOverflow
                                                                .ellipsis, // Truncate text with ellipsis if it overflows
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: height *
                                                                  0.016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xff4B4E45),
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            Container(
                                              width: width * 0.85,
                                              height: 1,
                                              decoration: BoxDecoration(
                                                color: Color(0xffE8EEEA),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 12, 12, 12),
                                              child: Container(
                                                width: width,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Notes:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.01),
                                                    Text(
                                                      tripProvider.trip!.note,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            height * 0.017,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.85,
                                              height: 1,
                                              decoration: BoxDecoration(
                                                color: Color(0xffE8EEEA),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 10, 12, 10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Comments 1:',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 0.01,
                                                        maxHeight: height >= 600
                                                            ? height * 0.1
                                                            : height *
                                                                0.04 
                                                        ),
                                                    child: Scrollbar(
                                                      controller:
                                                          _Comment1ScrollController,
                                                      thumbVisibility: true,
                                                      child: ListView(
                                                        controller:
                                                            _Comment1ScrollController,
                                                        shrinkWrap: true,
                                                        children: [
                                                          Text(
                                                          //  "Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollControllerComment2ScrollControllerComment2ScrollControllerComment2ScrollControllerComment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollControllerComment2ScrollController Comment2ScrollControllerComment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController",
                                                            '${tripProvider.trip!.comment1}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: height *
                                                                  0.017,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 4, 0, 8),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffE8EEEA),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Comments 2:',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 0.01,
                                                        maxHeight: height >=
                                                                600.0
                                                            ? height * 0.1
                                                            : height *
                                                                0.04
                                                        ),
                                                    child: Scrollbar(
                                                      controller:
                                                          _Comment2ScrollController,
                                                      thumbVisibility: true,
                                                      child: ListView(
                                                        controller:
                                                            _Comment2ScrollController,
                                                        shrinkWrap: true,
                                                        children: [
                                                          Text(
                                                         //  "Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollControllerComment2ScrollControllerComment2ScrollControllerComment2ScrollControllerComment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollControllerComment2ScrollController Comment2ScrollControllerComment2ScrollController Comment2ScrollController Comment2ScrollController Comment2ScrollController",
                                                            '${tripProvider.trip!.comment2}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: height *
                                                                  0.017,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Visibility(
                                      visible:
                                          notifiedTripProvider.trip!.status ==
                                              0, // initiated
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 12, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, bottom: 10),
                                          child: CustomButton(
                                              height: height * 0.07,
                                              width: width - 32,
                                              buttonColor: Color(0xff7CA03E),
                                              buttonTitle: "START",
                                              onPressed: () {
                                                tripProvider.setStatus(
                                                    index: widget.index,
                                                    value: 1); // started
                                                tripProvider.trip!.status = 1;
                                                deliveryInfoProv
                                                    .sendDeliveryInfo(
                                                  driverId:
                                                      phoneProvider.driverId ??
                                                          '',
                                                  tripId: tripProvider.trip!.id,
                                                  tripStatus: 1,
                                                  guardianFullName: '',
                                                  note: '',
                                                  isOverridden: false,
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: notifiedTripProvider
                                                  .trip!.status ==
                                              1 || // started
                                          notifiedTripProvider.trip!.status ==
                                              2, // in progress
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: notifiedTripProvider
                                                    .trip!.status ==
                                                1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 0, 16, 0),
                                              child: CustomButton(
                                                  height: height * 0.07,
                                                  width: width - 32,
                                                  buttonColor:
                                                      //  Color.fromARGB(255, 49, 50, 49),
                                                      Color.fromARGB(
                                                          255, 209, 174, 70),
                                                  buttonTitle: "NO SHOW",
                                                  fontColor: Colors.white,
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoShowP(
                                                                index: widget
                                                                    .index,
                                                              )),
                                                    );
                                                  }),
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.fromLTRB(
                                                16, height <= 600.0?5:15, 16, 5),
                                            child: CustomButton(
                                                height: height * 0.07,
                                                width: width - 32,
                                                buttonColor: Color(0xff7CA03E),
                                                buttonTitle:
                                                    notifiedTripProvider
                                                                .trip!.status ==
                                                            1
                                                        ? "PICK UP"
                                                        : "COMPLETE",
                                                onPressed: () {
                                                  tripProvider
                                                      .setPickUpOrDropOff();
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GuardianInfoP(
                                                              index:
                                                                  widget.index,
                                                            )),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                  replacement: ProgressIndicatorW()),
            ),
          ),
        ),
      ),
    );
  }
}

void openMaps(String address, BuildContext context) async {
  final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(address)}");

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    // Google Maps not installed, handle this case gracefully
    // For example, show a message to the user
    showDialog(
      context: context, // Use the actual context of your app
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
              'Please Activate Google Maps App so you can see the location!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xff7CA03E)),
              ),
            ),
          ],
        );
      },
    );
  }
}
