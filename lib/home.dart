import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/18482986/pexels-photo-18482986/free-photo-of-people-at-a-concert-on-a-stadium.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                  opacity: 0.5,
                  fit: BoxFit.cover,
                ),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Explore Great Places",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Search Bar and Button with rounded corners and padding
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Outer padding
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFE0E0E0), // Background color for search bar
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0), // Padding inside the text field
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search City",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(244, 65, 83, 1),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              )),
                              minimumSize: const Size(
                                  100, 60), // Minimum size for button
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16), // Padding for button text
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  const Center(
                      child: Text("Popular Cities",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                          ),
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Karachi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
