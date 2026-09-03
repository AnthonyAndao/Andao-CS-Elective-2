import '../models/product.dart';

/// SoleMate's sneaker catalog.
///
/// Photos are bundled locally under `assets/products/` (see pubspec.yaml)
/// rather than fetched from the network, since these are real product
/// shots the shop owner supplied directly.
final List<Product> products = [
  Product(
    id: 'p1',
    brand: 'Adidas',
    name: 'Samba OG "Black"',
    category: 'Lifestyle',
    price: 7000,
    imageUrl: 'assets/products/adidas_samba_og_black.png',
    description:
        'Classic soft leather terrace sneaker with the iconic 3-Stripes '
        'and gum rubber outsole. A streetwear staple since the 1950s.',
  ),
  Product(
    id: 'p2',
    brand: 'Adidas',
    name: 'Superstar 2',
    category: 'Lifestyle',
    price: 6000,
    imageUrl: 'assets/products/adidas_superstar_2.png',
    description:
        'The original shell-toe icon. Crisp white leather upper with '
        'bold blue 3-Stripes and the signature rubber toe cap.',
  ),
  Product(
    id: 'p3',
    brand: 'Adidas',
    name: 'Adistar Jellyfish by Pharrell',
    category: 'Lifestyle',
    price: 22000,
    imageUrl: 'assets/products/adidas_adistar_jellyfish_pharrell.png',
    description:
        'A Pharrell Williams design pairing exaggerated running-shoe '
        'proportions with a striking blue-and-white layered silhouette.',
  ),
  Product(
    id: 'p4',
    brand: 'Jordan',
    name: 'Air Jordan 1 Low "Midnight Navy"',
    category: 'Basketball',
    price: 6500,
    imageUrl: 'assets/products/jordan_1_low_midnight_navy.png',
    description:
        'Low-cut take on the AJ1 in a clean white and neutral colorway, '
        'with midnight navy Swoosh detailing and a gum outsole.',
  ),
  Product(
    id: 'p5',
    brand: 'Jordan',
    name: 'Air Jordan 4 Retro "Cave Stone"',
    category: 'Basketball',
    price: 11500,
    imageUrl: 'assets/products/jordan_4_retro_cave_stone.png',
    description:
        'Premium nubuck upper in an earthy taupe tone, with the classic '
        'AJ4 mesh wings and visible Air-Sole heel unit.',
  ),
  Product(
    id: 'p6',
    brand: 'New Balance',
    name: '327',
    category: 'Lifestyle',
    price: 4700,
    imageUrl: 'assets/products/new_balance_327.png',
    description:
        'Retro-runner silhouette with an oversized "N" logo, mixed suede '
        'and mesh paneling, and a chunky ridged outsole.',
  ),
  Product(
    id: 'p7',
    brand: 'New Balance',
    name: '550',
    category: 'Lifestyle',
    price: 4900,
    imageUrl: 'assets/products/new_balance_550.png',
    description:
        'A reissued late-\'80s basketball silhouette in crisp white '
        'leather with contrast black overlays and a chunky midsole.',
  ),
  Product(
    id: 'p8',
    brand: 'Nike',
    name: 'P-6000 "Metallic Silver"',
    category: 'Lifestyle',
    price: 6000,
    imageUrl: 'assets/products/nike_p6000_metallic_silver.png',
    description:
        'Y2K running-inspired silhouette with a reflective metallic '
        'silver upper and Nike\'s signature Rideliner sole unit.',
  ),
  Product(
    id: 'p9',
    brand: 'Nike',
    name: 'Zoom Vomero 5',
    category: 'Running',
    price: 8500,
    imageUrl: 'assets/products/nike_zoom_vomero_5.png',
    description:
        'Technical running shoe re-purposed for streetwear, with layered '
        'mesh, Cushlon foam, and a visible Zoom Air unit underfoot.',
  ),
];


List<String> get availableBrands {
  final brands = products.map((p) => p.brand).toSet().toList();
  brands.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return brands;
}
