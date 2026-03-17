# HelaService — Sri Lankan Home Services Platform

> A **PickMe-style dispatch app** for home services (cleaning, babysitting, elderly care, cooking, laundry) launching in Colombo, Sri Lanka. Built with Flutter + Firebase with strict PDPA compliance and Sri Lankan legal infrastructure baked in from day one.

---

## Architecture

Clean Architecture — Feature-First structure with dual state management:

```
lib/
├── core/
│   ├── constants/        # AppConstants, service zones (Colombo 03/04/07)
│   ├── config/           # GoRouter + theme
│   ├── router/           # app_router.dart (auth guards, redirects)
│   ├── services/         # LocationService (battery-optimised geohash tracking)
│   ├── extensions/       # BuildContext helpers (navigation, incident reporting)
│   └── utils/            # NICValidator, PhoneValidator, AuditLogger, SLValidators
├── features/
│   ├── auth/             # PhoneAuthPage + AuthBloc (Firebase phone OTP)
│   ├── worker/
│   │   ├── domain/       # Worker entity, WorkerApplication, WorkerRepository interface
│   │   ├── data/         # WorkerRepositoryImpl (Firestore + Storage)
│   │   └── presentation/ # Full onboarding BLoC + pages (NIC → Skills → Docs → Pending)
│   ├── customer/         # Zone checker, service selection, worker matching, live tracking
│   ├── matching/         # FindNearestWorker use case (PickMe scoring algorithm)
│   ├── incident/         # Emergency reporting (WhatsApp + Firestore audit log)
│   ├── admin/            # Admin dashboard (worker approvals, dispatch board, incidents)
│   └── splash/           # SplashPage with smart auth-state routing
├── injection_container.dart  # get_it DI setup
└── main.dart                 # Firebase init + BlocProvider + portrait lock
```

---

## Key Features

### The PickMe Dispatch Algorithm (`FindNearestWorker`)
Scores available online workers using a 3-factor weighted equation:
- **50% — Distance to customer** (closer = higher priority)
- **30% — Idle time** (workers who finished a job most recently get priority — fair rotation)
- **20% — Home-base proximity** (avoids stranding Moratuwa workers in Kotte overnight)

Top 3 workers are broadcast simultaneously. First to accept wins — others are auto-cancelled after 30 seconds. Implemented both client-side (Dart) and server-side (Cloud Functions TypeScript).

### Sri Lanka-Specific Controls
- **NIC Validation** — both old format (`853202937V`) and new 12-digit format (`199832029372`), with age verification
- **Geofencing** — Workers must be inside Colombo 03/04, Colombo 07, or Rajagiriya to go online
- **Phone** — `07XXXXXXXX` local format validation + Firebase Phone OTP auth
- **Cash payments** — v1 defaults `isCashPayment: true` (digital payments phase 2)

### PDPA Compliance (Personal Data Protection Act)
- Worker `homeLocation` and `bankDetails` hidden from customers via Firestore Rules
- Address stored as `houseNumber` + `landmark` only (not full GPS until dispatch)
- Live location streaming stops automatically upon job completion
- Chat messages enforced with `createdAt` timestamp for 30-day GCP TTL auto-deletion
- Medical data storage blocked (`allowMedicalDataStorage: false`)

### Legal Infrastructure
- **Independent Contractor Agreement** — digital signature gate before first job (`ContractAcceptancePage`)
- **Audit Trail** — `AuditLogger` writes immutable GPS check-ins, payouts, and incidents to `/audit_logs` (Firestore Rules: `allow update, delete: if false`)
- **Emergency Reporting** — one-tap WhatsApp deep-link to operator + Firestore incident log

---

## Worker Onboarding Flow

```
SplashPage → PhoneAuthPage (OTP) → NICInputPage → ServiceSelectionPage
    → DocumentUploadPage (NIC front/back + selfie) → VerificationPendingPage
    → [Admin approves] → ContractAcceptancePage → OnlineTogglePage (Go Online)
    → JobOfferPage (30s countdown modal) → ActiveJobPage (Check-in → Work → Complete)
```

---

## Firebase Setup

### Prerequisites
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
```

### Initialize (one-time)
```bash
cd home_service_app
flutterfire configure    # Generates firebase_options.dart for Android + iOS
```

### Deploy Security Rules
```bash
firebase deploy --only firestore:rules,storage
```

### Deploy Cloud Functions
```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

---

## Running Locally

```bash
flutter pub get
flutter run -d chrome        # Web (instant — no emulator needed)
flutter run -d ios           # iOS Simulator
flutter run -d android       # Android Emulator
```

> **Note:** The app runs in **mock mode** until `flutterfire configure` is executed. All repositories use simulated `Future.delayed` responses. To go live, uncomment the Firestore queries in `worker_repository_interface.dart`.

---

## Security Rules Summary

| Collection | Customer | Worker (own) | Worker (other) | Admin |
|---|---|---|---|---|
| `worker_profiles` | Read active only | Read/Write | ❌ | ✅ |
| `worker_profiles/private_data` | ❌ | Read/Write | ❌ | ✅ |
| `bookings` | Own only | Assigned only | ❌ | ✅ |
| `job_locations` | Own job only | During active job | ❌ | ✅ |
| `audit_logs` | ❌ | ❌ | ❌ | Read only |
| `messages` | Own | Own | ❌ | ✅ |

**Storage:** NIC documents are worker-private. Profile photos are publicly readable. All uploads capped at 5MB.

---

## Service Zones (v1 Launch)

| Zone ID | Area | Radius | Services |
|---|---|---|---|
| `col_03_04` | Kollupitiya–Bambalapitiya | 2.5 km | Cleaning, Babysitting, Elderly Care |
| `col_07` | Cinnamon Gardens | 3.0 km | Cleaning, Babysitting, Elderly Care, Cooking |
| `rajagiriya` | Rajagiriya–Nawala | 2.0 km | Cleaning, Cooking |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| State | `flutter_bloc` + `provider` |
| Backend | Firebase (Auth, Firestore, Storage, Functions, Messaging) |
| Routing | `go_router` |
| Maps | `google_maps_flutter` + `geolocator` |
| DI | `get_it` |
| Functions | TypeScript (Node 18) |
| Legal | PDPA compliance, IC Agreement, Audit Trail |

---

## Pre-Launch Checklist

- [ ] Run `flutterfire configure` → uncomment `DefaultFirebaseOptions` in `main.dart`
- [ ] Replace `operatorWhatsApp` in `AppConstants` with real number
- [ ] Replace `companySolePropName` with registered business name
- [ ] Add `NotoSansSinhala` font files to `assets/fonts/`
- [ ] Create `assets/images/` directory
- [ ] Set Admin custom claims via Firebase Admin SDK (`admin: true`)
- [ ] Register Google Maps API key in `AndroidManifest.xml` and `AppDelegate.swift`
- [ ] Set up Notify.lk (or similar) for SMS fallback in Cloud Functions
- [ ] Configure Firebase App Check for production
- [ ] Legal review of the Independent Contractor Agreement template
