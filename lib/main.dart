import 'package:attendease/takePhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'firebase_options.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _name;
  late String _prn;
  late String _email;
  late String _role;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch user data whenever the state changes
    _fetchUserData();
  }

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    // Placeholder widget until user data is fetched
    Container(),
    // ProfilePage(name: _name, prn: _prn),
    Container(),
    Container(),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/appbar.png", fit: BoxFit.cover),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 50,
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                _onItemTapped(0); // Change index according to your requirement
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                child: const Icon(
                    Icons.auto_awesome_mosaic_outlined,
                    size: 30,
                ),
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                _onItemTapped(1); // Change index according to your requirement
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 30,),
              ),
            ),
            label: 'Profile',
          ),
          // Add more items as needed
        ],
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _fetchUserData() async {
    // Check if a user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore (use secure storage if needed)
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        setState(() {
          _name = userData['name'];
          _prn = userData['prn'];
          _email = userData['email'];
          _role = userData['role'];
          if (_role == 'student') {
            // Update the DashboardPage widget with fetched data
            _pages[0] = DashboardPage(name: _name, prn: _prn);
            _pages[1] = ProfilePage(name: _name, prn: _prn, email: _email,role: _role,);
          }
          else {
            _pages[0] = TeacherDashboardPage(name: _name, prn: _prn);
            _pages[1] = TeacherProfilePage(name: _name, prn: _prn, email: _email, role: _role,);
          }
        });
      } else {
        // Handle non-existent user data
        print('User data not found');
      }
    } else {
      // Handle not-logged-in case (e.g., redirect to login)
      print('No user logged in');
    }
  }

}

class DashboardPage extends StatelessWidget {
  final String name;
  final String prn;

  const DashboardPage({super.key, required this.name, required this.prn});

  Widget buildContainerWithProfile(String name, String prn) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.blueAccent, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(20), //   Padding for content
      margin: const EdgeInsets.all(15), // Margin for container
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome,",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Text color
                  ),
                ),
                Text(
                  "$name!",
                  style: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Text color
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "PRN: $prn",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    textStyle: const TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
              shape: BoxShape.circle, // Circular shape
            ),
            child: const CircleAvatar(
              radius: 40, // Radius of the circle
              backgroundColor: Colors.white, // Background color of the circle
              child: Icon(
                Icons.person, // Icon for the profile image
                color: Colors.blueAccent, // Color of the icon
                size: 50, // Size of the icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainerWithOptions() {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
      color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(10), // Padding for content
      margin: const EdgeInsets.all(20), // Margin for container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Attendance List icon press
                },
                icon: const Icon(Icons.article_rounded),
                color: Colors.green,
                iconSize: 40,
              ),
              const Text(
                'Attendance \nList',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Attendance Correction icon press
                },
                icon: const Icon(Icons.edit_document),
                color: Colors.indigoAccent,
                iconSize: 40,
              ),
              const Text(
                'Attendance\nCorrection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Leave icon press
                },
                icon: const Icon(Icons.person_remove_alt_1_rounded),
                color: Colors.amber,
                iconSize: 40,
              ),
              const Text(
                'Leave',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithText(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
      }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 30, // Half of the screen width minus padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              // Handle button press
            },
            icon: Icon(icon),
            color: color,
            iconSize: 40,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainerWithAttendances(BuildContext context) {
    // List of subjects and their corresponding percentages
    List<Map<String, dynamic>> subjects = [
      {"name": "DAA", "percent": 70.0},
      {"name": "SE", "percent": 80.0},
      {"name": "RHL", "percent": 90.0},
      {"name": "CD", "percent": 75.0},
      {"name": "CSF", "percent": 95.0},
      {"name": "DAA lab", "percent": 85.0},
      // Add more subjects as needed
    ];

    int columns = 3; // Number of columns
    double rowSpacing = 20.0; // Spacing between rows

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      margin: const EdgeInsets.all(20), // Margin for container
      padding: const EdgeInsets.all(10), // Padding for content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "My Attendances", // Heading text
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10), // Adding spacing between heading and container
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (subjects.length / columns).ceil(), // Number of rows
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * columns; // Start index of subjects for this row
              int endIndex = startIndex + columns; // End index of subjects for this row
              endIndex = endIndex > subjects.length ? subjects.length : endIndex;

              return Padding(
                padding: EdgeInsets.only(bottom: rowSpacing), // Adding spacing between rows
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = startIndex; i < endIndex; i++)
                      Expanded(
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 40.0,
                              lineWidth: 10.0,
                              animation: true,
                              percent: subjects[i]["percent"] / 100.0, // Using the provided percentage
                              center: Text(
                                "${subjects[i]["percent"]}%", // Displaying the percentage
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                              ),
                              footer: Text(
                                subjects[i]["name"], // Displaying the subject name
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: subjects[i]["percent"] < 75 ? Colors.red : Colors.green, // Setting progress color based on percentage
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainerWithProfile(name, prn),
          buildContainerWithAttendances(context),
          buildContainerWithOptions(),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name;
  final String prn;
  final String email;
  final String role;
  const ProfilePage({super.key, required this.name, required this.prn, required this.email,required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Background color
              borderRadius: BorderRadius.circular(25), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3), // Shadow color
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                            shape: BoxShape.circle, // Circular shape
                          ),
                          child: const CircleAvatar(
                            radius: 60, // Radius of the circle
                            backgroundColor: Colors.white, // Background color of the circle
                            child: Icon(
                              Icons.person, // Icon for the profile image
                              color: Colors.blueAccent, // Color of the icon
                              size: 80,
                          ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40) ,
                        child: TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.edit_note_sharp,
                            color: Colors.black38,
                            size: 32,
                          ),
                          label: Text('Edit',
                            style: GoogleFonts.ruluko(color: Colors.black38, fontSize: 20,fontWeight: FontWeight.w700,),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent, // Adjust button color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(name,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PRN:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(prn,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Email:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(email,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mobile:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text('Mobile',style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Department:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text('COMP',style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Role:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(role,style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class TeacherDashboardPage extends StatelessWidget {
  final String name;
  final String prn;

  const TeacherDashboardPage({super.key, required this.name, required this.prn});

  Widget buildContainerWithProfile(String name, String prn) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.blueAccent, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(20), //   Padding for content
      margin: const EdgeInsets.all(15), // Margin for container
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, Teacher",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Text color
                  ),
                ),
                Text(
                  "$name!",
                  style: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Text color
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "ID: $prn",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    textStyle: const TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
              shape: BoxShape.circle, // Circular shape
            ),
            child: const CircleAvatar(
              radius: 40, // Radius of the circle
              backgroundColor: Colors.white, // Background color of the circle
              child: Icon(
                Icons.person, // Icon for the profile image
                color: Colors.blueAccent, // Color of the icon
                size: 50, // Size of the icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainerWithOptions() {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(10), // Padding for content
      margin: const EdgeInsets.all(20), // Margin for container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Attendance List icon press
                },
                icon: const Icon(Icons.article_rounded),
                color: Colors.green,
                iconSize: 40,
              ),
              const Text(
                'Attendance \nList',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Attendance Correction icon press
                },
                icon: const Icon(Icons.edit_document),
                color: Colors.indigoAccent,
                iconSize: 40,
              ),
              const Text(
                'Attendance\nCorrection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Handle Leave icon press
                },
                icon: const Icon(Icons.person_remove_alt_1_rounded),
                color: Colors.amber,
                iconSize: 40,
              ),
              const Text(
                'Leave',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithText(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
      }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 30, // Half of the screen width minus padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              // Handle button press
            },
            icon: Icon(icon),
            color: color,
            iconSize: 40,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainerWithAttendances(BuildContext context) {
    // List of subjects and their corresponding percentages
    List<Map<String, dynamic>> subjects = [
      {"name": "DAA lab", "division/batch": 'B3'},
      {"name": "SE theory", "division/batch": 'A'},
      {"name": "RHL lab", "division/batch": 'B'},
      {"name": "CD theory", "division/batch": 'C'},
      {"name": "CSF theory", "division/batch": 'OE'},
      {"name": "DAA lab", "division/batch": 'B2'},
      // Add more subjects as needed
    ];

    int columns = 3; // Number of columns
    double rowSpacing = 20.0; // Spacing between rows

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(25), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      margin: const EdgeInsets.all(20), // Margin for container
      padding: const EdgeInsets.all(10), // Padding for content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "My Classes", // Heading text
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10), // Adding spacing between heading and container
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (subjects.length / columns).ceil(), // Number of rows
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * columns; // Start index of subjects for this row
              int endIndex = startIndex + columns; // End index of subjects for this row
              endIndex = endIndex > subjects.length ? subjects.length : endIndex;

              return Padding(
                padding: EdgeInsets.only(bottom: rowSpacing), // Adding spacing between rows
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = startIndex; i < endIndex; i++)
                      Expanded(
                  child: TextButton(
                  onPressed: () {
                // Show popup here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(subjects[i]["name"]),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Division/Batch: ${subjects[i]["division/batch"]}"),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              // Navigate to takePhotoPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TakePhoto()),
                              );
                            },
                            child: Text('Take Photo'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
              children: [
                Text(subjects[i]["division/batch"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
              SizedBox(height: 5,),
              Text(subjects[i]["name"],style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 17.0),),
              SizedBox(height: 5),
              ],
              ),
                      ),
                      ),],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainerWithProfile(name, prn),
          buildContainerWithAttendances(context),
          buildContainerWithOptions(),
        ],
      ),
    );
  }
}

class TeacherProfilePage extends StatelessWidget {
  final String name;
  final String prn;
  final String email;
  final String role;
  const TeacherProfilePage({super.key, required this.name, required this.prn, required this.email,required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Background color
              borderRadius: BorderRadius.circular(25), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3), // Shadow color
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                            shape: BoxShape.circle, // Circular shape
                          ),
                          child: const CircleAvatar(
                            radius: 60, // Radius of the circle
                            backgroundColor: Colors.white, // Background color of the circle
                            child: Icon(
                              Icons.person, // Icon for the profile image
                              color: Colors.blueAccent, // Color of the icon
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40) ,
                        child: TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.edit_note_sharp,
                            color: Colors.black38,
                            size: 32,
                          ),
                          label: Text('Edit',
                            style: GoogleFonts.ruluko(color: Colors.black38, fontSize: 20,fontWeight: FontWeight.w700,),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent, // Adjust button color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(name,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PRN:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(prn,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Email:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(email,style: const TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mobile:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text('Mobile',style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Department:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text('COMP',style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Role:',style: TextStyle(color: Colors.white,fontSize: 18)),
                      Text(role,style: TextStyle(color: Colors.white,fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}