import 'package:shared_preferences/shared_preferences.dart';

Future<List<String?>> getLocation() async {
  final prefs = await SharedPreferences.getInstance();
  final city=prefs.getString("city");
  final district=prefs.getString("district");
  final state=prefs.getString("state");
  final nation=prefs.getString("nation");
  return [city,district,state,nation];
}

// Future<int?> loadTokenId() async {
//   final prefs = await SharedPreferences.getInstance();
//   final savedToken = prefs.getString("access_token");

//   if (savedToken != null) {
//     final decoded = JwtDecoder.decode(savedToken);
//     return decoded["id"];
//   }
//   return null;
// }
