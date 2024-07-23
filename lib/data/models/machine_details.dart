class MachineDetails {
  final String brandMachine;
  final String modelMachine;
  final String typeMachine;
  final String nameStaff;
  final String positionStaff;

  MachineDetails(
      {required this.brandMachine,
      required this.modelMachine,
      required this.typeMachine,
      required this.nameStaff,
      required this.positionStaff});

  factory MachineDetails.fromJson(Map<String, dynamic> json) {
    return MachineDetails(
      brandMachine: json['brand'] ?? '',
      modelMachine: json['model'] ?? '',
      typeMachine: json['machine_type'] ?? '',
      nameStaff: json['name'] ?? '',
      positionStaff: json['position'] ?? '',
    );
  }
}
