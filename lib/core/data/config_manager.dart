import "dart:async";
import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "api_client.dart";
import "../design/theme/theme_controller.dart";
import "../design/tokens/app_colors.dart";

class EmergencyContacts {
  final String highwayPolice;
  final String police;
  final String ambulance;
  final String officeDispatch;
  final String breakdownService;

  const EmergencyContacts({
    this.highwayPolice = "+91 98461 00100",
    this.police = "112",
    this.ambulance = "108",
    this.officeDispatch = "+91 98950 00000",
    this.breakdownService = "+91 98950 11111",
  });

  factory EmergencyContacts.fromJson(Map<String, dynamic> json) {
    return EmergencyContacts(
      highwayPolice: json["highway_police"] as String? ?? "+91 98461 00100",
      police: json["police"] as String? ?? "112",
      ambulance: json["ambulance"] as String? ?? "108",
      officeDispatch: json["office_dispatch"] as String? ?? "+91 98950 00000",
      breakdownService: json["breakdown_service"] as String? ?? "+91 98950 11111",
    );
  }

  Map<String, dynamic> toJson() => {
    "highway_police": highwayPolice,
    "police": police,
    "ambulance": ambulance,
    "office_dispatch": officeDispatch,
    "breakdown_service": breakdownService,
  };
}

class NoticeBanner {
  final String title;
  final String message;
  final String severity;
  final bool active;

  const NoticeBanner({
    required this.title,
    required this.message,
    this.severity = "info",
    this.active = true,
  });

  factory NoticeBanner.fromJson(Map<String, dynamic> json) {
    return NoticeBanner(
      title: json["title"] as String? ?? "",
      message: json["message"] as String? ?? "",
      severity: json["severity"] as String? ?? "info",
      active: json["active"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "message": message,
    "severity": severity,
    "active": active,
  };
}

class ConfigManager extends ChangeNotifier {
  static final ConfigManager instance = ConfigManager._();
  ConfigManager._() {
    _init();
  }

  int _version = 1;
  int get version => _version;

  EmergencyContacts _emergencyContacts = const EmergencyContacts();
  EmergencyContacts get emergencyContacts => _emergencyContacts;

  NoticeBanner? _noticeBanner;
  NoticeBanner? get noticeBanner => _noticeBanner;

  List<String> _cargos = [
    "Industrial Steel Coils",
    "Container Freight (Electronics & Spices)",
    "Cement Sacks & TMT Steel Bars",
    "Bulk Polymer Granules",
    "Automotive Spare Parts",
    "Food Grains & Rice Sacks",
    "Timber & Wood Pulp",
    "Petroleum & Chemical Drums",
    "FMCG Packaged Goods",
  ];
  List<String> get cargos => List.unmodifiable(_cargos);

  int _driverAllowanceDefault = 1500;
  int get driverAllowanceDefault => _driverAllowanceDefault;

  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;
    await _loadFromLocal();
    _isInitialized = true;
    unawaited(syncFromRemote());
  }

  Future<void> syncFromRemote() async {
    try {
      final configData = await ApiClient.instance.getAppConfig();
      if (configData != null) {
        applyRemoteConfig(configData);
        await _saveToLocal(configData);
      }
    } catch (_) {}
  }

  void applyRemoteConfig(Map<String, dynamic> data) {
    _version = data["version"] as int? ?? _version;

    if (data["emergency_contacts"] is Map<String, dynamic>) {
      _emergencyContacts = EmergencyContacts.fromJson(data["emergency_contacts"]);
    }

    if (data["notice_banner"] is Map<String, dynamic>) {
      _noticeBanner = NoticeBanner.fromJson(data["notice_banner"]);
    } else {
      _noticeBanner = null;
    }

    if (data["cargos"] is List) {
      _cargos = List<String>.from(data["cargos"]);
    }

    if (data["driver_allowance_default"] is num) {
      _driverAllowanceDefault = (data["driver_allowance_default"] as num).toInt();
    }

    // Auto-apply theme palette if set
    if (data["theme"] is Map<String, dynamic>) {
      final paletteStr = data["theme"]["default_palette"] as String?;
      if (paletteStr == "sky_blue") {
        ThemeController.instance.setPalette(AppAccentPalette.skyBlue);
      } else if (paletteStr == "claude_orange") {
        ThemeController.instance.setPalette(AppAccentPalette.claudeOrange);
      } else if (paletteStr == "lime_green") {
        ThemeController.instance.setPalette(AppAccentPalette.limeGreen);
      }
    }

    notifyListeners();
  }

  Future<void> _saveToLocal(Map<String, dynamic> data) async {
    try {
      final file = File("${Directory.systemTemp.path}/smartfleet_config.json");
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  Future<void> _loadFromLocal() async {
    try {
      final file = File("${Directory.systemTemp.path}/smartfleet_config.json");
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        applyRemoteConfig(data);
      }
    } catch (_) {}
  }
}
