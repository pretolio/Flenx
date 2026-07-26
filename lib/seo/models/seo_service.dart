/// Um serviço oferecido pela empresa — vira schema.org `Service` no JSON-LD.
/// Ajuda GEO/AEO: motores de IA citam serviços específicos ("quem faz X em SP?").
class SeoService {
  const SeoService({
    required this.name,
    this.description,
    this.serviceType,
    this.areaServed = const [],
    this.url,
  });

  final String name;
  final String? description;

  /// Categoria do serviço (ex.: "Logística hospitalar").
  final String? serviceType;

  /// Regiões atendidas (ex.: `['São Paulo', 'Rio de Janeiro']`).
  final List<String> areaServed;

  /// Caminho relativo da landing page do serviço (ex.: `/servicos/logistica`).
  final String? url;
}
