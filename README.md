# cally_app

A Flutter application for managing and making automated calls using uploaded calling lists.

**Assignment by Yash Karnik**

## Features

- **User Authentication**: Register, login, and OTP verification via email.
- **Onboarding**: Welcome screen with YouTube video instructions and user profile.
- **Dashboard**: View call statistics, interactive pie chart, and quick access to calling features.
- **Calling Lists**: Upload and manage calling lists from the Calley Web Panel.
- **Pie Chart Visualization**: Interactive chart showing Pending, Schedule, and Total calls with animated selection.
- **Side Menu**: Access to app info, settings, help, and logout.
- **Bottom Navigation**: Quick navigation between main app sections.
- **Responsive UI**: Clean, modern design with support for different screen sizes.
- **Logout & Session Management**: Securely log out and clear user data.

## How It Works

1. **Register & Login**  
   - New users register with name, email, password, and mobile number.
   - OTP is sent to the registered email for verification.
   - After verification, users are onboarded into the app.

2. **Onboarding**  
   - Users are greeted with a profile card and a YouTube video explaining how to use the app.
   - Instructions are provided to upload calling lists via the Calley Web Panel.

3. **Dashboard**  
   - Displays a summary of call statistics (Pending, Done, Schedule).
   - Interactive pie chart visualizes call statuses.
   - Users can start calling directly from the dashboard.

4. **Calling Lists**  
   - Users can view and select from available calling lists.
   - Lists are managed and uploaded via the web panel.

5. **Side Menu**  
   - Access app features like Getting Started, Sync Data, Gamification, Send Logs, Settings, Help, Cancel Subscription, About Us, Privacy Policy, Version, Share App, and Logout.

## Getting Started

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Add your assets (icons, images) as referenced in the code.
4. Run the app using `flutter run`.

For more details, see the [Flutter documentation](https://docs.flutter.dev/).

---
