import 'package:latlong2/latlong.dart';

/// Predefined coordinates for common logistics hubs and depots across Kerala and neighboring states.
class KeralaLocations {
  const KeralaLocations._();

  static const Map<String, LatLng> hubs = {
    'Kochi Port': LatLng(9.9312, 76.2673),
    'Kozhikode Hub': LatLng(11.2588, 75.7804),
    'Bangalore Yard': LatLng(12.9716, 77.5946),
    'Coimbatore Terminal': LatLng(11.0168, 76.9558),
    'Chennai Central': LatLng(13.0827, 80.2707),
    'Palakkad Depot': LatLng(10.7867, 76.6548),
    'Mangalore Port': LatLng(12.9141, 74.8560),
    'Kannur': LatLng(11.8745, 75.3704),
    'Ernakulam': LatLng(9.9816, 76.2999),
    'Thrissur': LatLng(10.5276, 76.2144),
    'Thiruvananthapuram': LatLng(8.5241, 76.9366),
    'Alappuzha': LatLng(9.4981, 76.3388),
    'Kottayam': LatLng(9.5916, 76.5222),
  };

  static LatLng resolve(String locationName, {LatLng fallback = const LatLng(10.5276, 76.2144)}) {
    return hubs[locationName] ?? fallback;
  }
}
