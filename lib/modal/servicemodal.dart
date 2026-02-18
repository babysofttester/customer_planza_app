import 'package:customer_app_planzaa/modal/services_response_model.dart';

class ServiceItem {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final bool isPopular;
  final bool fullHome;
  final String? badge;


  ServiceItem({
    required this.id,
    required this.title, 
    required this.subtitle,
    required this.image,
    this.isPopular = false,
    this.fullHome = false,
    this.badge,

  });  

  factory ServiceItem.fromServiceModel(Services service) {
  final name = (service.name ?? '').trim();
 
  return ServiceItem(
    id: service.id ?? 0,

    title: name,
    subtitle: defaultSubtitles[name.toLowerCase()] ?? '',
    image: defaultImages[name.toLowerCase()] ?? 'assets/images/house.png',
    //isPopular: popularServices.contains(name.toLowerCase()),
    // If backend sends boolean
    isPopular: service.isPopular == 1,

    // If backend sends string badge
    badge: service.badge,

    fullHome: fullHomeServices.contains(name.toLowerCase()),
  );
}

}



// Maps for default data
const defaultSubtitles = {
  '2d design': 'Smart planning with real visuals.',
  '3d design': 'Smart planning with real visuals.',
  'interior design': 'Functional and beautiful interiors.',
  'structural design': 'Strong, safe, and precise plans.',
  'electrical & plumbing': 'Well-planned electrical and plumbing.',
  'full home package': 'Site insights with proper utilities.',
  'site surveys': 'Site insights with proper utilities.',
};

const defaultImages = {
  '2d design': 'assets/images/2D_&_3D_Design.png',
  '3d design': 'assets/images/Structural_Design.png',
  'interior design': 'assets/images/Interior_Design.png',
  'structural design': 'assets/images/structural_drawing.png',
  'electrical & plumbing': 'assets/images/Electrical_&_Plumbing.png',
  'full home package': 'assets/images/Full_Home.png',
  'site surveys': 'assets/images/surveying_icon.png', 
};

const popularServices = {
  'electrical & plumbing',
};

const fullHomeServices = {
  'full home package',
};

