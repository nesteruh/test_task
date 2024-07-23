class StaffDetails {
  final String name;
  final String position;

  StaffDetails({required this.name, required this.position});
  factory StaffDetails.fromJson(Map<String, dynamic> json) {
    return StaffDetails(
      name: json['name'] ?? '',
      position: json['position'] ?? '',
    );
  }
}