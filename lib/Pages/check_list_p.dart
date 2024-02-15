import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Widgets/error_refresh_w.dart';
import 'package:provider/provider.dart';
import '../Provider/cheklist_prov.dart';
import '../Provider/connectivity_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/checkbox_list_w.dart';
import '../Widgets/no_internet_w.dart';
import '../Widgets/progress_indicator_w.dart';

class CheckListP extends StatefulWidget {
  @override
  _CheckListPState createState() => _CheckListPState();
}

class _CheckListPState extends State<CheckListP> {
  bool isCompleteCheckListPressed = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final checkList = Provider.of<CheckListProv>(context, listen: false);
    final notifiedCheckList = Provider.of<CheckListProv>(context);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);

    return Scaffold(
      appBar: appBar('Check List', () {
        Navigator.pop(context);
      }),
      body: Visibility(
        replacement: NoInternetW(
        ),
        visible: connectivity.isThereInternet,
        child: Visibility(
          replacement: ProgressIndicatorW(),
          visible: ! notifiedCheckList.isLoading,
          child:notifiedCheckList.errorMessage.isNotEmpty
                    ?ErrorAndRefreshW(errorMessage: checkList.errorMessage, onRefreshPressed: (){})
                    :  Container(
            color: Color(0xffE8EEEA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.12,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.05,
                          left: width * 0.05,
                          right: width * 0.05,
                        ),
                        child: Text(
                          'Please complete the checklist before starting your trips.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.08,
                        right: width * 0.08,
                        top: 10
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x430F1113),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: BoxConstraints(
                          minHeight: height * 0.2,
                          maxHeight: height * 0.65,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CheckBoxListW(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CustomButton(
                      buttonColor: notifiedCheckList.isAllChecked()
                          ? Color(0xff7CA03E)
                          : Color.fromARGB(255, 142, 142, 136),
                      buttonTitle: 'COMPLETE',
                      height: height * 0.065,
                      width: width * 0.88,
                      fontSize: 20,
                      onPressed: () async {
                        if (notifiedCheckList.isAllChecked()) {
                          notifiedCheckList.setIsCheckListComplete();
                          await checkList.saveIsCheckListComplete();
                          await checkList.saveDate();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}