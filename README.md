# FocusNFlow 📚

FocusNFlow is a Flutter + Firebase mobile application designed to help Georgia State students plan, collaborate, and study more effectively.

---

## 🚀 Features

### 🔐 Authentication
- Firebase Authentication (GSU email restriction)
- User profiles stored in Firestore

### 📋 Task Management
- Add, view, delete tasks
- Task prioritization based on:
  - Deadline
  - Effort
  - Course weight

### 📅 Study Planning Engine
- Automatically ranks tasks
- Generates smart study order

### 🏫 Study Room Finder
- Real-time room occupancy
- Firestore transactions (safe multi-user updates)

### 👥 Study Groups
- Create study groups
- View all groups in real-time

### 💬 Group Chat
- Real-time messaging with Firestore
- Messages stored per group

### 📆 Study Session Scheduling
- Create study sessions
- Stored in Firestore subcollections

### ⏱ Shared Pomodoro Timer
- Real-time synchronized timer across users
- Start / Stop / Reset
- Shared study goal tracking

### 🔔 Notifications
- Firebase Cloud Messaging (FCM)
- Device token stored in Firestore

---

## 🛠 Tech Stack

- Flutter (Dart)
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Messaging
- Firebase Storage

---

## 📂 Firestore Structure


users
userId
email
fcmToken

groups
groupId
name
timer
messages (subcollection)
sessions (subcollection)

rooms
roomId
name
occupancy


---

## 📲 How to Run

```bash
flutter clean
flutter pub get
flutter run