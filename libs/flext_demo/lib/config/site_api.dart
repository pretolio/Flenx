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

/// Models do projeto (geram a migrations.sql).
const dbModels = [leadsModel];

/// Endpoints do projeto. O form de leads grava + envia e-mail + redireciona.
const apis = [
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
