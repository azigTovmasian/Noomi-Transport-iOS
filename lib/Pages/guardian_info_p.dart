import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Pages/my_trips_p.dart';
import 'package:noomi_transport_app/Pages/signature_p.dart';
import 'package:noomi_transport_app/Pages/trip_detail_p.dart';
import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
import 'package:provider/provider.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/delivery_info_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/trip_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/custom_textfield_w.dart';
import '../Widgets/progress_indicator_w.dart';

class GuardianInfoP extends StatefulWidget {
  final int index;
  const GuardianInfoP({super.key, required this.index});

  @override
  State<GuardianInfoP> createState() => _GuardianInfoPState();
}

bool enabledoverride = false;
bool shouldenabled = true;
final notesController = TextEditingController();
final clientNameController = TextEditingController();

class _GuardianInfoPState extends State<GuardianInfoP> {
  bool isSubmitDeliveryInfoPressed = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final deliveryInfo = Provider.of<DeliveryInfoProv>(context, listen: false);
    final notifiedDeliveryInfo = Provider.of<DeliveryInfoProv>(context);
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    final tripsProv = Provider.of<TripProv>(context, listen: false);
    final notifiedTripsProv = Provider.of<TripProv>(context);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TripDetailP(
                    index: widget.index,
                    tripId: tripsProv.trip!.id,
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
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: appBar(
                    "Trip No. ${widget.index + 1} - ${notifiedTripsProv.trip!.status == 1 ? 'Pick Up' : 'Drop Off'}",
                    () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TripDetailP(
                              index: widget.index,
                              tripId: tripsProv.trip!.id,
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 18, 16, 0),
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 12,
                                        color:
                                            Color.fromARGB(67, 102, 111, 121),
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 3, 3),
                                        child: Text(
                                          "Authorized Person Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Color(0xff4B4E45),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextField(
                                          controller: clientNameController,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '[Auth Name...]',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Poppins',
                                              height: 2,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff4B4E45),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff95A1AC),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            filled: true,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 8, 0, 0),
                                          ),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 6, 2, 2),
                                              child: CustomButton(
                                                  buttonTitle: notifiedDeliveryInfo.isSignatureSaved?'SIGNED': 'SIGN',
                                                  buttonColor: !enabledoverride  
                                                      ?notifiedDeliveryInfo.isSignatureSaved? Color.fromARGB( 255, 90, 91, 91): Color(0xff7CA03E)
                                                      : Color.fromARGB( 255, 90, 91, 91),
                                             
                                                  width: width * 0.2,
                                                  height: 45,
                                                  onPressed: () {
                                                    (!enabledoverride &&
                                                            !notifiedDeliveryInfo
                                                                .isSignatureSaved)
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignatureP()))
                                                        : null;
                                                  })),
                                          Text(
                                            'Override',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color(0xff835FC1),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Switch(
                                              value: enabledoverride,
                                              activeColor: Color(0xff835FC1),
                                              activeTrackColor: Color.fromARGB(
                                                  255, 218, 207, 239),
                                              onChanged:
                                                  deliveryInfo.isSignatureSaved
                                                      ? (bool value) {}
                                                      : (bool? newValue) {
                                                          setState(() {
                                                            if (enabledoverride ==
                                                                false) {
                                                              enabledoverride =
                                                                  true;
                                                            } else {
                                                              enabledoverride =
                                                                  false;
                                                            }
                                                          });
                                                        })
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextFormField2(
                                detail: "",
                                title: "Notes",
                                controller: notesController,
                                focusNode: _focusNode,
                                onEditingComplete: () {
                                  _focusNode.unfocus();
                                },
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                child: CustomButton(
                                    width: width - 32,
                                    height: 50,
                                    buttonColor: ((notifiedDeliveryInfo
                                                    .isSignatureSaved ||
                                                enabledoverride) &&
                                            (clientNameController
                                                .text.isNotEmpty))
                                        ? Color(0xff7CA03E)
                                        : Color.fromARGB(255, 90, 91, 91),
                                    buttonTitle: "SUBMIT",
                                    onPressed: !((notifiedDeliveryInfo
                                                    .isSignatureSaved ||
                                                enabledoverride) &&
                                            (clientNameController
                                                .text.isNotEmpty))
                                        ? () {}
                                        : () async {
                                            deliveryInfo.setIsLoading(true);
                                            int value = notifiedTripsProv
                                                        .trip!.status ==
                                                    1 // 'started
                                                ? 2 // in progress
                                                : 4; // completed
                                            tripsProv.trip!.status = value;
                                            await deliveryInfo.sendDeliveryInfo(
                                                driverId:
                                                    phoneProvider.driverId ??
                                                        '',
                                                tripId: tripsProv.trip!.id,
                                                tripStatus: value,
                                                note: notesController.text,
                                                guardianFullName:
                                                    clientNameController.text,
                                                isOverridden: enabledoverride,
                                                signatureImage: deliveryInfo
                                                    .signatureImage);
                                            Future.delayed(
                                                Duration(milliseconds: 20),
                                                () async {});

                                            notifiedDeliveryInfo
                                                .setIsSignatureSaved(false);

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyTripsP(),
                                              ),
                                            );
                                            notesController.text = '';
                                            clientNameController.text = '';
                                            setState(() {
                                              enabledoverride = false;
                                            });
                                            deliveryInfo
                                                .setSignatureImage(null);
                                          }),
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
              ),
              Visibility(
                visible: notifiedDeliveryInfo.isLoading,
                child: Container(
                  color: Colors.transparent.withOpacity(0.7),
                  child: Center(child: ProgressIndicatorW()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
