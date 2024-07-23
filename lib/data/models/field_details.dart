class FieldDetails {
  final String fieldTitle;
  final String area;

  FieldDetails({required this.fieldTitle, required this.area});

  factory FieldDetails.fromJson(Map<String, dynamic> json) {
    return FieldDetails(
      fieldTitle: json['title'] ?? '',
      area: json['fact_area'] ?? '',
    );
  }
}