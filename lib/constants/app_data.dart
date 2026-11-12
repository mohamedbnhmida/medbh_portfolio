import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';
import 'package:medbh_portfolio/models/experience_model.dart';
import 'package:medbh_portfolio/models/project_model.dart';
import 'package:medbh_portfolio/models/review_model.dart';
import 'package:medbh_portfolio/models/technology_model.dart';

class AppData {
  static const List<TechnologyModel> technologies = [
    TechnologyModel(
      name: "Flutter",
      assetPath: "assets/flutter.png",
      color: Colors.blueAccent,
    ),

    TechnologyModel(
      name: "iOS (Swift)",
      icon: FontAwesomeIcons.swift,
      color: Color(0xFFF05138),
    ),
    TechnologyModel(
      name: "Backbase",
      assetPath: "assets/backbase.png",
      color: Color.fromARGB(255, 35, 34, 34),
    ),
    TechnologyModel(
      name: "Android",
      icon: FontAwesomeIcons.android,
      color: Color(0xFF3DDC84),
    ),
    TechnologyModel(
      name: "React Native",
      icon: FontAwesomeIcons.react,
      color: Color(0xFF61DAFB),
    ),
    TechnologyModel(
      name: "Express.js",
      icon: FontAwesomeIcons.nodeJs,
      color: Color(0xFF68A063),
    ),
    TechnologyModel(
      name: "Firebase",
      assetPath: 'assets/firebase.png',
      color: Color(0xFFFFCA28),
      icon: null,
    ),
    TechnologyModel(
      name: "Arduino",
      assetPath: "assets/arduino.png",
      color: Color(0xFF00979D),
    ),
    TechnologyModel(
      name: "Raspberry Pi",
      assetPath: "assets/raspberry.png",
      color: Color(0xFF00979D),
    ),
    TechnologyModel(
      name: "Python",
      assetPath: "assets/python.png",
      color: Color(0xFF3776AB),
    ),
    TechnologyModel(
      name: "Git",
      icon: FontAwesomeIcons.gitAlt,
      color: Color(0xFFF05032),
    ),
  ];

  static const List<ProjectModel> mobileProjects = [
    ProjectModel(
      name: "Shada LED Light",
      description:
          "Smart Bulb Controller (Personal project, 2026). Brings the Shada LED's light Bluetooth bulb (art. 600750) back to life after its official app was discontinued. Unofficial, not affiliated with Shada.",
      appIcon: "assets/projects/shada_led/icon.png",
      githubUrl: "https://github.com/mohamedbnhmida/Shada-Led-s-Light",
      screenshots: [
        "assets/projects/shada_led/screenshots/image1.png",
        "assets/projects/shada_led/screenshots/image2.png",
        "assets/projects/shada_led/screenshots/image3.png",
      ],
      technologies: [
        "Flutter",
        "Bluetooth LE",
        "Foreground Service",
        "Local Notifications",
        "Reverse Engineering",
      ],
      highlights: [
        "Decompiled the discontinued Android app to recover the bulb's proprietary BLE protocol (Quintic chip unlock + 10-byte color packets).",
        "Color wheel, warm-white mode, scenes with fades and loops, and schedules with a run duration.",
        "Scenes and schedules run in an Android foreground service, so they keep going with the app closed and survive reboots.",
        "English, French and Arabic (RTL), light and dark themes; open source on GitHub.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "MyLudo",
      description:
          "Online Multiplayer Ludo (Personal project, 2026). Took the open-source NLudo game (Apache 2.0) and turned it into an online party game: host a room, share a code or QR, and play with friends in real time.",
      appIcon: "assets/projects/my_ludo/icon.png",
      webUrl: "https://myludo-tunisie.web.app",
      screenshots: [
        "assets/projects/my_ludo/screenshots/image1.png",
        "assets/projects/my_ludo/screenshots/image2.png",
        "assets/projects/my_ludo/screenshots/image3.png",
      ],
      technologies: [
        "Flutter",
        "Firebase Realtime Database",
        "Firebase Auth",
        "Provider",
        "QR Codes",
      ],
      highlights: [
        "Added online multiplayer on Firebase Realtime Database: rooms, a live lobby and in-game state sync.",
        "Host a game and invite friends with a room code, a QR code or the share sheet; join by typing or scanning.",
        "Player profiles with name and photo, remembered between sessions.",
        "Local play for 2 to 4 players with CPU opponents, sounds, and a board that rotates to each player's side.",
        "Redesigned player chips, board centering and an animated dice-rain background.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Stocky",
      description:
          "Offline-First Inventory App (Personal project, 2026). Scan barcodes, record items and storage bins, and keep a team's stock in sync through Firebase, even without signal.",
      appIcon: "assets/projects/stocky/icon.png",
      screenshots: [
        "assets/projects/stocky/screenshots/image1.png",
        "assets/projects/stocky/screenshots/image2.png",
        "assets/projects/stocky/screenshots/image3.png",
        "assets/projects/stocky/screenshots/image4.png",
      ],
      technologies: [
        "Flutter",
        "Firebase",
        "Cloud Firestore",
        "SQLite",
        "Barcode Scanning",
        "PDF",
      ],
      highlights: [
        "Camera barcode scanning with flash, manual entry and audible feedback.",
        "Offline-first: every change is saved locally (sqflite) and synced to Firestore when the connection returns.",
        "Bin-ticket printing and PDF inventory export; backup and restore to a memory card.",
        "Email sign-in, remote config, English/French/Arabic, light and dark themes.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Seekers",
      description:
          "Outdoor Adventure Planning Application (Freelance, 2026). Cross-platform mobile app with deployed backend services.",
      appStoreUrl: "https://apps.apple.com/app/id6753112621",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.seekras.tn",
      appIcon: "assets/projects/seekers/icon.png",
      screenshots: [
        "assets/projects/seekers/screenshots/image1.png",
        "assets/projects/seekers/screenshots/image2.png",
        "assets/projects/seekers/screenshots/image3.png",
        "assets/projects/seekers/screenshots/image4.png",
      ],
      technologies: [
        "React Native",
        "Express.js",
        "TypeScript",
        "MongoDB",
        "Expo",
        "Firebase",
        "Socket.IO",
        "Docker",
      ],
      highlights: [
        "Designed and built the React Native mobile app end to end, solo, as the full-stack developer.",
        "Built and maintained the Express.js/TypeScript backend and MongoDB data layer.",
        "Google & Facebook sign-in with JWT-based session management.",
        "Real-time features via Socket.IO; media uploads handled through Cloudinary.",
        "Dockerized deployment; published to both the App Store and Google Play.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Weefarm",
      description:
          "Digital Farming Application (Verdanova Solutions, 2026). Cross-platform mobile app for smart agriculture management.",
      appIcon: "assets/projects/weefarm/icon.png",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.weefarm.app",
      screenshots: [
        "assets/projects/weefarm/screenshots/image1.png",
        "assets/projects/weefarm/screenshots/image2.png",
        "assets/projects/weefarm/screenshots/image3.png",
        "assets/projects/weefarm/screenshots/image4.png",
      ],
      technologies: [
        "Flutter",
        "Express.js",
        "TypeScript",
        "MongoDB",
        "Firebase",
        "Socket.IO",
        "Docker",
        "Cloudinary",
      ],
      highlights: [
        "Digitized field and crop monitoring workflows for Verdanova Solutions.",
        "Built the Flutter mobile app and the Express.js/TypeScript backend end to end.",
        "Real-time data sync via Socket.IO; media handled through Cloudinary.",
        "Crash monitoring with Firebase Crashlytics; containerized deployment with Docker.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Ilef Info Mobile",
      description: "Company app for Ilef Info Services built from scratch.",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=tn.ilefinfo.ilefinfo",
      appIcon: "assets/projects/ilef_info_mobile/icon.png",
      screenshots: [
        "assets/projects/ilef_info_mobile/screenshots/image1.png",
        "assets/projects/ilef_info_mobile/screenshots/image2.png",
        "assets/projects/ilef_info_mobile/screenshots/image3.png",
        "assets/projects/ilef_info_mobile/screenshots/image4.png",
      ],
      technologies: ["Flutter", "Dart", "Google Maps API"],
      highlights: [
        "Analysis and specification of needs, modeled with UML.",
        "Built the company app with Flutter from scratch, including custom animated components.",
        "Contributed to project documentation and conception.",
        "Tested and published the application to the Google Play Store.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "HLPro Mobile",
      description:
          "AI-based optical fiber patchcord testing system using Deep Learning.",
      appIcon: "assets/projects/hlpro_mobile/icon.png",
      screenshots: [
        "assets/projects/hlpro_mobile/screenshots/image1.png",
        "assets/projects/hlpro_mobile/screenshots/image2.png",
      ],
      technologies: ["Flutter", "Python", "TensorFlow", "Raspberry Pi"],
      highlights: [
        "Built a CNN-based deep learning pipeline for optical fiber patchcord quality prediction.",
        "Generated synthetic training data with DCGAN; evaluated VGG16, VGG19 and MobileNetV2.",
        "Deployed inference on a Raspberry Pi using TFLite for real-time, on-device predictions.",
        "Built the companion Flutter app for real-time result visualization.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Kalonet",
      description: "Health and Wellness Application with Clean Architecture.",
      appIcon: "assets/projects/kalonet/icon.png",
      screenshots: [
        "assets/projects/kalonet/screenshots/image1.png",
        "assets/projects/kalonet/screenshots/image2.png",
        "assets/projects/kalonet/screenshots/image3.png",
      ],
      technologies: ["Flutter", "GetX", "Clean Arch", "WidgetKit"],
      highlights: [
        "Conducted requirements analysis and modeled the system using UML.",
        "Implemented Clean Architecture with dependency injection for testability.",
        "Consumed RESTful web services for health & wellness data.",
        "Led team task coordination as part of a small dev team.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "SNTAT",
      description:
          "High-traffic social and entertainment app serving 5M+ users, with live voice chat rooms, short videos, games and a rewards economy.",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=my.game.sntat",
      appIcon: "assets/projects/sntat/icon.png",
      screenshots: [
        "assets/projects/sntat/screenshots/image1.png",
        "assets/projects/sntat/screenshots/image2.png",
        "assets/projects/sntat/screenshots/image3.png",
        "assets/projects/sntat/screenshots/image4.png",
        "assets/projects/sntat/screenshots/image5.png",
        "assets/projects/sntat/screenshots/image6.png",
        "assets/projects/sntat/screenshots/image7.png",
        "assets/projects/sntat/screenshots/image8.png",
      ],
      technologies: ["iOS", "SwiftUI", "Agora", "ZegoCloud", "Combine"],
      highlights: [
        "Built for scale: 5M+ users and high real-time traffic across chat rooms, feed and games.",
        "Developed a scalable MVVM architecture with Combine for state management.",
        "Enabled group voice chat in chatrooms using VoIP and real-time communication SDKs.",
        "Enhanced media delivery in the social feed via compression, format conversion, buffering and preload.",
        "Built a multiplayer games module with real-time features.",
        "Built a native C framework, shipped via Swift Package Manager, to protect API calls: fewer API attacks and survived automated script attacks.",
        "Reworked memory management with async/await and GCD: 70% faster app performance and fewer memory leaks.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "ASWAN",
      description: "Online commerce and wholesale app.",
      appStoreUrl: "https://apps.apple.com/us/app/aswan-/id6741357149",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=asph.shop.aswan",
      appIcon: "assets/projects/aswan/icon.png",
      screenshots: [
        "assets/projects/aswan/screenshots/image1.png",
        "assets/projects/aswan/screenshots/image2.png",
        "assets/projects/aswan/screenshots/image3.png",
      ],
      technologies: ["iOS", "SwiftUI", "CoreData", "Combine"],
      highlights: [
        "Developed a scalable MVVM architecture with Combine for state management.",
        "Consumed RESTful web services in JSON format for API processing.",
        "Used CoreData for efficient local data persistence.",
        "Integrated Crashlytics and Analytics for crash detection and quality assurance.",
        "Linked UIKit views inside SwiftUI using Coordinator and UIViewRepresentable.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Digital LIB",
      description:
          "Retail Banking App for Libyan Islamic Bank using Backbase SDK.",
      appStoreUrl: "https://apps.apple.com/us/app/digital-lib/id6737797097",
      appIcon: "assets/projects/digital_lib/icon.png",
      screenshots: [
        "assets/projects/digital_lib/screenshots/image1.png",
        "assets/projects/digital_lib/screenshots/image2.png",
        "assets/projects/digital_lib/screenshots/image3.png",
        "assets/projects/digital_lib/screenshots/image4.png",
      ],
      technologies: ["iOS", "Swift", "UIKit", "Backbase", "VIP"],
      highlights: [
        "Led onboarding by integrating the Backbase SDK and configuring the ModelBank foundation.",
        "Customized and configured out-of-the-box (OOTB) Backbase journeys for client requirements.",
        "Built custom banking journeys following Clean Architecture.",
        "Managed distribution via AppCenter, Firebase App Distribution and the App Store, with GitHub Actions and Fastlane.",
        "Ensured code quality with SwiftLint and SonarQube.",
        "Applied the OWASP Mobile Top 10 security checklist, hardening the app against 80% of common attack vectors.",
      ],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "LIB Corporate",
      description:
          "Corporate Banking App for Libyan Islamic Bank using Backbase SDK.",
      appStoreUrl: "https://apps.apple.com/us/app/digital-lib/id6757910485",
      appIcon: "assets/projects/lib_corporate/icon.jpg",
      screenshots: [
        "assets/projects/lib_corporate/screenshots/image1.png",
        "assets/projects/lib_corporate/screenshots/image2.png",
        "assets/projects/lib_corporate/screenshots/image3.png",
        "assets/projects/lib_corporate/screenshots/image4.png",
      ],
      technologies: ["iOS", "Swift", "SwiftUI", "Backbase", "Clean Arch"],
      highlights: [
        "Led onboarding by integrating the Backbase SDK and configuring the ModelBank foundation.",
        "Built custom banking journeys following Clean Architecture and SwiftUI.",
        "Managed distribution via AppCenter, Firebase App Distribution and the App Store, streamlined with GitHub Actions and Fastlane.",
        "Implemented mobile security: jailbreak/root detection, anti-hooking, anti-debug and SSL pinning.",
        "Applied the OWASP Mobile Top 10 security checklist, hardening the app against 80% of common attack vectors.",
      ],
      projectType: ProjectType.mobile,
    ),
  ];

  static const List<ProjectModel> webDesktopProjects = [
    ProjectModel(
      name: "Seekers Dashboard",
      description:
          "Admin Panel for Seekers Mobile App (Freelance, 2026). Web application with deployed backend services.",
      screenshots: [
        "assets/projects/seekers_dashboard/screenshots/image1.png",
        "assets/projects/seekers_dashboard/screenshots/image2.png",
        "assets/projects/seekers_dashboard/screenshots/image3.png",
        "assets/projects/seekers_dashboard/screenshots/image4.png",
      ],
      technologies: [
        "Flutter",
        "Express.js",
        "TypeScript",
        "MongoDB",
        "Socket.IO",
        "JWT Auth",
        "Cloudinary",
        "Docker",
      ],
      highlights: [
        "Built the Flutter-based admin panel for managing users, listings and activity on the Seekers platform.",
        "Shares a single Express.js/TypeScript/MongoDB backend with the mobile and web apps.",
        "Real-time updates via Socket.IO; media managed through Cloudinary.",
        "Secured with JWT auth; deployed via Docker.",
      ],
      projectType: ProjectType.webDesktop,
    ),
    ProjectModel(
      name: "Seekers Web",
      description:
          "Web platform for Seekers Outdoor Adventure Planning Application (Freelance, 2026). Responsive web experience with full backend integration.",
      webUrl: "https://app.seek-ers.com/",
      screenshots: [
        "assets/projects/seekers_web/screenshots/image1.png",
        "assets/projects/seekers_web/screenshots/image2.png",
        "assets/projects/seekers_web/screenshots/image3.png",
        "assets/projects/seekers_web/screenshots/image4.png",
        "assets/projects/seekers_web/screenshots/image5.png",
      ],
      technologies: [
        "Flutter Web",
        "Express.js",
        "TypeScript",
        "MongoDB",
        "Socket.IO",
        "JWT Auth",
        "Cloudinary",
        "Docker",
      ],
      highlights: [
        "Delivered a responsive Flutter Web experience for browsing and booking outdoor adventures.",
        "Full integration with the shared Socket.IO/MongoDB backend for live data.",
        "JWT-based authentication with Google/Facebook sign-in.",
        "Cloudinary-backed media delivery; Dockerized deployment.",
      ],
      projectType: ProjectType.webDesktop,
    ),
    ProjectModel(
      name: "Registre de Chambre Notaire",
      description:
          "Desktop Notary System (SDP Tunisie, 2026). Windows desktop application to track and manage notary operations in Tunisia.",
      screenshots: [
        "assets/projects/notary_system/screenshots/image1.png",
        "assets/projects/notary_system/screenshots/image2.png",
        "assets/projects/notary_system/screenshots/image3.png",
        "assets/projects/notary_system/screenshots/image4.png",
        "assets/projects/notary_system/screenshots/image5.png",
        "assets/projects/notary_system/screenshots/image6.png",
      ],
      technologies: ["Flutter", "Windows Desktop", "QR Code"],
      highlights: [
        "Digitized notary chamber document tracking and workflow for a Tunisian notary office.",
        "QR code generation and scanning for document identification.",
        "NFC support for ID/card-based lookups.",
        "Sentry integration for crash and error monitoring in production.",
      ],
      projectType: ProjectType.webDesktop,
    ),
    ProjectModel(
      name: "Visitor Management",
      description:
          "Desktop Visitor Management Solution (SDP Tunisie, 2026). Windows app to control company visits & appointments, generate daily reports with professional scanner support.",
      screenshots: [
        "assets/projects/visitor_management/screenshots/image1.png",
        "assets/projects/visitor_management/screenshots/image2.png",
        "assets/projects/visitor_management/screenshots/image3.png",
        "assets/projects/visitor_management/screenshots/image4.png",
        "assets/projects/visitor_management/screenshots/image5.png",
        "assets/projects/visitor_management/screenshots/image6.png",
        "assets/projects/visitor_management/screenshots/image7.png",
      ],
      technologies: [
        "Flutter",
        "Windows Desktop",
        "Express.js",
        "Desko SDK",
        "MRZ",
        "QR Code",
      ],
      highlights: [
        "Automated corporate visitor check-in, appointment scheduling and daily reporting.",
        "ID document scanning via Desko SDK with MRZ (passport/ID) parsing.",
        "QR code badge generation for visitor access.",
        "Express.js backend for data sync; Sentry for error monitoring.",
      ],
      projectType: ProjectType.webDesktop,
    ),
  ];

  static List<ProjectModel> get projects => [
    ...mobileProjects,
    ...webDesktopProjects,
  ];

  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      role: "iOS Developer",
      company: "One Tech Business Solutions",
      period: "Jun 2024 - Present",
      location: "Ariana, Tunisia",
      logo: "assets/logos/onetechbs.jpg",
    ),
    ExperienceModel(
      role: "iOS Developer",
      company: "Phylia Technology",
      period: "Jun 2022 - May 2024",
      location: "Medenine, Tunisia",
      logo: "assets/logos/phylia.jpg",
    ),
    ExperienceModel(
      role: "Mobile Developer",
      company: "Ilef Info Services (DB Consulting)",
      period: "Sep 2021 - Jun 2022",
      location: "Medenine, Tunisia",
      logo: "assets/logos/ilefinfo.png",
    ),
  ];

  static const List<EducationModel> education = [
    EducationModel(
      degree: "Professional Master in Embedded Systems",
      institution:
          "Higher Institute of Computer Science and Multimedia of Gabes",
      period: "2021 - 2023",
      logo: "assets/logos/isimg.jpg",
    ),
    EducationModel(
      degree: "Bachelor's Degree in Embedded Systems and Mobile",
      institution: "Higher Institute for Technological Studies of Medenine",
      period: "2014 - 2017",
      logo: "assets/logos/isetmd.jpg",
    ),
  ];

  static const List<CertificationModel> certifications = [
    CertificationModel(
      name: "BackBase iOS Developer",
      issuer: "Backbase",
      date: "Aug 2024",
      logo: "assets/logos/backbase.jpg",
      image: "assets/certs/backbase.jpg",
      skills: ["BackBase", "Resolver"],
    ),
    CertificationModel(
      name: "Scrum Fundamentals Certified",
      issuer: "VMEdu.com",
      date: "Jan 2022",
      url:
          "https://c46e136a583f7e334124-ac22991740ab4ff17e21daf2ed577041.ssl.cf1.rackcdn.com/Certificate/ScrumFundamentalsCertified-BenHmidaMohamed-892495.pdf",
      credentialId: "892495",
      logo: "assets/logos/vmedu.jpg",
      image: "assets/certs/scrum.jpg",
      skills: ["Scrum", "Agile Methodologies"],
    ),
    CertificationModel(
      name: "The Complete 2023 Swift & SwiftUI (IOS App Course) [Arabic]",
      issuer: "Udemy",
      date: "Jun 2024",
      url:
          "https://www.udemy.com/certificate/UC-83c5292f-8eb5-47d2-bbab-9376f9b6b504/",
      credentialId: "UC-83c5292f-8eb5-47d2-bbab-9376f9b6b504",
      logo: "assets/logos/udemy.jpg",
      image: "assets/certs/udemy_swift_arabic.jpg",
    ),
    CertificationModel(
      name: "iOS, Swift & SwiftUI - Complete iOS App Development",
      issuer: "Udemy",
      date: "Jun 2024",
      url:
          "https://www.udemy.com/certificate/UC-be696bc2-f621-4c39-bd0c-c04435237fda/",
      credentialId: "UC-be696bc2-f621-4c39-bd0c-c04435237fda",
      logo: "assets/logos/udemy.jpg",
      image: "assets/certs/udemy_ios_swiftui.jpg",
      skills: ["SwiftUI", "UIKit"],
    ),
    CertificationModel(
      name: "Réalisez un cahier des charges fonctionnel",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/7495954595",
      credentialId: "7495954595",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_7495954595.jpg",
    ),
    CertificationModel(
      name: "Découvrez la méthodologie DevOps",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/3110192171",
      credentialId: "3110192171",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_3110192171.jpg",
    ),
    CertificationModel(
      name: "Learn Python Basics",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/1515830936",
      credentialId: "1515830936",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_1515830936.jpg",
      skills: ["Python (Programming Language)"],
    ),
    CertificationModel(
      name: "Adoptez les API REST pour vos projets web",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/1654496063",
      credentialId: "1654496063",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_1654496063.jpg",
    ),
    CertificationModel(
      name: "Gérez la navigation et les formulaires sur iOS",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/3522126453",
      credentialId: "3522126453",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_3522126453.jpg",
    ),
    CertificationModel(
      name: "Approfondissez Swift avec la programmation orientée objet",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/1549387534",
      credentialId: "1549387534",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_1549387534.jpg",
      skills: ["Programmation orientée objet (POO)"],
    ),
    CertificationModel(
      name: "Débuguez et testez vos applications iOS",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/5072639716",
      credentialId: "5072639716",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_5072639716.jpg",
      skills: ["Test unitaire", "XCTest"],
    ),
    CertificationModel(
      name: "Learn fundamentals of the Swift Programming Language",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/4061512211",
      credentialId: "4061512211",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_4061512211.jpg",
    ),
    CertificationModel(
      name: "Introduction à iOS : plongez dans le développement mobile !",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/8395956056",
      credentialId: "8395956056",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_8395956056.jpg",
    ),
    CertificationModel(
      name: "Gérez du code avec Git et GitHub",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/3552853493",
      credentialId: "3552853493",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_3552853493.jpg",
    ),
    CertificationModel(
      name: "Développez une application iPhone avec le modèle MVC",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/6405581865",
      credentialId: "6405581865",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_6405581865.jpg",
      skills: ["Architecture MVC"],
    ),
    CertificationModel(
      name: "Créez une application responsive avec UIKit pour iOS",
      issuer: "OpenClassrooms",
      date: "Sep 2021",
      url: "https://openclassrooms.com/fr/course-certificates/9171909769",
      credentialId: "9171909769",
      logo: "assets/logos/openclassrooms.jpg",
      image: "assets/certs/oc_9171909769.jpg",
      skills: ["UIKit"],
    ),
  ];

  static const List<ReviewModel> reviews = [
    ReviewModel(
      name: "Jasser Ben Saad",
      role: "CEO",
      company: "Verdanova Solutions",
      initials: "JB",
      source: "Malt",
      sourceUrl: AppStrings.maltUrl,
      text:
          "I highly recommend Mohamed for his mobile development skills. He's a serious, competent and committed freelancer with a strong grasp of mobile technologies. Attentive, autonomous, and always able to propose effective solutions while respecting deadlines. A reliable person who is a real pleasure to work with.",
    ),
    ReviewModel(
      name: "Ala Romdhane",
      role: "Founder",
      company: "Seekers",
      initials: "AR",
      source: "Malt",
      sourceUrl: AppStrings.maltUrl,
      text:
          "Mohamed developed our Seekers platform from A to Z: iOS/Android mobile app, web dashboard and real-time backend. Serious, autonomous work with great communication, delivered and published on both stores. I highly recommend him for any mobile or full-stack project.",
    ),
  ];
}
