String cleanBase64(String base64String) {
  // Removes 'data:image/png;base64,' or similar prefix
  return base64String.contains(',')
      ? base64String.split(',').last
      : base64String;
}
