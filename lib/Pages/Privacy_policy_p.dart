import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Pages/profile_p.dart';
import '../Widgets/appbar_w.dart';

class PrivacyPolicyP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileP()),
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: appBar('Privacy Policy', () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileP()),
          );
        }),
        
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xffE8EEEA),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy for Noomi Transport App',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Effective Date: July 1, 2023',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'At Noomi Transport ("we" or "us"), we are committed to protecting the privacy of our users ("you" or "user") and providing a safe and secure experience when using our mobile application ("Noomi Transport App" or "App"). This Privacy Policy outlines the types of personal information we collect, how we use it, and the choices you have regarding the information we collect. By using the Noomi Transport App, you agree to the collection, use, and disclosure of your personal information as described in this Privacy Policy.',
                ),
                SizedBox(height: 16.0),
                Text(
                  '1. Information We Collect',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '1.1. Personal Information',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'When you use the Noomi Transport App, we may collect certain personal information, including but not limited to:',
                ),
                SizedBox(height: 8.0),
                Text(
                    ' - Name: We may collect your full name to identify you as a user of the App.'),
                Text(
                    ' - Phone Number: We collect your personal phone number for authentication purposes. This information is required to verify and authenticate your identity as a driver on our platform. We take appropriate measures to protect the security and confidentiality of your phone number.'),
                SizedBox(height: 16.0),
                Text(
                  '1.2. Location Information',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'To provide our services effectively, we may collect and process your location information, including your current and historical location. This information helps us match you with relevant transportation requests and optimize our services. We only collect location information with your explicit consent, and you can withdraw your consent at any time by adjusting the location settings on your device.',
                ),
                SizedBox(height: 16.0),
                Text(
                  '1.3. Device Information',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'We may collect certain device-specific information when you access or use the Noomi Transport App, such as your device type, operating system, unique device identifiers, and mobile network information. This information helps us optimize our services for your specific device and provide a seamless user experience.',
                ),
                SizedBox(height: 16.0),
                Text(
                  '2. Use of Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'We may use the information we collect for the following purposes:',
                ),
                SizedBox(height: 8.0),
                Text(
                    '- To authenticate your identity as a driver on our platform.'),
                Text(
                    '- To provide and improve our services, including matching drivers with transportation requests, optimizing routes, and enhancing the user experience.'),
                Text(
                    '- To communicate with you, respond to your inquiries, and provide customer support.'),
                Text(
                    '- To send you important updates, notifications, and promotional offers related to our services.'),
                Text(
                    '- To enforce our Terms of Service and other applicable policies.'),
                Text(
                    '- To protect the rights, property, or safety of Noomi Transport, its users, or others, as required or permitted by law.'),
                SizedBox(height: 16.0),
                Text(
                  '3. Disclosure of Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'We may disclose your personal information in the following circumstances:',
                ),
                SizedBox(height: 8.0),
                Text(
                    '- With your consent: We may share your information with third parties if you provide your explicit consent.'),
                Text(
                    '- Service Providers: We may engage trusted third-party service providers to perform certain functions on our behalf, such as payment processing, data analysis, and customer support. These service providers have access to your information only to the extent necessary to perform their services and are obligated to maintain the confidentiality of your information.'),
                Text(
                    '- Legal Requirements: We may disclose your personal information if required to do so by law or in response to valid requests by public authorities (e.g., law enforcement or government agencies).'),
                Text(
                    '- Business Transfers: In the event of a merger, acquisition, or sale of all or a portion of our assets, your personal information may be transferred or disclosed as part of the transaction. We will notify you of any such change in ownership or control of your personal information.'),
                Text(
                    '- Aggregated or Anonymized Data: We may share aggregated or anonymized data that does not personally identify you with third parties for various purposes, including analytics, research, and improving our services.'),
                SizedBox(height: 16.0),
                Text(
                  '4. Data Retention',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy unless a longer retention period is required or permitted by law. When determining the retention period, we consider the nature and sensitivity of the information, the potential risk of harm from unauthorized use or disclosure, the purposes for which we process the information, and applicable legal requirements.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
