final String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    id, name, status, period, progress, fieldName, area, brandMachine, modelMachine, typeMachine, nameStaffMachine, positionStaffMachine, nameStaff, positionStaff
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String status = 'status';
  static const String period = 'period';
  static const String progress = 'progress';
  static const String fieldName = 'fieldName';
  static const String area = 'area';
  static const String brandMachine = 'brandMachine';
  static const String modelMachine = 'modelMachine';
  static const String typeMachine = 'typeMachine';
  static const String nameStaffMachine = 'nameStaffMachine';
  static const String positionStaffMachine = 'positionStaffMachine';
  static const String nameStaff = 'nameStaff';
  static const String positionStaff = 'positionStaff';
}

class Task {
  final int? id;
  final String name;
  final String status;
  final String period;
  final double progress;
  final String fieldName;
  final String area;
  final String brandMachine;
  final String modelMachine;
  final String typeMachine;
  final String nameStaffMachine;
  final String positionStaffMachine;
  final String nameStaff;
  final String positionStaff;

  const Task({
    this.id,
    required this.name,
    required this.status,
    required this.period,
    required this.progress,
    required this.fieldName,
    required this.area,
    required this.brandMachine,
    required this.modelMachine,
    required this.typeMachine,
    required this.nameStaffMachine,
    required this.positionStaffMachine,
    required this.nameStaff,
    required this.positionStaff,
  });

  Task copy({
    int? id,
    String? name,
    String? status,
    String? period,
    double? progress,
    String? fieldName,
    String? area,
    String? brandMachine,
    String? modelMachine,
    String? typeMachine,
    String? nameStaffMachine,
    String? positionStaffMachine,
    String? nameStaff,
    String? positionStaff,
  }) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        period: period ?? this.period,
        progress: progress ?? this.progress,
        fieldName: fieldName ?? this.fieldName,
        area: area ?? this.area,
        brandMachine: brandMachine ?? this.brandMachine,
        modelMachine: modelMachine ?? this.modelMachine,
        typeMachine: typeMachine ?? this.typeMachine,
        nameStaffMachine: nameStaffMachine ?? this.nameStaffMachine,
        positionStaffMachine: positionStaffMachine ?? this.positionStaffMachine,
        nameStaff: nameStaff ?? this.nameStaff,
        positionStaff: positionStaff ?? this.positionStaff,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        name: json[TaskFields.name] as String,
        status: json[TaskFields.status] as String,
        period: json[TaskFields.period] as String,
        progress: json[TaskFields.progress] as double,
        fieldName: json[TaskFields.fieldName] as String,
        area: json[TaskFields.area] as String,
        brandMachine: json[TaskFields.brandMachine] as String,
        modelMachine: json[TaskFields.modelMachine] as String,
        typeMachine: json[TaskFields.typeMachine] as String,
        nameStaffMachine: json[TaskFields.nameStaffMachine] as String,
        positionStaffMachine: json[TaskFields.positionStaffMachine] as String,
        nameStaff: json[TaskFields.nameStaff] as String,
        positionStaff: json[TaskFields.positionStaff] as String,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.name: name,
        TaskFields.status: status,
        TaskFields.period: period,
        TaskFields.progress: progress,
        TaskFields.fieldName: fieldName,
        TaskFields.area: area,
        TaskFields.brandMachine: brandMachine,
        TaskFields.modelMachine: modelMachine,
        TaskFields.typeMachine: typeMachine,
        TaskFields.nameStaffMachine: nameStaffMachine,
        TaskFields.positionStaffMachine: positionStaffMachine,
        TaskFields.nameStaff: nameStaff,
        TaskFields.positionStaff: positionStaff,
      };
}
