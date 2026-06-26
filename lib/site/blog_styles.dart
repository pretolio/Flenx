/// CSS do blog — listagem em cards e artigo com tipografia legível (prose).
/// Usa os tokens (:root) definidos em flenxSiteCss.
const String blogCss = '''
.blog-main{padding:48px 0 80px;min-height:60vh}
.blog-archive>header,.taxonomy-index>header{display:flex;flex-direction:column;align-items:flex-start;gap:6px;text-align:left;margin-bottom:28px}
.blog-archive h1,.taxonomy-index h1{font-size:2.2rem;margin:0;line-height:1.15;letter-spacing:-.02em}
.blog-archive>header p{color:var(--muted);margin:0;font-size:1.05rem}
.blog-search{display:flex;gap:10px;margin:0 0 16px;max-width:520px}
.blog-search-input{flex:1;padding:11px 14px;border:1px solid var(--border);border-radius:10px;font:inherit;font-size:.95rem}
.blog-search-input:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(1,88,155,.15)}
.blog-filters{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin:0 0 28px}
.filter-label{font-size:.85rem;color:var(--muted);font-weight:600;margin-right:2px}
.chip{font-size:.85rem;padding:5px 12px;border-radius:9999px;background:#eef2f7;color:#334155;text-decoration:none;border:1px solid transparent;transition:.15s}
.chip:hover{background:#e0f2fe;color:#01589B;border-color:#cbe9fd}
.chip-tag{background:#fff;border-color:var(--border);color:#0369a1}
.chip-tag:hover{background:#f0f9ff}
.blog-section-title{font-size:1.25rem;margin:30px 0 16px;letter-spacing:-.01em}
.blog-empty{color:var(--muted);padding:18px 0}
.pagination{display:flex;gap:8px;justify-content:center;align-items:center;margin:40px 0 0;flex-wrap:wrap}
.page-btn{min-width:40px;text-align:center;padding:9px 14px;border:1px solid var(--border);border-radius:10px;color:var(--ink);text-decoration:none;font-weight:600;font-size:.92rem;background:#fff;transition:.15s}
.page-btn:hover{border-color:var(--primary);color:var(--primary)}
.page-btn.active{background:var(--primary);color:#fff;border-color:var(--primary)}
.post-list{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:22px}
.post-card{background:#fff;border:1px solid var(--border);border-radius:16px;padding:22px;transition:.18s}
.post-card:hover{box-shadow:0 14px 36px rgba(2,32,71,.10);transform:translateY(-3px);border-color:#cdd9e8}
.post-card a{text-decoration:none}
.post-card h2{font-size:1.2rem;margin:0 0 8px;color:var(--ink)}
.post-card .excerpt{color:var(--muted);margin:0 0 14px;font-size:.95rem}
.post-card .meta{display:flex;gap:12px;align-items:center;font-size:.84rem;color:var(--muted);flex-wrap:wrap}
.post-card .cat{background:#e0f2fe;color:#01589B;padding:3px 10px;border-radius:9999px;text-decoration:none;font-weight:600}
.post-card .tags{margin-top:12px;display:flex;gap:10px;flex-wrap:wrap}
.tag{font-size:.82rem;color:#0369a1;text-decoration:none}
.tag:hover{text-decoration:underline}
.blog-post{max-width:760px;margin:0 auto}
.breadcrumb{font-size:.88rem;color:var(--muted);margin-bottom:18px}
.breadcrumb a{color:var(--primary);text-decoration:none}
.breadcrumb a:hover{text-decoration:underline}
.blog-post>header h1{font-size:2.4rem;line-height:1.12;letter-spacing:-.02em;margin:0 0 12px}
.blog-post>header .subtitle{font-size:1.25rem;line-height:1.4;color:#475569;margin:0 0 16px;font-weight:400}
.blog-post>header .meta{display:flex;gap:14px;color:var(--muted);font-size:.9rem;margin-bottom:28px}
.blog-post figure.cover{margin:0 0 28px}
.blog-post figure.cover img{width:100%;height:auto;border-radius:14px;display:block}
.content figure{margin:24px 0}
.content figure img{width:100%;height:auto;border-radius:12px;display:block}
.content figure figcaption{font-size:.86rem;color:var(--muted);margin-top:8px;line-height:1.5}
.content figure figcaption .credit{color:#94a3b8;font-style:italic}
.content .embed{margin:24px 0}
.content .embed iframe{width:100%;aspect-ratio:16/9;border:0;border-radius:12px}
.content{font-size:1.08rem;line-height:1.8;color:#1f2937}
.content h2{font-size:1.5rem;margin:34px 0 12px;letter-spacing:-.01em}
.content h3{font-size:1.2rem;margin:24px 0 8px}
.content p{margin:0 0 16px}
.content ul,.content ol{margin:0 0 16px;padding-left:22px}
.content li{margin:6px 0}
.content a{color:var(--primary)}
.content pre{background:#0b1220;color:#e2e8f0;padding:18px 20px;border-radius:12px;overflow-x:auto;font-size:.9rem;margin:0 0 18px;line-height:1.6}
.content code{font-family:ui-monospace,SFMono-Regular,Menlo,monospace}
.content :not(pre)>code{background:#f1f5f9;padding:2px 6px;border-radius:6px;font-size:.9em}
.content blockquote{border-left:4px solid var(--primary);margin:0 0 18px;padding:8px 16px;color:#475569;background:#f8fafc;border-radius:0 8px 8px 0}
.blog-post>footer.tags{margin-top:32px;padding-top:20px;border-top:1px solid var(--border);display:flex;gap:12px;flex-wrap:wrap}
.taxonomy-list{list-style:none;padding:0;display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px}
.taxonomy-list li{background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px 16px}
.taxonomy-list a{color:var(--ink);text-decoration:none;font-weight:600}
.taxonomy-list a:hover{color:var(--primary)}
.taxonomy-list .count{color:var(--muted);font-weight:400}
''';
