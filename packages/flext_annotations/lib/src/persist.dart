/// Habilita **storage automático** do estado em memória de um container/store.
///
/// O code-gen produz `toJson`/`fromJson` e a integração com o backend de
/// persistência (Hive/IndexedDB na web, arquivo/SQLite no servidor). Inspirado
/// em hydrated_bloc/redux-persist, com migrations versionadas.
class Persist {
  /// Versão do schema persistido. Incremente ao mudar o formato do estado.
  final int version;

  /// Chaves a NÃO persistir (segredos, estado efêmero, valores derivados).
  final List<String> exclude;

  /// Debounce de escrita em milissegundos (evita gravar a cada mutação).
  final int debounceMs;

  const Persist({
    this.version = 1,
    this.exclude = const [],
    this.debounceMs = 300,
  });
}

/// Atalho conveniente: `@persist`.
const persist = Persist();
