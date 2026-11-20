import "dart:async";
import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "api_client.dart";
import "fleet_repository.dart";
import "config_manager.dart";

class FleetWebSocketService extends ChangeNotifier {
  static final FleetWebSocketService instance = FleetWebSocketService._();
  FleetWebSocketService._();

  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final _telemetryStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get telemetryStream => _telemetryStreamController.stream;

  void connect() {
    _reconnectTimer?.cancel();
    _initSocket();
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _socket?.close();
    _socket = null;
    _isConnected = false;
    notifyListeners();
  }

  Future<void> _initSocket() async {
    final wsUri = Uri.parse(ApiClient.instance.wsUrl);
    try {
      _socket = await WebSocket.connect(wsUri.toString()).timeout(const Duration(seconds: 8));
      _isConnected = true;
      notifyListeners();

      _pingTimer?.cancel();
      _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
        if (_isConnected && _socket != null) {
          try {
            _socket!.add("ping");
          } catch (_) {}
        }
      });

      _socket!.listen(
        (data) {
          if (data is String) {
            _handleIncomingMessage(data);
          }
        },
        onDone: () => _scheduleReconnect(),
        onError: (_) => _scheduleReconnect(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _isConnected = false;
    _socket = null;
    _pingTimer?.cancel();
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 4), () {
      _initSocket();
    });
  }

  void _handleIncomingMessage(String raw) {
    if (raw == "pong") return;
    try {
      final Map<String, dynamic> packet = jsonDecode(raw);
      final type = packet["type"] as String?;

      if (type == "telemetry_update") {
        _telemetryStreamController.add(packet);
        LocalFleetRepository.instance.handleTelemetryUpdate(packet);
      } else if (type == "trip_created" || type == "trip_status_changed" || type == "trip_delivered") {
        LocalFleetRepository.instance.syncTripsFromRemote();
      } else if (type == "config_updated" && packet["config"] is Map<String, dynamic>) {
        ConfigManager.instance.applyRemoteConfig(packet["config"]);
      }
    } catch (_) {}
  }
}
