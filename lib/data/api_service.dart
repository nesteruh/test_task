import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'models/field_details.dart';
import 'models/machine_details.dart';
import 'models/task.dart';
import 'models/staff_details.dart';
import 'package:logger/logger.dart';
import 'task_database.dart';

class ApiService {
  final String baseUrl = 'https://dev1.agroonline.kz';
  final Logger logger = Logger();

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

   Future<void> refreshToken(String refreshToken) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/token/refresh/'),
    body: jsonEncode({'refresh': refreshToken}),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'X-CSRFToken': '4CKSaT56BEAO1lRqN4d6C4npniQPNMiRpfJ4tlYsybcsWQLNb4TUe99DFEqb7hcA',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', data['access']);
  } else {
    throw Exception('Failed to refresh token');
  }
}


  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/token/'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'X-CSRFToken':
            '4CKSaT56BEAO1lRqN4d6C4npniQPNMiRpfJ4tlYsybcsWQLNb4TUe99DFEqb7hcA',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      await saveToken(data['access']);
      return data;
    } else {
      logger.e('Failed to login: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to login');
    }
  }

  Future<String> fetchWorkName(int workId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/company/1094/works/$workId/'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            '6cwHN0nBtVfG8V3PEjVurXtqMWAHr27Wx6ZHe1LqCnYDhUWUW9BpJLQ3RD0flO26',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['name'];
    } else {
      logger.e(
          'Failed to load work name: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load work name');
    }
  }

  Future<MachineDetails?> fetchMachineDetails(int machineId) async {
    if (machineId == 0) {
      return null;
    }
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final url = '$baseUrl/api/company/1094/machines/$machineId/';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            'G4WH33W0n6KTQC9g7p6o1w6DFSUIEzOGeYQZqZR928VIln2XmyN7wdUWeKynXQKs',
      },
    );

    logger.d('Request URL: $url');
    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      MachineDetails machine;
      final int staffId = data['machine_brigade'][0]['staff'];
      final StaffDetails? staffDetails = await fetchStaffDetails(staffId);
      if (staffDetails != null) {
        machine = MachineDetails(
            brandMachine: data['brand'],
            modelMachine: data['model'],
            typeMachine: data['machine_type'],
            nameStaff: staffDetails.name,
            positionStaff: staffDetails.position);
      } else {
        machine = MachineDetails(
            brandMachine: data['brand'],
            modelMachine: data['model'],
            typeMachine: data['machine_type'],
            nameStaff: '0',
            positionStaff: '0');
      }

      return machine;
    } else {
      logger.e(
          'Failed to load machine details: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load machine details');
    }
  }

  Future<StaffDetails?> fetchStaffDetails(int staffId) async {
    if (staffId == 0) {
      return null;
    }

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/company/1094/staff/$staffId/'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            'KVcrDtqjAn4FMUdSD523uUNW6Hygjbkd3z8qPM5thUsNR0mdinWBiKuGSFkajKr0',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return StaffDetails.fromJson(data);
    } else if (response.statusCode == 404) {
      logger.e('Staff not found: ${response.statusCode} - ${response.body}');
      return null;
    } else {
      logger.e(
          'Failed to load staff details: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load staff details');
    }
  }

  Future<FieldDetails> fetchFieldDetails(int fieldId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/company/1094/fields/$fieldId/'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            'MRJjKRlUhmVY9H3kvaj2JwKxqG3NM20vaftVIEl2LmyB1ynj4HiXpXpsUYXwz5Xw',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return FieldDetails.fromJson(data);
    } else {
      logger.e(
          'Failed to load field details: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load field details');
    }
  }

  Future<List<Task>> fetchTasks() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final tasksFromDB = await TaskDatabase.instance.fetchTasks();

    if (tasksFromDB.isNotEmpty) {
      logger.d('Loading tasks from database');
      return tasksFromDB;
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/company/1094/done_works/?time_from=2024-04-22T03%3A00%3A00&time_to=2024-06-17T18%3A59%3A59'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            '2zHTIvssL6NQyjbUgGxSr50llJtwLBKymsIbvYMUu49VyTvvwhTGiUQg52HLqwwH',
      },
    );

    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      List<Task> tasks = [];
      for (var item in data) {
        final int workId = item['work'] ?? 0;
        final int fieldId = item['linked_objects']['field'] ?? 0;
        final int staffId =
            (item['brigades'] != null && item['brigades'].isNotEmpty)
                ? item['brigades'][0]['staff']
                : 0;
        final int machineId = item['machine'] ?? 0;
        final String workName = await fetchWorkName(workId);
        final FieldDetails fieldDetails = await fetchFieldDetails(fieldId);
        final MachineDetails? machineDetails =
            await fetchMachineDetails(machineId);
        final StaffDetails? staffDetails = await fetchStaffDetails(staffId);

        final String status = determineStatus(
          isClosed: item['is_closed'] ?? false,
          period: List<String>.from(item['period'] ??
              ['1970-01-01T00:00:00Z', '1970-01-01T00:00:00Z']),
        );

        final double progress = item['supervisor_progress_volume'] is String
            ? double.tryParse(item['supervisor_progress_volume']) ?? 0.0
            : (item['supervisor_progress_volume'] as num?)?.toDouble() ?? 0.0;
        tasks.add(Task(
          id: item['id'] ?? 0,
          name: workName,
          status: status,
          period: formatPeriod(List<String>.from(item['period'] ??
              ['1970-01-01T00:00:00Z', '1970-01-01T00:00:00Z'])),
          progress: progress,
          fieldName: fieldDetails.fieldTitle,
          area: fieldDetails.area,
          brandMachine: machineDetails?.brandMachine ?? '0',
          modelMachine: machineDetails?.modelMachine ?? '0',
          typeMachine: machineDetails?.typeMachine ?? '0',
          nameStaffMachine: machineDetails?.nameStaff ?? '0',
          positionStaffMachine: machineDetails?.positionStaff ?? '0',
          nameStaff: staffDetails?.name ?? '0',
          positionStaff: staffDetails?.position ?? '0',
        ));
      }

      await TaskDatabase.instance.insertTasks(tasks);
      return tasks;
    } else {
      logger
          .e('Failed to load tasks: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> fetchAndUpdateTasks() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token is not set');
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/company/1094/done_works/?time_from=2024-04-22T03%3A00%3A00&time_to=2024-06-17T18%3A59%3A59'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            '2zHTIvssL6NQyjbUgGxSr50llJtwLBKymsIbvYMUu49VyTvvwhTGiUQg52HLqwwH',
      },
    );

    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      List<Task> tasks = [];
      for (var item in data) {
        final int workId = item['work'] ?? 0;
        final int fieldId = item['linked_objects']['field'] ?? 0;
        final int staffId =
            (item['brigades'] != null && item['brigades'].isNotEmpty)
                ? item['brigades'][0]['staff']
                : 0;
        final int machineId = item['machine'] ?? 0;
        final String workName = await fetchWorkName(workId);
        final FieldDetails fieldDetails = await fetchFieldDetails(fieldId);
        final MachineDetails? machineDetails =
            await fetchMachineDetails(machineId);
        final StaffDetails? staffDetails = await fetchStaffDetails(staffId);

        final String status = determineStatus(
          isClosed: item['is_closed'] ?? false,
          period: List<String>.from(item['period'] ??
              ['1970-01-01T00:00:00Z', '1970-01-01T00:00:00Z']),
        );

        final double progress = item['supervisor_progress_volume'] is String
            ? double.tryParse(item['supervisor_progress_volume']) ?? 0.0
            : (item['supervisor_progress_volume'] as num?)?.toDouble() ?? 0.0;
        tasks.add(Task(
          id: item['id'] ?? 0,
          name: workName,
          status: status,
          period: formatPeriod(List<String>.from(item['period'] ??
              ['1970-01-01T00:00:00Z', '1970-01-01T00:00:00Z'])),
          progress: progress,
          fieldName: fieldDetails.fieldTitle,
          area: fieldDetails.area,
          brandMachine: machineDetails?.brandMachine ?? '0',
          modelMachine: machineDetails?.modelMachine ?? '0',
          typeMachine: machineDetails?.typeMachine ?? '0',
          nameStaffMachine: machineDetails?.nameStaff ?? '0',
          positionStaffMachine: machineDetails?.positionStaff ?? '0',
          nameStaff: staffDetails?.name ?? '0',
          positionStaff: staffDetails?.position ?? '0',
        ));
      }

      final db = await TaskDatabase.instance.database;
      await db.transaction((txn) async {
        for (var task in tasks) {
          await txn.insert(
            tableTasks,
            task.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } else {
      logger
          .e('Failed to load tasks: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load tasks');
    }
  }

  String determineStatus(
      {required bool isClosed, required List<String> period}) {
    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime.parse(period[0]);
    final DateTime endDate = DateTime.parse(period[1]);

    if (isClosed) {
      return 'Выполнено';
    } else if (now.isBefore(startDate)) {
      return 'Запланировано';
    } else if (now.isAfter(endDate)) {
      return 'Отменено, просрочено';
    } else {
      return 'В процессе';
    }
  }

  String formatPeriod(List<String> period) {
    final DateTime startDate = DateTime.parse(period[0]);
    final DateTime endDate = DateTime.parse(period[1]);

    final String start =
        '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} ${startDate.day.toString().padLeft(2, '0')}.${startDate.month.toString().padLeft(2, '0')}';
    final String end =
        '${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')} ${endDate.day.toString().padLeft(2, '0')}.${endDate.month.toString().padLeft(2, '0')}';

    return '$start – $end';
  }
}
