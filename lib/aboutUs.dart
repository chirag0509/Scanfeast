import 'package:custom_signin_buttons/custom_signin_buttons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutUs extends StatefulWidget {
  const aboutUs({Key? key}) : super(key: key);

  @override
  _aboutUsState createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> with SingleTickerProviderStateMixin {
  Future<void> _launchurlWasp() async {
    Uri _url = Uri.parse('https://whatsapp.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlInsta() async {
    Uri _url =
        Uri.parse('https://instagram.com/scan_feast?igshid=ZDdkNTZiNTM=');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlFacebook() async {
    Uri _url = Uri.parse(
        'https://www.facebook.com/profile.php?id=100090994873352&mibextid=ZbWKwL');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlTwitter() async {
    Uri _url = Uri.parse('https://twitter.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Text("About Us"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.scale(
                    scale:1.8,
                    child: Image.asset("assets/Scan Feast.png",scale: 2.8,)),
                  Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our Story',
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'At Scan Feast, we believe that food brings people together. That\'s why we\'re dedicated to serving delicious meals made from fresh, locally-sourced ingredients. Our chefs are passionate about creating dishes that are not only flavorful, but also healthy and sustainable.',
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Meet the Team',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeamMember('Parth Dalvi', 'assets/parth2.png'),
                  _buildTeamMember('Prajakta Jadhav', 'assets/prajakta1.png'),
                  _buildTeamMember('Priyank Shah', 'assets/priyank.png'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'We are a family-owned restaurant that has been serving our community for over 10 years. Our mission is to provide the highest quality food and service to ensure our customers have an enjoyable dining experience. '
                  '\n\nCome and join us for a meal today!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      "Follow us on: ",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color.fromRGBO(37, 211, 102, 1),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlWasp();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFFF03b5998),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlFacebook();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Color.fromRGBO(255, 87, 51, 1.0),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlInsta();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Color(0xFFF00acee),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlTwitter();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '07, New Road, Mumbai',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hours:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mon-Fri: 11am - 9pm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
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
}

Widget _buildTeamMember(String name, String image) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 2,
                ))),
        backgroundImage: AssetImage(image),
      ),
      SizedBox(height: 8),
      Text(
        name,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
