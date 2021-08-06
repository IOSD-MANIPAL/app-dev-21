import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home:Home()
));

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  double counter=0;
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('PORTFOLIO APP'),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            counter+=0.5;
          });

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [
            Center(
              child:
                CircleAvatar(
                  backgroundImage: AssetImage('images/ankit.png'),
                  radius: 40.0,

                ),
            ),
            Divider(
              height: 90.0,
              color: Colors.white,
            ),
            Text(
              'NAME',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              'ANKIT MISHRA',
              style: TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontSize: 28.0,


              ),
            ),
            SizedBox(height:30.0),
            Text(
              'BRANCH',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,

              ),
            ),
            Text(
              'CCE',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  color: Colors.amberAccent,

              ),
            ),
            SizedBox(height:30.0),
            Row(
              children:<Widget> [

                Icon(
                  Icons.mail,
                  color: Colors.white,

                ),
                Text(
                  'ankit.mishra@gmail.com',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 20.0,
                    color: Colors.amberAccent,
                  ),
                ),

              ],
            ),
            SizedBox(height:30.0),
            Text(
              'CGPA',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,

              ),
            ),
            Text(
              '$counter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontSize: 28.0,
                color: Colors.amberAccent,

              ),
            ),


          ],
        ),
      ),
    );
  }
}