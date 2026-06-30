import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medbh_portfolio/models/project_model.dart';
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
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "Weefarm",
      description:
          "Digital Farming Application (Freelance, 2026). Cross-platform mobile app for smart agriculture management.",
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
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "HLPro Mobile",
      description:
          "AI-based optical fiber patchcord testing system using Deep Learning.",
      appIcon: "assets/projects/hlpro_mobile/icon.png",
      screenshots: [
        "assets/projects/hlpro_mobile/screenshots/image1.jpg",
        "assets/projects/hlpro_mobile/screenshots/image2.jpg",
      ],
      technologies: ["Flutter", "Python", "TensorFlow", "Raspberry Pi"],
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
        "assets/projects/kalonet/screenshots/image4.png",
      ],
      technologies: ["Flutter", "GetX", "Clean Arch", "WidgetKit"],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "SNTAT",
      description:
          "Entertainment application with group voice chat and real-time features.",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=my.game.sntat",
      appIcon: "assets/projects/sntat/icon.png",
      screenshots: [
        "assets/projects/sntat/screenshots/image1.png",
        "assets/projects/sntat/screenshots/image2.png",
        "assets/projects/sntat/screenshots/image3.png",
      ],
      technologies: ["iOS", "SwiftUI", "Agora", "ZegoCloud", "Combine"],
      projectType: ProjectType.mobile,
    ),
    ProjectModel(
      name: "ASWAN",
      description: "Online commerce and wholesale app.",
      appStoreUrl: "https://apps.apple.com/us/app/aswan-/id6741357149",
      appIcon: "assets/projects/aswan/icon.png",
      screenshots: [
        "assets/projects/aswan/screenshots/image1.png",
        "assets/projects/aswan/screenshots/image2.png",
        "assets/projects/aswan/screenshots/image3.png",
      ],
      technologies: ["iOS", "SwiftUI", "CoreData", "Combine"],
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
      projectType: ProjectType.webDesktop,
    ),
    ProjectModel(
      name: "Notary System",
      description:
          "Desktop Notary System (Freelance, 2026). Windows desktop application to track and manage notary operations in Tunisia.",
      screenshots: [
        "assets/projects/notary_system/screenshots/image1.png",
        "assets/projects/notary_system/screenshots/image2.png",
        "assets/projects/notary_system/screenshots/image3.png",
      ],
      technologies: ["Flutter", "Windows Desktop", "QR Code"],
      projectType: ProjectType.webDesktop,
    ),
    ProjectModel(
      name: "Visitor Management",
      description:
          "Desktop Visitor Management Solution (Freelance, 2026). Windows app to control company visits & appointments, generate daily reports with professional scanner support.",
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
      projectType: ProjectType.webDesktop,
    ),
  ];

  static List<ProjectModel> get projects => [
        ...mobileProjects,
        ...webDesktopProjects,
      ];
}
