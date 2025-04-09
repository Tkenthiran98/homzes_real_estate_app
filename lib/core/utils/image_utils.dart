import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';

class ImageUtils {
  ImageUtils._();

  static Widget assetImageWithFallback(
    String assetPath, {
    String? fallbackUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return FutureBuilder<bool>(
      future: _assetExists(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          Widget image = Image.asset(
            assetPath,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: color != null ? colorBlendMode : null,
          );
          
          if (borderRadius != null) {
            return ClipRRect(
              borderRadius: borderRadius,
              child: image,
            );
          }
          return image;
        } else if (fallbackUrl != null) {
          return networkImage(
            fallbackUrl,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: colorBlendMode,
            borderRadius: borderRadius,
            placeholder: placeholder,
            errorWidget: errorWidget,
          );
        } else {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: borderRadius,
            ),
            child: errorWidget ?? Icon(Icons.image_not_supported, color: Colors.grey[500]),
          );
        }
      },
    );
  }
  
  static Widget networkImage(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: color != null ? colorBlendMode : null,
      placeholder: (context, url) => placeholder ?? 
        Container(
          color: Colors.grey[300],
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
              ),
            ),
          ),
        ),
      errorWidget: (context, url, error) => errorWidget ?? 
        Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(Icons.broken_image, color: Colors.grey[500]),
          ),
        ),
    );
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }
  
  static Widget welcomeBackground({
    double? width,
    double? height,
    Color? overlayColor,
    Widget? child,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        assetImageWithFallback(
          AppAssets.welcomeBackground,
          fallbackUrl: AppAssets.networkWelcomeBackground,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
        
        if (overlayColor != null)
          Container(
            width: width,
            height: height,
            color: overlayColor,
          ),
          
        if (child != null) child,
      ],
    );
  }
  
  static Widget propertyImage(
    String? imageUrl, {
    double? width,
    double? height,
    BorderRadius? borderRadius,
    bool showPlaceholder = true,
  }) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return assetImageWithFallback(
        AppAssets.propertyPlaceholder,
        fallbackUrl: AppAssets.getRandomPropertyImage(),
        width: width,
        height: height,
        borderRadius: effectiveBorderRadius,
      );
    }
    
    return networkImage(
      imageUrl,
      width: width,
      height: height,
      borderRadius: effectiveBorderRadius,
    );
  }
  
  static Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}