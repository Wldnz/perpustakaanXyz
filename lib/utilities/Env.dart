import 'dart:collection';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String base_url = dotenv.env["BASE_URL"]!;
  static HashMap<String, dynamic> account = HashMap();
  static int currentIndexNavigationBar = 0;
  static final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: dotenv.env["API_KEY_CLOUDINARY"]!,
    apiSecret: dotenv.env["API_KEY_SECRET_CLOUDINARY"]!,
    cloudName: dotenv.env["NAME_CLOUDINARY"]!,
  );
}
