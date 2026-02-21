class ApiEndpoints {
  static const baseUrl =
      "http://192.168.1.188/planzaa-live/customer-api";

  static const sendOtp = "$baseUrl/send-otp";
  static const verifyOtp = "$baseUrl/varify-otp";
  static const register = "$baseUrl/register";
  static const profile = "$baseUrl/get-profile";
  static const updateProfile = "$baseUrl/update-profile";
  static const service = "$baseUrl/get-services";
  static const addProject = "$baseUrl/create-project";
  static const getStates = "$baseUrl/get-states";
  static const getCities = "$baseUrl/get-cities";
  static const designer = "$baseUrl/designers";
  static const designerDetail = "$baseUrl/designer-details";
  static const portfolioDetail = "$baseUrl/get-portfolio-details";
  static const projects = "$baseUrl/projects";
  static const projectsDetails = "$baseUrl/project-details";//choose-package
  static const choosePackage = "$baseUrl/choose-package";
  static const checkout = "$baseUrl/checkout";
    static const orders = "$baseUrl/orders";
}
