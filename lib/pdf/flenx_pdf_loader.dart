/// Carregamento de arquivos locais (fontes/imagens) para o gerador de PDF.
///
/// No servidor/tool (dart:io) lê do filesystem; no navegador (dart2js) não há
/// filesystem, então o stub devolve `null` e o chamador injeta os bytes de
/// outra forma (fontes embutidas / imagens pré-carregadas via `preloadedImages`).
library;

export 'flenx_pdf_loader_stub.dart'
    if (dart.library.io) 'flenx_pdf_loader_io.dart';
