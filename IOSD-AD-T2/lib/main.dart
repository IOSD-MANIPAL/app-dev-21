import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home:Boom(),
));

class Boom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white12,
      appBar: AppBar(
        title: Text(
          'WHO AM I ?',
          style: TextStyle(
            fontSize:20.0,
            fontWeight: FontWeight.bold,
            letterSpacing:2.0,
            color: Colors.redAccent[100],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
        elevation: 0.0,
      ),
      body:Padding(
        padding:EdgeInsets.fromLTRB(30.0, 40.0,30.0,0.0),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:<Widget> [
            Center(
              child: CircleAvatar(
                backgroundImage:NetworkImage('https://wallpaperaccess.com/full/2142078.png'),
                radius: 120.0,
              ),
            ),
            Divider(
              height:60.0,
              color:Colors.teal,
            ),
            Text(
              'NAME',
              style: TextStyle(
                  fontSize:20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing:2.0,
                  color: Colors.amber,
              ),
            ),
            SizedBox(height:10.0),
            Text(
              'YASH MANDHANIA',
              style: TextStyle(
                fontSize:30.0,
                fontWeight: FontWeight.bold,
                letterSpacing:2.0,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height:30.0),
            Text(
              'CLUB & LEVEL',
              style: TextStyle(
                fontSize:20.0,
                fontWeight: FontWeight.bold,
                letterSpacing:2.0,
                color: Colors.amber,
              ),
            ),
            SizedBox(height:10.0),
            Text(
              'IOSD:LEARNING COMMITTEE',
              style: TextStyle(
                fontSize:30.0,
                fontWeight: FontWeight.bold,
                letterSpacing:2.0,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height:30.0),
            Text(
              'CONTACT',
              style: TextStyle(
                fontSize:20.0,
                fontWeight: FontWeight.bold,
                letterSpacing:2.0,
                color: Colors.amber,
              ),
            ),
            SizedBox(height:10.0),
            Row(
              children:<Widget> [
                Icon(
                  Icons.email,
                  color:Colors.pinkAccent,
                  size: 30.0,
                ),
                SizedBox(width:10.0),
                Text(
                  'yashmandhania17@gmail.com',
                  style: TextStyle(
                    fontSize:20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing:1.0,
                    color: Colors.pinkAccent,
                  ),
                ),
          ],
        ),
            SizedBox(height:10.0),
            Row(
              children:<Widget> [
                Icon(
                  Icons.mobile_friendly_sharp,
                  color:Colors.pinkAccent,
                  size: 30.0,
                ),
                SizedBox(width:10.0),
                Text(
                  '8879379753',
                  style: TextStyle(
                    fontSize:20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing:1.0,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),

      ],
    ),
    ),
    );
  }
}



