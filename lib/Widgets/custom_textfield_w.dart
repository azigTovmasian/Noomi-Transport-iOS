import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class CustomTextFieldW extends StatefulWidget {
//   final String text;
//   final TextEditingController controller;
//   final Color fillColor;
//   final bool enable;
//   final TextInputType textInputType;
//   final FormFieldValidator<String>? validator; // added validator parameter
//   final bool enablePlusSign;
//   final List<TextInputFormatter>? inputFormatters; 
  

//   const CustomTextFieldW({
//     required this.text,
//     required this.controller,
//     required this.fillColor,
//     required this.enable,
//     required this.textInputType,
//     this.validator, // optional validator parameter
//     this.enablePlusSign = false,
//     this.inputFormatters, // optional parameter with default value
//   });
//   @override
//   State<CustomTextFieldW> createState() => _CustomTextFieldWState();
// }

// class _CustomTextFieldWState extends State<CustomTextFieldW> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//       child: TextFormField(
//         controller: widget.controller,
//         keyboardType: widget.textInputType,

//         inputFormatters: widget.inputFormatters,

//         autofocus: false,
//         enabled: widget.enable,
//         autovalidateMode:
//             AutovalidateMode.onUserInteraction, // set autovalidateMode
//         validator: widget.validator, // added validator parameter
//         // inputFormatters: widget.enablePlusSign // check if enablePlusSign is true
//         //     ? [FilteringTextInputFormatter.allow('+'),] // allow plus sign input
//         //     : null, // null means use default input formatter
//         decoration: InputDecoration(
//           hintText: widget.text,
//           hintStyle: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 15,
//               color: Color(0xff95A1AC),
//               fontFamily: 'Poppins'),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xff7CA03E),
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xff7CA03E),
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               style: BorderStyle.solid,
//               color: Color(0xff7CA03E),
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xffffffff),
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           filled: true,
//           fillColor: widget.fillColor,
//           contentPadding: EdgeInsets.all(16),
//         ),
//         style: TextStyle(
//           fontSize: 13,
//           fontFamily: 'Poppins',
//           color: Color(0xff4B4E45),
//         ),
//       ),
//     );
//   }
// }


// class TextFormField2 extends StatefulWidget {
//   final String detail;
//   final TextEditingController controller;
//   final void Function()? onEditingComplete;
//   final String title;
//   final TextInputType textInputType;
//   const TextFormField2({
//     required this.detail,
//     required this.title,
//     required this.controller,
//     this.onEditingComplete,
//     required this.textInputType,
//   });
//   @override
//   State<TextFormField2> createState() => _TextFormField2State();
// }

// class _TextFormField2State extends State<TextFormField2> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsetsDirectional.fromSTEB(16, 18, 16, 0),
//       child: Container(
//         width: double.infinity,
//         height: 300,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(67, 247, 249, 251),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 2,
//               color: Color.fromARGB(67, 224, 235, 243),
//             )
//           ],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//           child: TextFormField(
//             controller: widget.controller,
//             onEditingComplete: widget.onEditingComplete,
//             keyboardType: widget.textInputType,
//             onFieldSubmitted: (_) async {
//               setState(() {});
//             },
//             autofocus: false,
//             obscureText: false,
//             decoration: InputDecoration(
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color.fromARGB(255, 195, 197, 192),
//                   width: 0,
//                 ),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               labelText: widget.title,
//               labelStyle: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Poppins',
//                 color: Color(0xff4B4E45),
//               ),
//               hintText: widget.detail,
//               hintStyle: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Poppins',
//                 color: Color.fromARGB(255, 191, 202, 213),
//               ),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color.fromARGB(0, 224, 221, 221),
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xffffffff),
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               filled: true,
//               fillColor: Color(0xffFFFFFF),
//             ),
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Color(0xff4B4E45),
//             ),
//             maxLines: 15,
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomTextFieldW extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final Color fillColor;
  final bool enable;
  final TextInputType textInputType;
  final FormFieldValidator<String>? validator; // added validator parameter
  final bool enablePlusSign;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged; // added onChanged parameter

  const CustomTextFieldW({
    required this.text,
    required this.controller,
    required this.fillColor,
    required this.enable,
    required this.textInputType,
    this.validator, // optional validator parameter
    this.enablePlusSign = false,
    this.inputFormatters, // optional parameter with default value
    this.onChanged, // optional onChanged parameter
  });

  @override
  State<CustomTextFieldW> createState() => _CustomTextFieldWState();
}

class _CustomTextFieldWState extends State<CustomTextFieldW> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged, // pass onChanged callback
        autofocus: false,
        enabled: widget.enable,
        autovalidateMode: AutovalidateMode
            .onUserInteraction, // set autovalidateMode
        validator: widget.validator, // added validator parameter
        // inputFormatters: widget.enablePlusSign // check if enablePlusSign is true
        //     ? [FilteringTextInputFormatter.allow('+'),] // allow plus sign input
        //     : null, // null means use default input formatter
        decoration: InputDecoration(
          hintText: widget.text,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xff95A1AC),
              fontFamily: 'Poppins'),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff7CA03E),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff7CA03E),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Color(0xff7CA03E),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffffffff),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsets.all(16),
        ),
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          color: Color(0xff4B4E45),
        ),
      ),
    );
  }
}


class TextFormField2 extends StatefulWidget {
  final String detail;
  final TextEditingController controller;
  final void Function()? onEditingComplete;
  final String title;
  final TextInputType textInputType;
  final FocusNode? focusNode; // Optional FocusNode parameter

  const TextFormField2({
    required this.detail,
    required this.title,
    required this.controller,
    this.onEditingComplete,
    required this.textInputType,
    this.focusNode, // Provide a default value for the optional parameter
  });

  @override
  State<TextFormField2> createState() => _TextFormField2State();
}

class _TextFormField2State extends State<TextFormField2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 18, 16, 0),
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          color: Color.fromARGB(67, 247, 249, 251),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Color.fromARGB(67, 224, 235, 243),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
          child: TextFormField(
            controller: widget.controller,
            onEditingComplete: widget.onEditingComplete,
            keyboardType: widget.textInputType,
            focusNode: widget.focusNode, // Use the provided focusNode
            onFieldSubmitted: (_) async {
              setState(() {});
            },
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 195, 197, 192),
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              labelText: widget.title,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xff4B4E45),
              ),
              hintText: widget.detail,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 191, 202, 213),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(0, 224, 221, 221),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffffffff),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Color(0xffFFFFFF),
            ),
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff4B4E45),
            ),
            maxLines: 15,
          ),
        ),
      ),
    );
  }
}
