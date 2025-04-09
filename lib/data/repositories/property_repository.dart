import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/property_model.dart';

class PropertyRepository {
  final FirebaseFirestore _firestore;
  
  PropertyRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _propertiesCollection => 
      _firestore.collection('properties');
  
  // Get all properties
  Stream<List<PropertyModel>> getAllProperties() {
    debugPrint("Getting all properties");
    return _propertiesCollection
        .snapshots()
        .map((snapshot) {
          debugPrint("All properties snapshot received: ${snapshot.docs.length} docs");
          return snapshot.docs
              .map((doc) => PropertyModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // Get featured properties
  Stream<List<PropertyModel>> getFeaturedProperties() {
    debugPrint("Querying for featured properties");
    return _propertiesCollection
        .where('featured', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          debugPrint("Featured properties snapshot received: ${snapshot.docs.length} docs");
          if (snapshot.docs.isEmpty) {
            debugPrint("No featured properties found");
            // Try to get all properties to check if any exist
            _firestore.collection('properties').get().then((allSnapshot) {
              debugPrint("Total properties in collection: ${allSnapshot.docs.length}");
              if (allSnapshot.docs.isNotEmpty) {
                debugPrint("Sample property data: ${allSnapshot.docs.first.data()}");
              }
            });
          } else {
            for (var doc in snapshot.docs) {
              debugPrint("Featured property found: ${doc.id}");
              final data = doc.data() as Map<String, dynamic>;
              debugPrint("Data: $data");
            }
          }
          return snapshot.docs
              .map((doc) => PropertyModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // Get featured properties directly (one-time fetch)
  Future<List<PropertyModel>> getFeaturedPropertiesOnce() async {
    try {
      debugPrint("Fetching featured properties directly");
      
      // Try to get a property where featured is true (boolean)
      final boolQuerySnapshot = await _propertiesCollection
          .where('featured', isEqualTo: true)
          .get();
      
      debugPrint("Boolean query found: ${boolQuerySnapshot.docs.length} featured properties");
      
      if (boolQuerySnapshot.docs.isNotEmpty) {
        return boolQuerySnapshot.docs
            .map((doc) => PropertyModel.fromFirestore(doc))
            .toList();
      }
      
      // If nothing found, try with string 'true'
      final stringQuerySnapshot = await _propertiesCollection
          .where('featured', isEqualTo: 'true')
          .get();
          
      debugPrint("String query found: ${stringQuerySnapshot.docs.length} featured properties");
      
      if (stringQuerySnapshot.docs.isNotEmpty) {
        return stringQuerySnapshot.docs
            .map((doc) => PropertyModel.fromFirestore(doc))
            .toList();
      }
      
      // If nothing found, try with number 1
      final numberQuerySnapshot = await _propertiesCollection
          .where('featured', isEqualTo: 1)
          .get();
          
      debugPrint("Number query found: ${numberQuerySnapshot.docs.length} featured properties");
      
      if (numberQuerySnapshot.docs.isNotEmpty) {
        return numberQuerySnapshot.docs
            .map((doc) => PropertyModel.fromFirestore(doc))
            .toList();
      }
      
      // If we get here, check all properties to debug
      final allPropertiesSnapshot = await _propertiesCollection.get();
      debugPrint("Total properties in collection: ${allPropertiesSnapshot.docs.length}");
      
      if (allPropertiesSnapshot.docs.isNotEmpty) {
        debugPrint("Checking all properties for 'featured' field:");
        for (var doc in allPropertiesSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          debugPrint("Property ${doc.id} - featured: ${data['featured']} (type: ${data['featured'].runtimeType})");
        }
      }
      
      return [];
    } catch (e) {
      debugPrint("Error getting featured properties: $e");
      return [];
    }
  }
  
  // Get new offers
  Stream<List<PropertyModel>> getNewOffers() {
    debugPrint("Getting new offers");
    return _propertiesCollection
        .orderBy('created_at', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          debugPrint("New offers snapshot received: ${snapshot.docs.length} docs");
          return snapshot.docs
              .map((doc) => PropertyModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // Get new offers directly
  Future<List<PropertyModel>> getNewOffersOnce() async {
    try {
      debugPrint("Fetching new offers directly");
      final snapshot = await _propertiesCollection
          .orderBy('created_at', descending: true)
          .limit(5)
          .get();
          
      debugPrint("Found ${snapshot.docs.length} new offers");
      
      return snapshot.docs
          .map((doc) => PropertyModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint("Error getting new offers: $e");
      
      // If the orderBy fails, try without it
      try {
        debugPrint("Trying to get properties without ordering");
        final snapshot = await _propertiesCollection
            .limit(5)
            .get();
            
        debugPrint("Found ${snapshot.docs.length} properties without ordering");
        
        return snapshot.docs
            .map((doc) => PropertyModel.fromFirestore(doc))
            .toList();
      } catch (e2) {
        debugPrint("Error getting properties without ordering: $e2");
        return [];
      }
    }
  }
  
  // Get popular rent offers
  Stream<List<PropertyModel>> getPopularRentOffers() {
    debugPrint("Getting popular rent offers");
    try {
      return _propertiesCollection
          .where('type', isEqualTo: 'rent')
          .orderBy('views', descending: true)
          .limit(10)
          .snapshots()
          .map((snapshot) {
            debugPrint("Popular rent offers snapshot received: ${snapshot.docs.length} docs");
            return snapshot.docs
                .map((doc) => PropertyModel.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      debugPrint("Error setting up popular rent offers stream: $e");
      // Fallback to just getting properties without filtering
      return _propertiesCollection
          .limit(10)
          .snapshots()
          .map((snapshot) {
            debugPrint("Fallback properties snapshot received: ${snapshot.docs.length} docs");
            return snapshot.docs
                .map((doc) => PropertyModel.fromFirestore(doc))
                .toList();
          });
    }
  }
  
  // Add a new property
  Future<void> addProperty(PropertyModel property) {
    return _propertiesCollection.add(property.toMap());
  }
  
  // Update property
  Future<void> updateProperty(PropertyModel property) {
    return _propertiesCollection.doc(property.id).update(property.toMap());
  }
  
  // Delete property
  Future<void> deleteProperty(String id) {
    return _propertiesCollection.doc(id).delete();
  }
}