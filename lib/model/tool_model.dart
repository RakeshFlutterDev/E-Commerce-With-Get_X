class Tool {
  final String name;
  final String image;
  final double price;
  final String description;
  final String category;
  int quantity;

  Tool({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    this.quantity = 1,
  });

  Tool copyWith({
    String? name,
    String? image,
    double? price,
    String? description,
    String? category, // Added category parameter
    int? quantity,
  }) {
    return Tool(
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category, // Updated category
    );
  }
}


final List<Tool> tools = [
  Tool(
    name: 'Fish',
    image: 'assets/images/fish.png',
    price: 200.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Fish-Katla',
    image: 'assets/images/fish.png',
    price: 299.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Fish-Seelavathi',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Fish-Seelavathi',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Tuna fish',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Apolo Fish',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Rahu-Fish',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Boche-Fish',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Raganti-Fish',
    image: 'assets/images/fish.png',
    price: 399.00,
    description: 'Fish meal is now primarily used as a protein supplement in compound feed. As of 2010, about 56% of fish meal was used to feed farmed fish, about 20% was used in pig feed, about 12% in poultry feed, and about 12% in other uses, which included fertilizer.',
    category: 'SeaFood',
  ),
  Tool(
    name: 'Prawns',
    image: 'assets/images/prawns.png',
    price: 12.99,
    description: 'Prawns vary in colour from a dark red to an orange-red or pink; juveniles are sometimes green or brown. Running horizontally across their head are several white lines. They have a smooth, glossy body with an abdomen divided into several segments, the first and fifth bearing a distinctive white spot.',
    category: 'SeaFood',
  ),
  // Add more tools as needed
];
