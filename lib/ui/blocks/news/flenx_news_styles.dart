import '../../../flenx_palette.dart';

/// CSS dos blocos de notícia (estilo portal). O destaque usa `var(--primary)`,
/// herdando a cor primária definida no [FlenxPage] — sem cor fixa.
const flenxNewsCss =
    '''
.fnews-edit{display:flex;gap:22px;overflow-x:auto;scrollbar-width:none;padding:10px 0;}
.fnews-edit::-webkit-scrollbar{display:none;}
.fnews-edit a{color:${FlenxPalette.ink};font-size:14px;font-weight:700;text-decoration:none;white-space:nowrap;transition:color .15s;}
.fnews-edit a:hover{color:var(--primary);}
.fnews-hat{color:var(--primary);font-size:12px;font-weight:800;letter-spacing:.04em;text-transform:uppercase;}
.fnews-card{display:block;text-decoration:none;}
.fnews-thumb{overflow:hidden;border-radius:4px;}
.fnews-card img,.fnews-lead img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .35s ease;}
.fnews-card:hover img,.fnews-lead:hover img{transform:scale(1.04);}
.fnews-card .fnews-title{color:${FlenxPalette.ink};font-weight:700;line-height:1.25;transition:color .15s;}
.fnews-card:hover .fnews-title{color:var(--primary);}
.fnews-lead{display:block;text-decoration:none;}
.fnews-lead .fnews-title{color:${FlenxPalette.ink};font-weight:800;line-height:1.1;font-size:clamp(26px,4vw,42px);transition:color .15s;}
.fnews-lead:hover .fnews-title{color:var(--primary);}
.fnews-mr a{text-decoration:none;color:${FlenxPalette.ink};font-weight:700;line-height:1.3;transition:color .15s;}
.fnews-mr a:hover{color:var(--primary);}
.fnews-logo{display:inline-flex;align-items:baseline;gap:2px;background:var(--primary);color:#fff;padding:6px 12px;border-radius:8px;text-decoration:none;font-weight:900;letter-spacing:-.02em;}
.fnews-cols{display:flex;flex-wrap:wrap;gap:40px;align-items:flex-start;}
.fnews-cols>.fnews-main{flex:2 1 380px;min-width:0;}
.fnews-cols>.fnews-aside{flex:1 1 280px;min-width:0;}
''';
