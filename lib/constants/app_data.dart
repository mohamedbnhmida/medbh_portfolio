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
      assetPath: 'assets/firebase.png', // Using PNG as requested
      color: Color(0xFFFFCA28),
      icon: null,
    ),
    TechnologyModel(
      name: "Arduino",
      assetPath: "assets/arduino.png",
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

  static const List<ProjectModel> projects = [
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
    ),
    ProjectModel(
      name: "Ilef Info Mobile",
      description: "Company app for Ilef Info Services built from scratch.",
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=tn.ilefinfo.ilefinfo",
      appIcon: "assets/projects/ilef_info_mobile/icon.png",
      technologies: ["Flutter", "Dart", "Google Maps API"],
    ),
    ProjectModel(
      name: "HLPro Mobile",
      description:
          "AI-based optical fiber patchcord testing system using Deep Learning.",
      appIcon: "assets/projects/hlpro_mobile/icon.png",
      technologies: ["Flutter", "Python", "TensorFlow", "Raspberry Pi"],
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
    ),
    ProjectModel(
      name: "Seekers",
      description: "Outdoor Adventure Planning Application.",
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
      technologies: ["React Native", "Express.js", "MongoDB", "Expo"],
    ),
  ];
}
