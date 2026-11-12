import 'package:flutter/widgets.dart';

/// Content images are Cloudinary URLs from Firestore, or bundled asset paths as fallback.
ImageProvider appImageProvider(String path) => path.startsWith('http')
    ? NetworkImage(path)
    : AssetImage(path) as ImageProvider;
