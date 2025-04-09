class AppAssets {
  AppAssets._();

  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';

  static const String welcomeBackground = '$_imagePath/welcome_bg.jpg';
  static const String propertyPlaceholder = '$_imagePath/property_placeholder.jpg';
  
  static const String networkWelcomeBackground = 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1770&auto=format&fit=crop';
  static const String networkPropertyPlaceholder = 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?q=80&w=1770&auto=format&fit=crop';
  
  static const List<String> samplePropertyImages = [
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
  ];
  
  static const String rentIcon = '$_iconPath/chair.svg';
  static const String buyIcon = '$_iconPath/calculator.svg';
  static const String sellIcon = '$_iconPath/tag.svg';
  static const String locationIcon = '$_iconPath/location.svg';
  static const String bedIcon = '$_iconPath/bed.svg';
  static const String bathroomIcon = '$_iconPath/bathroom.svg';
  
  static String getRandomPropertyImage() {
    final random = DateTime.now().millisecondsSinceEpoch % samplePropertyImages.length;
    return samplePropertyImages[random];
  }
  
  static String getOptimizedPropertyImage(String id, {int width = 800, int height = 600}) {
    return '$id?q=80&w=$width&h=$height&auto=format&fit=crop';
  }
}