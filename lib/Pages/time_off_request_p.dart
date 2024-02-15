import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Pages/profile_p.dart';
import 'package:noomi_transport_app/Widgets/error_refresh_w.dart';
import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
import 'package:provider/provider.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/time_off_request_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/custom_textfield_w.dart';
import '../Widgets/pop_up_dialog_w.dart';
import 'package:intl/intl.dart';
import '../Widgets/progress_indicator_w.dart';

class TimeOffRequestP extends StatefulWidget {
  const TimeOffRequestP({super.key});

  @override
  State<TimeOffRequestP> createState() => _TimeOffRequestPState();
}

final controller = TextEditingController();
bool isNotEmpty = false, isSubmitTimeOffRequestPressed = false;

class _TimeOffRequestPState extends State<TimeOffRequestP> {
  @override
  void initState() {
    String driverId =
        Provider.of<PhoneProv>(context, listen: false).driverId ?? '';
    Provider.of<TimeOffRequestProv>(context, listen: false)
        .fetchPTimeOffRequestRespond(driverId);
    controller.addListener(() {
      setState(() {
        isNotEmpty = controller.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TimeOffRequestProv timeOffRequestProvider =
        Provider.of<TimeOffRequestProv>(context, listen: false);
    PhoneProv phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    TimeOffRequestProv notifiedTimeOffRequestProvider =
        Provider.of<TimeOffRequestProv>(context, listen: true);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        // profile.setIsImagePicked(false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileP()),
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
            appBar: appBar("Time-Off Request", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileP()),
              );
            }),
            backgroundColor: Color(0xffE8EEEA),
            body: Visibility(
              replacement: NoInternetW(),
              visible: connectivity.isThereInternet,
              child: Visibility(
                replacement: ProgressIndicatorW(),
                visible: !(notifiedTimeOffRequestProvider.isLoading),
                child: notifiedTimeOffRequestProvider.errorMessage.isNotEmpty
                    ? ErrorAndRefreshW(
                        errorMessage: timeOffRequestProvider.errorMessage,
                        onRefreshPressed: () async {
                          String driverId =
                              Provider.of<PhoneProv>(context, listen: false)
                                      .driverId ??
                                  '';
                          await Provider.of<TimeOffRequestProv>(context,
                                  listen: false)
                              .fetchPTimeOffRequestRespond(
                            driverId,
                          );
                        })
                    : Container(
                        height: height,
                        width: width,
                        child: Column(children: [
                          SizedBox(
                            height: 1,
                          ),
                          TextFormField2(
                            controller: controller,
                            detail:
                                'Please provide details about your Time-off request.',
                            title: 'Request',
                            textInputType: TextInputType.text,
                            onEditingComplete: () {
                              isNotEmpty = true;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              notifiedTimeOffRequestProvider.noRequest.isEmpty
                                  ? "FYI - Last Time-Off Request  is ${getTimeOffRequestRespondStatus(timeOffRequestProvider.timeOffRequest.status)}."
                                  : timeOffRequestProvider.noRequest,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            notifiedTimeOffRequestProvider.noRequest.isEmpty
                                ? DateFormat("d MMMM y").format(
                                    timeOffRequestProvider
                                        .timeOffRequest.updatedAt)
                                : '',
                            style: (TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                            child: CustomButton(
                                enabled: isNotEmpty,
                                width: width - 32,
                                height: 50,
                                buttonColor: isNotEmpty
                                    ? Color(0xff7CA03E)
                                    : Color.fromARGB(255, 142, 142, 136),
                                buttonTitle: "SUBMIT",
                                onPressed: !isNotEmpty
                                    ? () {}
                                    : () {
                                        timeOffRequestProvider
                                            .sendTimeOffRequestInfo(
                                          controller.text,
                                          phoneProvider.driverId ?? '',
                                        );
                                        PopUpDialogW(
                                            onPressed: () =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileP())),
                                            context: context,
                                            title: 'Time Off Request',
                                            body:
                                                'Your time_off request submitted successfully!');
                                        controller.text = '';
                                      }),
                          ),
                        ]),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String getTimeOffRequestRespondStatus(int timeOffRequestRespondStatus) {
  String status = '';
  switch (timeOffRequestRespondStatus) {
    case 0:
      status = 'Submitted';
      break;
    case 1:
      status = 'Approved';
      break;
    case 2:
      status = 'Rejected';
      break;
    default:
      status = 'Submitted';
      break;
  }
  return status;
}
