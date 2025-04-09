Architecture:

This project follows clean architecture principles and uses the BLoC pattern for state management:

Data Layer: Contains models, repositories, and services  
Domain Layer: Contains business logic and use cases  
Presentation Layer: Contains UI components, screens, and BLoCs  

Technologies Used:

- Flutter: UI framework  
- Bloc: State management  
- Firebase: Backend services  
- Firestore: Database  
- Storage: File storage  
- Cached Network Image: Image caching  

Prerequisites:

- Flutter SDK (3.2.0 <4.0.0)  
- Dart SDK (3.2.0 <4.0.0)  
- Firebase account  

Installation:

Clone the repository:  
https://github.com/Tkenthiran98/homzes_real_estate_app.git 

Install dependencies:  
flutter pub get  

Configure Firebase:

- Create a new Firebase project at Firebase Console  
- Add Android and iOS apps to your Firebase project  
- Download and add the configuration files:  
  - google-services.json for Android  
  - GoogleService-Info.plist for iOS  
- Update the Firebase configuration in lib/firebase_options.dart  

Run the app:  
flutter run  

Firebase Setup:

Firestore Schema:  
Create a collection called "properties" with the following fields:  

- title: String  
- image: String (URL to image)  
- location: String  
- price: Number  
- number_of_beds: Number  
- number_of_bathrooms: Number  
- type: String  
- rooms: Number  
- rating: Number  
- reviews: Number  
- featured: Boolean  
- created_at: Timestamp  
- views: Number  

Project Structure:

lib/  
├── core/  
│   ├── constants/  
│   ├── routes/  
│   └── utils/  
├── data/  
│   ├── models/  
│   ├── repositories/  
│   └── services/  
├── presentation/  
│   ├── bloc/  
│   ├── screens/  
│   └── widgets/  
├── firebase_options.dart  
└── main.dart  

State Management with BLoC:  
This project uses the BLoC pattern for state management with the following components:

- Events: Represent user actions or system events  
- States: Represent different states of the UI  
- BLoC: Business logic component that processes events and emits states  

Acknowledgements:

This project was developed for Vision Ex Digital (https://visionexdigital.com.au/)  
Design inspiration from the provided Figma mockups
