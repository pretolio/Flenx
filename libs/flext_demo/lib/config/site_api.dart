import 'package:flext/flext.dart';

/// Definição das APIs do site — em Dart, declarativa. A partir daqui o Flext
/// roda no alvo Dart (runtime shelf) OU gera PHP (`dart run tool/gen_php.dart`).

/// Tabela de leads (com relação seria só usar DbColumn.foreign).
const leadsModel = DbModel('leads', [
  DbColumn.id(),
  DbColumn('name', SqlType.varchar),
  DbColumn('email', SqlType.varchar),
  DbColumn('message', SqlType.text, nullable: true),
  DbColumn('created_at', SqlType.datetime),
]);

/// Models do projeto (geram a migrations.sql). `blogPostsModel` vem da lib e
/// guarda os posts criados pelo banco/admin (a outra forma, além dos `.md`).
const dbModels = [leadsModel, blogPostsModel];

/// Endpoints do projeto. O form de leads grava + envia e-mail + redireciona.
const apis = [
  // ---- Blog: CRUD de posts no banco (a forma "salva no banco") ----
  // Cria/edita posts ricos (estilo G1). O corpo vai em `body` (Markdown,
  // derivado dos blocos do editor) e os blocos estruturados em `blocks` (JSON).
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
  ApiEndpoint(
    path: '/api/leads',
    method: HttpMethod.post,
    fields: [
      Field('name', required: true),
      Field('email', required: true, email: true),
      Field('message'),
    ],
    actions: [
      InsertInto(leadsModel),
      SendEmail(to: 'contato@flext.dev', subject: 'Novo lead'),
      Redirect('/site?lead=ok#contato'),
    ],
  ),
  // Exemplo de listagem paginada (envelope + meta automáticos):
  ApiEndpoint(
    path: '/api/leads/list',
    method: HttpMethod.get,
    actions: [ListPaginated(leadsModel)],
  ),
];
