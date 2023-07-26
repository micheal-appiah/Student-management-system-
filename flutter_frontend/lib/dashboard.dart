import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool showCourses = true;
  bool showGrades = true;
  bool showAssignments = true;
  bool showProjects = true;

  String studentImage = 'lib/assets/dp.png';
  String studentName = '';
  String studentBio = '';

  Map<String, String> studentDetails = {
    'email': '',
    'dateOfBirth': '',
    'department': '',
    'level': '',
    'semester': '',
  };

  List<Map<String, dynamic>> enrolledCourses = [];
  List<Map<String, dynamic>> preResults = [];
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<String> getSchoolIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolId = prefs.getString('schoolId') ?? '';
    return schoolId;
  }

  Future<void> setDepartmentAndLevelInLocalStorage(
      String department, String level) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('department', department);
    prefs.setString('level', level);
  }

  Future<String> getCachedDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDepartment = prefs.getString('department') ?? '';
    return cachedDepartment;
  }

  Future<String> getCachedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedLevel = prefs.getString('level') ?? '';
    return cachedLevel;
  }

  Future<void> fetchDashboardData() async {
    try {
      final schoolId = await getSchoolIdFromLocalStorage();
      if (schoolId.isEmpty) {
        throw Exception('School ID is missing');
      }

      final studentResponse = await http.get(
          Uri.parse('http://localhost:8673/api/students?schoolId=$schoolId'));
      if (studentResponse.statusCode != 200) {
        throw Exception('Failed to fetch student details');
      }

      final studentData = json.decode(studentResponse.body);
      final student = studentData[0];

      setState(() {
        studentName = student['name'];
        studentBio = student['bio'];
        studentDetails['email'] = student['email'];
        studentDetails['dateOfBirth'] = student['dateOfBirth'];
        studentDetails['department'] = student['department'];
        studentDetails['level'] = student['level'];
        studentDetails['semester'] = student['semester'];
      });

      final registrationResponse = await http.get(Uri.parse(
          'http://localhost:8673/api/registrations?schoolId=$schoolId'));
      if (registrationResponse.statusCode != 200) {
        throw Exception('Failed to fetch registration details');
      }

      final registrationData = json.decode(registrationResponse.body);
      final registration = registrationData[0];

      final department = registration['department'];
      final level = registration['level'];

      await setDepartmentAndLevelInLocalStorage(department, level);

      final cachedDepartment = await getCachedDepartment();
      final cachedLevel = await getCachedLevel();

      final enrolledCoursesResponse = await http.get(Uri.parse(
          'http://localhost:8673/api/enrolled-courses?department=$cachedDepartment&level=$cachedLevel'));
      if (enrolledCoursesResponse.statusCode != 200) {
        throw Exception('Failed to fetch enrolled courses');
      }

      final enrolledCoursesData = json.decode(enrolledCoursesResponse.body);
      setState(() {
        enrolledCourses = List<Map<String, dynamic>>.from(enrolledCoursesData);
      });

      final preResultsResponse = await http.get(Uri.parse(
          'http://localhost:8673/api/previous-results?studentId=$schoolId&level=$cachedLevel&semester=${studentDetails['semester']}'));
      if (preResultsResponse.statusCode != 200) {
        throw Exception('Failed to fetch previous results');
      }

      final preResultsData = json.decode(preResultsResponse.body);
      setState(() {
        preResults = List<Map<String, dynamic>>.from(preResultsData);
      });

      final assignmentsResponse = await http.get(Uri.parse(
          'http://localhost:8673/api/assignments?department=$cachedDepartment&level=$cachedLevel'));
      if (assignmentsResponse.statusCode != 200) {
        throw Exception('Failed to fetch assignments');
      }

      final assignmentsData = json.decode(assignmentsResponse.body);
      setState(() {
        assignments = List<Map<String, dynamic>>.from(assignmentsData);
      });

      final projectsResponse = await http.get(Uri.parse(
          'http://localhost:8673/api/projects?department=$cachedDepartment&level=$cachedLevel'));
      if (projectsResponse.statusCode != 200) {
        throw Exception('Failed to fetch projects');
      }

      final projectsData = json.decode(projectsResponse.body);
      setState(() {
        projects = List<Map<String, dynamic>>.from(projectsData);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileSection(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSectionHeader('Navigation'),
                    _buildNavigationSection(),
                    _buildSectionHeader('Enrolled Courses'),
                    if (showCourses) _buildCoursesSection(),
                    _buildSectionHeader('Previous Semester Results'),
                    if (showGrades) _buildGradesSection(),
                    _buildSectionHeader('Assignments'),
                    if (showAssignments) _buildAssignmentsSection(),
                    _buildSectionHeader('Projects'),
                    if (showProjects) _buildProjectsSection(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      color: Colors.blueAccent,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(studentImage),
          ),
          SizedBox(height: 16),
          Text(
            studentName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Student',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNavigationItem(
            icon: Icons.book,
            title: 'Courses',
            value: showCourses,
            onChanged: (value) {
              setState(() {
                showCourses = value;
              });
            },
          ),
          _buildNavigationItem(
            icon: Icons.grade,
            title: 'Grades',
            value: showGrades,
            onChanged: (value) {
              setState(() {
                showGrades = value;
              });
            },
          ),
          _buildNavigationItem(
            icon: Icons.assignment,
            title: 'Assignments',
            value: showAssignments,
            onChanged: (value) {
              setState(() {
                showAssignments = value;
              });
            },
          ),
          _buildNavigationItem(
            icon: Icons.work,
            title: 'Projects',
            value: showProjects,
            onChanged: (value) {
              setState(() {
                showProjects = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30.0,
          color: Colors.blueAccent,
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
          inactiveTrackColor: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final course in enrolledCourses)
            ListTile(
              title: Text(
                course['name'],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Credit: ${course['credit']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final result in preResults)
            ListTile(
              title: Text(
                result['course'],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Credit: ${result['credit']} Grade: ${result['grade']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final assignment in assignments)
            ListTile(
              title: Text(
                assignment['title'],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Due Date: ${assignment['dueDate']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final project in projects)
            ListTile(
              title: Text(
                project['title'],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Due Date: ${project['dueDate']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
