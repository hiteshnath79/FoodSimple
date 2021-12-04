import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_flutter_application/screen/add_meal.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 90.0),
          child: Text('Dashboard'),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/1.jpg'), fit: BoxFit.fill)),
                child: Stack(children: [
                  Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      child: Text(
                        'Header',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))
                ])),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.face),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Text('Admin'),
                      ),
                    ],
                  ),
                  Row(
                    children: [Icon(Icons.arrow_forward_ios)],
                  )
                ],
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddMeal(),
              )),
            ),
            Divider(),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('foods').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return GridView.count(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) => Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: GridTile(
                        child: Image.network(
                          snapshot.data!.docs[index]['fimage'],
                          fit: BoxFit.cover,
                        ),
                        footer: GridTileBar(
                          backgroundColor: Colors.white70,
                          title: Text(
                            snapshot.data!.docs[index]['fname'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
