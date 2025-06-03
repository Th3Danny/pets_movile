class ApiEndpoints {
  
  static const String baseUrl = 'http://localhost:8080/api'; 

  // === AUTH ===
  static const String authenticate = '$baseUrl/auth/authenticate';
  static const String refreshToken = '$baseUrl/auth/refresh-token';

  // === USERS ===
  static const String users = '$baseUrl/users';
  static String userById(int id) => '$users/$id';
  static String userByEmail(String email) => '$users/email/$email';

  // === PETS ===
  static const String pets = '$baseUrl/pets';
  static String petById(int id) => '$pets/$id';
  static String petsByUserId(int userId) => '$pets/user/$userId';
  static String petsBySpecies(String species) => '$pets/species/$species';

  // === DIETS ===
  static const String diets = '$baseUrl/diets';
  static String dietById(int id) => '$diets/$id';

  // === MEDICATIONS ===
  static const String medications = '$baseUrl/medications';
  static String medicationById(int id) => '$medications/$id';
  static String medicationsByType(String type) => '$medications/type/$type';

  // === VACCINES ===
  static const String vaccines = '$baseUrl/vaccines';
  static String vaccineById(int id) => '$vaccines/$id';
}
