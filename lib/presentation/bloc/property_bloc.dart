import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/property_model.dart';
import '../../data/repositories/property_repository.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

class LoadFeaturedProperties extends PropertyEvent {}

class LoadNewOffers extends PropertyEvent {}

class LoadPopularRentOffers extends PropertyEvent {}

class ToggleFavorite extends PropertyEvent {
  final PropertyModel property;

  const ToggleFavorite(this.property);

  @override
  List<Object> get props => [property];
}

abstract class PropertyState extends Equatable {
  const PropertyState();
  
  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {
  final String type;
  
  const PropertyLoading(this.type);
  
  @override
  List<Object> get props => [type];
}

class FeaturedPropertiesLoaded extends PropertyState {
  final List<PropertyModel> properties;

  const FeaturedPropertiesLoaded(this.properties);

  @override
  List<Object> get props => [properties];
}

class NewOffersLoaded extends PropertyState {
  final List<PropertyModel> properties;

  const NewOffersLoaded(this.properties);

  @override
  List<Object> get props => [properties];
}

class PopularRentOffersLoaded extends PropertyState {
  final List<PropertyModel> properties;

  const PopularRentOffersLoaded(this.properties);

  @override
  List<Object> get props => [properties];
}

class PropertyError extends PropertyState {
  final String message;
  final String type;

  const PropertyError(this.message, this.type);

  @override
  List<Object> get props => [message, type];
}

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository _propertyRepository;
  
  List<PropertyModel> _featuredProperties = [];
  List<PropertyModel> _newOffers = [];
  List<PropertyModel> _popularRentOffers = [];
  
  PropertyBloc({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository,
        super(PropertyInitial()) {
    on<LoadFeaturedProperties>(_onLoadFeaturedProperties);
    on<LoadNewOffers>(_onLoadNewOffers);
    on<LoadPopularRentOffers>(_onLoadPopularRentOffers);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFeaturedProperties(
    LoadFeaturedProperties event,
    Emitter<PropertyState> emit,
  ) async {
    if (_featuredProperties.isEmpty) {
      emit(const PropertyLoading('featured'));
    }
    
    try {
      final properties = await _propertyRepository.getFeaturedPropertiesOnce();
      
      if (properties.isNotEmpty) {
        _featuredProperties = properties;
        emit(FeaturedPropertiesLoaded(properties));
      } else {
        emit(const PropertyError('No featured properties found', 'featured'));
      }
    } catch (e, stackTrace) {
      debugPrint("Error loading featured properties: $e");
      debugPrint("Stacktrace: $stackTrace");
      
      if (_featuredProperties.isNotEmpty) {
        emit(FeaturedPropertiesLoaded(_featuredProperties));
      } else {
        emit(PropertyError('Failed to load featured properties: $e', 'featured'));
      }
    }
  }

  Future<void> _onLoadNewOffers(
    LoadNewOffers event,
    Emitter<PropertyState> emit,
  ) async {
    if (_newOffers.isEmpty) {
      emit(const PropertyLoading('newOffers'));
    }
    
    try {
      final properties = await _propertyRepository.getNewOffersOnce();
      
      if (properties.isNotEmpty) {
        _newOffers = properties;
        emit(NewOffersLoaded(properties));
      } else {
        emit(const PropertyError('No new offers found', 'newOffers'));
      }
    } catch (e, stackTrace) {
      debugPrint("Error loading new offers: $e");
      debugPrint("Stacktrace: $stackTrace");
      
      if (_newOffers.isNotEmpty) {
        emit(NewOffersLoaded(_newOffers));
      } else {
        emit(PropertyError('Failed to load new offers: $e', 'newOffers'));
      }
    }
  }

  Future<void> _onLoadPopularRentOffers(
    LoadPopularRentOffers event,
    Emitter<PropertyState> emit,
  ) async {
    if (_popularRentOffers.isEmpty) {
      emit(const PropertyLoading('popularRent'));
    }
    
    try {
      final properties = await _propertiesFromStream(
        _propertyRepository.getPopularRentOffers(),
      );
      
      debugPrint('Popular Rent Offers - Fetched properties: ${properties.length}');
      
      if (properties.isNotEmpty) {
        _popularRentOffers = properties;
        emit(PopularRentOffersLoaded(properties));
      } else {
        debugPrint('No popular rent offers found');
        emit(const PropertyError('No popular rent offers found', 'popularRent'));
      }
    } catch (e, stackTrace) {
      debugPrint("Error loading popular rent offers: $e");
      debugPrint("Stacktrace: $stackTrace");
      
      if (_popularRentOffers.isNotEmpty) {
        emit(PopularRentOffersLoaded(_popularRentOffers));
      } else {
        emit(PropertyError('Failed to load popular rent offers: $e', 'popularRent'));
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      final updatedProperty = event.property.copyWith(
        isFavorite: !event.property.isFavorite,
      );
      
      _updatePropertyInCaches(updatedProperty);
      
      await _propertyRepository.updateProperty(updatedProperty);
      
      _reemitCurrentState(emit);
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  void _updatePropertyInCaches(PropertyModel updatedProperty) {
    _featuredProperties = _featuredProperties.map((property) {
      return property.id == updatedProperty.id ? updatedProperty : property;
    }).toList();
    
    _newOffers = _newOffers.map((property) {
      return property.id == updatedProperty.id ? updatedProperty : property;
    }).toList();
    
    _popularRentOffers = _popularRentOffers.map((property) {
      return property.id == updatedProperty.id ? updatedProperty : property;
    }).toList();
  }
  
  void _reemitCurrentState(Emitter<PropertyState> emit) {
    final currentState = state;
    
    if (currentState is FeaturedPropertiesLoaded) {
      emit(FeaturedPropertiesLoaded(_featuredProperties));
    } else if (currentState is NewOffersLoaded) {
      emit(NewOffersLoaded(_newOffers));
    } else if (currentState is PopularRentOffersLoaded) {
      emit(PopularRentOffersLoaded(_popularRentOffers));
    }
  }
  
  Future<List<PropertyModel>> _propertiesFromStream(
    Stream<List<PropertyModel>> stream,
  ) async {
    final completer = Completer<List<PropertyModel>>();
    
    final subscription = stream.listen(
      (properties) {
        if (!completer.isCompleted) {
          completer.complete(properties);
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );
    
    try {
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => <PropertyModel>[],
      );
    } finally {
      subscription.cancel();
    }
  }
}