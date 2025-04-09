import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PropertyModel extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String location;
  final double price;
  final int beds;
  final int bathrooms;
  final bool isFavorite;
  final String type;
  final int rooms;
  final double rating;
  final int reviews;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.beds,
    required this.bathrooms,
    this.isFavorite = false,
    required this.type,
    required this.rooms,
    this.rating = 0.0,
    this.reviews = 0,
  });

  PropertyModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? location,
    double? price,
    int? beds,
    int? bathrooms,
    bool? isFavorite,
    String? type,
    int? rooms,
    double? rating,
    int? reviews,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      price: price ?? this.price,
      beds: beds ?? this.beds,
      bathrooms: bathrooms ?? this.bathrooms,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
      rooms: rooms ?? this.rooms,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
    );
  }

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return PropertyModel(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['image'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] is int) 
          ? (data['price'] as int).toDouble() 
          : data['price'] ?? 0.0,
      beds: data['number_of_beds'] ?? 0,
      bathrooms: data['number_of_bathrooms'] ?? 0,
      type: data['type'] ?? 'apartment',
      rooms: data['rooms'] ?? 0,
      rating: (data['rating'] is int) 
          ? (data['rating'] as int).toDouble() 
          : data['rating'] ?? 0.0,
      reviews: data['reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': imageUrl,
      'location': location,
      'price': price,
      'number_of_beds': beds,
      'number_of_bathrooms': bathrooms,
      'type': type,
      'rooms': rooms,
      'rating': rating,
      'reviews': reviews,
    };
  }

  @override
  List<Object?> get props => [
    id, title, imageUrl, location, price, 
    beds, bathrooms, isFavorite, type, 
    rooms, rating, reviews
  ];
}