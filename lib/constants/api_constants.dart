class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String usersEndpoint = '/users';
  static const String postsEndpoint = '/posts';

  static String userPosts(int userId) => '$postsEndpoint?userId=$userId';
}
