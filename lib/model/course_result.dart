class CourseResult {
  final String id;
  final String studentId;
  final String courseId;
  final double score;

  CourseResult({
    String? id,
    required this.studentId,
    required this.courseId,
    required this.score,
  }) : id = id ?? '$studentId-$courseId';
}
