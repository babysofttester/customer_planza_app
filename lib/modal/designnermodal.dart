
import 'designerPorfolioModal.dart';
import 'designerServicesModal.dart';

// class DesignerItem {
//   final String name;
//   final String projects;
//   final String rate;
//   final String review;
//   final String image;
//   final List<DesignerService> services;
//   final List<DesignerPortfolio> portfolio;
//   final List<DesignerReview> reviews;
//
//
//   DesignerItem({
//     required this.name,
//     required this.projects,
//     required this.rate,
//     this.review= "",
//     required this.image,
//     required this.services,
//     required this.portfolio,
//     required this.reviews,
//   });
// }

class DesignerItem {
  final int id;
  final String name;
  final String image;
  final int projectsDone;
  final String amount;
  final int rating;

  // ✅ NEW OPTIONAL FIELDS (for detail page)
  final String currencySymbol;
  final List<dynamic> services;
  final List<dynamic> portfolios;
  final List<dynamic> reviews;

  DesignerItem({
    required this.id,
    required this.name,
    required this.image,
    required this.projectsDone,
    required this.amount,
    required this.rating,
    this.currencySymbol = "₹",
    this.services = const [],
    this.portfolios = const [],
    this.reviews = const [],
  });

  factory DesignerItem.fromJson(Map<String, dynamic> json) {
    return DesignerItem(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['avatar'] ?? '',
      projectsDone: json['projects_done'] ?? 0,
      amount: json['amount'].toString(),
      rating: json['average_rating'] ?? 0,
      currencySymbol: json['currancy_symbol'] ?? "₹",
      services: json['services'] ?? [],
      portfolios: json['portfolios'] ?? [],
      reviews: json['reviews'] ?? [],
    );
  }
}
String getServiceImage(String title) {
  switch (title.toLowerCase().trim()) {
    case "2d design":
      return "assets/images/2D_&_3D_Design.png";

    case "3d design":
      return "assets/images/Structural_Design.png";

    case "interior design":
      return "assets/images/Interior_Design.png";

    case "mep layouts":
      return "assets/images/Electrical_&_Plumbing.png";

    case "structural drawings":
      return "assets/images/structural_drawing.png";

    default:
      return "assets/images/Structural_Design.png";
  }
}



// final  List<DesignerItem> designers = [
//   DesignerItem(
//     name: 'Adam Collins',
//     projects: '100 Projects',
//     rate: '₹4,000',
//     review: '3',
//     image: 'assets/bgImage.png',
//     services: [
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//
//
//     ],
//     portfolio: [
//       DesignerPortfolio(
//         title: "Modern Living Room",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//           ],
//         content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//       DesignerPortfolio(
//         title: "Elegant Dining Area",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//
//           ],
//           content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//       DesignerPortfolio(
//         title: "Contemporary Home Office",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//
//           ],
//           content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//
//     ],
//     reviews: [
//       DesignerReview(
//         name: "Michael Smith",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '3',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//       DesignerReview(
//         name: "Sarah Walker",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '4',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//
//     ],
//   ),
//
//   DesignerItem(
//     name: 'Taylor Russell',
//     projects: '150 Projects',
//     rate: '₹5,000',
//     review: '5',
//     image: 'assets/bgImage.png',
//     services: [
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//       DesignerService(
//         title: "3D Elevation",
//         price: "4/sq.ft",
//         image: "assets/Structural_Design.png",
//       ),
//       DesignerService(
//         title: "MEP layouts",
//         price: "4/sq.ft",
//         image: "assets/Electrical_&_Plumbing.png",
//       ),
//     ],
//     portfolio: [
//       DesignerPortfolio(
//         title: "Modern Living Room",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//           ],
//           content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//       DesignerPortfolio(
//         title: "Elegant Dining Area",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//
//           ],
//           content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//
//     ],
//     reviews: [
//       DesignerReview(
//         name: "Michael Smith",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '3',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//       DesignerReview(
//         name: "Sarah Walker",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '4',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//
//     ],
//   ),
//
//   DesignerItem(
//     name: 'Jessica Morgan',
//     projects: '200 Projects',
//     rate: '₹6,000',
//     review: '4',
//     image: 'assets/bgImage.png',
//     services: [
//       DesignerService(
//         title: "2D Planning",
//         price: "4/sq.ft",
//         image: "assets/2D_&_3D_Design.png",
//       ),
//       DesignerService(
//         title: "Interior Design",
//         price: "4/sq.ft",
//         image: "assets/Interior_Design.png",
//       ),
//       DesignerService(
//         title: "3D Elevation",
//         price: "4/sq.ft",
//         image: "assets/Structural_Design.png",
//       ),
//       DesignerService(
//         title: "MEP layouts",
//         price: "4/sq.ft",
//         image: "assets/Electrical_&_Plumbing.png",
//       ),
//       DesignerService(
//         title: "Structural drawings",
//         price: "4/sq.ft",
//         image: "assets/structural_drawing.png",
//       ),
//     ],
//     portfolio: [
//       DesignerPortfolio(
//         title: "Modern Living Room",
//         year: "2024",
//           images: [
//             "assets/bgImage.png",
//             "assets/bgImage.png",
//
//           ],
//
//           content: 'Fusce eget bibendum augue. Praesent ut ligula porttitor, tincidunt nisl  in, vehicula magna. Quisque nec est rhoncus, rutrum est nec, lobortis  leo. Donec et fermentum metus. Lorem ipsum dolor sit amet, consectetur  adipiscing elit. Nullam id metus quis urna varius sollicitudin non ut sapien. Nam a  vulputate sem.'
//       ),
//     ],
//     reviews: [
//       DesignerReview(
//         name: "Michael Smith",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '3',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//       DesignerReview(
//         name: "Sarah Walker",
//         date: "April 15. 2024",
//         image: "assets/bgImage.png",
//         review: '4',
//         comment: 'Excellent work! Adam delivered a great design for our new home. Highly professional and easy to work with.',
//       ),
//
//     ],
//   ),
// ];
