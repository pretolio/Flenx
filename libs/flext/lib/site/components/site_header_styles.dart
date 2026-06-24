/// CSS do header institucional. Dropdowns por `:hover`/`:focus-within`; menu
/// mobile por checkbox-hack (`:checked ~ .nav-wrap`). Zero JavaScript (SSR/SEO).
const String siteHeaderCss = '''
.site-header{display:block;position:sticky;top:0;z-index:50;background:#fff;border-bottom:1px solid #e5e7eb;font-family:system-ui,-apple-system,sans-serif}
.header-inner{max-width:1120px;margin:0 auto;padding:0 20px;height:64px;display:flex;align-items:center;gap:20px}
.brand{flex-shrink:0;display:flex;align-items:center;gap:8px;text-decoration:none;color:#01589B;font-weight:800;font-size:1.25rem}
.brand-img{height:32px}
.nav-toggle{display:none}
.hamburger{display:none;cursor:pointer;font-size:1.6rem;line-height:1;color:#01589B;padding:6px;user-select:none}
/* Padrão: logo à esquerda, menus à direita */
.nav-wrap{display:flex;align-items:center;gap:24px;margin-left:auto}
/* Opção: menus centralizados (logo esq., login dir.) */
.nav-center .nav-wrap{flex:1;margin-left:0}
.nav-center .nav-list{margin-left:auto;margin-right:auto}
.nav-list{display:flex;align-items:center;gap:4px;list-style:none;margin:0;padding:0}
.nav-item{position:relative}
.nav-link{display:flex;align-items:center;gap:4px;padding:10px 12px;color:#1f2937;text-decoration:none;border-radius:8px;cursor:pointer;font-size:.95rem}
.nav-link:hover{background:#f3f4f6;color:#01589B}
.caret{font-size:.7rem}
.dropdown{position:absolute;top:100%;left:0;min-width:210px;background:#fff;border:1px solid #e5e7eb;border-radius:10px;box-shadow:0 8px 24px rgba(0,0,0,.08);list-style:none;margin:6px 0 0;padding:6px;opacity:0;visibility:hidden;transform:translateY(6px);transition:.15s ease}
.has-dropdown:hover>.dropdown,.has-dropdown:focus-within>.dropdown{opacity:1;visibility:visible;transform:none}
.dropdown li a{display:block;padding:9px 12px;color:#374151;text-decoration:none;border-radius:6px;font-size:.92rem}
.dropdown li a:hover{background:#f3f4f6;color:#01589B}
.dropdown-right{left:auto;right:0}
.login-btn{display:inline-flex;align-items:center;gap:6px;background:#01589B;color:#fff;padding:9px 18px;border-radius:9999px;text-decoration:none;font-weight:600;cursor:pointer;border:none;font-size:.95rem}
.login-btn:hover{background:#014478}
.login-menu{position:relative}
@media (max-width:860px){
 .hamburger{display:block}
 .nav-wrap{display:none;position:absolute;top:64px;left:0;right:0;flex-direction:column;align-items:stretch;gap:0;background:#fff;border-bottom:1px solid #e5e7eb;padding:10px;box-shadow:0 10px 24px rgba(0,0,0,.08)}
 .nav-toggle:checked ~ .nav-wrap{display:flex}
 .nav-list{flex-direction:column;align-items:stretch;gap:0;width:100%}
 .dropdown{position:static;opacity:1;visibility:visible;transform:none;box-shadow:none;border:none;margin:0 0 0 12px;min-width:auto}
 .login-btn{justify-content:center;margin-top:10px}
}
''';
