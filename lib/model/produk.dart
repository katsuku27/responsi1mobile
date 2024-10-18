class Produk {
  int? id;
  String? allergen;
  String? reaction;
  int? severityScale;

  // Constructor
  Produk({this.id, this.allergen, this.reaction, this.severityScale});

  // Factory method to create an instance from JSON
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'],
      allergen: obj['allergen'],
      reaction: obj['reaction'],
      severityScale: obj['severity_scale'] is String
          ? int.tryParse(obj['severity_scale']) // Convert String to int safely
          : obj['severity_scale'], // Keep it as int if it's already int
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergen': allergen,
      'reaction': reaction,
      'severity_scale': severityScale,
    };
  }
}
