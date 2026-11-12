import '../constants/app_strings.dart';

/// One ready answer. A question matches when it contains any [keywords]
/// (lowercase, accents ignored); the entry with the most matching keywords wins.
class QA {
  final List<String> keywords;
  final String answer;
  const QA(this.keywords, this.answer);
}

/// Answers written from the CV and portfolio. Edit freely: no code changes needed.
class KnowledgeBase {
  static const greeting =
      "Hi! 👋 I'm Mohamed's assistant. Ask me about his experience, skills or projects, "
      "or pick a question below.";

  static const suggestions = [
    'How many years of experience?',
    'Do you work with VoIP SDKs?',
    'Any fintech / banking projects?',
    'What is your tech stack?',
    'Which apps are published?',
    'Are you available for work?',
    'How can I contact you?',
  ];

  static final fallback =
      "I don't have a ready answer for that yet. You can ask about experience, iOS, Flutter, "
      "VoIP, banking, security, projects or availability, or write to Mohamed directly at "
      "${AppStrings.email}.";

  static final entries = <QA>[
    const QA(
      ['experience', 'years', 'how long', 'seniority', 'senior', 'xp'],
      "Mohamed has **5+ years** of professional mobile development experience: iOS developer at "
      "One Tech Business Solutions (2024 – present), iOS developer at Phylia Technology (2022 – 2024), "
      "and mobile developer at Ilef Info Services (2021 – 2022), plus several freelance projects.",
    ),
    const QA(
      [
        'voip',
        'voice',
        'call',
        'agora',
        'zego',
        'zegocloud',
        'webrtc',
        'real-time',
        'realtime',
        'chat room',
        'chatroom',
      ],
      "Yes. On SNTAT (5M+ users) he built group voice chat rooms with VoIP and real-time SDKs "
      "(Agora, ZegoCloud, CometChat), plus a real-time multiplayer games module.",
    ),
    const QA(
      [
        'fintech',
        'bank',
        'banking',
        'finance',
        'payment',
        'backbase',
        'libyan',
        'digital lib',
      ],
      "Yes. He works on **two large banking apps** for Libyan Islamic Bank, built on the Backbase SDK: "
      "**Digital LIB** (retail banking) and **LIB Corporate** (business banking), both high-traffic, "
      "security-critical apps on the App Store. He's a certified BackBase iOS Developer (2024).",
    ),
    const QA(
      [
        'security',
        'secure',
        'jailbreak',
        'root',
        'obfuscation',
        'ssl',
        'pinning',
        'encryption',
        'anti',
      ],
      "Security is a big part of his banking work: jailbreak/root detection, anti-hooking and anti-debug "
      "protections, tamper resistance, SSL pinning and code obfuscation. On SNTAT he also wrote a native C "
      "library for low-level API encryption.",
    ),
    const QA(
      [
        'traffic',
        'scale',
        'scalable',
        'users',
        'million',
        'performance',
        'concurrency',
        'memory',
        'gcd',
      ],
      "He has built for high traffic: SNTAT serves **5M+ users** with live voice rooms, a social feed and "
      "games, optimised with GCD concurrency and careful memory management. The banking apps handle "
      "high-traffic, critical financial operations.",
    ),
    const QA(
      ['stack', 'skills', 'technologies', 'tech', 'languages', 'tools'],
      "Main stack: **iOS (Swift, SwiftUI, UIKit, Combine)** and **Flutter (Dart)**. Also React Native, "
      "Express.js/TypeScript, MongoDB, Firebase, CoreData, Backbase. Architectures: MVVM, VIP, Clean "
      "Architecture. CI/CD: GitHub Actions, Fastlane. Testing: XCTest, XCUITest, SwiftLint, SonarQube.",
    ),
    const QA(
      ['ios', 'swift', 'swiftui', 'uikit', 'combine', 'iphone', 'apple'],
      "iOS is his core: Swift, SwiftUI, UIKit and Combine, with MVVM, VIP and Clean Architecture, "
      "published on the App Store (Digital LIB, LIB Corporate, Aswan, Seekers).",
    ),
    const QA(
      ['flutter', 'dart', 'cross-platform', 'cross platform', 'android'],
      "Yes, Flutter too: Weefarm, Stocky, MyLudo, Shada LED Light, Ilef Info, plus Windows desktop apps "
      "(Visitor Management, Notarial Chamber Registry) and the Seekers web dashboard.",
    ),
    const QA(
      ['react native', 'react', 'expo', 'javascript', 'typescript'],
      "Yes, he built the Seekers outdoor-adventure app in React Native (Expo) with an Express.js/TypeScript "
      "and MongoDB backend, published on both stores.",
    ),
    const QA(
      [
        'backend',
        'node',
        'express',
        'api',
        'mongodb',
        'server',
        'full stack',
        'fullstack',
        'docker',
      ],
      "He also does backend work: Express.js/TypeScript APIs, MongoDB, Socket.IO, JWT auth, Cloudinary "
      "and Docker deployments (Seekers, Weefarm).",
    ),
    const QA(
      [
        'project',
        'projects',
        'portfolio',
        'apps',
        'published',
        'store',
        'app store',
        'play store',
      ],
      "Published apps include **Digital LIB** and **LIB Corporate** (banking), **SNTAT** (social, 5M+ users), "
      "**Seekers** (outdoor adventure), **Weefarm** (smart farming), **Aswan** (e-commerce) and "
      "**Ilef Info**. Scroll to the Projects section to see them all.",
    ),
    const QA(
      [
        'ai',
        'machine learning',
        'deep learning',
        'tensorflow',
        'model',
        'llm',
        'claude',
        'mcp',
      ],
      "Yes. HLPro is an AI optical-fiber testing system (CNN, DCGAN, TensorFlow Lite on Raspberry Pi), "
      "and he uses Claude Code and MCP (Jira, Figma) daily to speed up development.",
    ),
    const QA(
      [
        'iot',
        'embedded',
        'arduino',
        'raspberry',
        'bluetooth',
        'ble',
        'hardware',
      ],
      "He has a Master's in Embedded Systems and builds hardware-connected apps: Shada LED Light "
      "(reverse-engineered BLE bulb protocol), HLPro on Raspberry Pi, and Arduino/ESP32 projects.",
    ),
    const QA(
      [
        'test',
        'testing',
        'quality',
        'ci',
        'cd',
        'fastlane',
        'github actions',
        'sonar',
      ],
      "Quality matters: XCTest/XCUITest, SwiftLint, SonarQube, code reviews, accessibility (VoiceOver, "
      "Dynamic Type), and CI/CD with GitHub Actions, Fastlane, AppCenter and Firebase App Distribution.",
    ),
    const QA(
      [
        'education',
        'degree',
        'master',
        'study',
        'university',
        'certification',
        'certificate',
        'scrum',
      ],
      "Professional Master's in Embedded Systems (2021–2023) and Bachelor's in Embedded Systems & Mobile "
      "(2014–2017). Certified BackBase iOS Developer (2024) and Scrum Fundamentals Certified (2022).",
    ),
    const QA(
      [
        'available',
        'availability',
        'hire',
        'freelance',
        'job',
        'open to',
        'remote',
        'relocate',
        'work with',
      ],
      "Mohamed is open to full-time iOS / mobile roles and freelance projects. The fastest way is the "
      "contact form below or ${AppStrings.email}.",
    ),
    const QA(
      ['contact', 'email', 'reach', 'phone', 'linkedin', 'message'],
      "Email: ${AppStrings.email} · LinkedIn: linkedin.com/in/mohamedbnhmida · GitHub: github.com/mohamedbnhmida. "
      "Or use the contact form at the bottom of the page.",
    ),
    const QA(
      [
        'architecture',
        'mvvm',
        'vip',
        'clean architecture',
        'design pattern',
        'solid',
        'coordinator',
      ],
      "He works with MVVM + Combine, VIP (Backbase journeys) and Clean Architecture, using coordinators and "
      "dependency injection (Resolver) to keep large codebases testable.",
    ),
    const QA(
      [
        'team',
        'teamwork',
        'lead',
        'leadership',
        'collaborat',
        'agile',
        'code review',
        'mentor',
      ],
      "He works in Agile/Scrum teams with PO, BA, UX/UI, QA and solution architects, does code reviews, "
      "and at Phylia he assigned and coordinated tasks within the mobile team.",
    ),
    const QA(
      ['accessibility', 'voiceover', 'dynamic type', 'a11y'],
      "Accessibility is part of his definition of done: VoiceOver, Dynamic Type and Accessibility Inspector "
      "checks on the banking and SNTAT apps.",
    ),
    const QA(
      [
        'desktop',
        'windows',
        'kiosk',
        'visitor',
        'notary',
        'notarial',
        'passport',
        'mrz',
        'nfc',
      ],
      "He built two Windows desktop apps in Flutter for SDP Tunisie: a Visitor Management system "
      "(ID/passport scanning with DESKO and ID BOX readers, MRZ, badges, daily reports) and a Notarial "
      "Chamber Registry (members, dues, NFC badges).",
    ),
    const QA(
      [
        'sntat',
        'social',
        'feed',
        'video',
        'games',
        'roulette',
        'rewards',
        'gifts',
      ],
      "SNTAT is a social & entertainment app with 5M+ users: live voice chat rooms, short videos, a social "
      "feed, games like spin-the-wheel, virtual gifts and a points/rewards economy. Mohamed built it in "
      "SwiftUI with Combine, Agora/ZegoCloud and GCD.",
    ),
    const QA(
      ['seekers', 'outdoor', 'adventure', 'hiking', 'trip'],
      "Seekers is an outdoor adventure platform (freelance, 2026): React Native mobile app, Flutter web "
      "dashboard and Express.js/MongoDB backend, live on the App Store, Google Play and the web.",
    ),
    const QA(
      ['location', 'based', 'where', 'country', 'tunisia'],
      "He's based in Ariana, Tunisia, and works with international teams remotely.",
    ),
    const QA(
      ['name', 'who are you', 'who is', 'about'],
      "This is Mohamed Ben Hmida's portfolio: a senior mobile developer (iOS & Flutter) with 5+ years of "
      "experience in banking, social and real-time apps. I'm his assistant bot.",
    ),
    const QA(['hello', 'hi', 'hey', 'salut', 'bonjour', 'salam'], greeting),
  ];

  static String _normalize(String s) {
    const from = 'àâäéèêëîïôöùûüç';
    const to = 'aaaeeeeiioouuuc';
    var out = s.toLowerCase();
    for (var i = 0; i < from.length; i++) {
      out = out.replaceAll(from[i], to[i]);
    }
    return out;
  }

  /// Best ready answer, or null when nothing matches.
  static String? answer(String question) {
    final q = ' ${_normalize(question)} ';
    QA? best;
    var bestScore = 0;
    for (final e in entries) {
      var score = 0;
      for (final k in e.keywords) {
        // short keywords must be whole words ("hi" should not match "this")
        final hit = k.length <= 3
            ? RegExp('\\b${RegExp.escape(k)}\\b').hasMatch(q)
            : q.contains(k);
        if (hit) score += k.length > 3 ? 2 : 1;
      }
      if (score > bestScore) {
        bestScore = score;
        best = e;
      }
    }
    return best?.answer;
  }
}
