class ProjectsItem {
  final int id;
  final String title;
  final String subtitle;
  final String status;

  ProjectsItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  factory ProjectsItem.fromJson(Map<String, dynamic> json) {
    return ProjectsItem(
      // id: json['project_id']?.toString() ?? '',
      id: json['project_id'] ?? 0,

      title: json['project_number']?.toString() ?? '',
      subtitle: (json['services'] as List?)
         ?.map((e) => e['name'].toString())
          .join(', ') ??
          'No Services',
      status: json['project_status']?.toString() ?? '',
    );
  }
}

