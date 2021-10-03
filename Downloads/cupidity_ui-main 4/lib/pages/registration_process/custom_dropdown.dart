import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';

class CustomDropDown extends StatelessWidget {
  final value;
  final List<String> itemsList;
  final Color dropdownColor;
  final Function(dynamic value) onChanged;
  const CustomDropDown({
    Key key,
    @required this.value,
    @required this.itemsList,
    @required this.dropdownColor,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: w * 0.04, horizontal: w * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffBDBFC0),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w * 0.02),
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: DropdownButtonFormField(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ThemeColor.maroon,
            ),
            isExpanded: true,
            dropdownColor: dropdownColor,
            value: value,
            style: GoogleFonts.raleway(
              textStyle: GoogleFonts.poppins(
                fontSize: 18,
                color: ThemeColor.notBlack,
              ),
            ),
            decoration: const InputDecoration(
                hintText: 'Enter Your Gender', border: InputBorder.none),
            items: itemsList
                .map(
                  (String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          item,
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: ThemeColor.notBlack,
                            ),
                          ),
                        ),
                      )),
                )
                .toList(),
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}
