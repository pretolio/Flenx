/// Verbo HTTP de um endpoint.
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  const HttpMethod(this.value);
  final String value;
}
