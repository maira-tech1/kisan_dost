import 'package:flutter/foundation.dart';

@immutable
class Farmer {
  const Farmer({
    this.name = '',
    this.location = '',
    this.cropIds = const [],
  });

  final String name;
  final String location;
  final List<String> cropIds;

  bool get isOnboardingComplete =>
      name.trim().isNotEmpty &&
      location.trim().isNotEmpty &&
      cropIds.isNotEmpty;

  Farmer copyWith({
    String? name,
    String? location,
    List<String>? cropIds,
  }) {
    return Farmer(
      name: name ?? this.name,
      location: location ?? this.location,
      cropIds: cropIds ?? this.cropIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Farmer &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          location == other.location &&
          cropIds.toString() == other.cropIds.toString();

  @override
  int get hashCode => Object.hash(name, location, cropIds.toString());
}
