import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Verificar se o serviço de localização está habilitado
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verificar permissões de localização
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Solicitar permissões de localização
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Verificar e solicitar todas as permissões necessárias
  static Future<bool> checkAndRequestPermissions() async {
    // Verificar se o serviço está habilitado
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException('Serviço de localização desabilitado');
    }

    // Verificar permissões
    LocationPermission permission = await checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionException('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionException(
        'Permissão de localização negada permanentemente. '
        'Habilite nas configurações do dispositivo.',
      );
    }

    return true;
  }

  // Obter localização atual
  static Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    await checkAndRequestPermissions();

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit ?? const Duration(seconds: 15),
      );
    } catch (e) {
      throw LocationException('Erro ao obter localização: $e');
    }
  }

  // Obter última localização conhecida
  static Future<Position?> getLastKnownPosition() async {
    await checkAndRequestPermissions();
    return await Geolocator.getLastKnownPosition();
  }

  // Calcular distância entre duas posições
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calcular bearing (direção) entre duas posições
  static double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Monitorar mudanças de posição
  static Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    final settings = locationSettings ??
        const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Atualizar a cada 10 metros
        );

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  // Verificar se uma posição está dentro de um raio específico
  static bool isWithinRadius(
    Position currentPosition,
    double targetLatitude,
    double targetLongitude,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLatitude,
      targetLongitude,
    );

    return distance <= radiusInMeters;
  }

  // Formatar coordenadas para exibição
  static String formatCoordinates(
    double latitude,
    double longitude, {
    int decimals = 6,
  }) {
    return 'Lat: ${latitude.toStringAsFixed(decimals)}, '
           'Lng: ${longitude.toStringAsFixed(decimals)}';
  }

  // Converter coordenadas para endereço (geocoding reverso)
  // Nota: Requer implementação com serviço de geocoding
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    // Em uma implementação real, você usaria um serviço como:
    // - Google Geocoding API
    // - OpenStreetMap Nominatim
    // - Mapbox Geocoding API
    
    // Por enquanto, retorna as coordenadas formatadas
    return formatCoordinates(latitude, longitude);
  }

  // Obter coordenadas de um endereço (geocoding)
  // Nota: Requer implementação com serviço de geocoding
  static Future<Position?> getCoordinatesFromAddress(String address) async {
    // Em uma implementação real, você usaria um serviço de geocoding
    // Por enquanto, retorna null
    return null;
  }

  // Abrir configurações de localização
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Abrir configurações do app
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Verificar precisão da localização
  static LocationAccuracyStatus getAccuracyStatus(Position position) {
    final accuracy = position.accuracy;
    
    if (accuracy <= 5) {
      return LocationAccuracyStatus.excellent;
    } else if (accuracy <= 10) {
      return LocationAccuracyStatus.good;
    } else if (accuracy <= 20) {
      return LocationAccuracyStatus.fair;
    } else {
      return LocationAccuracyStatus.poor;
    }
  }

  // Obter configurações de localização otimizadas para diferentes cenários
  static LocationSettings getSettingsForScenario(LocationScenario scenario) {
    switch (scenario) {
      case LocationScenario.oneTime:
        return const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        );
      
      case LocationScenario.tracking:
        return const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        );
      
      case LocationScenario.backgroundTracking:
        return const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 10,
        );
      
      case LocationScenario.batterySaving:
        return const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 50,
        );
    }
  }
}

// Enums para diferentes cenários de uso
enum LocationScenario {
  oneTime,
  tracking,
  backgroundTracking,
  batterySaving,
}

enum LocationAccuracyStatus {
  excellent,
  good,
  fair,
  poor,
}

// Exceções personalizadas
class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  
  @override
  String toString() => 'LocationException: $message';
}

class LocationServiceException extends LocationException {
  LocationServiceException(String message) : super(message);
}

class LocationPermissionException extends LocationException {
  LocationPermissionException(String message) : super(message);
}

// Modelo para dados de localização com informações adicionais
class LocationData {
  final Position position;
  final DateTime timestamp;
  final LocationAccuracyStatus accuracyStatus;
  final String? address;

  LocationData({
    required this.position,
    required this.timestamp,
    required this.accuracyStatus,
    this.address,
  });

  factory LocationData.fromPosition(Position position) {
    return LocationData(
      position: position,
      timestamp: position.timestamp,
      accuracyStatus: LocationService.getAccuracyStatus(position),
    );
  }

  double get latitude => position.latitude;
  double get longitude => position.longitude;
  double get accuracy => position.accuracy;
  double get altitude => position.altitude;
  double get heading => position.heading;
  double get speed => position.speed;

  String get formattedCoordinates => 
      LocationService.formatCoordinates(latitude, longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
    };
  }
}
