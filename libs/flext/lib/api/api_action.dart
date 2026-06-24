import '../db/db_model.dart';

/// Ação declarativa executada por um endpoint. O runtime Dart e o gerador PHP
/// sabem executar cada uma. Ações de listagem são sempre paginadas.
sealed class ApiAction {
  const ApiAction();
}

/// Insere os campos recebidos na tabela do [model].
class InsertInto extends ApiAction {
  const InsertInto(this.model);
  final DbModel model;
}

/// Lista (paginada) registros da tabela.
class ListPaginated extends ApiAction {
  const ListPaginated(this.model, {this.orderBy = 'id', this.desc = true});
  final DbModel model;
  final String orderBy;
  final bool desc;
}

/// Busca um registro por `id` (parâmetro `id`).
class FindById extends ApiAction {
  const FindById(this.model);
  final DbModel model;
}

/// Atualiza um registro por `id` com os campos recebidos.
class UpdateById extends ApiAction {
  const UpdateById(this.model);
  final DbModel model;
}

/// Remove um registro por `id`.
class DeleteById extends ApiAction {
  const DeleteById(this.model);
  final DbModel model;
}

/// Envia um e-mail (servidor) para [to].
class SendEmail extends ApiAction {
  const SendEmail({required this.to, this.subject = 'Novo contato'});
  final String to;
  final String subject;
}

/// Responde com um JSON fixo.
class RespondJson extends ApiAction {
  const RespondJson(this.body);
  final Map<String, Object?> body;
}

/// Redireciona (303) para [location] — padrão Post/Redirect/Get.
class Redirect extends ApiAction {
  const Redirect(this.location);
  final String location;
}
