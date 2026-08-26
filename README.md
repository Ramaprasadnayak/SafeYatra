# SafeYatra 

**AI-Based Smart Tourist Safety Monitoring and Tracking System**

SafeYatra is a cross-platform mobile application built with Flutter that helps tourists travel more safely across India. It combines real-time GPS tracking, AI-driven risk classification, geofencing, an emergency alert system, and multilingual communication into a single safety-first travel companion — going beyond the booking-and-itinerary focus of typical travel apps.

## Overview

Tourists often face safety risks — harassment, scams, unfamiliar or unsafe locations, and poor connectivity during emergencies. Existing travel apps rarely offer real-time location tracking, risk alerts, or emergency response support.

SafeYatra addresses this gap with an integrated system that uses **district-level historical crime data (NCRB)**, a **Random Forest risk classifier**, and **geofencing** to give tourists proactive, real-time safety guidance — while providing authorities with a live dashboard for monitoring and incident response.

## Key Features

-  **Real-Time GPS Tracking** — continuous location monitoring with live updates.
-  **AI-Based Risk Classification** — districts are classified as **Safe / Moderate / High Risk** using a Random Forest model trained on aggregated NCRB (National Crime Records Bureau) crime statistics.
-  **Safety Heatmap** — Kernel Density Estimation (KDE) over crime rates visualizes risk intensity across regions (Green / Yellow / Red).
-  **Geofencing & Restricted Zone Alerts** — automatic warnings when a tourist enters unsafe, restricted, or hazardous zones (military areas, flood-prone zones, construction sites, etc.).
-  **Anomaly Detection** — an LSTM model flags abnormal movement patterns for early risk detection.
-  **Emergency Alert System** — one-tap SOS captures GPS location, timestamp, and emergency type, then notifies emergency contacts via Firebase Cloud Messaging with an SMS gateway fallback for low-connectivity areas.
-  **Incident Reporting** — tourists can report theft, harassment, scams, medical emergencies, or accidents with GPS coordinates, description, and photos; reports are admin-verified.
-  **Real-Time Language Translation** — text and voice translation between English, Hindi, and regional languages (Kannada, Tamil, Telugu, Malayalam, Marathi, Bengali, and more), with Text-to-Speech support.
-  **Adaptive Safety Recommendations** — personalized route and destination suggestions based on location, behavior, weather, and crime data, favoring patrolled and well-lit areas.
-  **Authority Dashboard** — live tourist map, heatmaps, and incident visualization for monitoring and faster emergency response.

## How It Works

1. The app captures the tourist's **GPS location** and reverse-geocodes it to a state/district.
2. The district is matched against a **preprocessed NCRB crime profile** (violent crime, crimes against women, property crime, fraud/cybercrime, kidnapping).
3. A **Random Forest classifier** (trained with leakage-avoidance safeguards, using percentile-rank crime terciles as the target) predicts the area's safety level.
4. Results are shown as a **color-coded heatmap** and factored into **route/destination recommendations**.
5. If the tourist enters a restricted zone or triggers an SOS, the app sends **real-time alerts** to emergency contacts and (in future scope) nearby authorities.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend / Mobile App | **Flutter** (Android & iOS) |
| Backend / API | **FastAPI** (Python) |
| Database | **MongoDB** |
| Machine Learning | **Random Forest** classifier (risk prediction) |
| Maps & Geocoding | Google Maps API / Google Geocoding API |
| Emergency Messaging | Firebase Cloud Messaging + SMS Gateway fallback |
| Data Source | NCRB district-wise IPC crime statistics (via India Data Portal) |

## System Architecture

```
Flutter App  ──►  FastAPI Backend  ──►  Random Forest Model (risk prediction)
     │                   │
     │                   └──►  MongoDB (crime profiles, incident reports, contacts)
     │
     ├──►  Google Maps / Geocoding API (location & heatmap rendering)
     └──►  Firebase Cloud Messaging + SMS Gateway (emergency alerts)
```

The Flutter app stays a lightweight client — it sends the user's GPS-resolved district to the FastAPI backend, which returns the predicted safety level, and it renders maps, heatmaps, alerts, and translations locally.

## Project Structure

```
├── android/          # Android platform code
├── ios/               # iOS platform code
├── linux/             # Linux desktop platform code
├── macos/             # macOS platform code
├── windows/           # Windows desktop platform code
├── web/               # Web platform code
├── lib/               # Main Flutter/Dart application source
├── test/              # Unit and widget tests
├── pubspec.yaml        # Flutter project dependencies
└── analysis_options.yaml
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for mobile builds
- A configured Firebase project (for Cloud Messaging) and a Google Maps API key

### Installation

```bash
# Clone the repository
git clone https://github.com/Ramaprasadnayak/SafeYatra.git
cd SafeYatra

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

Add your API keys and backend endpoint before running:

- Google Maps API key — Android: `android/app/src/main/AndroidManifest.xml`, iOS: `ios/Runner/AppDelegate.swift`
- Firebase config — `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
- Backend base URL — update the API service file in `lib/`

## Roadmap

- Integration with nearby-authority notification systems
- Crowd-sourced, verified incident reports as a complementary real-time signal
- Broader multilingual and multi-region deployment
- Expanded scalability and integration with national safety networks

## Authors

- Ramaprasad Nayak
- Ryan Savio Sequeira
- Prem Sagar Phulsay
- Pratheek 

## Institution

Department of CSE – Artificial Intelligence and Machine Learning
Mangalore Institute of Technology & Engineering, Moodbidri, Mangalore, India
