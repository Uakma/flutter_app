import 'package:flutter/material.dart';
import 'package:motel/widgets/app_bar_close_icon.dart';

class PrivacyPolicyPage extends StatefulWidget {
  PrivacyPolicyPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(0.0, 0.1),
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 8,
                  right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AppBarCloseIcon(),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(14, 49, 120, 1)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1,),
            Expanded(
              child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 38, right: 37, top: 26),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      "FlyLine, Inc., a Delaware corporation, doing business as Flyline (???Flyline???) operates the Flyline.com and joinflyline.com websites (???Sites???), the Flyline mobile application (???App???), and the travel booking membership services offered through our Sites and App (together with the App and the Sites, the ???Services???). Flyline respects and protects the privacy of all individuals in our system. We maintain strict policies to ensure the privacy of Services (???End Users???) or those who may just be visiting our our our Site or whose data we hold as part of our service provider provider relationship with our clients (???Visitors???). This policy (???Privacy Policy???) describes the types of information we may collect from you and our practices for how we collect, use, maintain, protect, and disclose such information. The way that we collect and use your information depends on the way you access the Services (whether by Site or by App). This Privacy Policy also includes a description of certain rights that you may have over information that we may collect from you. By using the Services, you agree to this Privacy Policy. If you do not agree with our policies and practices, your choice is to not use our Services.\n\nTypes of Information Collected, ???Personal Data??? is information by which you may be personally identified. Flyline may collect the following Personal Data from you: Name; Email; Phone number; Date of Birth; Gender; Payment Information; Billing Address; and Known Traveler Numbers (TSA Pre-Check/Global Entry/etc.) Non-Personal Data Non-personal data includes any data that cannot be used on its own to identify, trace, or identify a person. We may collect your IP Address, device information, or location information. When non-Personal Data you give to us is combined with Personal Data we collect about you, it will be treated as Personal Data and we will only use it in accordance with this Privacy Policy.\n\nHow we collect information. With the exception of IP addresses which may be automatically collected, we only collect Personal Data when you affirmatively give it to us through interactions with the Services, including: During sign up to create an account on the Services; Through purchases you make on the Services; Through service requests or customer support; or Through feedback forms, surveys, or contests on the Services. We may collect non-Personal Data via automatic means including through cookies or through our third-party service providers listed below.\n\nWhy we collect and how we use your information. (Legal Basis). In general, we collect and use your Personal Data for the following reasons: when it is necessary for the general functioning of the Services; when it is necessary in connection with any contract you have entered into with us or to take steps prior to entering into a contract with us; when we have obtained your prior consent to the use (this legal basis is only used in relation to uses that are entirely voluntary ??? it is not used for information processing that is necessary or obligatory in any way); when we have a legitimate interest in processing your information for the purpose of providing or improving our Services; when have a legitimate interest in using the information for the purpose of contacting you, subject to compliance with applicable law; or when we have a legitimate interest in using the information for the purpose of detecting, and protecting against, breaches of our policies and applicable laws. We may use aggregated (anonymized) information about our End Users, and information that does not identify any individual, without restriction.\n\n\Accessing and Controlling Your Information. Flyline acknowledges your right to access and control your Personal Data. An who seeks who seeks to correct, amend, or delete delete data may do so through through through through through through through through through their account settings or by contacting us at support@JoinFlyline.com. If we receive a request to access or remove data, we will respond within a reasonable timeframe. If you would like to prevent us from collecting your information, you should cease use of our Services. You may have the option to opt-out of certain communications or data collection method as specified when presented to you, such as opt-ins or unsubscribe options. Please be aware that you are unable to opt-out of certain communications, including transaction-based communications.\n\nHow Long do we Store Personal Data? We will retain your Personal Data until we receive a deletion request or we determine the need to delete or archive the information. This length of time may vary according to the nature of your relationship with us.\n\nAutomated Data Collection Methods. Cookies, A cookie is a small file placed on the hard drive of your computer. Cookies are used to help us manage and report on your interaction with the Site. Through cookies, we are able to collect information that we use to improve the Services, keep track of shopping carts, keep track of click-stream data, authenticate your login credentials, manage multiple instances of the Site in a single browser, and tailor your experience on the Services. Cookies may also collect other data such as the date and time you visited the Site, and your current IP address. If you turn off cookies, your experience on the Services will be impaired. Log Files, We use means through the Services to collect IP addresses, browser types, access times, and physical location. We use this information to analyze service performance and to improve our Services.\n\nUsers under the age of 16. Our Services are not intended for children under 16 years of age and we do not knowingly collect Personal Data from children under 16. If you are under 16, do not use or register on the Services, make any purchases, use any of the interactive or public comment features, or provide any information about yourself to us. If we learn we have collected or received Personal Data from a child under 16 without verification of parental consent, we will delete that information. If you believe we might have any information from or about a child under 16, please contact us at the email address listed below.\n\nDo Not Track Settings. We do not track our Users over time and across third party websites to provide targeted advertising and do not specifically respond to Do Not Track (???DNT???) signals.\n\nWho We Share Data With. We may use aggregated (anonymized) information about our End Users and Visitors, and information that does not identify any individual, without restriction. We do not sell or otherwise disclose Personal Data specific personal or transactional information to anyone except as described below:\n\nPublic Reviews. When you write a review about your use of the Services, the review and your name may be posted on the review page on the Services.\n\nAffiliates. We may, for our legitimate interests, share your information with entities under common ownership or control with us who will process your information in a manner consistent with this Privacy Policy and subject to appropriate safeguards.\n\nSuccessors in Interest. We may, for our legitimate interests, share your information with a buyer or other successor in the event of a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of our assets, in which Personal Data about our End Users and Visitors is among the assets transferred. You will be notified of any such change by a prominent notice displayed on our Services or by e-mail. Any successor in interest to this Privacy Policy will be bound to the Privacy Policy at the time of transfer.\n\nLaw enforcement and other governmental agencies. We may share your information when we believe in good faith that such sharing is reasonably necessary to investigate, prevent, or take action regarding possible illegal activities or to comply with legal process. This may involve the sharing of your information with law enforcement, government agencies, courts, and/or other organizations.\n\nService Providers. We may, for our legitimate interests, share certain information with contractors, service providers, third party authenticators, and other third parties we use to support our business and who are bound by contractual obligations to keep Personal Data confidential and use it only for the purposes for which we disclose it to them. Some of the functions that our service providers provide are as follows: Travel booking APIs; Customer relationship management and live chat; Site and App analytics for activity, performance, and troubleshooting; Inbound marketing, sales, and service management; and Payment processing and payment storage.\n\nThird-Party Services and Websites. Flyline is not responsible for the privacy policies or other practices employed by websites linked to, or from, our Services nor the information or content contained therein, and we encourage you to read the privacy statements of any linked third party. This includes sharing information via social media websites.\n\nData Storage and How Flyline Protects Your Information. Flyline stores basic End User and Visitor data on our contracted servers including name, email, phone number, address, and username. Payment information is processed and stored by our partners or service providers. Personal Data about End Users and Visitors is stored within the United States. The Services are intended to be used inside the United States. If you are using the Services from the EEA or other regions with laws governing data collection and use, please note that you are agreeing to the transfer of your Personal Data to the United States. The United States may have laws which are different, and potentially not as protective, as the laws of your own country. By providing your Personal Data, you consent to any transfer and processing in accordance with this Privacy Policy. Flyline employs physical, electronic, and managerial control procedures to safeguard and help prevent unauthorized access to your information. We choose these safeguards based on the sensitivity of the information that we collect, process and store and the current state of technology. Our outsourced service providers who support our operations are also vetted to ensure that they too have the appropriate organizational and technical measures in place to protect your information Unfortunately, the transmission of information via the internet is not completely secure. Although we do our best to protect your Personal Data, we cannot guarantee the security of your information transmitted to the Services. Any transmission of information is at your own risk. We are not responsible for circumvention of any privacy settings or security measures contained on the Services. In the event that there is breach in the information that we hold; we shall notify of such breach via email or via notice on the Services.\n\nChanges to the Privacy Policy. It is our policy to post any changes we make to our Privacy Policy on this page. If we make material changes to how we treat our End Users??? or Visitors??? Personal Data, we will notify you by email to the primary email address specified in your account or through a prominent notice on the Site or App. Such changes will be effective when posted. The date the Privacy Policy was last revised is identified at the top of the page. Your continued use of our Services following the posting of any modification to this Privacy Policy shall constitute your acceptance of the amendments to this Privacy Policy. You can choose to discontinue use of the Service if you do not accept any modified version of this Privacy Policy.\n\nQuestions, Comments, and Requests. If you have any questions or comments about this Privacy Policy, or if you would like to file a request about the data we hold or file a deletion request, please contact us at hello@flyline.io or by mail 3102 Oak Lawn Ave., Dallas, TX 75219.",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color.fromRGBO(142, 150, 159, 1),
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      )
    );
  }
}
