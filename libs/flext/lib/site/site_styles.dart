import '../flext_palette.dart';

/// CSS do site institucional Flext — visual moderno (estilo Astra/landing).
/// As variáveis de cor (`:root`) vêm da paleta central [FlextPalette].
String get flextSiteCss => '${_rootVars}\n$_flextSiteBody';

/// `:root` gerado a partir da paleta central (fonte única de cores).
String get _rootVars => ':root{'
    '--ink:${FlextPalette.ink};--muted:${FlextPalette.muted};'
    '--primary:${FlextPalette.primary};--primary-d:${FlextPalette.primaryDark};'
    '--accent:${FlextPalette.accent};--surface:${FlextPalette.surface};'
    '--border:${FlextPalette.border}}';

const String _flextSiteBody = '''
html{scroll-behavior:smooth}
.flext-site{font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;color:var(--ink);line-height:1.6}
.flext-site *{box-sizing:border-box}
/* Compensa o header fixo ao pular para âncoras (#recursos, #contato) */
.flext-site section[id]{scroll-margin-top:84px}
.container{max-width:1120px;margin:0 auto;padding:0 20px}
.section{padding:88px 0}
.section-sm{padding:56px 0}
.eyebrow{color:var(--primary);font-weight:700;letter-spacing:.08em;text-transform:uppercase;font-size:.8rem;margin:0 0 10px}
h2.title{font-size:2.2rem;line-height:1.15;margin:0 0 14px;letter-spacing:-.02em}
.lead{color:var(--muted);font-size:1.1rem;max-width:680px}
.center{text-align:center;margin-left:auto;margin-right:auto}
.btn{display:inline-flex;align-items:center;gap:8px;padding:13px 24px;border-radius:9999px;font-weight:700;text-decoration:none;cursor:pointer;border:none;font-size:1rem;transition:.18s}
.btn-primary{background:var(--primary);color:#fff}
.btn-primary:hover{background:var(--primary-d);transform:translateY(-1px)}
.btn-ghost{background:rgba(255,255,255,.12);color:#fff;border:1px solid rgba(255,255,255,.4)}
.btn-ghost:hover{background:rgba(255,255,255,.2)}
/* HERO */
.hero{background:linear-gradient(135deg,#062744 0%,#01589B 55%,#0ea5e9 120%);color:#fff;padding:110px 0 96px;position:relative;overflow:hidden}
.hero h1{font-size:3.2rem;line-height:1.07;letter-spacing:-.03em;margin:0 0 18px;max-width:18ch}
.hero p{font-size:1.25rem;color:#dbeafe;max-width:60ch;margin:0 0 30px}
.hero-actions{display:flex;gap:14px;flex-wrap:wrap}
.hero-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:48px;align-items:center}
.code-card{background:#0b1220;border:1px solid #1e293b;border-radius:16px;box-shadow:0 30px 60px rgba(0,0,0,.35);overflow:hidden}
.code-card .bar{display:flex;gap:7px;padding:14px 16px;border-bottom:1px solid #1e293b}
.code-card .bar i{width:12px;height:12px;border-radius:50%}
.dot-r{background:#ff5f56}.dot-y{background:#ffbd2e}.dot-g{background:#27c93f}
.code-card pre{margin:0;padding:20px;color:#e2e8f0;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:.86rem;line-height:1.7;overflow-x:auto}
.code-card .k{color:#7dd3fc}.code-card .s{color:#86efac}.code-card .c{color:#64748b}
/* TRUST */
.trust{background:var(--surface);border-top:1px solid var(--border);border-bottom:1px solid var(--border)}
.trust .row{display:flex;gap:36px;flex-wrap:wrap;justify-content:center;align-items:center;color:var(--muted);font-weight:600}
.trust b{color:var(--ink)}
/* FEATURES */
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:22px}
.card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:26px;transition:.18s}
.card:hover{box-shadow:0 16px 40px rgba(2,32,71,.10);transform:translateY(-3px);border-color:#cdd9e8}
.card .ico{width:50px;height:50px;border-radius:14px;display:grid;place-items:center;font-size:1.5rem;background:linear-gradient(135deg,#e0f2fe,#dbeafe);margin-bottom:16px}
.card h3{margin:0 0 8px;font-size:1.15rem}
.card p{margin:0;color:var(--muted)}
/* STEPS */
.steps{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:22px;counter-reset:s}
.step{padding:24px;border-radius:16px;background:var(--surface);border:1px solid var(--border)}
.step .n{width:36px;height:36px;border-radius:50%;background:var(--primary);color:#fff;display:grid;place-items:center;font-weight:700;margin-bottom:14px}
/* CTA BAND */
.cta{background:linear-gradient(135deg,#01589B,#0ea5e9);color:#fff;border-radius:24px;padding:56px;text-align:center}
.cta h2{font-size:2rem;margin:0 0 10px}
.cta p{color:#dbeafe;margin:0 0 24px}
/* LEAD */
.lead-grid{display:grid;grid-template-columns:1fr 1fr;gap:48px;align-items:center}
.lead-list{list-style:none;padding:0;margin:18px 0 0}
.lead-list li{display:flex;gap:10px;margin:10px 0;color:var(--muted)}
.lead-list b{color:var(--ink)}
.lead-card{background:#fff;border:1px solid var(--border);border-radius:20px;padding:28px;box-shadow:0 20px 50px rgba(2,32,71,.08)}
.lead-form{display:flex;flex-direction:column;gap:14px}
.lead-row{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.fld-group{display:flex;flex-direction:column;gap:6px}
.fld-label{font-weight:600;font-size:.9rem}
.fld{width:100%;padding:12px 14px;border:1px solid var(--border);border-radius:10px;font:inherit;font-size:.95rem;background:#fff}
.fld:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(1,88,155,.15)}
.lead-submit{background:var(--primary);color:#fff;border:none;padding:13px;border-radius:10px;font-weight:700;cursor:pointer;font-size:1rem}
.lead-submit:hover{background:var(--primary-d)}
.lead-success{text-align:center;background:#ecfdf5;border:1px solid #a7f3d0;border-radius:20px;padding:36px}
.lead-check{width:56px;height:56px;border-radius:50%;background:#10b981;color:#fff;font-size:1.8rem;display:grid;place-items:center;margin:0 auto 14px}
/* FOOTER */
.foot{background:#0b1220;color:#94a3b8;padding:56px 0 28px}
.foot a{color:#cbd5e1;text-decoration:none;display:block;margin:7px 0}
.foot a:hover{color:#fff}
.foot-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:32px}
.foot h4{color:#fff;margin:0 0 12px;font-size:.95rem}
.foot .brand{font-weight:800;color:#fff;font-size:1.3rem}
.foot-bottom{border-top:1px solid #1e293b;margin-top:36px;padding-top:20px;font-size:.85rem;text-align:center}
/* 404 */
.notfound{text-align:center;padding:72px 0;min-height:46vh}
.nf-code{font-size:6.5rem;font-weight:800;color:var(--primary);line-height:1;letter-spacing:-.04em}
.notfound h1{font-size:2rem;margin:6px 0 10px}
.notfound p{color:var(--muted);margin:0 auto 26px;max-width:46ch}
.nf-actions{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
.btn-soft{background:#e0f2fe;color:#01589B}
.btn-soft:hover{background:#cbe9fd}
/* WHATSAPP FAB */
.whatsapp-fab{position:fixed;right:22px;bottom:22px;z-index:60;display:inline-flex;align-items:center;gap:10px;background:#25d366;color:#fff;padding:14px 20px;border-radius:9999px;text-decoration:none;font-weight:700;box-shadow:0 12px 30px rgba(37,211,102,.45);transition:.18s}
.whatsapp-fab:hover{transform:translateY(-2px) scale(1.03)}
.wa-icon{font-size:1.25rem}
@media (max-width:860px){
 .hero{padding:84px 0 72px}.hero h1{font-size:2.3rem}
 .hero-grid,.lead-grid{grid-template-columns:1fr;gap:32px}
 .code-card{order:2}
 h2.title{font-size:1.8rem}
 .cta{padding:40px 22px}
 .lead-row{grid-template-columns:1fr}
 .foot-grid{grid-template-columns:1fr 1fr}
 .wa-label{display:none}
}
''';
