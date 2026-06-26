import 'package:flenx/app.dart';

/// Tabela de produtos (catálogo editável pelo admin).
const productsModel = DbModel('products', [
  DbColumn.id(),
  DbColumn('slug', SqlType.varchar, unique: true),
  DbColumn('name', SqlType.varchar),
  DbColumn('price', SqlType.decimal),
  DbColumn('emoji', SqlType.varchar, nullable: true),
  DbColumn('tag', SqlType.varchar, nullable: true),
  DbColumn('summary', SqlType.varchar, nullable: true),
  DbColumn('description', SqlType.text, nullable: true),
  DbColumn('image', SqlType.varchar, nullable: true),
  DbColumn('active', SqlType.boolean, defaultValue: '1'),
  DbColumn('created_at', SqlType.datetime),
]);

/// Tabela de pedidos (gerados no checkout do carrinho).
const ordersModel = DbModel('orders', [
  DbColumn.id(),
  DbColumn('customer_name', SqlType.varchar),
  DbColumn('customer_email', SqlType.varchar),
  DbColumn('items', SqlType.text, nullable: true), // JSON do carrinho
  DbColumn('total', SqlType.decimal),
  DbColumn('status', SqlType.varchar, defaultValue: 'Novo'),
  DbColumn('created_at', SqlType.datetime),
]);

/// Models do projeto (geram a migrations.sql). `usersModel`/`settingsModel`
/// vêm da lib (admin genérico).
const dbModels = [productsModel, ordersModel, usersModel, settingsModel];

/// Endpoints declarativos da loja (Dart agora; geram PHP no build).
const apis = [
  // ---- Produtos (CRUD do catálogo) ----
  ApiEndpoint(
    path: '/api/products',
    method: HttpMethod.post,
    fields: [
      Field('slug', required: true),
      Field('name', required: true),
      Field('price', required: true),
      Field('emoji'),
      Field('tag'),
      Field('summary'),
      Field('description'),
      Field('image'),
      Field('active'),
    ],
    actions: [InsertInto(productsModel)],
  ),
  ApiEndpoint(
    path: '/api/products/list',
    method: HttpMethod.get,
    actions: [ListPaginated(productsModel)],
  ),
  ApiEndpoint(
    path: '/api/products/get',
    method: HttpMethod.get,
    fields: [Field('id', required: true)],
    actions: [FindById(productsModel)],
  ),
  ApiEndpoint(
    path: '/api/products/update',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [UpdateById(productsModel)],
  ),
  ApiEndpoint(
    path: '/api/products/delete',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [DeleteById(productsModel)],
  ),

  // ---- Pedidos (criados pelo carrinho; status editável no admin) ----
  ApiEndpoint(
    path: '/api/orders',
    method: HttpMethod.post,
    fields: [
      Field('customer_name', required: true),
      Field('customer_email', required: true, email: true),
      Field('items'),
      Field('total'),
    ],
    actions: [InsertInto(ordersModel)],
  ),
  ApiEndpoint(
    path: '/api/orders/list',
    method: HttpMethod.get,
    actions: [ListPaginated(ordersModel)],
  ),
  ApiEndpoint(
    path: '/api/orders/update',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [UpdateById(ordersModel)],
  ),
  ApiEndpoint(
    path: '/api/orders/delete',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [DeleteById(ordersModel)],
  ),

  // ---- Usuários (permissões/papéis) ----
  ApiEndpoint(
    path: '/api/users',
    method: HttpMethod.post,
    fields: [
      Field('name', required: true),
      Field('email', required: true, email: true),
      Field('role'),
      Field('active'),
    ],
    actions: [InsertInto(usersModel)],
  ),
  ApiEndpoint(
    path: '/api/users/list',
    method: HttpMethod.get,
    actions: [ListPaginated(usersModel)],
  ),
  ApiEndpoint(
    path: '/api/users/update',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [UpdateById(usersModel)],
  ),
  ApiEndpoint(
    path: '/api/users/delete',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [DeleteById(usersModel)],
  ),

  // ---- Configurações / tela home ----
  ApiEndpoint(
    path: '/api/settings/get',
    method: HttpMethod.get,
    fields: [Field('id', required: true)],
    actions: [FindById(settingsModel)],
  ),
  ApiEndpoint(
    path: '/api/settings/update',
    method: HttpMethod.post,
    fields: [Field('id', required: true), Field('data')],
    actions: [UpdateById(settingsModel)],
  ),
];
