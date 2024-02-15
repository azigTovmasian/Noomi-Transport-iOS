import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pages/trip_detail_p.dart';
import '../Provider/cheklist_prov.dart';
import '../Provider/delivery_info_prov.dart';
import '../Provider/phone_prov.dart';
import '../Provider/trip_prov.dart';
import 'button_w.dart';
import 'package:intl/intl.dart';

class TripCardW extends StatefulWidget {
  final int index;
  const TripCardW({super.key, required this.index});
  @override
  State<TripCardW> createState() => _TripCardWState();
}

class _TripCardWState extends State<TripCardW> {
  bool isStartPressed = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final tripProvider = Provider.of<TripProv>(context, listen: false);
    final notifiedTripProvider = Provider.of<TripProv>(context);
    final notifiedCheckList = Provider.of<CheckListProv>(context);
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    final deliveryInfoProv =
        Provider.of<DeliveryInfoProv>(context, listen: false);
    DateTime pickupTime = tripProvider.trips[widget.index].pickupTime;   
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: tripCardColor(
              index: widget.index,
              notfiedTripProvider: notifiedTripProvider,
              notifiedCheckListProvider: notifiedCheckList),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x430F1113),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   // "${tripProvider.trips[widget.index].pickupTime.hour.toString().padLeft(2, '0')}:${tripProvider.trips[widget.index].pickupTime.minute.toString().padLeft(2, '0')}",

                 "${DateFormat('h:mm a').format(pickupTime)}",
                    //"${tripProvider.trips[widget.index].pickupTime.hour.toString()}:${tripProvider.trips[widget.index].pickupTime.minute.toString()}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: StartButtonAndPhrasesCondition(
                              notfiedTripProvider: notifiedTripProvider,
                              notifiedCheckListProvider: notifiedCheckList,
                              index: widget.index)
                          ? Colors.black
                          : Color(0xFF9D9C9C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: StartButtonAndPhrasesCondition(
                        notfiedTripProvider: notifiedTripProvider,
                        notifiedCheckListProvider: notifiedCheckList,
                        index: widget.index),
                    child: CustomButton(
                        buttonTitle: 'START',
                        buttonColor: Color(0xff7CA03E),
                        height: height * 0.057,
                        width: width * 0.35,
                        onPressed: () async {
                          await tripProvider.fetchOneTrip(context,
                              tripId: tripProvider.trips[widget.index].id,
                              driverId: phoneProvider.driverId ?? '');
                          tripProvider.trip!.status = 1;
                          tripProvider.setStatus(index: widget.index, value: 1);
                          await deliveryInfoProv.sendDeliveryInfo(
                              driverId: phoneProvider.driverId ?? '',
                              tripId: tripProvider.trips[widget.index].id,
                              tripStatus: 1,
                              guardianFullName: '',
                              note: '',
                              isOverridden: false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripDetailP(
                                      index: widget.index,
                                      tripId:
                                          tripProvider.trips[widget.index].id,
                                      driverId: phoneProvider.driverId ?? '',
                                    )),
                          );
                        }),
                    replacement: Text(
                      tripProvider.trips[widget.index].status == 0 //initiated
                          ? ' '
                          : notifiedTripProvider.convertStatus2String(
                              tripProvider.trips[widget.index].status),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: getColorFromStatus(
                            tripProvider.trips[widget.index].status),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 2,
                width: width * 0.85,
                color: Color(0xffE8EEEA),
                margin: EdgeInsets.symmetric(vertical: 8),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 300,
                child: Text(
                  tripProvider.trips[widget.index].pickupLocation,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: StartButtonAndPhrasesCondition(
                              notfiedTripProvider: notifiedTripProvider,
                              notifiedCheckListProvider: notifiedCheckList,
                              index: widget.index)
                          //  (notifiedCheckList.isCheckListComplete() &&
                          //         notifiedTripProvider.stateCondition(
                          //             index: widget.index))
                          ? Color(0xFF4C5B3B)
                          : Color(0xFF9D9C9C),
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    //  "Trip No. ${widget.index + 1}",
                 "Trip No. ${tripProvider.trips[widget.index].tripNumber.toString()}", 
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF9D9C9C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${tripProvider.trips[widget.index].clients.FirstName} ${tripProvider.trips[widget.index].clients.LastName} ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: StartButtonAndPhrasesCondition(
                                notfiedTripProvider: notifiedTripProvider,
                                notifiedCheckListProvider: notifiedCheckList,
                                index: widget.index)
                            // (notifiedCheckList.isCheckListComplete() &&
                            //         notifiedTripProvider.stateCondition(
                            //             index: widget.index))
                            ? Colors.black
                            : Color(0xFF9D9C9C),
                        fontSize: height*0.02,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color tripCardColor(
      {required TripProv notfiedTripProvider,
      required CheckListProv notifiedCheckListProvider,
      required int index}) {
    Color color;
    if (((notfiedTripProvider.currentDate.year == DateTime.now().year &&
                notfiedTripProvider.currentDate.month == DateTime.now().month &&
                notfiedTripProvider.currentDate.day == DateTime.now().day) &&
            notifiedCheckListProvider.isCheckListComplete() == false) ||
        ((notfiedTripProvider.currentDate.year == DateTime.now().year &&
                notfiedTripProvider.currentDate.month == DateTime.now().month &&
                notfiedTripProvider.currentDate.day == DateTime.now().day) &&
            notifiedCheckListProvider.isCheckListComplete() == true &&
            (notfiedTripProvider.trips[index].status == 3 ||
                notfiedTripProvider.trips[index].status == 4 ||
                notfiedTripProvider.trips[index].status == 5)) ||
        (notfiedTripProvider.currentDate.year <= DateTime.now().year &&
            notfiedTripProvider.currentDate.month <= DateTime.now().month &&
            notfiedTripProvider.currentDate.day < DateTime.now().day)) {
      color = Color.fromARGB(255, 218, 218, 218);
    } else if ((notfiedTripProvider.currentDate.year == DateTime.now().year &&
            notfiedTripProvider.currentDate.month == DateTime.now().month &&
            notfiedTripProvider.currentDate.day == DateTime.now().day) &&
        (notifiedCheckListProvider.isCheckListComplete() == true) &&
        (notfiedTripProvider.trips[index].status == 0 &&
            index != 0 &&
            (notfiedTripProvider.trips[index - 1].status == 0 ||
                notfiedTripProvider.trips[index - 1].status == 1 ||
                notfiedTripProvider.trips[index - 1].status == 2))) {
      color = Color(0xFFE0E3E7);
    } else {
      color = Colors.white;
    }
    return color;
  }

  bool StartButtonAndPhrasesCondition(
      {required TripProv notfiedTripProvider,
      required CheckListProv notifiedCheckListProvider,
      required int index}) {
    bool cond;
    cond = ((notfiedTripProvider.currentDate.year == DateTime.now().year &&
            notfiedTripProvider.currentDate.month == DateTime.now().month &&
            notfiedTripProvider.currentDate.day == DateTime.now().day) &&
        ((index == 0 && notfiedTripProvider.trips[index].status == 0) ||
            (index != 0 &&
                (notfiedTripProvider.trips[index - 1].status == 3 ||
                    notfiedTripProvider.trips[index - 1].status == 4 ||
                    notfiedTripProvider.trips[index - 1].status == 5) &&
                (notfiedTripProvider.trips[index].status == 0))) &&
        (notifiedCheckListProvider.isCheckListComplete() == true));
    return cond;
  }

  Color getColorFromStatus(int? status) {
    switch (status) {
      case 1:
        return Color(0xFFA1C953);
      case 2:
        return Color(0xFFA1C953);
      // Color.fromARGB(255, 222, 227, 79);
      case 3:
        return Color.fromARGB(255, 209, 174, 70);

      //Color(0xFFF1F754);
      // Color(0xFF835FC1);
      case 4:
        return Color(0xFFA1C953);

      // return Color(0xFF95A1AC);
      case 5:
        return Color.fromARGB(255, 255, 98, 103);
      default:
        return Colors.black;
    }
  }
}
