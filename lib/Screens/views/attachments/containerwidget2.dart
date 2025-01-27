import 'package:flutter/material.dart';

class ContainerWidget2 extends StatelessWidget {
  const ContainerWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    // List of services to display
    final List<Map<String, dynamic>> services = [
      {'icon': Icons.local_shipping, 'label': 'Track Order'},
      {'icon': Icons.book, 'label': 'Look Book'},
      {'icon': Icons.refresh, 'label': 'Return & Exchanges'},
    ];

    return Padding(
      padding: const EdgeInsets.all(2.0), // Add padding around the content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Playstore Image and Contact Us with Green Background
          Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 255, 255, 255), // Green Background
            child: Row(
              children: [
                // Playstore Image
                Image.asset("assets/images/playstore.png", width: 40),
                const SizedBox(width: 10), // Spacer between image and text

                // Contact Us Title
                const Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.black, // White text for contrast
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Spacer between sections

          // Horizontal List of Services with Equal Space
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: services.map((service) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color.fromARGB(255, 43, 172, 0),
                    child: Icon(
                      service['icon'],
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 8), // Spacer below icon
                  Text(
                    service['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16), // Spacer between sections

          // Contact Information
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              color:
                  const Color.fromARGB(255, 255, 255, 255), // Green Background
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Helpline Row
                  Row(
                    children: [
                      Icon(Icons.phone, color: Color.fromARGB(255, 43, 172, 1)),
                      SizedBox(width: 8),
                      Text(
                        "Helpline: 123-456-7890",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8), // Spacer between rows

                  // Email Row
                  Row(
                    children: [
                      Icon(Icons.email, color: Color.fromARGB(255, 43, 172, 1)),
                      SizedBox(width: 8),
                      Text(
                        "Email: NextBu@Querry.com",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
