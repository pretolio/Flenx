/// Endereço físico para schema.org LocalBusiness (PostalAddress + GeoCoordinates).
class SeoAddress {
  const SeoAddress({
    required this.streetAddress,
    required this.addressLocality,
    this.addressRegion,
    required this.postalCode,
    this.addressCountry = 'BR',
    this.latitude,
    this.longitude,
  });

  final String streetAddress;
  final String addressLocality;
  final String? addressRegion;
  final String postalCode;
  final String addressCountry;
  final double? latitude;
  final double? longitude;

  bool get hasGeo => latitude != null && longitude != null;

  Map<String, dynamic> toJsonLd() => {
        '@type': 'PostalAddress',
        'streetAddress': streetAddress,
        'addressLocality': addressLocality,
        if (addressRegion != null) 'addressRegion': addressRegion,
        'postalCode': postalCode,
        'addressCountry': addressCountry,
      };
}
