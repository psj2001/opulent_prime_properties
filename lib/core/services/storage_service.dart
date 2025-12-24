import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';

class StorageService {
  /// Upload an image file to Cloudinary
  /// Returns the download URL of the uploaded image
  static Future<String> uploadOpportunityImage(
    XFile imageFile,
    String opportunityId,
    String imageId,
  ) async {
    try {
      print('StorageService: Starting Cloudinary upload for image $imageId');
      
      // Read image bytes
      final bytes = await imageFile.readAsBytes();
      print('StorageService: Image bytes read: ${bytes.length} bytes');
      
      // Create multipart request
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/image/upload',
      );
      
      final request = http.MultipartRequest('POST', uri);
      
      // Add file
      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: '$imageId.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
          ),
        );
      }
      
      // Use unsigned upload preset (recommended for client-side)
      if (AppConstants.cloudinaryUploadPreset.isNotEmpty && 
          AppConstants.cloudinaryUploadPreset != 'YOUR_UPLOAD_PRESET') {
        request.fields['upload_preset'] = AppConstants.cloudinaryUploadPreset;
        // Set folder and public_id for organization
        request.fields['folder'] = 'opportunities/$opportunityId';
        request.fields['public_id'] = '$opportunityId/$imageId';
        print('StorageService: Using upload preset: ${AppConstants.cloudinaryUploadPreset}');
      } else {
        // Fallback: Try without preset (may require signed upload)
        print('StorageService: Warning - No valid upload preset configured');
        print('StorageService: Attempting upload without preset (may fail if unsigned uploads disabled)');
        // Still set folder for organization
        request.fields['folder'] = 'opportunities/$opportunityId';
        request.fields['public_id'] = '$opportunityId/$imageId';
      }
      
      print('StorageService: Sending upload request to Cloudinary...');
      
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('StorageService: Upload timeout after 30 seconds');
          throw Exception('Upload timeout: Image upload took too long');
        },
      );
      
      // Read response
      final response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 10));
      
      print('StorageService: Upload response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final imageUrl = responseData['secure_url'] as String;
        print('StorageService: Upload successful. URL: $imageUrl');
        return imageUrl;
      } else {
        print('StorageService: Upload failed. Status: ${response.statusCode}');
        print('StorageService: Response: ${response.body}');
        throw Exception('Upload failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('StorageService: Upload error: $e');
      print('StorageService: Error type: ${e.runtimeType}');
      print('StorageService: Stack trace: $stackTrace');
      throw Exception('Failed to upload image: $e');
    }
  }


  /// Upload multiple images for an opportunity
  /// Returns a list of download URLs
  static Future<List<String>> uploadOpportunityImages(
    List<XFile> imageFiles,
    String opportunityId,
  ) async {
    try {
      print('StorageService: Starting upload of ${imageFiles.length} images to Cloudinary');
      final List<String> urls = [];
      
      for (int i = 0; i < imageFiles.length; i++) {
        print('StorageService: Uploading image ${i + 1}/${imageFiles.length}');
        final imageId = DateTime.now().millisecondsSinceEpoch.toString() + '_$i';
        final url = await uploadOpportunityImage(imageFiles[i], opportunityId, imageId);
        urls.add(url);
        print('StorageService: Image ${i + 1} uploaded successfully');
      }
      
      print('StorageService: All ${urls.length} images uploaded successfully');
      return urls;
    } catch (e, stackTrace) {
      print('StorageService: Error uploading multiple images: $e');
      print('StorageService: Stack trace: $stackTrace');
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Delete an image from Cloudinary
  /// Note: Requires admin API access
  static Future<void> deleteOpportunityImage(String imageUrl) async {
    try {
      // Extract public_id from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) {
        throw Exception('Invalid Cloudinary URL');
      }
      
      // Cloudinary URL format: https://res.cloudinary.com/{cloud_name}/image/upload/{version}/{public_id}.{format}
      // Extract public_id (everything after /upload/ or /v{version}/)
      String publicId = '';
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        // Get everything after 'upload'
        publicId = pathSegments.sublist(uploadIndex + 1).join('/');
        // Remove file extension
        publicId = publicId.replaceAll(RegExp(r'\.[^.]+$'), '');
      } else {
        throw Exception('Could not extract public_id from URL');
      }
      
      // Generate signature for deletion
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final stringToSign = 'public_id=$publicId&timestamp=$timestamp${AppConstants.cloudinaryApiSecret}';
      // Note: In production, use proper SHA1 hashing
      // For now, deletion requires server-side implementation
      
      print('StorageService: Deletion requires server-side implementation');
      // Deletion is typically done server-side for security
    } catch (e) {
      print('StorageService: Error deleting image: $e');
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Delete multiple images from Cloudinary
  static Future<void> deleteOpportunityImages(List<String> imageUrls) async {
    try {
      // Note: Deletion should be done server-side
      print('StorageService: Bulk deletion requires server-side implementation');
    } catch (e) {
      throw Exception('Failed to delete images: $e');
    }
  }
}
