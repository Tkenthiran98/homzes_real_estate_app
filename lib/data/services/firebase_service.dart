import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirebaseService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Auth methods
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Firestore helper methods
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  // Firebase Storage helper methods
  Reference storageRef(String path) {
    return _storage.ref().child(path);
  }

  // Sample properties data population method
  Future<void> populateSampleProperties() async {
    // Check if properties collection is empty
    final propertiesSnapshot = await _firestore.collection('properties').get();
    
    if (propertiesSnapshot.docs.isNotEmpty) {
      print('Properties collection already populated');
      return;
    }
    
    print('Populating properties collection with sample data');
    
    // Sample properties data
    final List<Map<String, dynamic>> sampleProperties = [
      {
        'title': 'Modern Apartment',
        'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        'location': 'Moscow, Russia',
        'price': 1250,
        'number_of_beds': 3,
        'number_of_bathrooms': 2,
        'type': 'apartment',
        'rooms': 4,
        'rating': 4.9,
        'reviews': 29,
        'featured': true,
        'created_at': FieldValue.serverTimestamp(),
        'views': 145,
      },
      {
        'title': 'Luxury Villa',
        'image': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
        'location': 'Moscow, Russia',
        'price': 1430,
        'number_of_beds': 2,
        'number_of_bathrooms': 2,
        'type': 'apartment',
        'rooms': 3,
        'rating': 4.7,
        'reviews': 18,
        'featured': true,
        'created_at': FieldValue.serverTimestamp(),
        'views': 120,
      },
      {
        'title': 'Cozy Cottage',
        'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
        'location': 'Saint Petersburg, Russia',
        'price': 750,
        'number_of_beds': 1,
        'number_of_bathrooms': 1,
        'type': 'apartment',
        'rooms': 4,
        'rating': 4.5,
        'reviews': 12,
        'featured': true,
        'created_at': FieldValue.serverTimestamp(),
        'views': 95,
      },
      {
        'title': 'Urban Loft',
        'image': 'https://images.unsplash.com/photo-1493809842364-78817add7ffb',
        'location': 'Moscow, Russia',
        'price': 980,
        'number_of_beds': 2,
        'number_of_bathrooms': 1,
        'type': 'rent',
        'rooms': 2,
        'rating': 4.3,
        'reviews': 8,
        'featured': false,
        'created_at': FieldValue.serverTimestamp(),
        'views': 78,
      },
      {
        'title': 'Seaside Villa',
        'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
        'location': 'Sochi, Russia',
        'price': 1800,
        'number_of_beds': 4,
        'number_of_bathrooms': 3,
        'type': 'rent',
        'rooms': 6,
        'rating': 4.8,
        'reviews': 35,
        'featured': false,
        'created_at': FieldValue.serverTimestamp(),
        'views': 210,
      },
      {
        'title': 'Mountain Retreat',
        'image': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c',
        'location': 'Krasnaya Polyana, Russia',
        'price': 1350,
        'number_of_beds': 3,
        'number_of_bathrooms': 2,
        'type': 'rent',
        'rooms': 5,
        'rating': 4.6,
        'reviews': 22,
        'featured': false,
        'created_at': FieldValue.serverTimestamp(),
        'views': 165,
      },
    ];

    // Add sample properties to Firestore
    final batch = _firestore.batch();
    
    for (final property in sampleProperties) {
      final docRef = _firestore.collection('properties').doc();
      batch.set(docRef, property);
    }
    
    await batch.commit();
    print('Sample properties added successfully');
  }
}