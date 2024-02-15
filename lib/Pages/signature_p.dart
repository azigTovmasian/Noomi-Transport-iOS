import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/delivery_info_prov.dart';
import '../Widgets/appbar_w.dart';
import '../Widgets/button_w.dart';
import '../Widgets/pop_up_dialog_w.dart';

class SignatureP extends StatefulWidget {
  const SignatureP({super.key});
  @override
  State<SignatureP> createState() => _SignaturePState();
}

final SignatureController _controller = SignatureController(
  penStrokeWidth: 5,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

class _SignaturePState extends State<SignatureP> {
  bool isSaveSignaturePressed = false, isClearSignaturePressed = false;
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final deliveryInfo = Provider.of<DeliveryInfoProv>(context, listen: false);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context,listen: true);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar("Auth Singature", () {
            Navigator.pop(context);
          }),
          backgroundColor: Color(0xffE8EEEA),
          body: Visibility(
            replacement: NoInternetW(),
            visible: connectivity.isThereInternet,
            child: Container(
              height: height,
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 3, 13),
                      child: Row(
                        children: [
                          Text(
                            "You are signing the Client Name:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Color(0xff4B4E45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        width: width - 32,
                        height: 400,
                        child: Signature(
                          controller: _controller,
                          backgroundColor: Colors.white,
                        )),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            buttonTitle: 'SAVE',
                            buttonColor: Color(0xff7CA03E),
                            height: height * 0.065,
                            width: width * 0.45,
                            onPressed: () async {
                              deliveryInfo.setIsSignatureSaved(true);
                              final exportedImage =
                                  await _controller.toPngBytes();
                              deliveryInfo.setSignatureImage(exportedImage!);
                              PopUpDialogW(
                                  context: context,
                                  title: 'Signature',
                                  body:
                                      'Client signature has been saved successfuly!',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                              _controller.clear();
                            },
                            fontSize: 20,
                          ),
                          CustomButton(
                            
                            buttonTitle: 'CLEAR',
                            buttonColor: Color(0xff4B4E45),
                            height: height * 0.065,
                            width: width * 0.3,
                            onPressed: () {
                              _controller.clear();
                            },
                            fontSize: 20,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

