import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'Dara');

    expect(lms.students.first.name, 'Dara');

    lms.removeStudent(studentId: 's1');
    expect(lms.students.length, 0);
  });

  test('enroll student into course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'Dara');
    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');

    expect(lms.courses.first.name, 'Mobile Dev');

    lms.enrollStudent(studentId: 's1', courseId: 'c1');
    expect(lms.courses.first.studentIds.length, 1);

    lms.removeStudent(studentId: 's1');
    expect(lms.courses.first.studentIds.length, 0);
  });

  test('save score for enrolled student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'Dara');
    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 's1', courseId: 'c1');

    lms.addScore(studentId: 's1', courseId: 'c1', score: 85);
    expect(lms.results.first.score, 85);

    lms.removeStudent(studentId: 's1');
    expect(lms.results.length, 0);
  });

  test('throw when creating course with existing id', () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');

    expect(() => lms.createCourse(courseId: 'c1', courseName: 'Web Dev'), throwsException);
  });

  test('throw when enrolling student that does not exist', () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');

    expect(() => lms.enrollStudent(studentId: 's1', courseId: 'c1'), throwsException);
  });

  test('throw when enrolling into nonexistent course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'Dara');

    expect(() => lms.enrollStudent(studentId: 's1', courseId: 'c1'), throwsException);
  });

  test('throw when adding score for unknown student', () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');

    expect(() => lms.addScore(studentId: 's1', courseId: 'c1', score: 85), throwsException);
  });

  test('throw when adding score for unknown course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'Dara');

    expect(() => lms.addScore(studentId: 's1', courseId: 'c1', score: 90), throwsException);
  });

  test('throw when adding score for student not in course', () {
    final lms = LmsSystem();
    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');
    lms.addStudent(studentId: 's1', studentName: 'Dara');

    expect(() => lms.addScore(studentId: 's1', courseId: 'c1', score: 96), throwsException);
  });

  test('throw when score is already added for student in course', () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: 'Mobile Dev');
    lms.addStudent(studentId: 's1', studentName: 'Dara');
    lms.enrollStudent(studentId: 's1', courseId: 'c1');
    lms.addScore(studentId: 's1', courseId: 'c1', score: 100);

    expect(() => lms.addScore(studentId: 's1', courseId: 'c1', score: 20), throwsException);
  });
}
