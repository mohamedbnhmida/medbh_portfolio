// The assistant's only source of truth. Edit this text to update what the chatbot knows,
// then run `npm run deploy`. Keep it stable between requests: it is prompt-cached.

export const PROFILE = `
# Mohamed Ben Hmida: Senior Mobile Developer (iOS & Flutter)

Based in Ariana, Tunisia. Works with international teams remotely.
Public contact: email mohamed-benhmida@outlook.com · linkedin.com/in/mohamedbnhmida · github.com/mohamedbnhmida · portfolio contact form.
Objective: full-time iOS / senior mobile engineer roles; also open to freelance projects.
Experience: 5+ years of professional mobile development (since 2021).

## Experience
### iOS Developer, One Tech Business Solutions (Jun 2024 – present, Ariana)
Client: Libyan Islamic Bank. Two large, high-traffic, security-critical banking apps on the Backbase SDK.
- LIB Corporate (business banking, App Store): led onboarding (Backbase SDK + ModelBank), customised out-of-the-box journeys, built custom journeys in SwiftUI with Clean Architecture, security hardening (jailbreak/root detection, anti-hooking, anti-debug, tamper resistance, SSL pinning).
- Digital LIB (retail banking, App Store): custom journeys with Clean Architecture, code obfuscation against reverse engineering.
- Both: distribution via AppCenter, Firebase App Distribution, TestFlight and App Store with GitHub Actions and Fastlane; SwiftLint, SonarQube, XCTest/XCUITest, accessibility (VoiceOver, Dynamic Type); Xcode Instruments profiling; production support within SLAs; works with UX/UI, solution architect, PO and BA; uses Claude Code and MCP (Jira, Figma).
- Stack: Swift, UIKit, SwiftUI, VIP, Resolver, Backbase SDK, Firebase SDK.

### iOS Developer, Phylia Technology (Jun 2022 – May 2024, Medenine)
- SNTAT: social & entertainment app with 5M+ users and high real-time traffic. MVVM + Combine; group voice chat rooms with VoIP / real-time SDKs (Agora, ZegoCloud, CometChat); social feed media streaming (compression, format conversion, buffering, caching, preloading; AVFoundation, VLCKit); real-time multiplayer games module; native C library for secure API access with low-level encryption; performance via memory management and GCD concurrency; code reviews, tests, accessibility; assigned and coordinated tasks in the team.
- ASWAN: online commerce & wholesale app (resellers buy at wholesale price and set their own selling price). MVVM + Combine, REST/JSON, CoreData, Crashlytics/Analytics, UIKit inside SwiftUI via Coordinator and UIViewRepresentable, TestFlight.

### Mobile Developer, Ilef Info Services / DB Consulting (Sep 2021 – Jun 2022)
- Designed and built the company app in Flutter from scratch (needs analysis, UML, documentation, animated components, Google Maps), published on Google Play.

## Freelance & personal projects
- Seekers (2026): outdoor adventure platform. React Native (Expo) app on App Store & Google Play, Flutter web dashboard and web app (app.seek-ers.com), Express.js/TypeScript + MongoDB backend, Socket.IO, JWT, Google/Facebook sign-in, Cloudinary, Docker. Full-stack, solo.
- Weefarm (2026, Verdanova Solutions): smart-farming app in Flutter: crop guide, pests & diseases, pesticides and fertilizers, marketplace. Express.js/TypeScript, MongoDB, Socket.IO, Firebase Crashlytics, Docker. Client review: "serious, competent, committed… always able to propose effective solutions while respecting deadlines" (Jasser Ben Saad, CEO, Verdanova Solutions, on Malt).
- Visitor Management (2026, SDP Tunisie): Windows desktop app in Flutter: ID/passport scanning (DESKO, ID BOX, MRZ), badges, appointments, blacklist, automatic daily reports.
- Notarial Chamber Registry (2026, SDP Tunisie): Flutter web/desktop registry for Tunisia's notaries: directory, dues/payments, NFC badges, PDF exports; Firebase.
- Kalonet: gamified nutrition & wellness app (goals, XP, streaks, rankings), Clean Architecture.
- Stocky: offline-first barcode inventory app (Flutter, sqflite, Firestore sync, bin-ticket printing).
- MyLudo: online multiplayer Ludo (Flutter, Firebase Realtime Database, rooms with code/QR).
- Shada LED Light: reverse-engineered a discontinued Bluetooth bulb's protocol and rebuilt its app in Flutter (BLE, background service, scenes, schedules); open source.
- HLPro: AI optical-fiber patchcord quality testing (CNN, DCGAN, VGG16/19, MobileNetV2, TensorFlow Lite on Raspberry Pi) with a Flutter companion app.

## Skills
- Mobile: iOS (Swift, SwiftUI, UIKit, Combine, RxSwift), Flutter (Dart, BLoC, GetX, Provider), React Native.
- Architecture: MVC, MVVM, VIP, Clean Architecture, Coordinator, dependency injection (Resolver).
- Backend: Express.js, TypeScript, MongoDB, Socket.IO, Docker. Databases: CoreData, SQLite, MySQL, MongoDB, Firebase.
- SDKs: Firebase, Backbase, Agora, ZegoCloud, CometChat, Facebook SDK, Google Sign-In (CocoaPods, SPM).
- CI/CD: GitHub Actions, Fastlane, Jenkins, AppCenter. Quality: XCTest, XCUITest, SwiftLint, SonarQube, code reviews.
- Security: jailbreak/root detection, anti-hooking/anti-debug, tamper resistance, SSL pinning, obfuscation, native C encryption.
- Accessibility: VoiceOver, Dynamic Type, Accessibility Inspector. Debugging: Instruments, Crashlytics, LLDB.
- Methods: Agile, Scrum, Kanban. AI tooling: Claude Code, MCP.
- Embedded/IoT background: Arduino, Raspberry Pi, ESP32, Bluetooth LE.

## Education & certifications
- Professional Master's in Embedded Systems, Higher Institute of Computer Science and Multimedia of Gabes (2021 – 2023).
- Bachelor's Degree in Embedded Systems and Mobile, Higher Institute for Technological Studies of Medenine (2014 – 2017).
- BackBase iOS Developer Certificate (Aug 2024). Scrum Fundamentals Certified, SFC (Jan 2022).
`.trim();
