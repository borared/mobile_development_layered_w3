import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $studentId already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
    // remove student from the course list
    for (Course course in courses) {
      course.studentIds.remove(studentId);
    }
    results.removeWhere((result) => result.studentId == studentId);
  }

  void createCourse({required String courseId, required String courseName}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $courseId already exists');
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void addCourse({required String courseId, required String courseName}) {
    createCourse(courseId: courseId, courseName: courseName);
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    courses.removeWhere((course) => course.id == courseId);
    results.removeWhere((result) => result.courseId == courseId);
  }

  void enrollStudent({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is already enrolled in course $courseId');
    }

    course.studentIds.add(studentId);
  }

  void addStudentToCourse({required String studentId, required String courseId}) {
    enrollStudent(studentId: studentId, courseId: courseId);
  }

  void discardStudentFromCourse({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    course.studentIds.remove(studentId);
    results.removeWhere((result) => result.studentId == studentId && result.courseId == courseId);
  }

  void addResult({required String studentId, required String courseId, required double score}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }

    if (_findResultOrNull(studentId, courseId) != null) {
      throw Exception('Result already exists for student $studentId in course $courseId');
    }

    results.add(CourseResult(studentId: studentId, courseId: courseId, score: score));
  }

  void addScore({required String studentId, required String courseId, required double score}) {
    addResult(studentId: studentId, courseId: courseId, score: score);
  }

  void removeResult({required String studentId, required String courseId}) {
    CourseResult? result = _findResultOrNull(studentId, courseId);
    if (result == null) {
      throw Exception('Result for student $studentId in course $courseId not found');
    }
    results.remove(result);
  }

  void removeResultById({required String resultId}) {
    CourseResult? result = _findResultByIdOrNull(resultId);
    if (result == null) {
      throw Exception('Result $resultId not found');
    }
    results.remove(result);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null;
  } 

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  CourseResult? _findResultOrNull(String studentId, String courseId) {
    for (CourseResult r in results) {
      if (r.studentId == studentId && r.courseId == courseId) {
        return r;
      }
    }
    return null;
  }

  CourseResult? _findResultByIdOrNull(String resultId) {
    for (CourseResult r in results) {
      if (r.id == resultId) {
        return r;
      }
    }
    return null;
  }
}
