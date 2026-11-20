import "package:latlong2/latlong.dart";

/// Commercial freight highway corridor waypoints for South India routes.
/// Ensures map polylines follow actual National Highways (NH 66, NH 766, NH 544)
/// instead of cutting straight across mountains or water bodies.
class HighwayRoutes {
  static const LatLng kozhikode = LatLng(11.2588, 75.7804);
  static const LatLng kochi = LatLng(9.9658, 76.2711);
  static const LatLng bangalore = LatLng(12.9716, 77.5946);
  static const LatLng coimbatore = LatLng(11.0168, 76.9558);
  static const LatLng kannur = LatLng(11.8745, 75.3704);
  static const LatLng palakkad = LatLng(10.7867, 76.6548);
  static const LatLng thrissur = LatLng(10.5276, 76.2144);

  /// NH 66 Corridor: Kozhikode -> Kochi Port (approx 180 km)
  static final List<LatLng> kozhikodeToKochi = [
    const LatLng(11.2588, 75.7804), // Kozhikode Hub
    const LatLng(11.1714, 75.8341), // Feroke
    const LatLng(11.1278, 75.8893), // Chelari
    const LatLng(11.0006, 75.9996), // Kottakkal
    const LatLng(10.8872, 76.0718), // Valanchery
    const LatLng(10.8358, 76.0358), // Kuttippuram
    const LatLng(10.7634, 76.0021), // Edappal
    const LatLng(10.6517, 76.0684), // Kunnamkulam
    const LatLng(10.5847, 76.0270), // Chavakkad
    const LatLng(10.2268, 76.1969), // Kodungallur
    const LatLng(10.1472, 76.2295), // North Paravur
    const LatLng(10.0812, 76.2736), // Varapuzha Bridge
    const LatLng(10.0261, 76.3082), // Edappally
    const LatLng(9.9658, 76.2711),  // Kochi Port (Willingdon Island)
  ];

  /// NH 766 & NH 275 Corridor: Kozhikode -> Bangalore (approx 350 km)
  static final List<LatLng> kozhikodeToBangalore = [
    const LatLng(11.2588, 75.7804), // Kozhikode Hub
    const LatLng(11.4172, 75.9348), // Thamarassery
    const LatLng(11.5123, 76.0125), // Wayanad Ghats / Adivaram
    const LatLng(11.6094, 76.0827), // Kalpetta
    const LatLng(11.6644, 76.2588), // Sultan Bathery
    const LatLng(11.6700, 76.4000), // Muthanga Checkpost
    const LatLng(11.8080, 76.6910), // Gundlupet
    const LatLng(12.1187, 76.6800), // Nanjangud
    const LatLng(12.3051, 76.6551), // Mysore Ring Road
    const LatLng(12.5242, 76.8958), // Mandya
    const LatLng(12.7208, 77.2799), // Ramanagara
    const LatLng(12.7978, 77.3855), // Bidadi
    const LatLng(12.9716, 77.5946), // Bangalore Yard
  ];

  /// NH 544 Corridor: Kochi -> Coimbatore (approx 190 km)
  static final List<LatLng> kochiToCoimbatore = [
    const LatLng(9.9658, 76.2711),  // Kochi Port
    const LatLng(10.1076, 76.3516), // Aluva Bypass
    const LatLng(10.1960, 76.3860), // Angamaly
    const LatLng(10.3070, 76.3330), // Chalakudy
    const LatLng(10.5276, 76.2144), // Thrissur
    const LatLng(10.5960, 76.4950), // Vadakkencherry
    const LatLng(10.7867, 76.6548), // Palakkad
    const LatLng(10.8280, 76.8520), // Walayar Border
    const LatLng(11.0168, 76.9558), // Coimbatore
  ];

  /// Retrieve best polyline for any given trip route
  static List<LatLng> getCorridorPolyline(String from, String to, {LatLng? fallbackOrigin, LatLng? fallbackDest}) {
    final f = from.toLowerCase();
    final t = to.toLowerCase();

    // 1. Kozhikode <-> Bangalore
    if ((f.contains("kozhikode") || f.contains("calicut")) && (t.contains("bangalore") || t.contains("bengaluru"))) {
      return kozhikodeToBangalore;
    }
    if ((f.contains("bangalore") || f.contains("bengaluru")) && (f.contains("kozhikode") || f.contains("calicut"))) {
      return kozhikodeToBangalore.reversed.toList();
    }

    // 2. Kozhikode <-> Kochi
    if ((f.contains("kozhikode") || f.contains("calicut")) && (t.contains("kochi") || t.contains("cochin") || t.contains("ernakulam"))) {
      return kozhikodeToKochi;
    }
    if ((f.contains("kochi") || f.contains("cochin") || f.contains("ernakulam")) && (t.contains("kozhikode") || t.contains("calicut"))) {
      return kozhikodeToKochi.reversed.toList();
    }

    // 3. Kochi <-> Coimbatore
    if ((f.contains("kochi") || f.contains("cochin")) && t.contains("coimbatore")) {
      return kochiToCoimbatore;
    }
    if (f.contains("coimbatore") && (t.contains("kochi") || t.contains("cochin"))) {
      return kochiToCoimbatore.reversed.toList();
    }

    // Fallback: interpolate 5 smooth corridor waypoints between origin & destination
    final o = fallbackOrigin ?? kozhikode;
    final d = fallbackDest ?? kochi;
    return [
      o,
      LatLng(o.latitude * 0.75 + d.latitude * 0.25, o.longitude * 0.75 + d.longitude * 0.25 + 0.05),
      LatLng(o.latitude * 0.50 + d.latitude * 0.50, o.longitude * 0.50 + d.longitude * 0.50 - 0.03),
      LatLng(o.latitude * 0.25 + d.latitude * 0.75, o.longitude * 0.25 + d.longitude * 0.75 + 0.02),
      d,
    ];
  }
}
