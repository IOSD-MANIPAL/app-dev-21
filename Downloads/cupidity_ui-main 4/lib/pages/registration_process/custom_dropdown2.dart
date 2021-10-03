import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';

class CustomDropDown2 extends StatelessWidget {
  final value;
  final List<String> itemsList;
  final Color dropdownColor;
  final Function(dynamic value) onChanged;
  CustomDropDown2({
    @required this.value,
    @required this.itemsList,
    this.dropdownColor,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xffBDBFC0),
            spreadRadius: 0,
            blurRadius: 4.68,
            offset: Offset(0, 2.34),
          )
        ],
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: Container(
          width: w * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ThemeColor.maroon,
            ),
            isExpanded: true,
            dropdownColor: dropdownColor,
            value: value,
            isDense: true,
            style: GoogleFonts.raleway(
              textStyle: GoogleFonts.poppins(
                fontSize: 18,
                color: ThemeColor.notBlack,
              ),
            ),
            decoration: InputDecoration(
                hintText: 'Your Gender Preference', border: InputBorder.none),
            items: itemsList
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.raleway(
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18,
                            color: ThemeColor.notBlack,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) => onChanged(value),
          ),
        ),
      ),
    );
  }
}
