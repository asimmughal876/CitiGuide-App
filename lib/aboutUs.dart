import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
         
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(248, 0, 35, 80),
                    Color.fromARGB(255, 0, 0, 0),
                  ],
                ),
              ),
            ),
          ),

          
          Positioned(
            top: 100,
            left: 30,
            right: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/capture.png',
                width: MediaQuery.of(context).size.width - 60,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),

         
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'City Guide',
                    style: GoogleFonts.lilitaOne(
                      fontSize: 30,
                      shadows: [
                        const Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black,
                          blurRadius: 3.0,
                        ),
                      ],
                      color: const Color.fromARGB(255, 251, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Learn more about our mission and values',
                    style: GoogleFonts.lilitaOne(
                      fontSize: 35,
                      color: const Color.fromARGB(255, 250, 253, 255),
                      shadows: [
                        const Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black,
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 59, 107),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                    ),
                    child: Text(
                      'Contact Us',
                      style: GoogleFonts.lilitaOne(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5), 
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(191, 227, 255, 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Stay updated on local events!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(191, 227, 255, 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Discover the best hotels to stay.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(191, 227, 255, 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Explore restaurants in the city.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
