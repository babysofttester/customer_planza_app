class ProjectsItem {
  final String id;
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
      id: json['project_id']?.toString() ?? '',
      title: json['project_number']?.toString() ?? '',
      subtitle: (json['services'] as List?)
          ?.map((e) => e.toString())
          .join(', ') ??
          'No Services',
      status: json['project_status']?.toString() ?? '',
    );
  }
}


// final projects = [
//   ProjectsItem(
//     title: '#223445',
//     subtitle: '2D Design, 3D Design,  MEP layouts, Structural drawings, Interior Design',
//     status: 'Completed',
//   ),
//
//   ProjectsItem(
//     title: '#223456',
//     subtitle: 'Interior Design, MEP layouts',
//     status: 'In Progress',
//   ),
//   ProjectsItem(
//     title: '#223456',
//     subtitle: '2D & 3D Design, 3D Design,  MEP layout',
//     status: 'Completed',
//   ),
//
//   ProjectsItem(
//     title: '#223456',
//     subtitle: 'Interior Design,  Structural drawings, Interior Design',
//     status: 'In Progress',
//   ),
//   ProjectsItem(
//     title: ' #223456',
//     subtitle: '2D & 3D Design',
//     status: 'Completed',
//   ),
//
//   ProjectsItem(
//     title: '#223456',
//     subtitle: 'Interior Design',
//     status: 'In Progress',
//   ),
//   ProjectsItem(
//     title: ' #223456',
//     subtitle: '2D & 3D Design',
//     status: 'Completed',
//   ),
//
//   ProjectsItem(
//     title: '#223456',
//     subtitle: 'Interior Design',
//     status: 'In Progress',
//   ),
//   ProjectsItem(
//     title: '#223456',
//     subtitle: '2D & 3D Design',
//     status: 'Completed',
//   ),
//
//   ProjectsItem(
//     title: ' #223456',
//     subtitle: 'Interior Design',
//     status: 'In Progress',
//   ),
//
// ];