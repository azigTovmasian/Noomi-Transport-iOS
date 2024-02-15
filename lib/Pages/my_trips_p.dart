import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noomi_transport_app/Pages/profile_p.dart';
import 'package:noomi_transport_app/Pages/trip_detail_p.dart';
import 'package:noomi_transport_app/Widgets/error_refresh_w.dart';
import 'package:provider/provider.dart';
import '../Provider/cheklist_prov.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/profile_prov.dart';
import '../Provider/trip_prov.dart';
import '../Widgets/button_w.dart';
import '../Widgets/date_selector_w.dart';
import '../Widgets/no_internet_w.dart';
import '../Widgets/progress_indicator_w.dart';
import '../Widgets/trip_card_w.dart';
import 'check_list_p.dart';

class MyTripsP extends StatefulWidget {
  @override
  State<MyTripsP> createState() => _MyTripsPState();
}

class _MyTripsPState extends State<MyTripsP>
    with SingleTickerProviderStateMixin {
  bool isCompleteCheckListPressed = false;

  @override
  void initState() {
    super.initState();
    executeCodeBlock();
    checkingCheckList();
  }

  Future<void> executeCodeBlock() async {
    String driverId =
        Provider.of<PhoneProv>(context, listen: false).driverId ?? '';
    
    await Provider.of<TripProv>(context, listen: false)
        .fetchNoomiAdminPhoneNumber(driverId: driverId);
    await Provider.of<CheckListProv>(context, listen: false)
        .fetchCheckList(driverId: driverId);
    await Provider.of<ProfileProv>(context, listen: false)
        .fetchProfileData(driverId);

    await Provider.of<TripProv>(context, listen: false).fetchPerviousDayTrips(
      context: context,
      driverId: driverId,
    );
    await Provider.of<TripProv>(context, listen: false).fetchTrips(
      context: context,
      driverId: driverId,
    );

  }

  Future<void> checkingCheckList() async {
    final checkList = Provider.of<CheckListProv>(context, listen: false);
    await checkList.loadDate();
    await checkList.loadIsCheckListComplete();
    checkList.CompareDates();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final notifiedCheckList = Provider.of<CheckListProv>(context);
    final notifiedTripProvider = Provider.of<TripProv>(context);
    final tripProvider = Provider.of<TripProv>(context);
    final phoneProvider = Provider.of<PhoneProv>(context);
    ProfileProv profile = Provider.of<ProfileProv>(context, listen: false);
    ProfileProv notifiedProfile =
        Provider.of<ProfileProv>(context, listen: true);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to exit the Noomi App?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Color(0xff7CA03E)),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Color(0xff7CA03E)),
                ),
              ),
            ],
          ),
        );
        if (confirmExit == true) {
          return true;
        } else {
          return false;
        }
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            backgroundColor: Color(0xffE8EEEA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'My Trips',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  color: Color(0xff7CA03E),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileP()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 142, 182, 73),
                      radius: 24,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff7CA03E),
                        radius: 23,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/default_profile.png'),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: notifiedProfile.profile!.profileImage.isEmpty
                                ? Container(
                                    color: Colors.transparent,
                                  )
                                : Image.network(
                                    profile.profile!.profileImage,
                                    fit: BoxFit.fill,
                                    height: 45,
                                    width: 45,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              centerTitle: false,
              elevation: 2,
            ),
            body: Visibility(
              replacement: NoInternetW(),
              visible: connectivity.isThereInternet,
              child: Visibility(
                visible: !notifiedTripProvider.isLoading,
                child: notifiedTripProvider.errorMessage.isNotEmpty
                    ? ErrorAndRefreshW(
                        errorMessage: tripProvider.errorMessage,
                        onRefreshPressed: () async {
                          tripProvider.setIsLoading(true);

                          await checkingCheckList();
                          await Provider.of<TripProv>(context, listen: false)
                              .fetchPerviousDayTrips(
                            context: context,
                            driverId: phoneProvider.driverId ?? '',
                          );
                          await Provider.of<TripProv>(context, listen: false)
                              .fetchTrips(
                            context: context,
                            driverId: phoneProvider.driverId ?? '',
                          );
                        })
                    : Container(
                        color: Color(0xffE8EEEA),
                        child: ListView(
                          children: [
                            Material(
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffE8EEEA),
                                ),
                                child: DateSelectorW(),
                              ),
                            ),
                            Visibility(
                              visible: ((!notifiedCheckList
                                          .isCheckListComplete()) &&
                                      (notifiedTripProvider.trips.length !=
                                          0) &&
                                      (notifiedTripProvider.currentDate.year ==
                                              DateTime.now().year &&
                                          notifiedTripProvider
                                                  .currentDate.month ==
                                              DateTime.now().month &&
                                          notifiedTripProvider
                                                  .currentDate.day ==
                                              DateTime.now().day)) ||
                                  ((notifiedTripProvider.currentDate.year >=
                                              DateTime.now().year &&
                                          notifiedTripProvider
                                                  .currentDate.month >=
                                              DateTime.now().month &&
                                          notifiedTripProvider.currentDate.day >
                                              DateTime.now().day) &&
                                      (notifiedTripProvider.trips.length != 0)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 50, right: 50),
                                child: Center(
                                  child: CustomButton(
                                      buttonTitle: 'Complete Checklist',
                                      buttonColor: ((notifiedTripProvider
                                                          .currentDate.year >=
                                                      DateTime.now().year &&
                                                  notifiedTripProvider
                                                          .currentDate.month >=
                                                      DateTime.now().month &&
                                                  notifiedTripProvider
                                                          .currentDate.day >
                                                      DateTime.now().day) ||
                                              !(notifiedTripProvider
                                                  .isPreviousDayTripsCompleted))
                                          ? Color.fromARGB(255, 78, 82, 70)
                                          : Color(0xff7CA03E),
                                      height: height * 0.05,
                                      width: width * 0.68,
                                      onPressed: () {
                                        (notifiedTripProvider
                                                            .currentDate.year >=
                                                        DateTime.now().year &&
                                                    notifiedTripProvider
                                                            .currentDate
                                                            .month >=
                                                        DateTime.now().month &&
                                                    notifiedTripProvider
                                                            .currentDate.day >
                                                        DateTime.now().day) ||
                                                !(notifiedTripProvider
                                                    .isPreviousDayTripsCompleted)
                                            ? null
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckListP()),
                                              );
                                      },
                                      fontSize: 18,
                                      fontColor: Colors.white),
                                ),
                              ),
                            ),
                            RefreshIndicator(
                              color: Color(0xff7CA03E),
                              onRefresh: () async {
                                await Future.delayed(Duration(seconds: 1));
                                await Provider.of<TripProv>(context,
                                        listen: false)
                                    .fetchPerviousDayTrips(
                                  context: context,
                                  driverId: phoneProvider.driverId ?? '',
                                );
                                await Provider.of<TripProv>(context,
                                        listen: false)
                                    .fetchTrips(
                                  context: context,
                                  driverId: phoneProvider.driverId ?? '',
                                );
                              },
                              child: Visibility(
                                visible: tripProvider.trips.length != 0,
                                replacement: Center(
                                  child: Container(
                                    height: height * 0.6,
                                    child: Visibility(
                                      replacement: Center(
                                        child: ProgressIndicatorW(),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "There are no trips for this day\n",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              tripProvider.setIsLoading(true);
                                              await tripProvider.fetchTrips(
                                                  context: context,
                                                  driverId:
                                                      phoneProvider.driverId ??
                                                          '');
                                              tripProvider.setIsLoading(false);
                                            },
                                            child: Text(
                                              'Refresh',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff7CA03E),
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    height: notifiedTripProvider.currentDate
                                            .isBefore(DateTime.now())
                                        ? height * 0.79
                                        : notifiedCheckList
                                                .isCheckListComplete()
                                            ? height * 0.79
                                            : height * 0.71,
                                    child: ListView.builder(
                                      itemCount: tripProvider.trips.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            ((notifiedTripProvider.currentDate.year == DateTime.now().year &&
                                                        notifiedTripProvider
                                                                .currentDate
                                                                .month ==
                                                            DateTime.now()
                                                                .month &&
                                                        notifiedTripProvider.currentDate.day ==
                                                            DateTime.now()
                                                                .day) &&
                                                    notifiedCheckList
                                                        .isCheckListComplete() &&
                                                    notifiedTripProvider
                                                        .isPreviousDayTripsCompleted)
                                                ? ((index == 0) ||
                                                        (tripProvider.trips[index - 1].status ==
                                                                4 //'completed'
                                                            ||
                                                            tripProvider.trips[index - 1].status ==
                                                                3 // 'no show'
                                                            ||
                                                            tripProvider.trips[index - 1].status ==
                                                                5 //canceled
                                                        ))
                                                    ? fetchTripAndNavigate(
                                                        index: index,
                                                        tripProvider:
                                                            tripProvider,
                                                        phoneProvider:
                                                            phoneProvider)
                                                    : null
                                                : ((notifiedTripProvider.currentDate.year <= DateTime.now().year &&
                                                            notifiedTripProvider
                                                                    .currentDate
                                                                    .month <=
                                                                DateTime.now()
                                                                    .month &&
                                                            (notifiedTripProvider.currentDate.month == DateTime.now().month
                                                                ? notifiedTripProvider.currentDate.day < DateTime.now().day
                                                                : true)) &&
                                                        (notifiedTripProvider.isPreviousDayTripsCompleted))
                                                    ? fetchTripAndNavigate(index: index, tripProvider: tripProvider, phoneProvider: phoneProvider)
                                                    : null;
                                          },
                                          child: TripCardW(
                                            index: index,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                replacement: ProgressIndicatorW(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchTripAndNavigate({
    required int index,
    required TripProv tripProvider,
    required PhoneProv phoneProvider,
  }) async {
    await tripProvider.fetchOneTrip(context,
        tripId: tripProvider.trips[index].id,
        driverId: phoneProvider.driverId ?? '');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailP(
          index: index,
          tripId: tripProvider.trips[index].id,
          driverId: phoneProvider.driverId ?? '',
        ),
      ),
    );
  }
}
