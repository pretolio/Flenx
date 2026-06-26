import 'package:flext/app.dart';

/// API declarativa do portal (em Dart). Define os modelos do banco e os
/// endpoints REST consumidos pelo admin (notícias, usuários e configurações).

/// Modelos do banco. `blogPostsModel`, `usersModel` e `settingsModel` vêm da
/// lib e geram as tabelas (notícias salvas pelo admin, usuários e a config da
/// home num único registro JSON).
const dbModels = [blogPostsModel, usersModel, settingsModel];

/// Endpoints do portal.
const apis = [
  // ---- Notícias: CRUD de posts no banco (estilo G1) ----
  // O corpo vai em `body` (Markdown) e os blocos estruturados em `blocks`.
  ApiEndpoint(
    path: '/api/blog/posts',
    method: HttpMethod.post,
    fields: [
      Field('slug', required: true),
      Field('title', required: true),
      Field('subtitle'),
      Field('description'),
      Field('body'),
      Field('blocks'),
      Field('author'),
      Field('image'),
      Field('category'),
      Field('tags'),
      Field('draft'),
      Field('date'),
    ],
    actions: [InsertInto(blogPostsModel)],
  ),
  ApiEndpoint(
    path: '/api/blog/posts/list',
    method: HttpMethod.get,
    actions: [ListPaginated(blogPostsModel)],
  ),
  ApiEndpoint(
    path: '/api/blog/posts/get',
    method: HttpMethod.get,
    fields: [Field('id', required: true)],
    actions: [FindById(blogPostsModel)],
  ),
  ApiEndpoint(
    path: '/api/blog/posts/update',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [UpdateById(blogPostsModel)],
  ),
  ApiEndpoint(
    path: '/api/blog/posts/delete',
    method: HttpMethod.post,
    fields: [Field('id', required: true)],
    actions: [DeleteById(blogPostsModel)],
  ),

  // ---- Usuários: CRUD básico ----
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

  // ---- Configurações da home (registro único id=1, coluna data em JSON) ----
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
