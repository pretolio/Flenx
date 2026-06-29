/// CSS do kit de e-commerce (loja estilo marketplace de moda). Injetado uma
/// única vez pelo [FlenxStoreShell]. Os componentes só emitem elementos com
/// estas classes — o app nunca escreve HTML/CSS.
const flenxCommerceCss = r'''
.fxz{font-family:'Inter',system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:#222}
.fxz *{box-sizing:border-box}
.fxz a{text-decoration:none;color:inherit}
.fxz-wrap{max-width:1180px;margin:0 auto;padding:0 16px}

/* topo */
.fxz-top{background:#1f1f1f;color:#fff}
.fxz-top-in{display:flex;align-items:center;gap:20px;padding:12px 0}
.fxz-logo{font-weight:900;font-size:24px;letter-spacing:-1px;color:#fff;white-space:nowrap}
.fxz-logo b{color:#e2231a}
.fxz-cep{display:flex;align-items:center;gap:6px;font-size:12px;color:#cfcfcf;white-space:nowrap}
.fxz-cep strong{color:#fff;display:block}
.fxz-search{flex:1;display:flex;background:#fff;border-radius:6px;overflow:hidden;min-width:160px}
.fxz-search input{flex:1;border:0;padding:11px 14px;font-size:14px;outline:none}
.fxz-search button{border:0;background:#fff;color:#1f1f1f;padding:0 16px;cursor:pointer;font-size:18px}
.fxz-acts{display:flex;align-items:center;gap:22px;white-space:nowrap}
.fxz-act{display:flex;align-items:center;gap:7px;font-size:13px;color:#fff}
.fxz-act .ic{font-size:19px}
.fxz-cart{position:relative}
.fxz-cart .badge{position:absolute;top:-8px;right:-10px;background:#e2231a;color:#fff;border-radius:999px;font-size:11px;font-weight:700;min-width:18px;height:18px;display:grid;place-items:center;padding:0 4px}

/* nav + promo */
.fxz-nav{background:#fff;border-bottom:1px solid #eee}
.fxz-nav-in{display:flex;gap:26px;overflow-x:auto}
.fxz-nav a{padding:14px 2px;font-size:14px;font-weight:700;color:#333;border-bottom:3px solid transparent;white-space:nowrap}
.fxz-nav a:hover{color:#e2231a;border-bottom-color:#e2231a}
.fxz-nav a.sale{color:#e2231a}
.fxz-promo{background:#111;color:#fff;text-align:center;font-size:13.5px;padding:9px 16px}
.fxz-promo b{color:#ffd54a}

/* hero */
.fxz-hero{position:relative;background:linear-gradient(120deg,#7a5638,#b5824f 60%,#caa06b);color:#fff;overflow:hidden}
.fxz-hero-in{max-width:1180px;margin:0 auto;padding:54px 60px;display:flex;align-items:center;justify-content:space-between;min-height:300px}
.fxz-hero h2{font-size:52px;font-weight:900;letter-spacing:-1px;margin:0}
.fxz-hero p{font-size:18px;opacity:.92;margin:6px 0 0}
.fxz-hero .eyebrow{font-weight:800;letter-spacing:3px;text-transform:uppercase;font-size:13px;opacity:.9}
.fxz-hero .price{text-align:right}
.fxz-hero .price small{display:block;font-size:14px;opacity:.9}
.fxz-hero .price .big{font-size:60px;font-weight:900;line-height:1}
.fxz-hero .cta{display:inline-block;margin-top:14px;background:#f3c98b;color:#3a2a17;font-weight:800;padding:12px 30px;border-radius:6px}
.fxz-arrow{position:absolute;top:50%;transform:translateY(-50%);width:42px;height:42px;border-radius:50%;background:rgba(255,255,255,.85);color:#333;display:grid;place-items:center;font-size:22px;font-weight:700}
.fxz-arrow.l{left:14px}.fxz-arrow.r{right:14px}
.fxz-dots{position:absolute;bottom:14px;left:50%;transform:translateX(-50%);display:flex;gap:8px}
.fxz-dots span{width:9px;height:9px;border-radius:50%;background:rgba(255,255,255,.5)}
.fxz-dots span.on{background:#fff}

/* pílulas de preço */
.fxz-pills{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;padding:18px 0}
.fxz-pill{background:#1f1f1f;color:#fff;border-radius:8px;text-align:center;padding:16px;font-weight:800;font-size:15px}
.fxz-pill b{color:#ffd54a;font-size:20px;display:block;margin-top:2px}

/* marcas */
.fxz-brands{display:grid;grid-template-columns:repeat(6,1fr);gap:12px;padding:8px 0 24px}
.fxz-brand{border:1px solid #eee;border-radius:10px;overflow:hidden;text-align:center;transition:.15s}
.fxz-brand:hover{box-shadow:0 10px 26px rgba(0,0,0,.10);transform:translateY(-3px)}
.fxz-brand .pic{height:120px;display:grid;place-items:center;font-size:48px;background:linear-gradient(135deg,#f3f5f8,#e7ecf2)}
.fxz-brand .cf{display:block;background:#1f1f1f;color:#fff;font-weight:700;font-size:13px;padding:9px}

/* prateleira */
.fxz-shelf{padding:8px 0 28px}
.fxz-shelf-head{background:#e2231a;color:#fff;border-radius:8px 8px 0 0;display:flex;align-items:center;gap:16px;padding:12px 18px}
.fxz-shelf-head .t{font-weight:900;font-size:18px}
.fxz-clock{display:flex;gap:6px;align-items:center}
.fxz-clock b{background:#111;color:#fff;border-radius:5px;padding:5px 8px;font-size:15px;font-weight:800;min-width:30px;text-align:center}
.fxz-shelf-head .sub{margin-left:auto;font-size:13px;opacity:.95}
.fxz-carousel{display:flex;gap:14px;overflow-x:auto;padding:18px;border:1px solid #eee;border-top:0;border-radius:0 0 8px 8px;scroll-snap-type:x mandatory}

/* card de produto */
.fxz-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;padding:8px 0 32px}
.fxz-card{flex:0 0 240px;scroll-snap-align:start;border:1px solid #eee;border-radius:10px;background:#fff;padding:12px;position:relative;transition:.15s;display:flex;flex-direction:column}
.fxz-grid .fxz-card{flex:auto}
.fxz-card:hover{box-shadow:0 12px 30px rgba(0,0,0,.12);transform:translateY(-3px)}
.fxz-card .heart{position:absolute;top:12px;right:12px;font-size:18px;color:#bbb}
.fxz-badge{position:absolute;top:12px;left:12px;background:#1b9e4b;color:#fff;font-weight:800;font-size:12px;padding:3px 8px;border-radius:5px}
.fxz-pic{height:180px;display:grid;place-items:center;font-size:72px;background:linear-gradient(135deg,#f6f8fb,#eef2f7);border-radius:8px;margin-bottom:10px}
.fxz-card .brand{font-size:11px;font-weight:800;letter-spacing:1px;text-transform:uppercase;color:#888}
.fxz-card .name{font-size:13.5px;color:#333;margin:3px 0 8px;line-height:1.35;min-height:38px}
.fxz-card .old{font-size:12px;color:#aaa;text-decoration:line-through}
.fxz-card .price{font-size:19px;font-weight:900;color:#111}
.fxz-card .inst{font-size:12px;color:#1b9e4b;font-weight:700;margin-top:2px}
.fxz-card .buy{margin-top:10px;display:block;text-align:center;background:#e2231a;color:#fff;font-weight:800;font-size:13px;padding:10px;border-radius:6px}
.fxz-card .buy:hover{background:#b71c14}

/* benefícios + rodapé */
.fxz-benes{display:flex;justify-content:center;gap:60px;flex-wrap:wrap;background:#f6f7f9;padding:22px 16px;border-top:1px solid #eee}
.fxz-bene{display:flex;align-items:center;gap:12px;font-size:14px;color:#444}
.fxz-bene .ic{font-size:26px}
.fxz-bene b{display:block;color:#111}
.fxz-foot{background:#1f1f1f;color:#bdbdbd;padding:40px 16px 16px}
.fxz-foot-cols{max-width:1180px;margin:0 auto;display:grid;grid-template-columns:repeat(4,1fr);gap:24px}
.fxz-foot h4{color:#fff;font-size:14px;margin:0 0 12px}
.fxz-foot a{display:block;color:#bdbdbd;font-size:13px;padding:4px 0}
.fxz-foot a:hover{color:#fff}
.fxz-pay{display:flex;gap:6px;flex-wrap:wrap;margin-top:8px}
.fxz-pay span{background:#333;border-radius:4px;padding:4px 8px;font-size:11px;font-weight:700;color:#eee}
.fxz-foot-bottom{max-width:1180px;margin:24px auto 0;border-top:1px solid #333;padding-top:16px;font-size:12px;color:#8a8a8a;text-align:center}
.fxz-sec-title{font-size:22px;font-weight:900;letter-spacing:-.5px;margin:6px 0 0}

/* detalhe do produto */
.fxz-crumb{font-size:13px;color:#888;padding:14px 0}
.fxz-crumb a:hover{color:#e2231a}
.fxz-pd{display:grid;grid-template-columns:1fr 1fr;gap:40px;padding:8px 0 32px;align-items:start}
.fxz-pd-pic{height:440px;display:grid;place-items:center;font-size:180px;background:linear-gradient(135deg,#f6f8fb,#eef2f7);border-radius:14px;position:relative}
.fxz-pd-pic .b{position:absolute;top:16px;left:16px;background:#1b9e4b;color:#fff;font-weight:800;font-size:13px;padding:4px 10px;border-radius:6px}
.fxz-pd-info .brand{font-size:12px;font-weight:800;letter-spacing:1px;text-transform:uppercase;color:#888}
.fxz-pd-info h1{font-size:30px;font-weight:900;letter-spacing:-.5px;margin:4px 0 14px;line-height:1.15}
.fxz-pd-info .old{font-size:15px;color:#aaa;text-decoration:line-through}
.fxz-pd-info .price{font-size:34px;font-weight:900;color:#111;margin:2px 0}
.fxz-pd-info .inst{font-size:14px;color:#1b9e4b;font-weight:700}
.fxz-pd-info .desc{color:#555;line-height:1.7;margin:18px 0;font-size:15px}
.fxz-pd-buys{display:flex;gap:12px;flex-wrap:wrap;margin-top:8px}
.fxz-pd-buys a{font-weight:800;font-size:15px;padding:14px 28px;border-radius:8px}
.fxz-pd-buys .buy{background:#e2231a;color:#fff}
.fxz-pd-buys .buy:hover{background:#b71c14}
.fxz-pd-buys .ghost{background:#fff;color:#1f1f1f;border:1.5px solid #ddd}

@media(max-width:900px){
  .fxz-pd{grid-template-columns:1fr}.fxz-pd-pic{height:300px;font-size:120px}
  .fxz-pills,.fxz-brands{grid-template-columns:repeat(2,1fr)}
  .fxz-foot-cols{grid-template-columns:repeat(2,1fr)}
  .fxz-hero h2{font-size:34px}.fxz-hero .price .big{font-size:40px}
  .fxz-hero-in{padding:32px 24px;flex-direction:column;gap:16px;align-items:flex-start}
}
''';
