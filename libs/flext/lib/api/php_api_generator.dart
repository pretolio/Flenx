import 'dart:io';

import '../db/db_model.dart';
import '../db/sql_migration_generator.dart';
import 'api_action.dart';
import 'api_endpoint.dart';
import 'field.dart';

/// Gera o backend em **PHP** (PDO + MySQL) a partir da MESMA definição
/// declarativa usada no alvo Dart. Emite um `_flext.php` (base: `.env`, PDO,
/// envelope, paginação, CORS) e um arquivo por endpoint. O usuário não escreve PHP.
class PhpApiGenerator {
  const PhpApiGenerator();

  /// Retorna `nomeArquivo -> conteúdo` (inclui `_flext.php`).
  Map<String, String> generate(List<ApiEndpoint> endpoints) {
    final files = <String, String>{'_flext.php': _bootstrap};
    for (final ep in endpoints) {
      files[ep.phpFileName] = _endpoint(ep);
    }
    return files;
  }

  /// Escreve os `.php` em [dir] e, se houver [models], a `migrations.sql`.
  Future<void> writeTo(String dir, List<ApiEndpoint> endpoints,
      {List<DbModel> models = const []}) async {
    final out = Directory(dir);
    await out.create(recursive: true);
    generate(endpoints).forEach((name, content) {
      File('$dir/$name').writeAsStringSync(content);
    });
    if (models.isNotEmpty) {
      File('$dir/migrations.sql')
          .writeAsStringSync(const SqlMigrationGenerator().generate(models));
    }
  }

  String _endpoint(ApiEndpoint ep) {
    final b = StringBuffer()
      ..writeln('<?php')
      ..writeln('// Gerado pelo Flext a partir da definição Dart — não edite.')
      ..writeln("require __DIR__ . '/_flext.php';")
      ..writeln(r'$in = flext_input();');
    for (final f in ep.fields) {
      b.write(_validation(f));
    }
    for (final a in ep.actions) {
      b.write(_action(a));
    }
    // Resposta padrão se nenhuma ação encerrou antes.
    b.writeln('flext_respond(true, ' r'$flext_result ?? null' ');');
    return b.toString();
  }

  String _validation(Field f) {
    final n = f.name;
    final get = "(\$in['$n'] ?? '')";
    final sb = StringBuffer();
    if (f.required) {
      sb.writeln("if (trim($get) === '') "
          "flext_respond(false, null, 'O campo \"$n\" é obrigatório.', null, 400);");
    }
    if (f.email) {
      sb.writeln("if ($get !== '' && !filter_var($get, FILTER_VALIDATE_EMAIL)) "
          "flext_respond(false, null, 'O campo \"$n\" deve ser um e-mail válido.', null, 400);");
    }
    if (f.isInt) {
      sb.writeln("if ($get !== '' && !is_numeric($get)) "
          "flext_respond(false, null, 'O campo \"$n\" deve ser um número inteiro.', null, 400);");
    }
    if (f.maxLength != null) {
      sb.writeln("if (mb_strlen($get) > ${f.maxLength}) "
          "flext_respond(false, null, 'O campo \"$n\" excede ${f.maxLength} caracteres.', null, 400);");
    }
    return sb.toString();
  }

  String _action(ApiAction a) {
    switch (a) {
      case InsertInto(:final model):
        final cols = model.columns
            .where((c) => !(c.primaryKey && c.autoIncrement))
            .toList();
        final names = cols.map((c) => '`${c.name}`').join(',');
        final marks = cols.map((_) => '?').join(',');
        final vals = cols.map((c) => c.name == 'created_at'
            ? "date('c')"
            : "(\$in['${c.name}'] ?? null)").join(', ');
        return "\$stmt = flext_db()->prepare('INSERT INTO `${model.table}` ($names) VALUES ($marks)');\n"
            "\$stmt->execute([$vals]);\n"
            "\$flext_result = ['id' => (int) flext_db()->lastInsertId()];\n";
      case ListPaginated(:final model, :final orderBy, :final desc):
        final dir = desc ? 'DESC' : 'ASC';
        return "\$pg = flext_page();\n"
            "\$stmt = flext_db()->prepare('SELECT * FROM `${model.table}` ORDER BY `$orderBy` $dir LIMIT ? OFFSET ?');\n"
            "\$stmt->bindValue(1, \$pg['perPage'], PDO::PARAM_INT);\n"
            "\$stmt->bindValue(2, \$pg['offset'], PDO::PARAM_INT);\n"
            "\$stmt->execute();\n"
            "\$rows = \$stmt->fetchAll(PDO::FETCH_ASSOC);\n"
            "\$total = (int) flext_db()->query('SELECT COUNT(*) FROM `${model.table}`')->fetchColumn();\n"
            "flext_respond(true, \$rows, null, flext_meta(\$pg, \$total));\n";
      case FindById(:final model):
        return "\$stmt = flext_db()->prepare('SELECT * FROM `${model.table}` WHERE `id` = ? LIMIT 1');\n"
            "\$stmt->execute([\$in['id'] ?? null]);\n"
            "\$row = \$stmt->fetch(PDO::FETCH_ASSOC);\n"
            "if (!\$row) flext_respond(false, null, 'Não encontrado', null, 404);\n"
            "flext_respond(true, \$row);\n";
      case DeleteById(:final model):
        return "\$stmt = flext_db()->prepare('DELETE FROM `${model.table}` WHERE `id` = ?');\n"
            "\$stmt->execute([\$in['id'] ?? null]);\n"
            "\$flext_result = ['deleted' => true];\n";
      case UpdateById(:final model):
        final cols = model.columns
            .where((c) => !c.primaryKey && c.name != 'created_at')
            .toList();
        final sets = cols.map((c) => '`${c.name}` = ?').join(', ');
        final vals = cols.map((c) => "(\$in['${c.name}'] ?? null)").join(', ');
        return "\$stmt = flext_db()->prepare('UPDATE `${model.table}` SET $sets WHERE `id` = ?');\n"
            "\$stmt->execute([$vals, \$in['id'] ?? null]);\n"
            "\$flext_result = ['updated' => true];\n";
      case SendEmail(:final to, :final subject):
        return "@mail('$to', '$subject', json_encode(\$in));\n";
      case RespondJson(:final body):
        return "flext_respond(true, json_decode('${_jsonLiteral(body)}', true));\n";
      case Redirect(:final location):
        return "flext_cors();\nheader('Location: $location', true, 303);\nexit;\n";
    }
  }

  String _jsonLiteral(Map<String, Object?> m) {
    final entries = m.entries
        .map((e) => '"${e.key}":${e.value is String ? '"${e.value}"' : e.value}')
        .join(',');
    return '{$entries}';
  }

  static const String _bootstrap = r'''
<?php
// Gerado pelo Flext — base de todos os endpoints (não edite à mão).

function flext_env($key, $default = '') {
  static $env = null;
  if ($env === null) {
    $env = [];
    $path = __DIR__ . '/../.env';
    if (is_file($path)) {
      foreach (file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        if (substr($line, 0, 1) === '#') continue;
        $p = explode('=', $line, 2);
        if (count($p) === 2) $env[trim($p[0])] = trim($p[1]);
      }
    }
  }
  $v = getenv($key);
  return $v !== false ? $v : ($env[$key] ?? $default);
}

function flext_db() {
  static $pdo = null;
  if ($pdo === null) {
    $host = flext_env('DB_HOST', 'localhost');
    $port = flext_env('DB_PORT', '3306');
    $name = flext_env('DB_NAME', '');
    $pdo = new PDO(
      "mysql:host=$host;port=$port;dbname=$name;charset=utf8mb4",
      flext_env('DB_USER', 'root'),
      flext_env('DB_PASSWORD', ''),
      [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
  }
  return $pdo;
}

function flext_cors() { header('Access-Control-Allow-Origin: *'); }

function flext_respond($success, $data = null, $error = null, $meta = null, $status = 200) {
  flext_cors();
  http_response_code($status);
  header('Content-Type: application/json; charset=utf-8');
  $out = ['success' => $success, 'data' => $data, 'error' => $error];
  if ($meta !== null) $out['meta'] = $meta;
  echo json_encode($out);
  exit;
}

function flext_input() {
  if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') return $_GET;
  $ct = $_SERVER['CONTENT_TYPE'] ?? '';
  if (strpos($ct, 'application/json') !== false) {
    $j = json_decode(file_get_contents('php://input'), true);
    return is_array($j) ? array_merge($_GET, $j) : $_GET;
  }
  return array_merge($_GET, $_POST);
}

function flext_page($defaultPer = 20, $maxPer = 100) {
  $page = max(1, (int)($_GET['page'] ?? 1));
  $per = (int)($_GET['perPage'] ?? $defaultPer);
  if ($per < 1) $per = $defaultPer;
  if ($per > $maxPer) $per = $maxPer;
  return ['page' => $page, 'perPage' => $per, 'offset' => ($page - 1) * $per];
}

function flext_meta($pg, $total) {
  $totalPages = $total <= 0 ? 1 : (int)ceil($total / $pg['perPage']);
  return [
    'page' => $pg['page'], 'perPage' => $pg['perPage'],
    'total' => $total, 'totalPages' => $totalPages,
    'hasNext' => $pg['page'] < $totalPages, 'hasPrev' => $pg['page'] > 1,
  ];
}

$flext_result = null;
''';
}
