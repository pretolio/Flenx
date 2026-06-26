import 'product.dart';

/// Catálogo inicial (semeia o banco na primeira execução). Depois, os produtos
/// são gerenciados pelo admin (criar/editar/excluir). Ver [ProductRepository].
const productSeeds = <Product>[
  Product(
    slug: 'fone-bluetooth',
    name: 'Fone Bluetooth Pro',
    price: 299.90,
    emoji: '🎧',
    tag: 'Mais vendido',
    summary: 'Cancelamento de ruído e 30h de bateria.',
    description: 'Som imersivo com cancelamento ativo de ruído, conexão '
        'multiponto e estojo com carregamento rápido. 30 horas de autonomia.',
  ),
  Product(
    slug: 'teclado-mecanico',
    name: 'Teclado Mecânico RGB',
    price: 459.00,
    emoji: '⌨️',
    summary: 'Switches hot-swap e iluminação RGB.',
    description: 'Teclado mecânico com switches removíveis (hot-swap), keycaps '
        'PBT e iluminação RGB por tecla. Layout ABNT2.',
  ),
  Product(
    slug: 'mouse-sem-fio',
    name: 'Mouse Sem Fio Ergo',
    price: 189.90,
    emoji: '🖱️',
    summary: 'Ergonômico, 8 botões, 4000 DPI.',
    description: 'Design ergonômico vertical, 8 botões programáveis, sensor de '
        '4000 DPI e bateria recarregável que dura semanas.',
  ),
  Product(
    slug: 'monitor-27',
    name: 'Monitor 27" 144Hz',
    price: 1599.00,
    emoji: '🖥️',
    tag: 'Novo',
    summary: 'QHD, 144Hz, 1ms — ideal para games.',
    description: 'Tela QHD (2560×1440) de 27 polegadas, 144Hz, 1ms de resposta '
        'e suporte a HDR. Bordas finas e base ajustável.',
  ),
  Product(
    slug: 'webcam-full-hd',
    name: 'Webcam Full HD',
    price: 249.00,
    emoji: '📷',
    summary: '1080p com microfone e foco automático.',
    description: 'Webcam 1080p a 30fps, foco automático, correção de luz e dois '
        'microfones com redução de ruído. Plug and play.',
  ),
  Product(
    slug: 'cadeira-gamer',
    name: 'Cadeira Gamer',
    price: 1299.00,
    emoji: '🪑',
    summary: 'Reclinável, apoio lombar e braços 4D.',
    description: 'Encosto reclinável até 155°, almofadas de apoio lombar e '
        'cervical, braços ajustáveis 4D e revestimento respirável.',
  ),
];
