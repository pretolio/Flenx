import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../auth/token_verifier.dart';
import '../db/db_model.dart';
import 'api_action.dart';
import 'api_config.dart';
import 'api_endpoint.dart';
import 'api_response.dart';
import 'db_executor.dart';
import 'http_method.dart';
import 'pagination.dart';

/// Hook de envio de e-mail (servidor).
typedef EmailSender = void Function(
    String to, String subject, Map<String, String> data);

/// Runtime do **alvo Dart**: transforma a lista declarativa de [ApiEndpoint]
/// em rotas shelf, já com os middlewares padrão (JSON, CORS, validação,
/// tratamento de erro) e o envelope/paginação padronizados.
class FlextApi {
  FlextApi(
    this.endpoints,
    this.db, {
    this.config = const ApiConfig(),
    this.onEmail,
    this.tokenVerifier,
  });

  final List<ApiEndpoint> endpoints;
  final DbExecutor db;
  final ApiConfig config;
  final EmailSender? onEmail;

  /// Verificador de token (JWT próprio ou Firebase) para endpoints com auth.
  final TokenVerifier? tokenVerifier;

  /// Registra todos os endpoints no [router].
  void mountOn(Router router) {
    for (final ep in endpoints) {
      final h = _handlerFor(ep);
      switch (ep.method) {
        case HttpMethod.get:
          router.get(ep.path, h);
        case HttpMethod.post:
          router.post(ep.path, h);
        case HttpMethod.put:
          router.put(ep.path, h);
        case HttpMethod.delete:
          router.delete(ep.path, h);
      }
    }
  }

  Map<String, String> get _cors =>
      {'access-control-allow-origin': config.corsOrigin};

  Response _json(ApiResponse r, {int status = 200}) => Response(
        status,
        body: jsonEncode(r.toJson()),
        headers: {'content-type': 'application/json; charset=utf-8', ..._cors},
      );

  Handler _handlerFor(ApiEndpoint ep) {
    return (Request req) async {
      try {
        // Middleware de autenticação.
        if (ep.requiresAuth) {
          final auth = req.headers['authorization'] ?? '';
          final token = auth.toLowerCase().startsWith('bearer ')
              ? auth.substring(7).trim()
              : '';
          final claims = token.isEmpty ? null : await tokenVerifier?.call(token);
          if (claims == null) {
            return _json(ApiResponse.fail('Não autorizado'), status: 401);
          }
        }
        final input = await _readInput(req);
        // Middleware de validação.
        for (final f in ep.fields) {
          final err = f.validate(input[f.name]);
          if (err != null) return _json(ApiResponse.fail(err), status: 400);
        }

        Object? result;
        PageMeta? meta;
        int? insertedId;

        for (final action in ep.actions) {
          switch (action) {
            case InsertInto(:final model):
              insertedId = await db.insert(model.table, _values(model, input));
            case ListPaginated(:final model, :final orderBy, :final desc):
              final pr = PageRequest.fromQuery(
                req.url.queryParameters,
                defaultPerPage: config.defaultPerPage,
                maxPerPage: config.maxPerPage,
              );
              result = await db.list(model.table,
                  limit: pr.limit, offset: pr.offset, orderBy: orderBy, desc: desc);
              meta = PageMeta.of(pr, await db.count(model.table));
            case FindById(:final model):
              final r = await db.findById(model.table, input['id'] ?? '');
              if (r == null) {
                return _json(ApiResponse.fail('Não encontrado'), status: 404);
              }
              result = r;
            case UpdateById(:final model):
              await db.updateById(
                  model.table, input['id'] ?? '', _values(model, input));
              result = {'updated': true};
            case DeleteById(:final model):
              await db.deleteById(model.table, input['id'] ?? '');
              result = {'deleted': true};
            case SendEmail(:final to, :final subject):
              onEmail?.call(to, subject, input);
            case RespondJson(:final body):
              result = body;
            case Redirect(:final location):
              return Response(303, headers: {'location': location, ..._cors});
          }
        }

        if (meta != null) {
          return _json(ApiResponse.page((result as List).cast<Object?>(), meta));
        }
        return _json(ApiResponse.ok(result ?? {'id': insertedId}));
      } catch (_) {
        return _json(ApiResponse.fail('Erro interno do servidor'), status: 500);
      }
    };
  }

  Future<Map<String, String>> _readInput(Request req) async {
    final q = Map<String, String>.from(req.url.queryParameters);
    if (req.method == 'GET') return q;
    final body = await req.readAsString();
    if (body.isEmpty) return q;
    final ct = req.headers['content-type'] ?? '';
    if (ct.contains('application/json')) {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return {...q, for (final e in decoded.entries) '${e.key}': '${e.value}'};
      }
      return q;
    }
    return {...q, ...Uri.splitQueryString(body)};
  }

  Map<String, Object?> _values(DbModel model, Map<String, String> input) {
    final out = <String, Object?>{};
    for (final c in model.columns) {
      if (c.primaryKey && c.autoIncrement) continue;
      if (c.name == 'created_at' && !input.containsKey('created_at')) {
        out['created_at'] = DateTime.now().toIso8601String();
        continue;
      }
      if (input.containsKey(c.name)) out[c.name] = input[c.name];
    }
    return out;
  }
}
