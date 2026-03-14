/// Enum for HTTP methods.
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  const HttpMethod(this.value);
  final String value;
}
