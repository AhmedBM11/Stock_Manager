import 'package:flutter/material.dart';
import 'package:sat/views/pages/page_one/auth_page.dart';

class WelcomePage extends StatelessWidget {
  final bool isConnected;
  final String? userName;

  const WelcomePage({super.key, this.isConnected = false, this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Icon(Icons.inventory_2,
                          size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 10),
                      Text(
                        "Stock Manager",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Your smart solution to manage your store easily",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Center(
                  child: isConnected
                      ? Text(
                    "Welcome back, ${userName ?? 'User'} 👋",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      : Column(
                    children: [
                      const Text(
                        "Welcome to Stock Manager!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AuthPage(isLogin: false,);
                              },));
                            },
                            child: const Text("Create Account"),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AuthPage(isLogin: true,);
                              },));
                              },
                            child: const Text("Login"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "App Features",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 15),

                Column(
                  children: [
                    featureCard(
                      icon: Icons.store_outlined,
                      title: "Multi-Store Management",
                      description:
                      "Create and manage several stores from a single account, switching seamlessly between them.",
                    ),
                    featureCard(
                      icon: Icons.settings_accessibility_outlined,
                      title: "Role-Based Accessibility",
                      description:
                      "Assign permissions like Read Only, Read & Write, or Admin to each user for precise control over data.",
                    ),
                    featureCard(
                      icon: Icons.stacked_bar_chart,
                      title: "Product Stock Tracking",
                      description:
                      "Easily add, edit, and monitor product stock levels with real-time updates, reducing the risk of errors.",
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                const Text(
                  "Upcoming Features",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 15),

                Column(
                  children: [
                    featureCard(
                      icon: Icons.pie_chart_sharp,
                      title: "Analytics Dashboard",
                      description:
                      "Gain insights into sales trends and stock performance with clear charts.",
                    ),
                    featureCard(
                      icon: Icons.document_scanner_outlined,
                      title: "Barcode Scanner Integration",
                      description:
                      "Speed up product management by scanning items directly.",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget featureCard(
      {required IconData icon,
        required String title,
        required String description}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(description,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
