class ProjectsItem {
  final int id;
  final String title;
  final String subtitle;
  final String status;
  final List<int> selectedServiceIds;

  ProjectsItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.selectedServiceIds,
  });

  factory ProjectsItem.fromJson(Map<String, dynamic> json) {
    final services = json['services'] as List? ?? [];

    return ProjectsItem(
      id: json['project_id'] ?? 0,

      title: json['project_number']?.toString() ?? '',

      subtitle: services
          .map((e) => e['name'].toString())
          .join(', '),

      status: json['project_status']?.toString() ?? '',

      // ✅ THIS WAS MISSING
      selectedServiceIds: services
          .map<int>((e) => e['id'] as int)
          .toList(),
    );
  }
}