import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../Provider/cheklist_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/trip_prov.dart';

class DateSelectorW extends StatelessWidget {
  Future<void> checkingCheckList(BuildContext context) async {
    final checkList = Provider.of<CheckListProv>(context, listen: false);
    await checkList.loadDate();
    await checkList.loadIsCheckListComplete();
    checkList.CompareDates();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final tripProvider = Provider.of<TripProv>(context);
    final notifiedTripProvider = Provider.of<TripProv>(context, listen: true);
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);

    return Container(
      width: width,
      height: height * 0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () async {
                  final newDate =
                      tripProvider.currentDate.subtract(Duration(days: 1));
                  tripProvider.setCurrentDate(newDate);
                  await tripProvider.fetchTrips(
                    context: context,
                    driverId: phoneProvider.driverId ?? '',
                  );
                  tripProvider.checkIfSelectedDateIsOneDayAfterCurrentDate();
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.E().format(tripProvider.currentDate),
                  style: TextStyle(fontSize: 16.0,color:(notifiedTripProvider
                                                          .currentDate.year ==
                                                      DateTime.now().year &&
                                                  notifiedTripProvider
                                                          .currentDate.month ==
                                                      DateTime.now().month &&
                                                  notifiedTripProvider
                                                          .currentDate.day ==
                                                      DateTime.now().day)? Color(0xff7CA03E):Colors.black),
                ),
                Text(
                  DateFormat.yMMMMd().format(tripProvider.currentDate),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color:(notifiedTripProvider
                                                          .currentDate.year ==
                                                      DateTime.now().year &&
                                                  notifiedTripProvider
                                                          .currentDate.month ==
                                                      DateTime.now().month &&
                                                  notifiedTripProvider
                                                          .currentDate.day ==
                                                      DateTime.now().day)? Color(0xff7CA03E):Colors.black),
                ),
              ],
            ),
            IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifiedTripProvider.isTomorrow
                      ? Color.fromARGB(255, 216, 216, 216)
                      : Colors.black,
                ),
                onPressed: notifiedTripProvider.isTomorrow
                    ? () {}
                    : () async {
                        final newDate =
                            tripProvider.currentDate.add(Duration(days: 1));
                        tripProvider.setCurrentDate(newDate);
                        await Future.delayed(
                            Duration(microseconds: 500), () {});
                        await tripProvider.fetchTrips(
                          context: context,
                          driverId: phoneProvider.driverId ?? '',
                        );
                        tripProvider
                            .checkIfSelectedDateIsOneDayAfterCurrentDate();
                      }),
          ],
        ),
      ),
    );
  }
}
