//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

final imdbHtmlSampleInner = r'''
<tr class="findResult odd">
  <td class="primary_photo"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1"><img src="https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1">Wonder Woman</a> (2017) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2"><img src="https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2">Wonder Woman</a> (1975) (TV Series) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3"><img src="https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3">Wonder Woman</a> (2011) (TV Movie) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4"><img src="https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4">Wonder Woman 1984</a> (2020) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5"><img src="https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5">Wonder Woman: Bloodlines</a> (2019) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6"><img src="https://m.media-amazon.com/images/S/sash/85lhIiFCmSScRzu.png"></a> </td> 
  <td class="result_text"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6">Wonder Woman 3</a> </td> 
</tr>
''';

final imdbHtmlSampleFull = r'''




<!DOCTYPE html>
<html
    xmlns:og="http://ogp.me/ns#"
    xmlns:fb="http://www.facebook.com/2008/fbml">
    <head>
        
<script type='text/javascript'>var ue_t0=ue_t0||+new Date();</script>
<script type='text/javascript'>
window.ue_ihb = (window.ue_ihb || window.ueinit || 0) + 1;
if (window.ue_ihb === 1) {

var ue_csm = window,
    ue_hob = +new Date();
(function(d){var e=d.ue=d.ue||{},f=Date.now||function(){return+new Date};e.d=function(b){return f()-(b?0:d.ue_t0)};e.stub=function(b,a){if(!b[a]){var c=[];b[a]=function(){c.push([c.slice.call(arguments),e.d(),d.ue_id])};b[a].replay=function(b){for(var a;a=c.shift();)b(a[0],a[1],a[2])};b[a].isStub=1}};e.exec=function(b,a){return function(){try{return b.apply(this,arguments)}catch(c){ueLogError(c,{attribution:a||"undefined",logLevel:"WARN"})}}}})(ue_csm);


    var ue_err_chan = 'jserr';
(function(d,e){function h(f,b){if(!(a.ec>a.mxe)&&f){a.ter.push(f);b=b||{};var c=f.logLevel||b.logLevel;c&&c!==k&&c!==m&&c!==n&&c!==p||a.ec++;c&&c!=k||a.ecf++;b.pageURL=""+(e.location?e.location.href:"");b.logLevel=c;b.attribution=f.attribution||b.attribution;a.erl.push({ex:f,info:b})}}function l(a,b,c,e,g){d.ueLogError({m:a,f:b,l:c,c:""+e,err:g,fromOnError:1,args:arguments},g?{attribution:g.attribution,logLevel:g.logLevel}:void 0);return!1}var k="FATAL",m="ERROR",n="WARN",p="DOWNGRADED",a={ec:0,ecf:0,
pec:0,ts:0,erl:[],ter:[],mxe:50,startTimer:function(){a.ts++;setInterval(function(){d.ue&&a.pec<a.ec&&d.uex("at");a.pec=a.ec},1E4)}};l.skipTrace=1;h.skipTrace=1;h.isStub=1;d.ueLogError=h;d.ue_err=a;e.onerror=l})(ue_csm,window);


var ue_id = 'YAQYHQZAPJWQPCYD78VQ',
    ue_url,
    ue_navtiming = 1,
    ue_mid = 'A1EVAM02EL8SFB',
    ue_sid = '137-3442349-9635931',
    ue_sn = 'www.imdb.com',
    ue_furl = 'fls-na.amazon.com',
    ue_surl = 'https://unagi-na.amazon.com/1/events/com.amazon.csm.nexusclient.prod',
    ue_int = 0,
    ue_fcsn = 1,
    ue_urt = 3,
    ue_rpl_ns = 'cel-rpl',
    ue_ddq = 1,
    ue_fpf = '//fls-na.amazon.com/1/batch/1/OP/A1EVAM02EL8SFB:137-3442349-9635931:YAQYHQZAPJWQPCYD78VQ$uedata=s:',
    ue_sbuimp = 1,
    ue_ibft = 0,
    ue_fnt = 0,

    ue_swi = 1;
var ue_viz=function(){(function(b,e,a){function k(c){if(b.ue.viz.length<p&&!l){var a=c.type;c=c.originalEvent;/^focus./.test(a)&&c&&(c.toElement||c.fromElement||c.relatedTarget)||(a=e[m]||("blur"==a||"focusout"==a?"hidden":"visible"),b.ue.viz.push(a+":"+(+new Date-b.ue.t0)),"visible"==a&&(b.ue.isl&&q("at"),l=1))}}for(var l=0,q=b.uex,f,g,m,n=["","webkit","o","ms","moz"],d=0,p=20,h=0;h<n.length&&!d;h++)if(a=n[h],f=(a?a+"H":"h")+"idden",d="boolean"==typeof e[f])g=a+"visibilitychange",m=(a?a+"V":"v")+
"isibilityState";k({});d&&e.addEventListener(g,k,0);b.ue&&d&&(b.ue.pageViz={event:g,propHid:f})})(ue_csm,ue_csm.document,ue_csm.window)};

(function(d,k,K){function G(a){return a&&a.replace&&a.replace(/^\s+|\s+$/g,"")}function q(a){return"undefined"===typeof a}function C(a,b){for(var c in b)b[t](c)&&(a[c]=b[c])}function L(a){try{var b=K.cookie.match(RegExp("(^| )"+a+"=([^;]+)"));if(b)return b[2].trim()}catch(c){}}function M(n,b,c){var e=(x||{}).type;if("device"!==c||2!==e&&1!==e)n&&(d.ue_id=a.id=a.rid=n,y=y.replace(/((.*?:){2})(\w+)/,function(a,b){return b+n})),b&&(y=y.replace(/(.*?:)(\w|-)+/,function(a,c){return c+b}),d.ue_sid=b),c&&
a.tag("page-source:"+c),d.ue_fpf=y}function O(){var a={};return function(b){b&&(a[b]=1);b=[];for(var c in a)a[t](c)&&b.push(c);return b}}function u(d,b,c,e){if(0<v&&0<=(aa||[]).indexOf(d)&&!b){for(var g=z.now(),k=0;z.now()-g<v;)k++;a.tag("marker-delayed:"+d)}e=e||+new z;var w;if(b||q(c)){if(d)for(w in g=b?h("t",b)||h("t",b,{}):a.t,g[d]=e,c)c[t](w)&&h(w,b,c[w]);return e}}function h(d,b,c){var e=b&&b!=a.id?a.sc[b]:a;e||(e=a.sc[b]={});"id"===d&&c&&(P=1);return e[d]=c||e[d]}function Q(d,b,c,e,g){c="on"+
c;var h=b[c];"function"===typeof h?d&&(a.h[d]=h):h=function(){};b[c]=function(a){g?(e(a),h(a)):(h(a),e(a))};b[c]&&(b[c].isUeh=1)}function R(n,b,c,e){function r(b,c){var d=[b],e=0,f={},g,k;c?(d.push("m=1"),f[c]=1):f=a.sc;for(k in f)if(f[t](k)){var r=h("wb",k),l=h("t",k)||{},p=h("t0",k)||a.t0,m;if(c||2==r){r=r?e++:"";d.push("sc"+r+"="+k);for(m in l)q(l[m])||null===l[m]||d.push(m+r+"="+(l[m]-p));d.push("t"+r+"="+l[n]);if(h("ctb",k)||h("wb",k))g=1}}!v&&g&&d.push("ctb=1");return d.join("&")}function N(b,
c,f,e){if(b){var g=d.ue_err;d.ue_url&&!e&&b&&0<b.length&&(e=new Image,a.iel.push(e),e.src=b,a.count&&a.count("postbackImageSize",b.length));if(y){var h=k.encodeURIComponent;h&&b&&(e=new Image,b=""+d.ue_fpf+h(b)+":"+(+new z-d.ue_t0),a.iel.push(e),e.src=b)}else a.log&&(a.log(b,"uedata",{n:1}),a.ielf.push(b));g&&!g.ts&&g.startTimer();a.b&&(g=a.b,a.b="",N(g,c,f,1))}}function w(b){var c=x?x.type:D,d=2==c||a.isBFonMshop,c=c&&!d,e=a.bfini;P||(e&&1<e&&(b+="&bfform=1",c||(a.isBFT=e-1)),d&&(b+="&bfnt=1",a.isBFT=
a.isBFT||1),a.ssw&&a.isBFT&&(a.isBFonMshop&&(a.isNRBF=0),q(a.isNRBF)&&(d=a.ssw(a.oid),d.e||q(d.val)||(a.isNRBF=1<d.val?0:1)),q(a.isNRBF)||(b+="&nrbf="+a.isNRBF)),a.isBFT&&!a.isNRBF&&(b+="&bft="+a.isBFT));return b}if(!a.paused&&(b||q(c))){for(var p in c)c[t](p)&&h(p,b,c[p]);a.isBFonMshop||u("pc",b,c);p=h("id",b)||a.id;var s=h("id2",b),f=a.url+"?"+n+"&v="+a.v+"&id="+p,v=h("ctb",b)||h("wb",b),A;v&&(f+="&ctb="+v);s&&(f+="&id2="+s);1<d.ueinit&&(f+="&ic="+d.ueinit);if(!("ld"!=n&&"ul"!=n||b&&b!=p)){if("ld"==
n){try{k[H]&&k[H].isUeh&&(k[H]=null)}catch(F){}if(k.chrome)for(s=0;s<I.length;s++)S(E,I[s]);(s=K.ue_backdetect)&&s.ue_back&&s.ue_back.value++;d._uess&&(A=d._uess());a.isl=1}a._bf&&(f+="&bf="+a._bf());d.ue_navtiming&&g&&(h("ctb",p,"1"),a.isBFonMshop||u("tc",D,D,J));!B||a.isBFonMshop||T||(g&&C(a.t,{na_:g.navigationStart,ul_:g.unloadEventStart,_ul:g.unloadEventEnd,rd_:g.redirectStart,_rd:g.redirectEnd,fe_:g.fetchStart,lk_:g.domainLookupStart,_lk:g.domainLookupEnd,co_:g.connectStart,_co:g.connectEnd,
sc_:g.secureConnectionStart,rq_:g.requestStart,rs_:g.responseStart,_rs:g.responseEnd,dl_:g.domLoading,di_:g.domInteractive,de_:g.domContentLoadedEventStart,_de:g.domContentLoadedEventEnd,_dc:g.domComplete,ld_:g.loadEventStart,_ld:g.loadEventEnd,ntd:("function"!==typeof B.now||q(J)?0:new z(J+B.now())-new z)+a.t0}),x&&C(a.t,{ty:x.type+a.t0,rc:x.redirectCount+a.t0}),T=1);a.isBFonMshop||C(a.t,{hob:d.ue_hob,hoe:d.ue_hoe});a.ifr&&(f+="&ifr=1")}u(n,b,c,e);c="ld"==n&&b&&h("wb",b);var m,l;c||b&&b!==p||ba(b);
c||p==a.oid||ca(p,(h("t",b)||{}).tc||+h("t0",b),+h("t0",b));(e=d.ue_mbl)&&e.cnt&&!c&&(f+=e.cnt());c?h("wb",b,2):"ld"==n&&(a.lid=G(p));for(m in a.sc)if(1==h("wb",m))break;if(c){if(a.s)return;f=r(f,null)}else e=r(f,null),e!=f&&(e=w(e),a.b=e),A&&(f+=A),f=r(f,b||a.id);f=w(f);if(a.b||c)for(m in a.sc)2==h("wb",m)&&delete a.sc[m];A=0;a._rt&&(f+="&rt="+a._rt());e=k.csa;if(!c&&e)for(l in m=h("t",b)||{},e=e("PageTiming"),m)m[t](l)&&e("mark",da[l]||l,m[l]);c||(a.s=0,(l=d.ue_err)&&0<l.ec&&l.pec<l.ec&&(l.pec=
l.ec,f+="&ec="+l.ec+"&ecf="+l.ecf),A=h("ctb",b),"ld"!==n||b||a.markers||(a.markers={},C(a.markers,h("t",b))),h("t",b,{}));a.tag&&a.tag().length&&(f+="&csmtags="+a.tag().join("|"),a.tag=O());l=a.viz||[];(m=l.length)&&(f+="&viz="+l.splice(0,m).join("|"));q(d.ue_pty)||(f+="&pty="+d.ue_pty+"&spty="+d.ue_spty+"&pti="+d.ue_pti);a.tabid&&(f+="&tid="+a.tabid);a.aftb&&(f+="&aftb=1");!a._ui||b&&b!=p||(f+=a._ui());a.a=f;N(f,n,A,c)}}function ba(a){var b=k.ue_csm_markers||{},c;for(c in b)b[t](c)&&u(c,a,D,b[c])}
function F(a,b,c){c=c||k;if(c[U])c[U](a,b,!1);else if(c[V])c[V]("on"+a,b)}function S(a,b,c){c=c||k;if(c[W])c[W](a,b,!1);else if(c[X])c[X]("on"+a,b)}function Y(){function a(){d.onUl()}function b(a){return function(){c[a]||(c[a]=1,R(a))}}var c={},e,g;d.onLd=b("ld");d.onLdEnd=b("ld");d.onUl=b("ul");e={stop:b("os")};k.chrome?(F(E,a),I.push(a)):e[E]=d.onUl;for(g in e)e[t](g)&&Q(0,k,g,e[g]);d.ue_viz&&ue_viz();F("load",d.onLd);u("ue")}function ca(g,b,c){var e=d.ue_mbl,h=k.csa,q=h&&h("SPA"),h=h&&h("PageTiming");
e&&e.ajax&&e.ajax(b,c);q&&h&&(q("newPage",{requestId:g,transitionType:"soft"}),h("mark","transitionStart",b));a.tag("ajax-transition")}d.ueinit=(d.ueinit||0)+1;var a=d.ue=d.ue||{};a.t0=k.aPageStart||d.ue_t0;a.id=d.ue_id;a.url=d.ue_url;a.rid=d.ue_id;a.a="";a.b="";a.h={};a.s=1;a.t={};a.sc={};a.iel=[];a.ielf=[];a.viz=[];a.v="0.218044.0";a.paused=!1;var t="hasOwnProperty",E="beforeunload",H="on"+E,U="addEventListener",W="removeEventListener",V="attachEvent",X="detachEvent",da={cf:"criticalFeature",af:"aboveTheFold",
fn:"functional",fp:"firstPaint",fcp:"firstContentfulPaint",bb:"bodyBegin",be:"bodyEnd",ld:"loaded"},z=k.Date,B=k.performance||k.webkitPerformance,g=(B||{}).timing,x=(B||{}).navigation,J=(g||{}).navigationStart,y=d.ue_fpf,aa=d.ue_tx_md,v=d.ue_tx_ad,P=0,T=0,I=[],D;a.oid=G(a.id);a.lid=G(a.id);a._t0=a.t0;a.tag=O();a.ifr=k.top!==k.self||k.frameElement?1:0;a.markers=null;a.attach=F;a.detach=S;if("000-0000000-8675309"===d.ue_sid){var Z=L("cdn-rid"),$=L("session-id");Z&&$&&M(Z,$,"cdn")}d.uei=Y;d.ueh=Q;d.ues=
h;d.uet=u;d.uex=R;a.reset=M;a.pause=function(d){a.paused=d};Y();0<v&&u("ho")})(ue_csm,ue_csm.window,ue_csm.document);


ue.stub(ue,"log");ue.stub(ue,"onunload");ue.stub(ue,"onflush");
(function(c){var a=c.ue;a.cv={};a.cv.scopes={};a.count=function(d,c,b){var e={},f=a.cv,g=b&&0===b.c;e.counter=d;e.value=c;e.t=a.d();b&&b.scope&&(f=a.cv.scopes[b.scope]=a.cv.scopes[b.scope]||{},e.scope=b.scope);if(void 0===c)return f[d];f[d]=c;d=0;b&&b.bf&&(d=1);ue_csm.ue_sclog||!a.clog||0!==d||g?a.log&&a.log(e,"csmcount",{c:1,bf:d}):a.clog(e,"csmcount",{bf:d})};a.count("baselineCounter2",1);a&&a.event&&(a.event({requestId:c.ue_id||"rid",server:c.ue_sn||"sn",obfuscatedMarketplaceId:c.ue_mid||"mid"},
"csm","csm.CSMBaselineEvent.4"),a.count("nexusBaselineCounter",1,{bf:1}))})(ue_csm);



var ue_hoe = +new Date();
}
window.ueinit = window.ue_ihb;
</script>

<!-- 1zxhwordmh6wu6mask5eqxo3huq59id54tmnba63rjsp -->
<script>window.ue && ue.count && ue.count('CSMLibrarySize', 9644)</script> 
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="apple-itunes-app" content="app-id=342792525, app-argument=imdb:///name/nm0004376?src=mdot">



        <script type="text/javascript">var IMDbTimer={starttime: new Date().getTime(),pt:'java'};</script>

<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadTitle", {wb: 1});
    }
</script>
  <script>(function(t){ (t.events = t.events || {})["csm_head_pre_title"] = new Date().getTime(); })(IMDbTimer);</script>
        <title>Franka Potente - IMDb</title>
  <script>(function(t){ (t.events = t.events || {})["csm_head_post_title"] = new Date().getTime(); })(IMDbTimer);</script>
<script>
    if (typeof uet == 'function') {
      uet("be", "LoadTitle", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadTitle", {wb: 1});
    }
</script>

        <link rel="canonical" href="https://www.imdb.com/name/nm0004376/" />
        <meta property="og:url" content="http://www.imdb.com/name/nm0004376/" />
        <link rel="alternate" media="only screen and (max-width: 640px)" href="https://m.imdb.com/name/nm0004376/">

<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadIcons", {wb: 1});
    }
</script>
  <script>(function(t){ (t.events = t.events || {})["csm_head_pre_icon"] = new Date().getTime(); })(IMDbTimer);</script>

        <link rel='icon' sizes='32x32' href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/favicon_desktop_32x32._CB1582158068_.png' />
        <link rel='icon' sizes='167x167' href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/favicon_iPad_retina_167x167._CB1582158068_.png' />
        <link rel='icon' sizes='180x180' href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/favicon_iPhone_retina_180x180._CB1582158069_.png' />

        <link href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/apple-touch-icon-mobile._CB479963088_.png' rel='apple-touch-icon' />
        <link href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/apple-touch-icon-mobile-76x76._CB479962152_.png' rel='apple-touch-icon' sizes='76x76' />
        <link href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/apple-touch-icon-mobile-120x120._CB479963088_.png' rel='apple-touch-icon' sizes='120x120' />
        <link href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/apple-touch-icon-web-152x152._CB479963088_.png' rel='apple-touch-icon' sizes='152x152' />

        <link href='https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/android-mobile-196x196._CB479962153_.png' rel='shortcut icon' sizes='196x196' />

        <meta name="theme-color" content="#000000" />
         
        <link rel="search" type="application/opensearchdescription+xml" href="https://m.media-amazon.com/images/S/sash/MzfIBMq9GBucYqW.xml" title="IMDb" />
  <script>(function(t){ (t.events = t.events || {})["csm_head_post_icon"] = new Date().getTime(); })(IMDbTimer);</script>
<script>
    if (typeof uet == 'function') {
      uet("be", "LoadIcons", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadIcons", {wb: 1});
    }
</script>

        <meta property="pageId" content="nm0004376" />
        <meta property="pageType" content="name" />
        <meta property="subpageType" content="main" />


        <link rel='image_src' href="https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_UY1200_CR111,0,630,1200_AL_.jpg">
        <meta property='og:image' content="https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_UY1200_CR111,0,630,1200_AL_.jpg" />

        <meta property='og:type' content="actor" />
    <meta property='fb:app_id' content='115109575169727' />

      <meta property='og:title' content="Franka Potente - IMDb" />
    <meta property='og:site_name' content='IMDb' />
    <meta name="title" content="Franka Potente - IMDb" />
        <meta name="description" content="Franka Potente, Actress: Lola rennt. Franka Potente was born on 22 July 1974 in the German city of Münster, to Hildegard, a medical assistant, and Dieter Potente, a teacher, and raised in the nearby town of Dülmen. After her graduation in 1994, she went to the Otto-Falckenberg-Schule, a drama school in Munich, but soon broke off to study at the Lee Strasberg Theatre Institute in New ..." />
        <meta property="og:description" content="Franka Potente, Actress: Lola rennt. Franka Potente was born on 22 July 1974 in the German city of Münster, to Hildegard, a medical assistant, and Dieter Potente, a teacher, and raised in the nearby town of Dülmen. After her graduation in 1994, she went to the Otto-Falckenberg-Schule, a drama school in Munich, but soon broke off to study at the Lee Strasberg Theatre Institute in New ..." />
        <meta name="keywords" content="Biography, Photos, Awards, News" />
        <meta name="request_id" content="YAQYHQZAPJWQPCYD78VQ" />
<script type="application/ld+json">{
  "@context": "http://schema.org",
  "@type": "Person",
  "url": "/name/nm0004376/",
  "name": "Franka Potente",
  "image": "https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_.jpg",
  "jobTitle": [
    "Actress",
    "Soundtrack",
    "Director"
  ],
  "description": "Franka Potente was born on 22 July 1974 in the German city of Münster, to Hildegard, a medical assistant, and Dieter Potente, a teacher, and raised in the nearby town of Dülmen. After her graduation in 1994, she went to the Otto-Falckenberg-Schule, a drama school in Munich, but soon broke off to study at the Lee Strasberg Theatre Institute in New ...",
  "birthDate": "1974-07-22"
}</script>
    <script>
        (function (win) {
            win.PLAID_LOAD_FONTS_FIRED = true;

            if (typeof win.FontFace !== "undefined"
                && typeof win.Promise !== "undefined") {
                if (win.ue) {
                    win.uet("bb", "LoadRoboto", { wb: 1 });
                }
                var allowableLoadTime = 1000;
                var startTimeInt = +new Date();
                var roboto = new FontFace('Roboto',
                    'url(https://m.media-amazon.com/images/G/01/IMDb/cm9ib3Rv.woff2)',
                    { style:'normal', weight: 400 });
                var robotoMedium = new FontFace('Roboto',
                    'url(https://m.media-amazon.com/images/G/01/IMDb/cm9ib3RvTWVk.woff2)',
                    { style:'normal', weight: 500 });
                var robotoBold = new FontFace('Roboto',
                    'url(https://m.media-amazon.com/images/G/01/IMDb/cm9ib3RvQm9sZA.woff2)',
                    { style:'normal', weight: 600 });
                var robotoLoaded = roboto.load();
                var robotoMediumLoaded = robotoMedium.load();
                var robotoBoldLoaded = robotoBold.load();

                win.Promise.all([robotoLoaded, robotoMediumLoaded, robotoBoldLoaded]).then(function() {
                    var loadTimeInt = +new Date();
                    var robotoLoadedCount = 0;
                    if ((loadTimeInt - startTimeInt) <= allowableLoadTime) {
                        win.document.fonts.add(roboto);
                        win.document.fonts.add(robotoMedium);
                        win.document.fonts.add(robotoBold);
                        robotoLoadedCount++;
                    }
                    if (win.ue) {
                        win.ue.count("roboto-loaded", robotoLoadedCount);
                        win.uet("be", "LoadRoboto", { wb: 1 });
                        win.uex("ld", "LoadRoboto", { wb: 1 });
                    }
                }).catch(function() {
                    if (win.ue) {
                        win.ue.count("roboto-loaded", 0);
                    }
                });
            } else {
                if (win.ue) {
                    win.ue.count("roboto-load-not-attempted", 1);
                }
            }
        })(window);
    </script>

<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadCSS", {wb: 1});
    }
</script>
  <script>(function(t){ (t.events = t.events || {})["csm_head_pre_css"] = new Date().getTime(); })(IMDbTimer);</script>
        
<link rel="stylesheet" type="text/css" href="https://m.media-amazon.com/images/I/41pzfEC8F8L.css" /><link rel="stylesheet" type="text/css" href="https://m.media-amazon.com/images/I/41468wxWxGL.css" />

<!-- h=ics-c52xl-7-1e-43bb27aa.us-east-1 -->

            <link rel="stylesheet" type="text/css" href="https://m.media-amazon.com/images/S/sash/ehdAf5xkBOY9ils.css" />
            <link rel="stylesheet" type="text/css" href="https://m.media-amazon.com/images/S/sash/wuRV0qMNkKJMwOY.css" />
        <noscript>
            <link rel="stylesheet" type="text/css" href="https://m.media-amazon.com/images/S/sash/CCc6Ja$8QUPPKkY.css">
        </noscript>
  <script>(function(t){ (t.events = t.events || {})["csm_head_post_css"] = new Date().getTime(); })(IMDbTimer);</script>
<script>
    if (typeof uet == 'function') {
      uet("be", "LoadCSS", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadCSS", {wb: 1});
    }
</script>

<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadJS", {wb: 1});
    }
</script>
<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadHeaderJS", {wb: 1});
    }
</script>
  <script>(function(t){ (t.events = t.events || {})["csm_head_pre_ads"] = new Date().getTime(); })(IMDbTimer);</script>
        
        <script  type="text/javascript">
            // ensures js doesn't die if ads service fails.  
            // Note that we need to define the js here, since ad js is being rendered inline after this.
            (function(f) {
                // Fallback javascript, when the ad Service call fails.  
                
                if((window.csm == null || window.generic == null || window.consoleLog == null)) {
                    if (window.console && console.log) {
                        console.log("one or more of window.csm, window.generic or window.consoleLog has been stubbed...");
                    }
                }
                
                window.csm = window.csm || { measure:f, record:f, duration:f, listen:f, metrics:{} };
                window.generic = window.generic || { monitoring: { start_timing: f, stop_timing: f } };
                window.consoleLog = window.consoleLog || f;
            })(function() {});
        </script>
<script type="text/javascript">
    if (!window.RadWidget) {
        window.RadWidget = {
            registerReactWidgetInstance: function(input) {
                window.RadWidget[input.widgetName] = window.RadWidget[input.widgetName] || [];
                window.RadWidget[input.widgetName].push({
                    id: input.instanceId,
                    props: JSON.stringify(input.model)
                })
            },
            getReactWidgetInstances: function(widgetName) {
                return window.RadWidget[widgetName] || []
            }
        };
    }
</script>  <script>
    if ('csm' in window) {
      csm.measure('csm_head_delivery_finished');
    }
  </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "LoadHeaderJS", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadHeaderJS", {wb: 1});
    }
</script>
<script>
    if (typeof uet == 'function') {
      uet("be", "LoadJS", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadJS", {wb: 1});
    }
</script>

        <script type='text/javascript'>
window.ue_ihe = (window.ue_ihe || 0) + 1;
if (window.ue_ihe === 1) {
(function(k,l,g){function m(a){c||(c=b[a.type].id,"undefined"===typeof a.clientX?(e=a.pageX,f=a.pageY):(e=a.clientX,f=a.clientY),2!=c||h&&(h!=e||n!=f)?(r(),d.isl&&l.setTimeout(function(){p("at",d.id)},0)):(h=e,n=f,c=0))}function r(){for(var a in b)b.hasOwnProperty(a)&&d.detach(a,m,b[a].parent)}function s(){for(var a in b)b.hasOwnProperty(a)&&d.attach(a,m,b[a].parent)}function t(){var a="";!q&&c&&(q=1,a+="&ui="+c);return a}var d=k.ue,p=k.uex,q=0,c=0,h,n,e,f,b={click:{id:1,parent:g},mousemove:{id:2,
parent:g},scroll:{id:3,parent:l},keydown:{id:4,parent:g}};d&&p&&(s(),d._ui=t)})(ue_csm,window,document);


(function(s,l){function m(b,e,c){c=c||new Date(+new Date+t);c="expires="+c.toUTCString();n.cookie=b+"="+e+";"+c+";path=/"}function p(b){b+="=";for(var e=n.cookie.split(";"),c=0;c<e.length;c++){for(var a=e[c];" "==a.charAt(0);)a=a.substring(1);if(0===a.indexOf(b))return decodeURIComponent(a.substring(b.length,a.length))}return""}function q(b,e,c){if(!e)return b;-1<b.indexOf("{")&&(b="");for(var a=b.split("&"),f,d=!1,h=!1,g=0;g<a.length;g++)f=a[g].split(":"),f[0]==e?(!c||d?a.splice(g,1):(f[1]=c,a[g]=
f.join(":")),h=d=!0):2>f.length&&(a.splice(g,1),h=!0);h&&(b=a.join("&"));!d&&c&&(0<b.length&&(b+="&"),b+=e+":"+c);return b}var k=s.ue||{},t=3024E7,n=ue_csm.document||l.document,r=null,d;a:{try{d=l.localStorage;break a}catch(u){}d=void 0}k.count&&k.count("csm.cookieSize",document.cookie.length);k.cookie={get:p,set:m,updateCsmHit:function(b,e,c){try{var a;if(!(a=r)){var f;a:{try{if(d&&d.getItem){f=d.getItem("csm-hit");break a}}catch(k){}f=void 0}a=f||p("csm-hit")||"{}"}a=q(a,b,e);r=a=q(a,"t",+new Date);
try{d&&d.setItem&&d.setItem("csm-hit",a)}catch(h){}m("csm-hit",a,c)}catch(g){"function"==typeof l.ueLogError&&ueLogError(Error("Cookie manager: "+g.message),{logLevel:"WARN"})}}}})(ue_csm,window);


(function(l,e){function c(b){b="";var c=a.isBFT?"b":"s",d=""+a.oid,g=""+a.lid,h=d;d!=g&&20==g.length&&(c+="a",h+="-"+g);a.tabid&&(b=a.tabid+"+");b+=c+"-"+h;b!=f&&100>b.length&&(f=b,a.cookie?a.cookie.updateCsmHit(m,b+("|"+ +new Date)):e.cookie="csm-hit="+b+("|"+ +new Date)+n+"; path=/")}function p(){f=0}function d(b){!0===e[a.pageViz.propHid]?f=0:!1===e[a.pageViz.propHid]&&c({type:"visible"})}var n="; expires="+(new Date(+new Date+6048E5)).toGMTString(),m="tb",f,a=l.ue||{},k=a.pageViz&&a.pageViz.event&&
a.pageViz.propHid;a.attach&&(a.attach("click",c),a.attach("keyup",c),k||(a.attach("focus",c),a.attach("blur",p)),k&&(a.attach(a.pageViz.event,d,e),d({})));a.aftb=1})(ue_csm,ue_csm.document);


ue_csm.ue.stub(ue,"impression");


ue.stub(ue,"trigger");



if(window.ue&&uet) { uet('bb'); }

}
</script>
<script>window.ue && ue.count && ue.count('CSMLibrarySize', 2729)</script>
    </head>
    <body id="styleguide-v2" class="fixed">
        

<script>
!function(){function n(n,t){var r=i(n);return t&&(r=r("instance",t)),r}var r=[],c=0,i=function(t){return function(){var n=c++;return r.push([t,[].slice.call(arguments,0),n,{time:Date.now()}]),i(n)}};n._s=r,this.csa=n}();;
csa('Config', {});
if (window.csa) {
    csa("Config", {
        
        'Events.Namespace': 'csa',
        'ObfuscatedMarketplaceId': 'A1EVAM02EL8SFB',
        'Events.SushiEndpoint': 'https://unagi.amazon.com/1/events/com.amazon.csm.csa.prod',
        'CacheDetection.RequestID': "YAQYHQZAPJWQPCYD78VQ",
        'CacheDetection.Callback': window.ue && ue.reset,
        'LCP.elementDedup': 1
    });

    csa("Events")("setEntity", {
        page: {requestId: "YAQYHQZAPJWQPCYD78VQ", meaningful: "interactive"},
        session: {id: "137-3442349-9635931"}
    });
}
!function(r){var i,e,o="splice",u=r.csa,f={},c={},a=r.csa._s,s=0,l={},g={},h={},n=Object.keys,v=function(){};function t(n,t){return u(n,t)}function d(n,t){var r=c[n]||{};I(r,t),c[n]=r,E(D,0)}function p(n,t,r){var i=!0;return t=y(t),r&&r.buffered&&(i=(h[n]||[]).every(function(n){return!1!==t(n)})),i?(l[n]||(l[n]=[]),l[n].push(t),function(){!function(n,t){var r=l[n];r&&r[o](r.indexOf(t),1)}(n,t)}):v}function m(n,t){if(t=y(t),n in g)return t(g[n]),v;return p(n,function(n){return t(n),!1})}function w(n,t){if(u("Errors")("logError",n),f.DEBUG)throw t||n}function b(){return Math.abs(4294967295*Math.random()|0).toString(36)}function y(n,t){return function(){try{return n.apply(this,arguments)}catch(n){w(n.message||n,n)}}}function E(n,t){return r.setTimeout(y(n),t)}function D(){for(var n=0;n<a.length;){var t=a[n],r=t[0]in c;if(!r&&!e)return void(s=t.length);r?(a[o](s=n,1),S(t)):n++}}function S(n){var arguments,t=c[n[0]],r=(arguments=n[1])[0];if(!t||!t[r])return w("Undefined function: "+t+"/"+r);i=n[3],c[n[2]]=t[r].apply(t,arguments.slice(1))||{},i=0}function U(){e=1,D()}function I(t,r){n(r).forEach(function(n){t[n]=r[n]})}m("$beforeunload",U),d("Config",{instance:function(n){I(f,n)}}),u.plugin=y(function(n){n(t)}),t.config=f,t.register=d,t.on=p,t.once=m,t.blank=v,t.emit=function(n,t,r){for(var i=l[n]||[],e=0;e<i.length;)!1===i[e](t)?i[o](e,1):e++;g[n]=t||{},r&&r.buffered&&(h[n]||(h[n]=[]),100<=h[n].length&&h[n].shift(),h[n].push(t||{}))},t.UUID=function(){return[b(),b(),b(),b()].join("-")},t.time=function(n){var t=i?new Date(i.time):new Date;return"ISO"===n?t.toISOString():t.getTime()},t.error=w,t.warn=function(n,t){if(u("Errors")("logWarn",n),f.DEBUG)throw t||n},t.exec=y,t.timeout=E,t.interval=function(n,t){return r.setInterval(y(n),t)},(t.global=r).csa._s.push=function(n){n[0]in c&&(!a.length||e)?S(n):a[o](s++,0,n)},D(),E(function(){E(U,f.SkipMissingPluginsTimeout||5e3)},1)}("undefined"!=typeof window?window:global);csa.plugin(function(o){var f="addEventListener",e="requestAnimationFrame",t=o.exec,r=o.global,u=o.on;o.raf=function(n){if(r[e])return r[e](t(n))},o.on=function(n,e,t,r){if(n&&"function"==typeof n[f]){var i=o.exec(t);return n[f](e,i,r),function(){n.removeEventListener(e,i,r)}}return"string"==typeof n?u(n,e,t,r):o.blank}});csa.plugin(function(o){var t,n,r={},e="localStorage",c="sessionStorage",a="local",i="session",u=o.exec;function s(e,t){var n;try{r[t]=!!(n=o.global[e]),n=n||{}}catch(e){r[t]=!(n={})}return n}function f(){t=t||s(e,a),n=n||s(c,i)}function l(e){return e&&e[i]?n:t}o.store=u(function(e,t,n){f();var o=l(n);return e?t?void(o[e]=t):o[e]:Object.keys(o)}),o.storageSupport=u(function(){return f(),r}),o.deleteStored=u(function(e,t){f();var n=l(t);if("function"==typeof e)for(var o in n)n.hasOwnProperty(o)&&e(o,n[o])&&delete n[o];else delete n[e]})});csa.plugin(function(o){function r(n){return function(r){o("Metrics",{producerId:"csa",dimensions:{message:r}})("recordMetric",n,1)}}o.register("Errors",{logError:r("jsError"),logWarn:r("jsWarn")})});csa.plugin(function(r){var o,e=r.global,i=r("Events"),f=e.location,d=e.document,a=((e.performance||{}).navigation||{}).type,t=r.on,u=r.emit,g={};function n(a,e){var t=!!o,n=(e=e||{}).keepPageAttributes;t&&(u("$beforePageTransition"),u("$pageTransition")),t&&!n&&i("removeEntity","page"),o=r.UUID(),n?g.id=o:g={schemaId:"<ns>.PageEntity.1",id:o,url:f.href,server:f.hostname,path:f.pathname,referrer:d.referrer,title:d.title},Object.keys(a||{}).forEach(function(e){g[e]=a[e]}),i("setEntity",{page:g}),u("$pageChange",g,{buffered:1}),t&&u("$afterPageTransition")}function l(){u("$load"),u("$ready"),u("$afterload")}function s(){u("$ready"),u("$beforeunload"),u("$unload"),u("$afterunload")}f&&d&&(t(e,"beforeunload",s),t(e,"pagehide",s),"complete"===d.readyState?l():t(e,"load",l),r.register("SPA",{newPage:n}),n({transitionType:{0:"hard",1:"refresh",2:"back-button"}[a]||"unknown"}))});csa.plugin(function(c){var t="Events",e="UNKNOWN",a="id",u="all",n="messageId",i="timestamp",f="producerId",o="application",r="obfuscatedMarketplaceId",s="entities",d="schemaId",l="version",p="attributes",v="<ns>",g=c.config,h=(c.global.location||{}).host,m=g[t+".Namespace"]||"csa_other",I=g.Application||"Other"+(h?":"+h:""),b=c("Transport"),y={},O=function(t,e){Object.keys(t).forEach(e)};function E(n,i,o){O(i,function(t){var e=o===u||(o||{})[t];t in n||(n[t]={version:1,id:i[t][a]||c.UUID()}),U(n[t],i[t],e)})}function U(e,n,i){O(n,function(t){!function(t,e,n){return"string"!=typeof e&&t!==l?c.error("Attribute is not of type string: "+t):!0===n||1===n||(t===a||!!~(n||[]).indexOf(t))}(t,n[t],i)||(e[t]=n[t])})}function N(o,t,r){O(t,function(t){var e=o[t];if(e[d]){var n={},i={};n[a]=e[a],n[f]=e[f]||r,n[d]=e[d],n[l]=e[l]++,n[p]=i,S(n),U(i,e,1),k(i),b("log",n)}})}function S(t){t[i]=function(t){return"number"==typeof t&&(t=new Date(t).toISOString()),t||c.time("ISO")}(t[i]),t[n]=t[n]||c.UUID(),t[o]=I,t[r]=g.ObfuscatedMarketplaceId||e,t[d]=t[d].replace(v,m)}function k(t){delete t[l],delete t[d],delete t[f]}function w(o){var r={};this.log=function(t,e){var n={},i=(e||{}).ent;return t?"string"!=typeof t[d]?c.error("A valid schema id is required for the event"):(S(t),E(n,y,i),E(n,r,i),E(n,t[s]||{},i),O(n,function(t){k(n[t])}),t[f]=o[f],t[s]=n,void b("log",t)):c.error("The event cannot be undefined")},this.setEntity=function(t){E(r,t,u),N(r,t,o[f])}}g["KillSwitch."+t]||c.register(t,{setEntity:function(t){E(y,t,u),N(y,t,"csa")},removeEntity:function(t){delete y[t]},instance:function(t){return new w(t)}})});csa.plugin(function(s){var c,l="Transport",g="post",u="preflight",r="csa.cajun.",i="store",a="deleteStored",f="sendBeacon",t=0,e=s.config[l+".BufferSize"]||2e3,h=s.config[l+".RetryDelay"]||1500,o=[],p=0,d=[],v=s.global,n=s.on,y=s.once,m=v.document,E=s.timeout,R=s.config[l+".FlushInterval"]||5e3,S=0;function b(n){if(864e5<s.time()-+new Date(n.timestamp))return s.warn("Event is too old: "+n);p<e&&(o.push(n),p++,!S&&t&&(S=E(w,R)))}function w(){d.forEach(function(t){var e=[];o.forEach(function(n){t.accepts(n)&&e.push(n)}),e.length&&(t.chunks?t.chunks(e).forEach(function(n){I(t,n)}):I(t,e))}),o=[],S=0}function I(t,e){function o(){s[a](r+n)}var n=s.UUID();s[i](r+n,JSON.stringify(e)),[function(n,t,e){var o=v.navigator||{},r=v.cordova||{};if(!o[f]||!n[g])return 0;n[u]&&r&&"ios"===r.platformId&&!c&&((new Image).src=n[u]().url,c=1);var i=n[g](t);if(!i.type&&o[f](i.url,i.body))return e(),1},function(n,t,e){if(!n[g])return 0;var o=n[g](t),r=o.url,i=o.body,c=o.type,u=new XMLHttpRequest,a=0;function f(n,t,e){u.open("POST",n),e&&u.setRequestHeader("Content-Type",e),u.send(t)}return u.onload=function(){u.status<299?e():s.config[l+".XHRRetries"]&&a<3&&E(function(){f(r,i,c)},++a*h)},f(r,i,c),1}].some(function(n){try{return n(t,e,o)}catch(n){}})}y("$afterload",function(){t=1,function(e){(s[i]()||[]).forEach(function(n){if(!n.indexOf(r))try{var t=s[i](n);s[a](n),JSON.parse(t).forEach(e)}catch(n){s.error(n)}})}(b),n(m,"visibilitychange",w,!1),w()}),y("$afterunload",function(){t=1,w()}),n("$afterPageTransition",function(){p=0}),s.register(l,{log:b,register:function(n){d.push(n)}})});csa.plugin(function(n){var r=n.config["Events.SushiEndpoint"];n("Transport")("register",{accepts:function(n){return n.schemaId},post:function(n){var t=n.map(function(n){return{data:n}});return{url:r,body:JSON.stringify({events:t})}},preflight:function(){var n,t=/\/\/(.*?)\//.exec(r);return t&&t[1]&&(n="https://"+t[1]+"/ping"),{url:n}},chunks:function(n){for(var t=[];500<n.length;)t.push(n.splice(0,500));return t.push(n),t}})});csa.plugin(function(n){var t,a,o,r,e=n.config,i="PageViews",d=e[i+".ImpressionMinimumTime"]||1e3,s="hidden",c="innerHeight",g="innerWidth",l="renderedTo",f=l+"Viewed",m=l+"Meaningful",u=l+"Impressed",p=1,v=2,h=3,w=4,y=5,P="loaded",I=7,T=8,b=n.global,E=n.on,V=n("Events",{producerId:"csa"}),$=b.document,M={},S={},H=y;function K(e){if(!M[I]){var i;if(M[e]=n.time(),e!==h&&e!==P||(t=t||M[e]),t&&H===w)a=a||M[e],(i={})[m]=t-o,i[f]=a-o,R("PageView.4",i),r=r||n.timeout(j,d);if(e!==y&&e!==p&&e!==v||(clearTimeout(r),r=0),e!==p&&e!==v||R("PageRender.3",{transitionType:e===p?"hard":"soft"}),e===I)(i={})[m]=t-o,i[f]=a-o,i[u]=M[e]-o,R("PageImpressed.2",i)}}function R(e,i){S[e]||(i.schemaId="<ns>."+e,V("log",i,{ent:"all"}),S[e]=1)}function W(){0===b[c]&&0===b[g]?(H=T,n("Events")("setEntity",{page:{viewport:"hidden-iframe"}})):H=$[s]?y:w,K(H)}function j(){K(I),r=0}function k(){var e=o?v:p;M={},S={},a=t=0,o=n.time(),K(e),W()}function q(){var e=$.readyState;"interactive"===e&&K(h),"complete"===e&&K(P)}e["KillSwitch."+i]||($&&void 0!==$[s]?(k(),E($,"visibilitychange",W,!1),E($,"readystatechange",q,!1),E("$afterPageTransition",k),E("$timing:loaded",q),n.once("$load",q)):n.warn("Page visibility not supported"))});csa.plugin(function(c){var s=c.config["Interactions.ParentChainLength"]||15,e="click",r="touches",f="timeStamp",o="length",u="pageX",g="pageY",p="pageXOffset",h="pageYOffset",m=250,v=5,d=200,l=.5,t={capture:!0,passive:!0},X=c.global,Y=c.emit,n=c.on,x=X.Math.abs,a=(X.document||{}).documentElement||{},y={x:0,y:0,t:0,sX:0,sY:0},N={x:0,y:0,t:0,sX:0,sY:0};function b(t){if(t.id)return"//*[@id='"+t.id+"']";var e=function(t){var e,n=1;for(e=t.previousSibling;e;e=e.previousSibling)e.nodeName===t.nodeName&&(n+=1);return n}(t),n=t.nodeName;return 1!==e&&(n+="["+e+"]"),t.parentNode&&(n=b(t.parentNode)+"/"+n),n}function I(t,e,n){var a=c("Content",{target:n}),i={schemaId:"<ns>.ContentInteraction.1",interaction:t,interactionData:e,messageId:c.UUID()};if(n){var r=b(n);r&&(i.attribution=r);var o=function(t){for(var e=t,n=e.tagName,a=!1,i=t?t.href:null,r=0;r<s;r++){if(!e||!e.parentElement){a=!0;break}n=(e=e.parentElement).tagName+"/"+n,i=i||e.href}return a||(n=".../"+n),{pc:n,hr:i}}(n);o.pc&&(i.interactionData.parentChain=o.pc),o.hr&&(i.interactionData.href=o.hr)}a("log",i),Y("$content.interaction",i)}function i(t){I(e,{interactionX:""+t.pageX,interactionY:""+t.pageY},t.target)}function C(t){if(t&&t[r]&&1===t[r][o]){var e=t[r][0];N=y={e:t.target,x:e[u],y:e[g],t:t[f],sX:X[p],sY:X[h]}}}function D(t){if(t&&t[r]&&1===t[r][o]&&y&&N){var e=t[r][0],n=t[f],a=n-N.t,i={e:t.target,x:e[u],y:e[g],t:n,sX:X[p],sY:X[h]};N=i,d<=a&&(y=i)}}function E(t){if(t){var e=x(y.x-N.x),n=x(y.y-N.y),a=x(y.sX-N.sX),i=x(y.sY-N.sY),r=t[f]-y.t;if(m<1e3*e/r&&v<e||m<1e3*n/r&&v<n){var o=n<e;o&&a&&e*l<=a||!o&&i&&n*l<=i||I((o?"horizontal":"vertical")+"-swipe",{interactionX:""+y.x,interactionY:""+y.y,endX:""+N.x,endY:""+N.y},y.e)}}}n(a,e,i,t),n(a,"touchstart",C,t),n(a,"touchmove",D,t),n(a,"touchend",E,t)});

</script>
<script>window.ue && ue.count && ue.count('CSMLibrarySize', 11336)</script>
<script>
    if (typeof uet == 'function') {
      uet("bb");
    }
</script>
  <script>
    if ('csm' in window) {
      csm.measure('csm_body_delivery_started');
    }
  </script>
       
<script>
    if (typeof uet == 'function') {
      uet("ns");
    }
</script>
        <style data-styled="gwOpQB iwkRT erYeKd bkeTFm diDBNJ eWjUDO LrpYY dzfmPm dFDExU RQLCk YOYgO ddqdtC hOXnzb cIKARP gTFTwO dKTgZt crQfrC OQYVG hjoCyi hoAGyu cECatH kaVyhF eIWOUD" data-styled-version="4.3.2">
/* sc-component-id: NavLogo-e02kni-0 */
.ddqdtC{-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;margin-left:0.25rem;margin-right:auto;-webkit-order:1;-ms-flex-order:1;order:1;position:relative;} @media screen and (min-width:1024px){.ddqdtC{margin-left:auto;margin-right:0.5rem;-webkit-order:0;-ms-flex-order:0;order:0;padding-left:0;}} @media (hover:hover) and (pointer:fine){.ddqdtC:focus{outline:1px dashed currentColor;}.ddqdtC:focus:active{outline:0;}.ddqdtC:before,.ddqdtC:after{border-radius:10%;bottom:0;content:'';height:100%;left:0;margin:auto;opacity:0;position:absolute;right:0;top:0;-webkit-transition:opacity .2s cubic-bezier(1,1,1,1);transition:opacity .2s cubic-bezier(1,1,1,1);width:100%;}}
/* sc-component-id: SearchTypeahead-sc-112a48v-0 */
.OQYVG li:first-child > ._3CzPBqlWRmSAoWxtvQQ5Eo{border-top:none;}
/* sc-component-id: FlyoutMenu-xq6xx0-0 */
.crQfrC{position:relative;} .crQfrC.navbar__flyout__text-button-after-mobile,.crQfrC .navbar__flyout__text-button-after-mobile{display:none;} .crQfrC .navbar__flyout__text-button-after-mobile > div{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;} .crQfrC .navbar__flyout--menu{top:100%;position:absolute;margin-top:.25rem;} .crQfrC.crQfrC.navbar__flyout--positionLeft .navbar__flyout--menu{left:0;right:auto;} @media screen and (min-width:600px){.crQfrC.navbar__flyout--breakpoint-m .navbar__flyout__icon-on-mobile{display:none;}.crQfrC.navbar__flyout--breakpoint-m .navbar__flyout__text-button-after-mobile{display:-webkit-inline-box;display:-webkit-inline-flex;display:-ms-inline-flexbox;display:inline-flex;}} @media screen and (min-width:1024px){.crQfrC.navbar__flyout--breakpoint-l .navbar__flyout__icon-on-mobile{display:none;}.crQfrC.navbar__flyout--breakpoint-l .navbar__flyout__text-button-after-mobile{display:-webkit-inline-box;display:-webkit-inline-flex;display:-ms-inline-flexbox;display:inline-flex;}} @media screen and (min-width:1280px){.crQfrC.navbar__flyout--breakpoint-xl .navbar__flyout__icon-on-mobile{display:none;}.crQfrC.navbar__flyout--breakpoint-xl .navbar__flyout__text-button-after-mobile{display:-webkit-inline-box;display:-webkit-inline-flex;display:-ms-inline-flexbox;display:inline-flex;}} .crQfrC .navbar__flyout__button-pointer{-webkit-transition:-webkit-transform 0.2s;-webkit-transition:transform 0.2s;transition:transform 0.2s;-webkit-transform:rotateX(0);-ms-transform:rotateX(0);transform:rotateX(0);} .crQfrC.navbar__flyout--isVisible .navbar__flyout__button-pointer{-webkit-transform:rotateX(180deg);-ms-transform:rotateX(180deg);transform:rotateX(180deg);}
/* sc-component-id: SearchCategorySelector__StyledContainer-sc-18f40f7-0 */
.dKTgZt .search-category-selector__opener{border-radius:2px 0 0 2px;padding:0 0 0 0.5rem;min-height:32px;height:20px;border-right:1px solid rgba(0,0,0,0.3);} .dKTgZt _1L5qcXA4wOKR8LeHJgsqja{cursor:pointer;}
/* sc-component-id: SearchForm-dxsip9-0 */
.gTFTwO{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-box-flex:1;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;margin:0;padding:0;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;} @media screen and (min-width:600px){.gTFTwO{-webkit-transition:border 0.2s,background-color 0.2s,box-shadow 0.2s;transition:border 0.2s,background-color 0.2s,box-shadow 0.2s;}} .gTFTwO .nav-search__search-input-container{width:100%;padding-right:3.5rem;} .gTFTwO ._1-XI3_I8iwubPnQ1mmvW97{position:absolute;right:.35rem;min-width:2rem;cursor:pointer;top:.35rem;-webkit-transition:all 0.2s;transition:all 0.2s;} @media screen and (min-width:600px){.gTFTwO.q2gp5sSzXI30d2n_razRe ._1-XI3_I8iwubPnQ1mmvW97{background:transparent;opacity:1;}} .gTFTwO .imdb-header-search__input{background:transparent;-webkit-box-flex:1;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;outline:none;padding:1rem 1rem 1rem .75rem;width:100%;} @media screen and (min-width:600px){.gTFTwO .imdb-header-search__input{padding:.375em 0 .375rem .5rem;}} .gTFTwO .imdb-header-search__input::-ms-clear{display:none;}
/* sc-component-id: SearchBar-sc-1nweg6x-0 */
.hOXnzb{-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;left:0;margin:0;min-height:3.5rem;opacity:0;-webkit-transform:translateY(-10px);-ms-transform:translateY(-10px);transform:translateY(-10px);-webkit-transition:none;transition:none;-webkit-order:3;-ms-flex-order:3;order:3;pointer-events:none;position:absolute;top:0;visibility:hidden;width:100%;z-index:1;} .hOXnzb .imdb-header-search__state-closer{-webkit-transform:scale(0.5);-ms-transform:scale(0.5);transform:scale(0.5);-webkit-transition:-webkit-transform 0.2s 0.1s;-webkit-transition:transform 0.2s 0.1s;transition:transform 0.2s 0.1s;display:inline;margin:.25rem;position:absolute;right:0;top:0;} .hOXnzb .imdb-header-search__state,.hOXnzb .imdb-header-search__input,.hOXnzb .nav-search__search-submit{-moz-appearance:none;-webkit-appearance:none;-webkit-appearance:none;-moz-appearance:none;appearance:none;border:none;} @media screen and (min-width:600px){.hOXnzb{-webkit-box-flex:1;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;margin:0 0.5rem;padding:0;min-height:2.25rem;-webkit-order:3;-ms-flex-order:3;order:3;opacity:1;visibility:visible;pointer-events:auto;position:relative;-webkit-transform:translateY(0);-ms-transform:translateY(0);transform:translateY(0);}.hOXnzb .imdb-header-search__state,.hOXnzb .nav-search__search-submit{padding:0;}.hOXnzb .nav-search__search-submit:focus{outline:var(--ipt-focus-outline-on-base);outline-offset:1px;}.hOXnzb .imdb-header-search__state-closer{display:none;}}
/* sc-component-id: SearchBar__SearchLauncherButton-sc-1nweg6x-1 */
.hjoCyi{-webkit-transition:all 0.3s;transition:all 0.3s;opacity:1;-webkit-transform:scale(1);-ms-transform:scale(1);transform:scale(1);-webkit-order:3;-ms-flex-order:3;order:3;} @media screen and (min-width:600px){.hjoCyi{-webkit-order:3;-ms-flex-order:3;order:3;}.hjoCyi.imdb-header-search__state-opener{display:none;}}
/* sc-component-id: SearchBar__MobileSearchStateToggle-sc-1nweg6x-2 */
.cIKARP:checked ~ .nav-search__search-container{opacity:1;-webkit-transform:scale(1);-ms-transform:scale(1);transform:scale(1);-webkit-transition:opacity 0.2s,-webkit-transform 0.2s;-webkit-transition:opacity 0.2s,transform 0.2s;transition:opacity 0.2s,transform 0.2s;visibility:visible;pointer-events:auto;z-index:100;} .cIKARP:checked ~ .nav-search__search-container .nav-search__search-select,.cIKARP:checked ~ .nav-search__search-container .nav-search__search-submit{display:none;} .cIKARP:checked ~ .nav-search__search-container .imdb-header-search__state-closer{-webkit-transform:scale(1);-ms-transform:scale(1);transform:scale(1);} .cIKARP:checked ~ .nav-search__search-container ~ .SearchBar__SearchLauncherButton-sc-1nweg6x-1{-webkit-transform:scale(0.5);-ms-transform:scale(0.5);transform:scale(0.5);-webkit-transition:all 0.3s 0.3s;transition:all 0.3s 0.3s;opacity:0;}
/* sc-component-id: Drawer__StyledContainer-sc-1h7cs9y-0 */
.bkeTFm._14--k36qjjvLW3hUWHDPb_{bottom:0;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;left:0;overflow:hidden;-webkit-perspective:70vh;-moz-perspective:70vh;-ms-perspective:70vh;perspective:70vh;pointer-events:none;position:fixed;right:0;top:0;visibility:hidden;z-index:100;} .bkeTFm .iRO9SK-8q3D8_287dhn28{box-shadow:none;box-sizing:border-box;height:100%;overflow-x:hidden;overflow-y:auto;position:relative;-webkit-transform:translateX(calc(-100% - 36px));-ms-transform:translateX(calc(-100% - 36px));transform:translateX(calc(-100% - 36px));-webkit-transform-origin:right center;-ms-transform-origin:right center;transform-origin:right center;-webkit-transition:all 0.3s,box-shadow 0s;transition:all 0.3s,box-shadow 0s;width:280px;z-index:2;-webkit-overflow-scroll:touch;} .bkeTFm ._1iCYg55DI6ds7d3KVrdYBX{box-sizing:border-box;display:block;height:100%;left:0;opacity:0;position:absolute;top:0;-webkit-transition:opacity 0.3s;transition:opacity 0.3s;visibility:hidden;width:100%;will-change:opacity;z-index:1;} .bkeTFm ._3rHHDKyPLOjL8tGKHWMRza{-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;box-sizing:border-box;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-box-pack:end;-webkit-justify-content:flex-end;-ms-flex-pack:end;justify-content:flex-end;min-height:3.5rem;margin-bottom:0.5rem;padding:0.25rem;} .bkeTFm ._2RzUkzyrsjx_BPIQ5uoj5s{-webkit-touch-callout:none;-webkit-tap-highlight-color:transparent;} ._146x-LuQBSfM9yosRvjSGF:checked ~ .bkeTFm._14--k36qjjvLW3hUWHDPb_{pointer-events:auto;visibility:visible;} ._146x-LuQBSfM9yosRvjSGF:checked ~ .bkeTFm._14--k36qjjvLW3hUWHDPb_ > .iRO9SK-8q3D8_287dhn28{-webkit-transform:translateX(0);-ms-transform:translateX(0);transform:translateX(0);box-shadow:0px 11px 15px -7px rgba(var(--ipt-baseAlt-rgb),0.2),0px 24px 38px 3px rgba(var(--ipt-baseAlt-rgb),0.14),0px 9px 46px 8px rgba(var(--ipt-baseAlt-rgb),0.12);} ._146x-LuQBSfM9yosRvjSGF:checked ~ .bkeTFm._14--k36qjjvLW3hUWHDPb_ > ._1iCYg55DI6ds7d3KVrdYBX{opacity:0.5;visibility:visible;} @media screen and (min-width:1024px){.bkeTFm .iRO9SK-8q3D8_287dhn28{width:100%;-webkit-transform:translateY(calc(-100%));-ms-transform:translateY(calc(-100%));transform:translateY(calc(-100%));padding:2rem 0;}.bkeTFm ._3rHHDKyPLOjL8tGKHWMRza{background:none;max-width:1024px;margin:auto;-webkit-box-pack:justify;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;padding:0 1rem;}.bkeTFm ._3bRJYEaOz1BKUQYqW6yb29{max-width:1024px;margin:auto;}.bkeTFm .WNY8DBPCS1ZbiSd7NoqdP{display:inline;}}
/* sc-component-id: NavLink-sc-19k0khm-0 */
.LrpYY .ipc-icon{opacity:0.5;-webkit-transition:opacity 0.2s;transition:opacity 0.2s;} .LrpYY:hover .ipc-icon{opacity:1;} @media screen and (max-width:479px){.LrpYY.nav-link--hideXS{display:none;}} @media screen and (min-width:480px) and (max-width:599px){.LrpYY.nav-link--hideS{display:none;}} @media screen and (min-width:600px) and (max-width:1023px){.LrpYY.nav-link--hideM{display:none;}} @media screen and (min-width:1024px) and (max-width:1279px){.LrpYY.nav-link--hideL{display:none;}} @media screen and (min-width:1280px){.LrpYY.nav-link--hideXL{display:none;}}
/* sc-component-id: NavLinkCategory__StyledContainer-sc-1zvm8t-0 */
.eWjUDO ._2vjThdvAXrHx6CofJjm03w{cursor:pointer;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;border-top:1px solid transparent;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-box-pack:justify;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;height:3rem;margin:0;padding:0 1rem;-webkit-transition:color 0.1s ease-in,border-color 0.1s ease-in,opacity 0.12s ease-in;transition:color 0.1s ease-in,border-color 0.1s ease-in,opacity 0.12s ease-in;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;} .eWjUDO ._2vjThdvAXrHx6CofJjm03w:focus{outline:var(--ipt-focus-outline-on-baseAlt);outline-offset:1px;} .eWjUDO ._1tLXJMH37mh4UmvfVF8swF{padding-right:0.75rem;} .eWjUDO ._2aunAih-uMfbdgTUIjnQMd{-webkit-box-flex:1;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;overflow:hidden;padding-right:0.75rem;text-overflow:ellipsis;white-space:nowrap;} .eWjUDO ._2BeDp2pKthfMnxArm4lS0T{-webkit-transform:rotate(90deg);-ms-transform:rotate(90deg);transform:rotate(90deg);} .eWjUDO ._1tLXJMH37mh4UmvfVF8swF,.eWjUDO ._2BeDp2pKthfMnxArm4lS0T{opacity:0.5;-webkit-transition:all 0.2s;transition:all 0.2s;} .eWjUDO ._2vjThdvAXrHx6CofJjm03w:focus ._2BeDp2pKthfMnxArm4lS0T,.eWjUDO ._2vjThdvAXrHx6CofJjm03w:hover ._2BeDp2pKthfMnxArm4lS0T,.eWjUDO ._2vjThdvAXrHx6CofJjm03w:focus ._1tLXJMH37mh4UmvfVF8swF,.eWjUDO ._2vjThdvAXrHx6CofJjm03w:hover ._1tLXJMH37mh4UmvfVF8swF{opacity:1;} .eWjUDO ._1S9IOoNAVMPB2VikET3Lr2{overflow:hidden;border-bottom:1px solid transparent;-webkit-transition:border-color 0.1s ease-in,height 0.2s;transition:border-color 0.1s ease-in,height 0.2s;} .eWjUDO .s6lVaL5MYgQM-fYJ9KWp7:checked ~ span ._2vjThdvAXrHx6CofJjm03w ._1tLXJMH37mh4UmvfVF8swF{opacity:1;} .eWjUDO .s6lVaL5MYgQM-fYJ9KWp7:checked ~ span ._2vjThdvAXrHx6CofJjm03w ._2BeDp2pKthfMnxArm4lS0T{-webkit-transform:rotate(-90deg);-ms-transform:rotate(-90deg);transform:rotate(-90deg);} .eWjUDO .s6lVaL5MYgQM-fYJ9KWp7:checked ~ span ._1S9IOoNAVMPB2VikET3Lr2{display:block;} .eWjUDO:nth-of-type(1) ._2vjThdvAXrHx6CofJjm03w{border-top:none;} @media screen and (min-width:1024px){.eWjUDO.noMarginItem ._2vjThdvAXrHx6CofJjm03w{margin-top:0;}} @media screen and (min-width:1024px){.eWjUDO{-webkit-flex-basis:33%;-ms-flex-preferred-size:33%;flex-basis:33%;}.eWjUDO ._2vjThdvAXrHx6CofJjm03w{pointer-events:none;margin-top:1.5rem;height:3rem;border:none;}.eWjUDO .s6lVaL5MYgQM-fYJ9KWp7:checked ~ ._2Q0QZxgQqVpU0nQBqv1xlY ._2vjThdvAXrHx6CofJjm03w ._2aunAih-uMfbdgTUIjnQMd{color:inherit;}.eWjUDO ._1S9IOoNAVMPB2VikET3Lr2{visibility:inherit;height:auto !important;border:0;}.eWjUDO ._2BeDp2pKthfMnxArm4lS0T{display:none;}.eWjUDO ._1tLXJMH37mh4UmvfVF8swF{color:var(--ipt-on-baseAlt-accent1-color);opacity:1;}.eWjUDO .ipc-list__item{height:2rem;}.eWjUDO .ipc-list--baseAlt .ipc-list__item:hover{background:none;-webkit-text-decoration:underline;text-decoration:underline;}} @media screen and (max-width:479px){.eWjUDO._2BpsDlqEMlo9unX-C84Nji--hideXS{display:none;}} @media screen and (min-width:480px) and (max-width:599px){.eWjUDO._2BpsDlqEMlo9unX-C84Nji--hideS{display:none;}} @media screen and (min-width:600px) and (max-width:1023px){.eWjUDO._2BpsDlqEMlo9unX-C84Nji--hideM{display:none;}} @media screen and (min-width:1024px) and (max-width:1279px){.eWjUDO._2BpsDlqEMlo9unX-C84Nji--hideL{display:none;}} @media screen and (min-width:1280px){.eWjUDO._2BpsDlqEMlo9unX-C84Nji--hideXL{display:none;}}
/* sc-component-id: NavDynamicCategoryList__CategoryGroupContainer-f186ms-0 */
@media screen and (min-width:1024px){.dzfmPm{-webkit-flex-basis:33%;-ms-flex-preferred-size:33%;flex-basis:33%;}}
/* sc-component-id: NavDynamicCategoryList__EmptyContainer-f186ms-1 */
@media screen and (min-width:1024px){.dFDExU{-webkit-flex-basis:33%;-ms-flex-preferred-size:33%;flex-basis:33%;}}
/* sc-component-id: NavLinkCategoryList__StyledContainer-sc-13vymju-0 */
.diDBNJ ._1cBEhLbHn9YeCkfPvo9USU{list-style:none;margin:0.5rem 0;opacity:0.2;} .diDBNJ ._3xW8qYlqcCPv5fOHeXBer5{margin-bottom:3rem;margin-top:1.5rem;padding:1rem;height:auto;} @media screen and (min-width:1024px){.diDBNJ{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap;}.diDBNJ ._1BC0pBnjYqz3wST1u3CwmG{display:none;}.diDBNJ ._3xW8qYlqcCPv5fOHeXBer5{-webkit-align-self:flex-start;-ms-flex-item-align:start;align-self:flex-start;display:none;}.diDBNJ:focus{outline:var(--ipt-focus-outline-on-baseAlt);outline-offset:1px;}}
/* sc-component-id: NavLinkCategoryList__LogoNavLink-sc-13vymju-1 */
.RQLCk{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;}
/* sc-component-id: NavLinkCategoryList__TextNavLink-sc-13vymju-2 */
.YOYgO{margin-top:.25rem;}
/* sc-component-id: HamburgerMenu-k5mvoq-0 */
.erYeKd{-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;-webkit-order:0;-ms-flex-order:0;order:0;} .erYeKd.desktop{display:none;} @media screen and (min-width:1024px){.erYeKd{-webkit-order:1;-ms-flex-order:1;order:1;}.erYeKd.mobile{display:none;}.erYeKd.desktop{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;}}
/* sc-component-id: UserMenu-sc-1poz515-0 */
.eIWOUD{-webkit-order:6;-ms-flex-order:6;order:6;} @media screen and (min-width:600px){.eIWOUD .navbar__user-menu__username-divider,.eIWOUD .navbar__user-menu__username{display:none;}} @media screen and (min-width:1024px){.eIWOUD{-webkit-order:7;-ms-flex-order:7;order:7;}} .eIWOUD .navbar__user-menu-toggle__button{padding-right:0.25rem;} .eIWOUD .navbar__user-name{max-width:160px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;}
/* sc-component-id: NavWatchlistButton-sc-1b65w5j-0 */
.kaVyhF{-webkit-order:5;-ms-flex-order:5;order:5;display:none;} @media screen and (min-width:1024px){.kaVyhF{-webkit-order:6;-ms-flex-order:6;order:6;display:-webkit-inline-box;display:-webkit-inline-flex;display:-ms-inline-flexbox;display:inline-flex;}} .kaVyhF .imdb-header__watchlist-button-count{margin-left:0.5rem;background:var(--ipt-on-base-accent1-color);color:var(--ipt-on-accent1-color);padding:0 0.4rem;border-radius:10px;text-align:center;} .kaVyhF .ipc-button__text{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;}
/* sc-component-id: NavProFlyout-sc-1cjctnc-0 */
.hoAGyu{-webkit-order:4;-ms-flex-order:4;order:4;} @media screen and (min-width:1024px){.hoAGyu{-webkit-order:4;-ms-flex-order:4;order:4;}} .hoAGyu .navbar__imdbpro-menu-toggle__name{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;} .hoAGyu .navbar__imdbpro-content .navbar__flyout--menu{background-image:url(//m.media-amazon.com/images/G/01/imdb/images/navbar/imdbpro_navbar_menu_bg-3083451252._V_.png);background-size:cover;padding-left:17px;padding-bottom:25px;padding-top:25px;color:white;font-weight:bold;} .hoAGyu .navbar__imdbpro-imdb-pro-ad{background-repeat:no-repeat;color:white;cursor:pointer;width:573px;overflow:hidden;border-radius:8px;left:initial;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__content,.hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__image{display:inline-block;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__title{color:white;line-height:1.3em;margin-bottom:10px;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__line{cursor:inherit;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__link{display:inline-block;-webkit-text-decoration:none;text-decoration:none;vertical-align:middle;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__content,.hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__image{vertical-align:top;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__content{font-family:'Arial';margin-left:15px;width:400px;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__content .imdb-pro-ad__line{display:list-item;font-size:12px;list-style-position:inside;list-style-type:disc;margin:0px;padding:.1rem 0;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-ad__content .imdb-pro-ad__title{font-size:15px;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-new__button{margin-top:15px;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-new__button text{fill:#111111;font-size:13px;font-weight:normal;} .hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-new__button svg:hover rect,.hoAGyu .navbar__imdbpro-imdb-pro-ad .imdb-pro-new__button text:hover rect{fill:#f7dd95;} .hoAGyu .navbar__imdbpro-content .sub_nav{background-color:#f2f2f2;border-bottom-left-radius:10px;border-bottom-right-radius:10px;box-shadow:0 2px 5px rgba(0,0,0,0.6);color:#999;height:325px;} .hoAGyu .navbar__imdbpro-content .sub_nav h5{color:#A58500;margin:20px 0 10px;position:relative;}
/* sc-component-id: LegacyLoginNode-sc-1oajtws-0 */
.iwkRT{display:none;}
/* sc-component-id: Root__Header-sc-7p0yen-0 */
.gwOpQB{padding:0.25rem;margin:0;position:relative;z-index:1000;min-height:3.5rem;display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;width:100%;} .gwOpQB a{color:inherit;} .gwOpQB .navbar__inner{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-webkit-box-align:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:justify;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;width:100vw;margin:0;} @media screen and (min-width:600px){.gwOpQB .navbar__inner{padding:0 .75rem;}} @media screen and (min-width:1024px){.gwOpQB .navbar__inner{width:100%;margin:0 auto;}} .gwOpQB label{margin-bottom:0;}
/* sc-component-id: Root__Separator-sc-7p0yen-1 */
.cECatH{border:1px solid rgba(var(--ipt-on-baseAlt-rgb),.16);-webkit-order:5;-ms-flex-order:5;order:5;width:1px;height:2rem;margin:0 .5rem;} @media screen and (max-width:600px){.cECatH{display:none;-webkit-order:7;-ms-flex-order:7;order:7;}}</style>
    <div id="b14a9999-1cd5-43d0-a8bc-6c66338d6a7c">
       <nav id="imdbHeader" class="FHCtKBINjbqzCITNiccU0 imdb-header imdb-header--react Root__Header-sc-7p0yen-0 gwOpQB"><div id="nblogin" class="imdb-header__login-state-node"></div><div class="ipc-page-content-container ipc-page-content-container--center navbar__inner" role="presentation"><label id="imdbHeader-navDrawerOpen" class="ipc-icon-button jOOJQ0waXoTX6ZSthGtum HamburgerMenu-k5mvoq-0 erYeKd mobile ipc-icon-button--baseAlt ipc-icon-button--onBase" title="Open Navigation Drawer" role="button" tabindex="0" aria-label="Open Navigation Drawer" aria-disabled="false" for="imdbHeader-navDrawer"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--menu" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M4 18h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1s.45 1 1 1zm0-5h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1s.45 1 1 1zM3 7c0 .55.45 1 1 1h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1z"></path></svg></label><label id="imdbHeader-navDrawerOpen--desktop" class="ipc-button ipc-button--single-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-baseAlt ipc-button--theme-baseAlt ipc-button--on-textPrimary ipc-text-button jOOJQ0waXoTX6ZSthGtum HamburgerMenu-k5mvoq-0 erYeKd desktop" role="button" tabindex="0" aria-label="Open Navigation Drawer" aria-disabled="false" for="imdbHeader-navDrawer"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--menu ipc-button__icon ipc-button__icon--pre" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M4 18h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1s.45 1 1 1zm0-5h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1s.45 1 1 1zM3 7c0 .55.45 1 1 1h16c.55 0 1-.45 1-1s-.45-1-1-1H4c-.55 0-1 .45-1 1z"></path></svg><div class="ipc-button__text">Menu</div></label><input type="checkbox" class="_146x-LuQBSfM9yosRvjSGF" name="imdbHeader-navDrawer" id="imdbHeader-navDrawer" aria-hidden="true" hidden=""/><aside class="_14--k36qjjvLW3hUWHDPb_ _32i38MKalFVUkNAqPm88ln imdb-header__nav-drawer Drawer__StyledContainer-sc-1h7cs9y-0 bkeTFm" role="presentation" data-testid="drawer"><div class="iRO9SK-8q3D8_287dhn28" role="presentation" aria-hidden="true" data-testid="panel"><div class="_3rHHDKyPLOjL8tGKHWMRza" role="presentation" data-testid="panel-header"><a href="/?ref_=nv_home"><svg class="ipc-logo WNY8DBPCS1ZbiSd7NoqdP" xmlns="http://www.w3.org/2000/svg" width="98" height="56" viewBox="0 0 64 32" version="1.1"><g fill="#F5C518"><rect x="0" y="0" width="100%" height="100%" rx="4"></rect></g><g transform="translate(8.000000, 7.000000)" fill="#000000" fill-rule="nonzero"><polygon points="0 18 5 18 5 0 0 0"></polygon><path d="M15.6725178,0 L14.5534833,8.40846934 L13.8582008,3.83502426 C13.65661,2.37009263 13.4632474,1.09175121 13.278113,0 L7,0 L7,18 L11.2416347,18 L11.2580911,6.11380679 L13.0436094,18 L16.0633571,18 L17.7583653,5.8517865 L17.7707076,18 L22,18 L22,0 L15.6725178,0 Z"></path><path d="M24,18 L24,0 L31.8045586,0 C33.5693522,0 35,1.41994415 35,3.17660424 L35,14.8233958 C35,16.5777858 33.5716617,18 31.8045586,18 L24,18 Z M29.8322479,3.2395236 C29.6339219,3.13233348 29.2545158,3.08072342 28.7026524,3.08072342 L28.7026524,14.8914865 C29.4312846,14.8914865 29.8796736,14.7604764 30.0478195,14.4865461 C30.2159654,14.2165858 30.3021941,13.486105 30.3021941,12.2871637 L30.3021941,5.3078959 C30.3021941,4.49404499 30.272014,3.97397442 30.2159654,3.74371416 C30.1599168,3.5134539 30.0348852,3.34671372 29.8322479,3.2395236 Z"></path><path d="M44.4299079,4.50685823 L44.749518,4.50685823 C46.5447098,4.50685823 48,5.91267586 48,7.64486762 L48,14.8619906 C48,16.5950653 46.5451816,18 44.749518,18 L44.4299079,18 C43.3314617,18 42.3602746,17.4736618 41.7718697,16.6682739 L41.4838962,17.7687785 L37,17.7687785 L37,0 L41.7843263,0 L41.7843263,5.78053556 C42.4024982,5.01015739 43.3551514,4.50685823 44.4299079,4.50685823 Z M43.4055679,13.2842155 L43.4055679,9.01907814 C43.4055679,8.31433946 43.3603268,7.85185468 43.2660746,7.63896485 C43.1718224,7.42607505 42.7955881,7.2893916 42.5316822,7.2893916 C42.267776,7.2893916 41.8607934,7.40047379 41.7816216,7.58767002 L41.7816216,9.01907814 L41.7816216,13.4207851 L41.7816216,14.8074788 C41.8721037,15.0130276 42.2602358,15.1274059 42.5316822,15.1274059 C42.8031285,15.1274059 43.1982131,15.0166981 43.281155,14.8074788 C43.3640968,14.5982595 43.4055679,14.0880581 43.4055679,13.2842155 Z"></path></g></svg></a><label class="ipc-icon-button _2RzUkzyrsjx_BPIQ5uoj5s ipc-icon-button--baseAlt ipc-icon-button--onBase" title="Close Navigation Drawer" role="button" tabindex="0" aria-label="Close Navigation Drawer" aria-disabled="false" for="imdbHeader-navDrawer"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--clear" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M18.3 5.71a.996.996 0 0 0-1.41 0L12 10.59 7.11 5.7A.996.996 0 1 0 5.7 7.11L10.59 12 5.7 16.89a.996.996 0 1 0 1.41 1.41L12 13.41l4.89 4.89a.996.996 0 1 0 1.41-1.41L13.41 12l4.89-4.89c.38-.38.38-1.02 0-1.4z"></path></svg></label></div><div class="_3bRJYEaOz1BKUQYqW6yb29" role="presentation" data-testid="panel-content"><div role="presentation" class="_3wpok4xkiX-9E61ruFL_RA NavLinkCategoryList__StyledContainer-sc-13vymju-0 diDBNJ"><li role="separator" class="ipc-list-divider _1cBEhLbHn9YeCkfPvo9USU"></li><div class="_2BpsDlqEMlo9unX-C84Nji NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-mov" tabindex="-1" data-category-id="mov" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand Movies Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-mov" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--movie" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M18 4v1h-2V4c0-.55-.45-1-1-1H9c-.55 0-1 .45-1 1v1H6V4c0-.55-.45-1-1-1s-1 .45-1 1v16c0 .55.45 1 1 1s1-.45 1-1v-1h2v1c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-1h2v1c0 .55.45 1 1 1s1-.45 1-1V4c0-.55-.45-1-1-1s-1 .45-1 1zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm10 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">Movies</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/calendar/?ref_=nv_mv_cal" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Release Calendar</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/list/ls016522954/?ref_=nv_tvv_dvd" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">DVD &amp; Blu-ray Releases</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/chart/top/?ref_=nv_mv_250" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Top Rated Movies</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/chart/moviemeter/?ref_=nv_mv_mpm" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Most Popular Movies</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/feature/genre/?ref_=nv_ch_gr" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Browse Movies by Genre</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/chart/boxoffice/?ref_=nv_ch_cht" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Top Box Office</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideL nav-link--hideXL NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://m.imdb.com/showtimes/movie/?ref_=nv_mv_sh" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Showtimes &amp; Tickets</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/showtimes/?ref_=nv_mv_sh" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Showtimes &amp; Tickets</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/movies-in-theaters/?ref_=nv_mv_inth" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">In Theaters</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideL nav-link--hideXL NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://m.imdb.com/coming-soon/?ref_=nv_mv_cs" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Coming Soon</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/coming-soon/?ref_=nv_mv_cs" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Coming Soon</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/news/movie/?ref_=nv_nw_mv" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Movie News</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/india/toprated/?ref_=nv_mv_in" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">India Movie Spotlight</span></a></ul></div></div></span></div><div data-testid="grouped-link-category" class="NavDynamicCategoryList__CategoryGroupContainer-f186ms-0 dzfmPm"><div class="_2BpsDlqEMlo9unX-C84Nji NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-tvshows" tabindex="-1" data-category-id="tvshows" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand TV Shows Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-tvshows" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--television" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M21 3H3c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h5v1c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-1h5c1.1 0 1.99-.9 1.99-2L23 5a2 2 0 0 0-2-2zm-1 14H4c-.55 0-1-.45-1-1V6c0-.55.45-1 1-1h16c.55 0 1 .45 1 1v10c0 .55-.45 1-1 1z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">TV Shows</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/whats-on-tv/?ref_=nv_tv_ontv" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">What&#x27;s on TV &amp; Streaming</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideL nav-link--hideXL NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://m.imdb.com/whats-on-tv/?ref_=nv_tv_ontv" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">What&#x27;s on TV &amp; Streaming</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/chart/toptv/?ref_=nv_tvv_250" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Top Rated Shows</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/chart/tvmeter/?ref_=nv_tvv_mptv" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Most Popular Shows</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/feature/genre/?ref_=nv_tv_gr" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Browse TV Shows by Genre</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/news/tv/?ref_=nv_nw_tv" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">TV News</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/india/tv?ref_=nv_tv_in" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">India TV Spotlight</span></a></ul></div></div></span></div><div class="_2BpsDlqEMlo9unX-C84Nji NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-video" tabindex="-1" data-category-id="video" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand Watch Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-video" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--video-library" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M3 6c-.55 0-1 .45-1 1v13c0 1.1.9 2 2 2h13c.55 0 1-.45 1-1s-.45-1-1-1H5c-.55 0-1-.45-1-1V7c0-.55-.45-1-1-1zm17-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-8 12.5v-9l5.47 4.1c.27.2.27.6 0 .8L12 14.5z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">Watch</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/what-to-watch/?ref_=nv_watch" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">What to Watch</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/trailers/?ref_=nv_mv_tr" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Latest Trailers</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/originals/?ref_=nv_sf_ori" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">IMDb Originals</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/imdbpicks/?ref_=nv_pi" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">IMDb Picks</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/podcasts/?ref_=nv_pod" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">IMDb Podcasts</span></a></ul></div></div></span></div></div><div class="_2BpsDlqEMlo9unX-C84Nji NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-awards" tabindex="-1" data-category-id="awards" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand Awards &amp; Events Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-awards" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--star-circle-filled" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm3.23 15.39L12 15.45l-3.22 1.94a.502.502 0 0 1-.75-.54l.85-3.66-2.83-2.45a.505.505 0 0 1 .29-.88l3.74-.32 1.46-3.45c.17-.41.75-.41.92 0l1.46 3.44 3.74.32a.5.5 0 0 1 .28.88l-2.83 2.45.85 3.67c.1.43-.36.77-.74.54z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">Awards &amp; Events</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/oscars/?ref_=nv_ev_acd" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Oscars</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideL nav-link--hideXL NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://m.imdb.com/feature/bestpicture/?ref_=nv_ch_osc" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Best Picture Winners</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/search/title/?count=100&amp;groups=oscar_best_picture_winners&amp;sort=year%2Cdesc&amp;ref_=nv_ch_osc" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Best Picture Winners</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/golden-globes/?ref_=nv_ev_gg" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Golden Globes</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/emmys/?ref_=nv_ev_rte" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Emmys</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/imdbpicks/pride/?ref_=nv_ev_pri" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">LGBTQ+ Pride Month</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/starmeterawards/?ref_=nv_ev_sma" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">STARmeter Awards</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/comic-con/?ref_=nv_ev_comic" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">San Diego Comic-Con</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/nycc/?ref_=nv_ev_nycc" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">New York Comic-Con</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/sundance/?ref_=nv_ev_sun" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Sundance Film Festival</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/toronto/?ref_=nv_ev_tor" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Toronto Int&#x27;l Film Festival</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/awards-central/?ref_=nv_ev_awrd" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Awards Central</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/festival-central/?ref_=nv_ev_fc" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Festival Central</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/event/all/?ref_=nv_ev_all" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">All Events</span></a></ul></div></div></span></div><div class="_2BpsDlqEMlo9unX-C84Nji noMarginItem NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-celebs" tabindex="-1" data-category-id="celebs" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand Celebs Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-celebs" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--people" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V18c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05.02.01.03.03.04.04 1.14.83 1.93 1.94 1.93 3.41V18c0 .35-.07.69-.18 1H22c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">Celebs</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/feature/bornondate/?ref_=nv_cel_brn" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Born Today</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideL nav-link--hideXL NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://m.imdb.com/chart/starmeter/?ref_=nv_cel_brn" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Most Popular Celebs</span></a><a role="menuitem" class="ipc-list__item nav-link nav-link--hideXS nav-link--hideS nav-link--hideM NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://www.imdb.com/search/name/?gender=male%2Cfemale&amp;ref_=nv_cel_m" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Most Popular Celebs</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/news/celebrity/?ref_=nv_cel_nw" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Celebrity News</span></a></ul></div></div></span></div><div data-testid="nav-link-category" class="NavDynamicCategoryList__EmptyContainer-f186ms-1 dFDExU"></div><div class="_2BpsDlqEMlo9unX-C84Nji noMarginItem NavLinkCategory__StyledContainer-sc-1zvm8t-0 eWjUDO" data-testid="nav-link-category" role="presentation"><input type="radio" class="s6lVaL5MYgQM-fYJ9KWp7" name="nav-categories-list" id="nav-link-categories-comm" tabindex="-1" data-category-id="comm" hidden="" aria-hidden="true"/><span class="_2Q0QZxgQqVpU0nQBqv1xlY"><label role="button" aria-label="Expand Community Nav Links" class="_2vjThdvAXrHx6CofJjm03w" tabindex="0" for="nav-link-categories-comm" data-testid="category-expando"><span class="_1tLXJMH37mh4UmvfVF8swF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--earth" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"></path></svg></span><span class="_2aunAih-uMfbdgTUIjnQMd">Community</span><span class="_2BeDp2pKthfMnxArm4lS0T"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></label><div class="_1S9IOoNAVMPB2VikET3Lr2" aria-hidden="true" aria-expanded="false" data-testid="list-container"><div class="_1IQgIe3JwGh2arzItRgYN3" role="presentation"><ul class="ipc-list _1gB7giE3RrFWXvlzwjWk-q ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://help.imdb.com/imdb?ref_=cons_nb_hlp" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Help Center</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="https://contribute.imdb.com/czone?ref_=nv_cm_cz" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Contributor Zone</span></a><a role="menuitem" class="ipc-list__item nav-link NavLink-sc-19k0khm-0 LrpYY ipc-list__item--indent-one" href="/poll/?ref_=nv_cm_pl" tabindex="-1" aria-disabled="false"><span class="ipc-list-item__text" role="presentation">Polls</span></a></ul></div></div></span></div><a role="menuitem" class="ipc-list__item nav-link _3xW8qYlqcCPv5fOHeXBer5 NavLink-sc-19k0khm-0 LrpYY" href="https://pro.imdb.com?ref_=cons_nb_hm&amp;rf=cons_nb_hm" target="_blank" aria-label="Go To IMDb Pro" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><div class="_33PK8nBHiT1fGjnfXwum3v NavLinkCategoryList__LogoNavLink-sc-13vymju-1 RQLCk"><svg class="ipc-logo" width="52" height="14" viewBox="0 0 52 14" xmlns="http://www.w3.org/2000/svg" version="1.1"><g fill="currentColor"><rect x="0" y="1" width="3.21" height="12.34"></rect><path d="M10,1 L9.3,6.76 L8.84,3.63 C8.7,2.62 8.58,1.75 8.45,1 L4.3,1 L4.3,13.34 L7.11,13.34 L7.11,5.19 L8.3,13.34 L10.3,13.34 L11.42,5 L11.42,13.33 L14.22,13.33 L14.22,1 L10,1 Z"></path><path d="M19.24,3.22 C19.3711159,3.29185219 19.4602235,3.42180078 19.48,3.57 C19.5340993,3.92393477 19.554191,4.28223587 19.54,4.64 L19.54,9.42 C19.578852,9.92887392 19.5246327,10.4405682 19.38,10.93 C19.27,11.12 18.99,11.21 18.53,11.21 L18.53,3.11 C18.7718735,3.09406934 19.0142863,3.13162626 19.24,3.22 Z M19.24,13.34 C19.8163127,13.3574057 20.3928505,13.3138302 20.96,13.21 C21.3245396,13.1481159 21.6680909,12.9969533 21.96,12.77 C22.2288287,12.5438006 22.4209712,12.2398661 22.51,11.9 C22.643288,11.1679419 22.6969338,10.4236056 22.67,9.68 L22.67,5.34 C22.6662002,4.55669241 22.6060449,3.77467335 22.49,3 C22.43037,2.59841431 22.260779,2.22116094 22,1.91 C21.6636187,1.56093667 21.2326608,1.317654 20.76,1.21 C19.7709421,1.02848785 18.7647002,0.958050915 17.76,1 L15.32,1 L15.32,13.34 L19.24,13.34 Z"></path><path d="M27.86,10.34 C27.8769902,10.7218086 27.8501483,11.1043064 27.78,11.48 C27.72,11.63 27.46,11.71 27.26,11.71 C27.0954951,11.7299271 26.9386363,11.6349863 26.88,11.48 C26.7930212,11.1542289 26.7592527,10.8165437 26.78,10.48 L26.78,7.18 C26.7626076,6.84408875 26.7929089,6.50740774 26.87,6.18 C26.9317534,6.03447231 27.0833938,5.94840616 27.24,5.97 C27.43,5.97 27.7,6.05 27.76,6.21 C27.8468064,6.53580251 27.8805721,6.87345964 27.86,7.21 L27.86,10.34 Z M23.7,1 L23.7,13.34 L26.58,13.34 L26.78,12.55 C27.0112432,12.8467609 27.3048209,13.0891332 27.64,13.26 C28.0022345,13.4198442 28.394069,13.5016184 28.79,13.5 C29.2588971,13.515288 29.7196211,13.3746089 30.1,13.1 C30.4399329,12.8800058 30.6913549,12.5471372 30.81,12.16 C30.9423503,11.6167622 31.0061799,11.0590937 31,10.5 L31,7 C31.0087531,6.51279482 30.9920637,6.02546488 30.95,5.54 C30.904474,5.28996521 30.801805,5.05382649 30.65,4.85 C30.4742549,4.59691259 30.2270668,4.40194735 29.94,4.29 C29.5869438,4.15031408 29.2096076,4.08232558 28.83,4.09 C28.4361722,4.08961884 28.0458787,4.16428368 27.68,4.31 C27.3513666,4.46911893 27.0587137,4.693713 26.82,4.97 L26.82,1 L23.7,1 Z"></path><path d="M32.13,1 L35.32,1 C35.9925574,0.978531332 36.6650118,1.04577677 37.32,1.2 C37.717112,1.29759578 38.0801182,1.50157071 38.37,1.79 C38.6060895,2.05302496 38.7682605,2.37391646 38.84,2.72 C38.935586,3.27463823 38.9757837,3.8374068 38.96,4.4 L38.96,5.46 C38.9916226,6.03689533 38.9100917,6.61440551 38.72,7.16 C38.5402933,7.53432344 38.2260614,7.82713037 37.84,7.98 C37.3049997,8.18709035 36.7332458,8.28238268 36.16,8.26 L35.31,8.26 L35.31,13.16 L32.13,13.16 L32.13,1 Z M35.29,3.08 L35.29,6.18 L35.53,6.18 C35.7515781,6.20532753 35.9725786,6.12797738 36.13,5.97 C36.2717869,5.69610033 36.3308522,5.38687568 36.3,5.08 L36.3,4.08 C36.3390022,3.79579475 36.2713114,3.5072181 36.11,3.27 C35.8671804,3.11299554 35.5771259,3.04578777 35.29,3.08 Z"></path><path d="M42,4.36 L41.89,5.52 C42.28,4.69 43.67,4.42 44.41,4.37 L43.6,7.3 C43.2290559,7.27725357 42.8582004,7.34593052 42.52,7.5 C42.3057075,7.61238438 42.1519927,7.81367763 42.1,8.05 C42.0178205,8.59259006 41.9843538,9.14144496 42,9.69 L42,13.16 L39.34,13.16 L39.34,4.36 L42,4.36 Z"></path><path d="M51.63,9.71 C51.6472876,10.3265292 51.6003682,10.9431837 51.49,11.55 C51.376862,11.9620426 51.1639158,12.3398504 50.87,12.65 C50.5352227,13.001529 50.1148049,13.2599826 49.65,13.4 C49.0994264,13.5686585 48.5257464,13.6496486 47.95,13.64 C47.3333389,13.6524659 46.7178074,13.5818311 46.12,13.43 C45.6996896,13.322764 45.3140099,13.1092627 45,12.81 C44.7275808,12.5275876 44.5254637,12.1850161 44.41,11.81 C44.2627681,11.2181509 44.1921903,10.6098373 44.2,10 L44.2,7.64 C44.1691064,6.9584837 44.2780071,6.27785447 44.52,5.64 C44.7547114,5.12751365 45.1616363,4.71351186 45.67,4.47 C46.3337168,4.13941646 47.0688388,3.97796445 47.81,4 C48.4454888,3.98667568 49.0783958,4.08482705 49.68,4.29 C50.1352004,4.42444561 50.5506052,4.66819552 50.89,5 C51.1535526,5.26601188 51.3550281,5.58700663 51.48,5.94 C51.6001358,6.42708696 51.6506379,6.92874119 51.63,7.43 L51.63,9.71 Z M48.39,6.73 C48.412199,6.42705368 48.3817488,6.12255154 48.3,5.83 C48.2091142,5.71223121 48.0687606,5.64325757 47.92,5.64325757 C47.7712394,5.64325757 47.6308858,5.71223121 47.54,5.83 C47.447616,6.12046452 47.4136298,6.42634058 47.44,6.73 L47.44,10.93 C47.4168299,11.2204468 47.4508034,11.5126191 47.54,11.79 C47.609766,11.9270995 47.7570827,12.0067302 47.91,11.99 C48.0639216,12.0108082 48.2159732,11.9406305 48.3,11.81 C48.3790864,11.5546009 48.4096133,11.2866434 48.39,11.02 L48.39,6.73 Z"></path></g></svg><div class="NavLinkCategoryList__TextNavLink-sc-13vymju-2 YOYgO">For Industry Professionals</div></div></span><span class="ipc-list-item__icon ipc-list-item__icon--post" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--launch" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M16 16.667H8A.669.669 0 0 1 7.333 16V8c0-.367.3-.667.667-.667h3.333c.367 0 .667-.3.667-.666C12 6.3 11.7 6 11.333 6h-4C6.593 6 6 6.6 6 7.333v9.334C6 17.4 6.6 18 7.333 18h9.334C17.4 18 18 17.4 18 16.667v-4c0-.367-.3-.667-.667-.667-.366 0-.666.3-.666.667V16c0 .367-.3.667-.667.667zm-2.667-10c0 .366.3.666.667.666h1.727L9.64 13.42a.664.664 0 1 0 .94.94l6.087-6.087V10c0 .367.3.667.666.667.367 0 .667-.3.667-.667V6h-4c-.367 0-.667.3-.667.667z"></path></svg></span></a></div></div></div><label class="_1iCYg55DI6ds7d3KVrdYBX" data-testid="backdrop" role="button" for="imdbHeader-navDrawer" tabindex="0" aria-hidden="true" aria-label="Close Navigation Drawer"></label></aside><a class="NavLogo-e02kni-0 ddqdtC imdb-header__logo-link _3XaDsUnZG7ZfFqFF37dZPv" id="home_img_holder" href="/?ref_=nv_home" aria-label="Home"><svg id="home_img" class="ipc-logo" xmlns="http://www.w3.org/2000/svg" width="64" height="32" viewBox="0 0 64 32" version="1.1"><g fill="#F5C518"><rect x="0" y="0" width="100%" height="100%" rx="4"></rect></g><g transform="translate(8.000000, 7.000000)" fill="#000000" fill-rule="nonzero"><polygon points="0 18 5 18 5 0 0 0"></polygon><path d="M15.6725178,0 L14.5534833,8.40846934 L13.8582008,3.83502426 C13.65661,2.37009263 13.4632474,1.09175121 13.278113,0 L7,0 L7,18 L11.2416347,18 L11.2580911,6.11380679 L13.0436094,18 L16.0633571,18 L17.7583653,5.8517865 L17.7707076,18 L22,18 L22,0 L15.6725178,0 Z"></path><path d="M24,18 L24,0 L31.8045586,0 C33.5693522,0 35,1.41994415 35,3.17660424 L35,14.8233958 C35,16.5777858 33.5716617,18 31.8045586,18 L24,18 Z M29.8322479,3.2395236 C29.6339219,3.13233348 29.2545158,3.08072342 28.7026524,3.08072342 L28.7026524,14.8914865 C29.4312846,14.8914865 29.8796736,14.7604764 30.0478195,14.4865461 C30.2159654,14.2165858 30.3021941,13.486105 30.3021941,12.2871637 L30.3021941,5.3078959 C30.3021941,4.49404499 30.272014,3.97397442 30.2159654,3.74371416 C30.1599168,3.5134539 30.0348852,3.34671372 29.8322479,3.2395236 Z"></path><path d="M44.4299079,4.50685823 L44.749518,4.50685823 C46.5447098,4.50685823 48,5.91267586 48,7.64486762 L48,14.8619906 C48,16.5950653 46.5451816,18 44.749518,18 L44.4299079,18 C43.3314617,18 42.3602746,17.4736618 41.7718697,16.6682739 L41.4838962,17.7687785 L37,17.7687785 L37,0 L41.7843263,0 L41.7843263,5.78053556 C42.4024982,5.01015739 43.3551514,4.50685823 44.4299079,4.50685823 Z M43.4055679,13.2842155 L43.4055679,9.01907814 C43.4055679,8.31433946 43.3603268,7.85185468 43.2660746,7.63896485 C43.1718224,7.42607505 42.7955881,7.2893916 42.5316822,7.2893916 C42.267776,7.2893916 41.8607934,7.40047379 41.7816216,7.58767002 L41.7816216,9.01907814 L41.7816216,13.4207851 L41.7816216,14.8074788 C41.8721037,15.0130276 42.2602358,15.1274059 42.5316822,15.1274059 C42.8031285,15.1274059 43.1982131,15.0166981 43.281155,14.8074788 C43.3640968,14.5982595 43.4055679,14.0880581 43.4055679,13.2842155 Z"></path></g></svg></a><input type="checkbox" class="imdb-header-search__state EL4bTiUhQdfIvyX_PMRVv SearchBar__MobileSearchStateToggle-sc-1nweg6x-2 cIKARP" id="navSearch-searchState" name="navSearch-searchState" aria-hidden="true" hidden=""/><div id="suggestion-search-container" class="nav-search__search-container _2cVsg1cgtNxl8NEGDHTPH6 SearchBar-sc-1nweg6x-0 hOXnzb"><form id="nav-search-form" name="nav-search-form" method="get" action="/find" class="_19kygDgP4Og4wL_TIXtDmm imdb-header__search-form SearchForm-dxsip9-0 gTFTwO" role="search"><div class="search-category-selector SearchCategorySelector__StyledContainer-sc-18f40f7-0 dKTgZt"><div class="FlyoutMenu-xq6xx0-0 crQfrC navbar__flyout--breakpoint-m navbar__flyout--positionLeft"><label class="ipc-button ipc-button--single-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-base ipc-button--theme-base ipc-button--on-textPrimary ipc-text-button navbar__flyout__text-button-after-mobile search-category-selector__opener P7UFTypc7bsdHDd2RHdil nav-search-form__categories" role="button" tabindex="0" aria-label="All" aria-disabled="false" for="navbar-search-category-select"><div class="ipc-button__text">All<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--arrow-drop-down navbar__flyout__button-pointer" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M8.71 11.71l2.59 2.59c.39.39 1.02.39 1.41 0l2.59-2.59c.63-.63.18-1.71-.71-1.71H9.41c-.89 0-1.33 1.08-.7 1.71z"></path></svg></div></label><input type="checkbox" class="ipc-menu__focused-state" id="navbar-search-category-select" name="navbar-search-category-select" hidden="" tabindex="-1" aria-hidden="true"/><div class="ipc-menu mdc-menu ipc-menu--not-initialized ipc-menu--on-baseAlt ipc-menu--anchored ipc-menu--with-checkbox ipc-menu--expand-from-top-left navbar__flyout--menu" data-menu-id="navbar-search-category-select" role="presentation"><div class="ipc-menu__items mdc-menu__items" role="presentation"><span id="navbar-search-category-select-contents"><ul class="ipc-list _2crW0ewf49BFHCKEEUJ_9o ipc-list--baseAlt" role="menu" aria-orientation="vertical"><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja _3lrXaniHRqyCb5hUFHbcds" aria-label="All" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--search _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M15.5 14h-.79l-.28-.27a6.5 6.5 0 0 0 1.48-5.34c-.47-2.78-2.79-5-5.59-5.34a6.505 6.505 0 0 0-7.27 7.27c.34 2.8 2.56 5.12 5.34 5.59a6.5 6.5 0 0 0 5.34-1.48l.27.28v.79l4.25 4.25c.41.41 1.08.41 1.49 0 .41-.41.41-1.08 0-1.49L15.5 14zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path></svg>All</span></a><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" aria-label="Titles" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--movie _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M18 4v1h-2V4c0-.55-.45-1-1-1H9c-.55 0-1 .45-1 1v1H6V4c0-.55-.45-1-1-1s-1 .45-1 1v16c0 .55.45 1 1 1s1-.45 1-1v-1h2v1c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-1h2v1c0 .55.45 1 1 1s1-.45 1-1V4c0-.55-.45-1-1-1s-1 .45-1 1zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm10 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z"></path></svg>Titles</span></a><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" aria-label="TV Episodes" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--television _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M21 3H3c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h5v1c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-1h5c1.1 0 1.99-.9 1.99-2L23 5a2 2 0 0 0-2-2zm-1 14H4c-.55 0-1-.45-1-1V6c0-.55.45-1 1-1h16c.55 0 1 .45 1 1v10c0 .55-.45 1-1 1z"></path></svg>TV Episodes</span></a><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" aria-label="Celebs" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--people _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V18c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05.02.01.03.03.04.04 1.14.83 1.93 1.94 1.93 3.41V18c0 .35-.07.69-.18 1H22c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5z"></path></svg>Celebs</span></a><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" aria-label="Companies" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--business _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M12 7V5c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V9c0-1.1-.9-2-2-2h-8zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm9 12h-7v-2h2v-2h-2v-2h2v-2h-2V9h7c.55 0 1 .45 1 1v8c0 .55-.45 1-1 1zm-1-8h-2v2h2v-2zm0 4h-2v2h2v-2z"></path></svg>Companies</span></a><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" aria-label="Keywords" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--label _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M17.63 5.84C17.27 5.33 16.67 5 16 5L5 5.01C3.9 5.01 3 5.9 3 7v10c0 1.1.9 1.99 2 1.99L16 19c.67 0 1.27-.33 1.63-.84l3.96-5.58a.99.99 0 0 0 0-1.16l-3.96-5.58z"></path></svg>Keywords</span></a><li role="separator" class="ipc-list-divider"></li><a role="menuitem" class="ipc-list__item _1L5qcXA4wOKR8LeHJgsqja" href="https://www.imdb.com/search/" tabindex="0" aria-disabled="false"><span class="ipc-list-item__text" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--find-in-page _2re8nTkPmRXI_TBcLnh1u8" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M20 19.59V8.83c0-.53-.21-1.04-.59-1.41l-4.83-4.83c-.37-.38-.88-.59-1.41-.59H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c.45 0 .85-.15 1.19-.4l-4.43-4.43c-.86.56-1.89.88-3 .82-2.37-.11-4.4-1.96-4.72-4.31a5.013 5.013 0 0 1 5.83-5.61c1.95.33 3.57 1.85 4 3.78.33 1.46.01 2.82-.7 3.9L20 19.59zM9 13c0 1.66 1.34 3 3 3s3-1.34 3-3-1.34-3-3-3-3 1.34-3 3z"></path></svg>Advanced Search</span><span class="ipc-list-item__icon ipc-list-item__icon--post" role="presentation"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--chevron-right" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M9.29 6.71a.996.996 0 0 0 0 1.41L13.17 12l-3.88 3.88a.996.996 0 1 0 1.41 1.41l4.59-4.59a.996.996 0 0 0 0-1.41L10.7 6.7c-.38-.38-1.02-.38-1.41.01z"></path></svg></span></a></ul></span></div></div></div></div><div class="nav-search__search-input-container SearchTypeahead-sc-112a48v-0 OQYVG"><div role="combobox" aria-haspopup="listbox" aria-owns="react-autowhatever-1" aria-expanded="false" class="react-autosuggest__container"><input type="text" value="" autoComplete="off" aria-autocomplete="list" aria-controls="react-autowhatever-1" class="imdb-header-search__input _3gDVKsXm3b_VAMhhSw1haV react-autosuggest__input" id="suggestion-search" name="q" placeholder="Search IMDb" aria-label="Search IMDb" autoCapitalize="off" autoCorrect="off"/></div></div><button id="suggestion-search-button" type="submit" aria-label="Submit Search" class="nav-search__search-submit _1-XI3_I8iwubPnQ1mmvW97"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--magnify" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M15.5 14h-.79l-.28-.27a6.5 6.5 0 0 0 1.48-5.34c-.47-2.78-2.79-5-5.59-5.34a6.505 6.505 0 0 0-7.27 7.27c.34 2.8 2.56 5.12 5.34 5.59a6.5 6.5 0 0 0 5.34-1.48l.27.28v.79l4.25 4.25c.41.41 1.08.41 1.49 0 .41-.41.41-1.08 0-1.49L15.5 14zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path></svg></button><input type="hidden" name="ref_" value="nv_sr_sm"/></form><label id="imdbHeader-searchClose" class="ipc-icon-button imdb-header-search__state-closer ipc-icon-button--baseAlt ipc-icon-button--onBase" title="Close Search" role="button" tabindex="0" aria-label="Close Search" aria-disabled="false" for="navSearch-searchState"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--clear" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M18.3 5.71a.996.996 0 0 0-1.41 0L12 10.59 7.11 5.7A.996.996 0 1 0 5.7 7.11L10.59 12 5.7 16.89a.996.996 0 1 0 1.41 1.41L12 13.41l4.89 4.89a.996.996 0 1 0 1.41-1.41L13.41 12l4.89-4.89c.38-.38.38-1.02 0-1.4z"></path></svg></label></div><label id="imdbHeader-searchOpen" class="ipc-icon-button imdb-header-search__state-opener SearchBar__SearchLauncherButton-sc-1nweg6x-1 hjoCyi ipc-icon-button--baseAlt ipc-icon-button--onBase" title="Open Search" role="button" tabindex="0" aria-label="Open Search" aria-disabled="false" for="navSearch-searchState"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="ipc-icon ipc-icon--magnify" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path fill="none" d="M0 0h24v24H0V0z"></path><path d="M15.5 14h-.79l-.28-.27a6.5 6.5 0 0 0 1.48-5.34c-.47-2.78-2.79-5-5.59-5.34a6.505 6.505 0 0 0-7.27 7.27c.34 2.8 2.56 5.12 5.34 5.59a6.5 6.5 0 0 0 5.34-1.48l.27.28v.79l4.25 4.25c.41.41 1.08.41 1.49 0 .41-.41.41-1.08 0-1.49L15.5 14zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path></svg></label><div class="navbar__imdbpro NavProFlyout-sc-1cjctnc-0 hoAGyu"><div class="navbar__imdbpro-content FlyoutMenu-xq6xx0-0 crQfrC navbar__flyout--breakpoint-l"><a class="ipc-button ipc-button--single-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-baseAlt ipc-button--theme-baseAlt ipc-button--on-textPrimary ipc-text-button navbar__flyout__text-button-after-mobile navbar__imdb-pro--toggle" role="button" tabindex="0" aria-label="Go To IMDb Pro" aria-disabled="false" href="https://pro.imdb.com/login/ap?u=/login/lwa&amp;imdbPageAction=signUp&amp;rf=cons_nb_hm&amp;ref_=cons_nb_hm"><div class="ipc-button__text"><svg class="ipc-logo navbar__imdbpro-menu-toggle__name" width="52" height="14" viewBox="0 0 52 14" xmlns="http://www.w3.org/2000/svg" version="1.1"><g fill="currentColor"><rect x="0" y="1" width="3.21" height="12.34"></rect><path d="M10,1 L9.3,6.76 L8.84,3.63 C8.7,2.62 8.58,1.75 8.45,1 L4.3,1 L4.3,13.34 L7.11,13.34 L7.11,5.19 L8.3,13.34 L10.3,13.34 L11.42,5 L11.42,13.33 L14.22,13.33 L14.22,1 L10,1 Z"></path><path d="M19.24,3.22 C19.3711159,3.29185219 19.4602235,3.42180078 19.48,3.57 C19.5340993,3.92393477 19.554191,4.28223587 19.54,4.64 L19.54,9.42 C19.578852,9.92887392 19.5246327,10.4405682 19.38,10.93 C19.27,11.12 18.99,11.21 18.53,11.21 L18.53,3.11 C18.7718735,3.09406934 19.0142863,3.13162626 19.24,3.22 Z M19.24,13.34 C19.8163127,13.3574057 20.3928505,13.3138302 20.96,13.21 C21.3245396,13.1481159 21.6680909,12.9969533 21.96,12.77 C22.2288287,12.5438006 22.4209712,12.2398661 22.51,11.9 C22.643288,11.1679419 22.6969338,10.4236056 22.67,9.68 L22.67,5.34 C22.6662002,4.55669241 22.6060449,3.77467335 22.49,3 C22.43037,2.59841431 22.260779,2.22116094 22,1.91 C21.6636187,1.56093667 21.2326608,1.317654 20.76,1.21 C19.7709421,1.02848785 18.7647002,0.958050915 17.76,1 L15.32,1 L15.32,13.34 L19.24,13.34 Z"></path><path d="M27.86,10.34 C27.8769902,10.7218086 27.8501483,11.1043064 27.78,11.48 C27.72,11.63 27.46,11.71 27.26,11.71 C27.0954951,11.7299271 26.9386363,11.6349863 26.88,11.48 C26.7930212,11.1542289 26.7592527,10.8165437 26.78,10.48 L26.78,7.18 C26.7626076,6.84408875 26.7929089,6.50740774 26.87,6.18 C26.9317534,6.03447231 27.0833938,5.94840616 27.24,5.97 C27.43,5.97 27.7,6.05 27.76,6.21 C27.8468064,6.53580251 27.8805721,6.87345964 27.86,7.21 L27.86,10.34 Z M23.7,1 L23.7,13.34 L26.58,13.34 L26.78,12.55 C27.0112432,12.8467609 27.3048209,13.0891332 27.64,13.26 C28.0022345,13.4198442 28.394069,13.5016184 28.79,13.5 C29.2588971,13.515288 29.7196211,13.3746089 30.1,13.1 C30.4399329,12.8800058 30.6913549,12.5471372 30.81,12.16 C30.9423503,11.6167622 31.0061799,11.0590937 31,10.5 L31,7 C31.0087531,6.51279482 30.9920637,6.02546488 30.95,5.54 C30.904474,5.28996521 30.801805,5.05382649 30.65,4.85 C30.4742549,4.59691259 30.2270668,4.40194735 29.94,4.29 C29.5869438,4.15031408 29.2096076,4.08232558 28.83,4.09 C28.4361722,4.08961884 28.0458787,4.16428368 27.68,4.31 C27.3513666,4.46911893 27.0587137,4.693713 26.82,4.97 L26.82,1 L23.7,1 Z"></path><path d="M32.13,1 L35.32,1 C35.9925574,0.978531332 36.6650118,1.04577677 37.32,1.2 C37.717112,1.29759578 38.0801182,1.50157071 38.37,1.79 C38.6060895,2.05302496 38.7682605,2.37391646 38.84,2.72 C38.935586,3.27463823 38.9757837,3.8374068 38.96,4.4 L38.96,5.46 C38.9916226,6.03689533 38.9100917,6.61440551 38.72,7.16 C38.5402933,7.53432344 38.2260614,7.82713037 37.84,7.98 C37.3049997,8.18709035 36.7332458,8.28238268 36.16,8.26 L35.31,8.26 L35.31,13.16 L32.13,13.16 L32.13,1 Z M35.29,3.08 L35.29,6.18 L35.53,6.18 C35.7515781,6.20532753 35.9725786,6.12797738 36.13,5.97 C36.2717869,5.69610033 36.3308522,5.38687568 36.3,5.08 L36.3,4.08 C36.3390022,3.79579475 36.2713114,3.5072181 36.11,3.27 C35.8671804,3.11299554 35.5771259,3.04578777 35.29,3.08 Z"></path><path d="M42,4.36 L41.89,5.52 C42.28,4.69 43.67,4.42 44.41,4.37 L43.6,7.3 C43.2290559,7.27725357 42.8582004,7.34593052 42.52,7.5 C42.3057075,7.61238438 42.1519927,7.81367763 42.1,8.05 C42.0178205,8.59259006 41.9843538,9.14144496 42,9.69 L42,13.16 L39.34,13.16 L39.34,4.36 L42,4.36 Z"></path><path d="M51.63,9.71 C51.6472876,10.3265292 51.6003682,10.9431837 51.49,11.55 C51.376862,11.9620426 51.1639158,12.3398504 50.87,12.65 C50.5352227,13.001529 50.1148049,13.2599826 49.65,13.4 C49.0994264,13.5686585 48.5257464,13.6496486 47.95,13.64 C47.3333389,13.6524659 46.7178074,13.5818311 46.12,13.43 C45.6996896,13.322764 45.3140099,13.1092627 45,12.81 C44.7275808,12.5275876 44.5254637,12.1850161 44.41,11.81 C44.2627681,11.2181509 44.1921903,10.6098373 44.2,10 L44.2,7.64 C44.1691064,6.9584837 44.2780071,6.27785447 44.52,5.64 C44.7547114,5.12751365 45.1616363,4.71351186 45.67,4.47 C46.3337168,4.13941646 47.0688388,3.97796445 47.81,4 C48.4454888,3.98667568 49.0783958,4.08482705 49.68,4.29 C50.1352004,4.42444561 50.5506052,4.66819552 50.89,5 C51.1535526,5.26601188 51.3550281,5.58700663 51.48,5.94 C51.6001358,6.42708696 51.6506379,6.92874119 51.63,7.43 L51.63,9.71 Z M48.39,6.73 C48.412199,6.42705368 48.3817488,6.12255154 48.3,5.83 C48.2091142,5.71223121 48.0687606,5.64325757 47.92,5.64325757 C47.7712394,5.64325757 47.6308858,5.71223121 47.54,5.83 C47.447616,6.12046452 47.4136298,6.42634058 47.44,6.73 L47.44,10.93 C47.4168299,11.2204468 47.4508034,11.5126191 47.54,11.79 C47.609766,11.9270995 47.7570827,12.0067302 47.91,11.99 C48.0639216,12.0108082 48.2159732,11.9406305 48.3,11.81 C48.3790864,11.5546009 48.4096133,11.2866434 48.39,11.02 L48.39,6.73 Z"></path></g></svg></div></a></div></div><div class="Root__Separator-sc-7p0yen-1 cECatH"></div><div class="NavWatchlistButton-sc-1b65w5j-0 kaVyhF imdb-header__watchlist-button"><a class="ipc-button ipc-button--single-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-baseAlt ipc-button--theme-baseAlt ipc-button--on-textPrimary ipc-text-button" role="button" tabindex="0" aria-disabled="false" href="/list/watchlist?ref_=nv_usr_wl_all_0"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--watchlist ipc-button__icon ipc-button__icon--pre" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M17 3c1.05 0 1.918.82 1.994 1.851L19 5v16l-7-3-7 3V5c0-1.05.82-1.918 1.851-1.994L7 3h10zm-4 4h-2v3H8v2h3v3h2v-3h3v-2h-3V7z" fill="currentColor"></path></svg><div class="ipc-button__text">Watchlist</div></a></div><div class="_3x17Igk9XRXcaKrcG3_MXQ navbar__user UserMenu-sc-1poz515-0 eIWOUD"><a class="ipc-button ipc-button--single-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-baseAlt ipc-button--theme-baseAlt ipc-button--on-textPrimary ipc-text-button imdb-header__signin-text" role="button" tabindex="0" aria-disabled="false" href="/registration/signin?ref=nv_generic_lgin"><div class="ipc-button__text">Sign In</div></a></div></div></nav><svg style="width:0;height:0;overflow:hidden;display:block" xmlns="http://www.w3.org/2000/svg" version="1.1"><defs><linearGradient id="ipc-svg-gradient-tv-logo-t" x1="31.973%" y1="53.409%" x2="153.413%" y2="-16.853%"><stop stop-color="#D01F49" offset="21.89%"></stop><stop stop-color="#E8138B" offset="83.44%"></stop></linearGradient><linearGradient id="ipc-svg-gradient-tv-logo-v" x1="-38.521%" y1="84.997%" x2="104.155%" y2="14.735%"><stop stop-color="#D01F49" offset="21.89%"></stop><stop stop-color="#E8138B" offset="83.44%"></stop></linearGradient></defs></svg>
    </div>
<script type="text/javascript">
    if (!window.RadWidget) {
        window.RadWidget = {
            registerReactWidgetInstance: function(input) {
                window.RadWidget[input.widgetName] = window.RadWidget[input.widgetName] || [];
                window.RadWidget[input.widgetName].push({
                    id: input.instanceId,
                    props: JSON.stringify(input.model)
                })
            },
            getReactWidgetInstances: function(widgetName) {
                return window.RadWidget[widgetName] || []
            }
        };
    }
</script>    <script type="text/javascript">
        window['RadWidget'].registerReactWidgetInstance({
            widgetName: "IMDbConsumerSiteNavFeatureV1",
            instanceId: "b14a9999-1cd5-43d0-a8bc-6c66338d6a7c",
            model: {"username":null,"isLoggedIn":false,"showIMDbTVLink":false,"weblabs":[]}
        });
    </script>
<script>
    if (typeof uet == 'function') {
      uet("ne");
    }
</script>

        <style>
            .oscars-site-stripe {
                background-color: #000;
                overflow: hidden;
                display: flex;
                justify-content: center;
            }
            .oscars-site-stripe__img--sm {
                height: 64px;
            }
        </style>
        <div class="oscars-site-stripe">
        </div>


        <div id="wrapper">
            <div id="root" class="redesign">
                <div id="nb20" class="navbarSprite">
                    <div id="supertab">	
        <!-- no content received for slot: top_ad -->
            <script>
                if (window && window.mediaOrchestrator) {
                    window.mediaOrchestrator.publish('mediaPlaybackEvent', {
                        type: 'no-autoplay-video-ad-detected',
                        slotName: 'top_ad',
                        timestamp: Date.now()
                    });
                }
            </script>
	
</div>
	
        <!-- no content received for slot: navstrip -->
	
	
        <!-- no content received for slot: injected_navstrip -->
	
                </div>
              

               <div id="pagecontent" class="pagecontent">
	
        <!-- no content received for slot: injected_billboard -->
	


    
    
    

    
    
    

<div id="content-2-wide" class="redesign">

    <div class="maindetails_center" id="maindetails_center_top">


    
    
    

    
    
    

	
        <!-- no content received for slot: provider_promotion -->
	


    
    
    


                <div class="article name-overview with-hero">
<script>
    if (typeof uet == 'function') {
      uet("bb", "NameOverviewWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameOverviewWidget_started');
      }
    </script>

    <div id="name-overview-widget" class="name-overview-widget">
        <table cellspacing="0" cellpadding="0" border="0" id="name-overview-widget-layout">
            <tbody>
                <tr>
                    <td class="name-overview-widget__section">
    <h1 class="header"> <span class="itemprop">Franka Potente</span>


    </h1>

        <div class="infobar" id="name-job-categories">
            
<a href="#actress"
onclick="nameJobCategoriesClickHandler(this)" > <span class="itemprop">
Actress</span></a>                     <span class="ghost">|</span> 
            
<a href="#soundtrack"
onclick="nameJobCategoriesClickHandler(this)" > <span class="itemprop">
Soundtrack</span></a>                     <span class="ghost">|</span> 
            
<a href="#director"
onclick="nameJobCategoriesClickHandler(this)" > <span class="itemprop">
Director</span></a>                
        </div>

        <hr/>







            <div id="prometer_container">
                <div id="prometer" class="meter-collapsed up three-line">
                    <div id="meterHeaderBox">
                        <div class="meterToggleOnHover">STARmeter</div>
<a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_meter&ref_=cons_nm_meter"
id="meterRank" >Top 5000</a>
                    </div>
                    <div id="meterChangeRow" class="meterToggleOnHover">
                            <span>Up</span>
                        <span id="meterChange">103</span>
                        <span>this week</span>
                    </div>
                    <div id="meterSeeMoreRow" class="meterToggleOnHover">
<a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_meter&ref_=cons_nm_meter"
>View rank on IMDbPro</a>
                        <span>&raquo;</span>
                    </div>
                </div>
            </div>
                    </td>
                </tr>
                <tr>
                    <td id="img_primary">
                        <div class="poster-hero-container">
                                <div class="image">
<a href="/name/nm0004376/mediaviewer/rm1767485184?ref_=nm_ov_ph"
> <img id="name-poster"
height="317"
width="214"
alt="Franka Potente Picture"
title="Franka Potente Picture"
src="https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_UY317_CR5,0,214,317_AL_.jpg" />
</a>                                </div> 

    <div class="heroWidget">
        <figure class="slate">
<a href="/video/imdb/vi413448985?playlistId=nm0004376&ref_=nm_ov_vi"
class="slate_button prevent-ad-overlay video-modal" data-type='recommends' data-nconst='nm0004376' data-video='vi413448985' data-context='imdb' data-refsuffix='nm_ov_vi' data-pixels=''> <img alt="Trailer"
title="Trailer"
src="https://m.media-amazon.com/images/M/MV5BMDE1Yzc2NGQtZGIyNS00NDIzLWJlMjQtNTc5MDRhYjQ4MzgyXkEyXkFqcGdeQXRodW1ibmFpbC1pbml0aWFsaXplcg@@._V1_UX477_CR0,0,477,268_AL_.jpg" />
</a>            <figcaption class="caption">
                <div>2:01 <span class="ghost">|</span> Trailer</div>
                    <div >        <a href="/name/nm0004376/videogallery?ref_=nm_ov_vi_sm"
>17 VIDEOS</a>
    <span class="ghost">|</span>        <a href="/name/nm0004376/mediaindex?ref_=nm_ov_mi_sm"
>126 IMAGES</a>
</div>
            </figcaption>
        </figure>
    </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td id="overview-top" class="name-overview-widget__section">

        <div id="resume-teaser">
            <div id="add-photos-pro">
            </div>
            <div id="resume-links">

            </div>
        </div>

<div class="txt-block" id="name-bio-text">
        <div class="name-trivia-bio-text">
          
            <div class="inline">
Franka Potente was born on 22 July 1974 in the German city of Münster, to Hildegard, a medical assistant, and Dieter Potente, a teacher, and raised in the nearby town of Dülmen. After her graduation in 1994, she went to the Otto-Falckenberg-Schule, a drama school in Munich, but soon broke off to study at the Lee Strasberg Theatre Institute in New ...            <span class="see-more inline nobr-only">
                    <a href="/name/nm0004376/bio?ref_=nm_ov_bio_sm"
>See full bio</a> &raquo;
            </span>
</div>        </div>
</div>


    <div id="name-born-info" class="txt-block">
        <h4 class="inline">Born:</h4>
   
  <time datetime="1974-7-22">
<a href="/search/name?birth_monthday=7-22&refine=birth_monthday&ref_=nm_ov_bth_monthday"
>July 22</a>, 
     
<a href="/search/name?birth_year=1974&ref_=nm_ov_bth_year"
>1974</a>    
  </time>
            in
            <a href="/search/name?birth_place=M%C3%BCnster,%20North%20Rhine-Westphalia,%20Germany&ref_=nm_ov_bth_place"
>Münster, North Rhine-Westphalia, Germany</a>
    </div>

                   </td>
                </tr>
                <tr>
                   <td id="overview-middle" class="name-overview-widget__section">
    <div id="name-pro-info" class="pro-list">
        <div id="name-pro-info-redesign">
            <span class="pro-list-title"><a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_more&ref_=cons_nm_more"
>More at IMDbPro</a> &raquo;</span>
<a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_contact&ref_=cons_nm_contact"
> <img class="absmiddle" width="13" height="13" src="https://m.media-amazon.com/images/S/sash/FjpOuUKl709a20X.png"
srcset="https://m.media-amazon.com/images/S/sash/FjpOuUKl709a20X.png 1x,
https://m.media-amazon.com/images/S/sash/1TwW9nIiWUfC2ia.png 2x"
alt="Contact Info on IMDbPro"/></a>            <strong>Contact Info:</strong>
<a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_contact&ref_=cons_nm_contact"
> View agent, publicist, legal on IMDbPro
</a>        </div>
    </div>
                   </td>
                </tr>
            </tbody>
        </table>

    </div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameOverviewWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameOverviewWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameOverviewWidget", {wb: 1});
    }
</script>
                </div> 


<script>
    if (typeof uet == 'function') {
      uet("af");
    }
</script>
  <script>
    if ('csm' in window) {
      csm.measure('csm_atf_main');
    }
  </script>

    
    
    
    </div> 

<script>
    if (typeof uet == 'function') {
      uet("cf");
    }
</script>


    <div id="maindetails_sidebar_bottom" class="maindetails_sidebar" data-caller-name="name-main">

  <script>
    if ('csm' in window) {
      csm.measure('csm_atf_sidebar');
    }
  </script>

	
        <!-- no content received for slot: top_rhs -->
	


    
    
    

    
    
    


    
    
    <div class="aux-content-widget-3 links subnav" div="quicklinks">

             <h3>Quick Links</h3>



        <div id="maindetails_quicklinks">
                <div class="split_0">

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/bio?ref_=nm_ql_1"
class="link" >Biography</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/awards?ref_=nm_ql_2"
class="link" >Awards</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/mediaindex?ref_=nm_ql_3"
class="link" >Photo Gallery</a>
                    </span>
                </li>
    </ul>
                </div>
                <div class="split_1">

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/?nmdp=1&ref_=nm_ql_4#filmography"
class="link" >Filmography <span class="ghost quicklink_modifier">(by Job)</span></a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/videogallery?ref_=nm_ql_5"
class="link" >Trailers and Videos</a>
                    </span>
                </li>
    </ul>
                </div>
        </div>


        <hr/>

        <div id="full_subnav">




        <h4>Filmography</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/filmosearch?sort=year&explore=title_type&role=nm0004376&ref_=nm_ql_flmg_1"
class="link" ><span class="ghost">by</span> Year</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/?nmdp=1&ref_=nm_ql_flmg_2#filmography"
class="link" ><span class="ghost">by</span> Job</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/filmosearch?sort=user_rating&explore=title_type&role=nm0004376&ref_=nm_ql_flmg_3"
class="link" ><span class="ghost">by</span> Ratings</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/filmosearch?sort=num_votes&explore=title_type&role=nm0004376&ref_=nm_ql_flmg_4"
class="link" ><span class="ghost">by</span> Votes</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/filmosearch?sort=moviemeter&explore=genres&role=nm0004376&ref_=nm_ql_flmg_5"
class="link" ><span class="ghost">by</span> Genre</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/filmosearch?sort=moviemeter&explore=keywords&role=nm0004376&ref_=nm_ql_flmg_6"
class="link" ><span class="ghost">by</span> Keyword</a>
                    </span>
                </li>
    </ul>



        <h4>Personal Details</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/bio?ref_=nm_ql_pdtls_1"
class="link" >Biography</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/otherworks?ref_=nm_ql_pdtls_2"
class="link" >Other Works</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/publicity?ref_=nm_ql_pdtls_3"
class="link" >Publicity Listings</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/officialsites?ref_=nm_ql_pdtls_4"
class="link ghost" >Official Sites</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
                            <a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_ql_contact&ref_=cons_nm_ql_contact"
>Contact Info <span class="ghost quicklink_modifier">(IMDbPro)</span></a>
                    </span>
                </li>
    </ul>



        <h4>Did You Know?</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/bio?ref_=nm_ql_dyk_1#quotes"
class="link" >Personal Quotes</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/bio?ref_=nm_ql_dyk_2#trivia"
class="link" >Trivia </a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/bio?ref_=nm_ql_dyk_3#trademark"
class="link" >Trademark</a>
                    </span>
                </li>
    </ul>



        <h4>Photo & Video</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/mediaindex?ref_=nm_ql_pv_1"
class="link" >Photo Gallery</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/videogallery?ref_=nm_ql_pv_2"
class="link" >Trailers and Videos</a>
                    </span>
                </li>
    </ul>



        <h4>Opinion</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/awards?ref_=nm_ql_op_1"
class="link" >Awards</a>
                    </span>
                </li>
    </ul>



        <h4>Related Items</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/search/common?name=nm0004376&ref_=nm_ql_rel_1"
class="link" >Credited With</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/news?ref_=nm_ql_rel_2"
class="link" >News</a>
                    </span>
                </li>
                <li class="subnav_item_main">
                    <span class="nobr-only">
<a href="/name/nm0004376/externalsites?ref_=nm_ql_rel_3"
class="link" >External Sites</a>
                    </span>
                </li>
    </ul>



        <h4>Professional Services</h4>

    <ul class="quicklinks">
                <li class="subnav_item_main">
                    <span class="nobr-only">
                            <a href="https://pro.imdb.com/name/nm0004376?rf=cons_nm_ql_getmore&ref_=cons_nm_ql_getmore"
>Get more at IMDbPro</a>
                    </span>
                </li>
    </ul>
    <hr/>
        </div>

        <div class="show_more"><span class="titlePageSprite arrows show"></span>Explore More</div>
        <div class="show_less"><span class="titlePageSprite arrows hide"></span>Show Less</div>
    </div>


    
    
        <a name="slot_right-3"></a>
        <div class="aux-content-widget-2">
        
    
        
                                

    
            <script type="text/javascript">if(typeof uet === 'function'){uet('bb','NinjaWidget',{wb:1});}</script>
                                

                    
    
        <span class="ab_widget">
        
    

    <div class="ab_ninja">
<span class="widget_header"> <span class="oneline"> <a href="/list/ls505110245/mediaviewer/rm1722402561/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_hd" > <h3> The Best Movies & TV to Watch in July</h3> </a> </span> </span> <div class="widget_content no_inline_blurb"> <div class="widget_nested"> <div class="ninja_image_pack"> <div class="ninja_center"> <div class="ninja_image first_image last_image" style="width:307px;height:auto;" > <div style="width:307px;height:auto;margin:0 auto;"> <div class="widget_image"> <div class="image"> <a href="/list/ls505110245/mediaviewer/rm1722402561/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_i_1" > <img class="pri_image" src="https://m.media-amazon.com/images/M/MV5BY2Q4ZTkzNWEtY2IzMi00ZWE5LWFmMzAtYzA4NWY3MTkwYzQ4XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SY230_SX307_AL_.jpg" /> </a> </div> </div> </div> </div> </div> </div> </div> </div> <p class="blurb">Our list of the best new movies and shows releasing in July includes <i><a href="/title/tt3480822/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_lk1">Black Widow</a></i>, "<a href="/title/tt10986410/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_lk2">Ted Lasso</a>” Season 2, and <i><a href="/title/tt9243804/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_lk3">The Green Knight</a></i>.</p> <p class="seemore"> <a href="/list/ls505110245/mediaviewer/rm1722402561/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5c590762-8f77-4d07-b156-c37d18ded118&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-3&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_pks_july_r_sm" class="position_bottom supplemental" > See the list</a> </p>    </div>
    

                        
        </span>



            <script type="text/javascript">
                if(typeof uex === 'function'){uex('ld','NinjaWidget',{wb:1});}
            </script>
        




        </div>
    


    
    
    


    
    
    

  <div class="aux-content-widget-2" id="social-share-widget">
    
    <div class="social">
      <div class="social_networking">
       <span><strong>Share</strong> this page:</span>
  <a onclick="window.open(&quot;https://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0004376%2F&quot;, 'newWindow', 'width=626, height=436'); return false;" href="https://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0004376%2F" target="_blank" title="Share on Facebook" class="share_icon facebook"></a>
  <a onclick="window.open(&quot;https://twitter.com/intent/tweet?text=Franka%20Potente%20-%20https%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0004376%2F&quot;, 'newWindow', 'width=815, height=436'); return false;" href="https://twitter.com/intent/tweet?text=Franka%20Potente%20-%20https%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0004376%2F" target="_blank" title="Share on Twitter" class="share_icon twitter"></a>
  <a onclick="$('div.social input[name=share-link]').show().select(); return false;" title="Share the page" class="share_icon share_url_link" href="http://www.imdb.com/name/nm0004376/"></a>
      </div>
      <input type="text" name="share-link" value="https://www.imdb.com/name/nm0004376/" readonly>
    </div>
  </div>


    
    
        <a name="slot_right-5"></a>
        <div class="aux-content-widget-2">
        
    
        
                                

    
            <script type="text/javascript">if(typeof uet === 'function'){uet('bb','NinjaWidget',{wb:1});}</script>
                                

                    
    
        <span class="ab_widget">
        
    

    <div class="ab_ninja">
<span class="widget_header"> <span class="oneline"> <a href="/gallery/rg1469225728/mediaviewer/rm3780356097?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=96ab99ea-279c-430b-b7ec-01eb68d02a07&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-5&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_gal_beach_r_hd" > <h3> Vintage Looks: Stars at the Beach</h3> </a> </span> </span> <div class="widget_content no_inline_blurb"> <div class="widget_nested"> <div class="ninja_image_pack"> <div class="ninja_center"> <div class="ninja_image first_image last_image" style="width:307px;height:auto;" > <div style="width:307px;height:auto;margin:0 auto;"> <div class="widget_image"> <div class="image"> <a href="/gallery/rg1469225728/mediaviewer/rm3780356097?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=96ab99ea-279c-430b-b7ec-01eb68d02a07&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-5&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_gal_beach_r_i_1" > <img class="pri_image" src="https://m.media-amazon.com/images/M/MV5BNzFiMWE4MjItNGFjZC00OWMxLWE5MjAtYTAxNWU5OGY0NDRkXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SY230_SX307_AL_.jpg" /> </a> </div> </div> </div> </div> </div> </div> </div> </div> <p class="blurb">Turn back the clock and hit the beach with some of our favorite classic Hollywood stars.</p> <p class="seemore"> <a href="/gallery/rg1469225728/mediaviewer/rm3780356097?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=96ab99ea-279c-430b-b7ec-01eb68d02a07&pf_rd_r=YAQYHQZAPJWQPCYD78VQ&pf_rd_s=right-5&pf_rd_t=15011&pf_rd_i=nm0004376&ref_=nm_sw_gal_beach_r_sm" class="position_bottom supplemental" > See the entire gallery</a> </p>    </div>
    

                        
        </span>



            <script type="text/javascript">
                if(typeof uex === 'function'){uex('ld','NinjaWidget',{wb:1});}
            </script>
        




        </div>
    

	
        <!-- no content received for slot: rhs_cornerstone -->
	

	
        <!-- no content received for slot: inline80 -->
	


    
    
    

<script>
    if (typeof uet == 'function') {
      uet("bb", "RelatedNewsWidgetRHS", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_RelatedNewsWidgetRHS_started');
      }
    </script>

        <div class="aux-content-widget-2" >
            <h3>Related News</h3>
    <ul class="ipl-simple-list">
            <li class="news_item">
<a href="/news/ni63315399?ref_=nm_nwr1"
> Germany’s Augenschein Filmproduktion Launches Financing, Sales Arm With Former Telepool Senior Executive
</a><br />
                <small>
                <span>02 June 2021</span>
                <span>|</span>
                <span>Variety</span>
                </small>
            </li>
            <li class="news_item">
<a href="/news/ni63315165?ref_=nm_nwr2"
> ‘Stowaway’ & ‘7500’ Producer Augenschein Launches Financing & Sales Arm
</a><br />
                <small>
                <span>02 June 2021</span>
                <span>|</span>
                <span>Deadline</span>
                </small>
            </li>
            <li class="news_item">
<a href="/news/ni63194822?ref_=nm_nwr3"
> Taapsee Pannu: Ran behind films, some have thankfully fallen in my lap
</a><br />
                <small>
                <span>14 February 2021</span>
                <span>|</span>
                <span>GlamSham</span>
                </small>
            </li>
    </ul>

            <div class="see-more">
                <a href="/name/nm0004376/news?ref_=nm_nwr_sm"
>See all related articles</a>&nbsp;&raquo;
            </div>
        </div>

    <script>
      if ('csm' in window) {
        csm.measure('csm_RelatedNewsWidgetRHS_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "RelatedNewsWidgetRHS", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "RelatedNewsWidgetRHS", {wb: 1});
    }
</script>


    
    
        <a name="slot_right-7"></a>
        <div class="aux-content-widget-2">
        
    
        
                                

    
            <script type="text/javascript">if(typeof uet === 'function'){uet('bb','TaboolaWidget',{wb:1});}</script>
                                

                    
    
        <span class="ab_widget">
                <div class="ab_taboola">
<span class="widget_header"> <span class="oneline"> <h3> Around The Web</h3> <span>&nbsp;|&nbsp;</span> <h4> <a href="https://popup.taboola.com" target="_blank">Provided by Taboola</a></h4> </span> </span> <div class="widget_content no_inline_blurb"> <div class="widget_nested"> <script> /** * * Wrap script in check for window.Promise for IE compatibility * */ if (window.Promise) { Promise.wait = function (time) { return new Promise(function (resolve) { return setTimeout(resolve, time || 0); }); }; Promise.pulse = function (count, func, delay) { return func().then(function () { return count > 0 ? Promise.wait(delay).then(function () { return Promise.pulse(count - 1, func, delay); }).catch(function (err) {}) : Promise.reject(); }).catch(function (err) {}); }; function tb_debounce(func, wait) { var timeout; return function() { var context = this, args = arguments; var later = function() { timeout = null; func.apply(context, args); }; var callNow = !timeout; clearTimeout(timeout); timeout = setTimeout(later, wait); if (callNow) func.apply(context, args); }; }; /** On page resize, send notification to taboola to send the resize message */ window.addEventListener('resize', tb_debounce(sendPingToTaboola, 500)); /** When we get a message from taboola, call the resize function */ window.addEventListener('message', function (event) { var ifm = document.getElementById('ads_taboola_iframe'); if (!ifm) { return; } var ifmHeight = event.data.height; var collapseTaboola = event.data.collapseTaboola; if (ifmHeight) { resizeTaboolaIframe(ifmHeight); } else if (collapseTaboola) { collapseTaboolaIframe(ifm); } }); function getOriginForIframe(ifm) { var dummyA = (document && typeof document !== 'undefined') ? document.createElement('a') : null; if (dummyA && ifm) { dummyA.href = ifm.src; } var targetOrigin = dummyA ? dummyA.origin : null; return targetOrigin; } /** Sends message to the taboola iframe to remeasure its height and notify us with the new size */ function sendPingToTaboola() { var ifm = document.getElementById('ads_taboola_iframe'); if (ifm && ifm.src && ifm.src !== '') { ifm.contentWindow.postMessage({resizeTaboola: true}, ifm.src); return true; } return false; } function sendPingToTaboolaPromise() { return new Promise(function(resolve, reject) { sendPingToTaboola() ? resolve() : reject(); }); } function pingTaboola() { try { if (typeof uex == 'function') { uex('ld', 'taboola_legacy', {wb: 1}); } Promise.pulse(10, sendPingToTaboolaPromise, 500); /** * * If the taboola widget isn't loaded after 10s, collapse the widget * Why 10s? We want to make sure we allow enough time for valid requests go through * **/ Promise.wait(10000).then( function() { sendCheckTaboolaLoadedMessage(); }).catch(function (err) {}); } catch (e) { /** Promise not supported in IE11 */ } } function sendCheckTaboolaLoadedMessage() { if (isIframeCollapsed()) { return; } var ifm = document.getElementById('ads_taboola_iframe'); if (ifm && ifm.src && ifm.src !== "") { ifm.contentWindow.postMessage({checkForLoad: true}, ifm.src); return true; } return false; } function resizeTaboolaIframe(height) { if (height && height > 300 && height < 900) { ifm.style = 'height:' + height + 'px !important'; } } /** * * Check for the presence of the widget, then collapse the container with the styling for the * ab_widget. We check for ab_taboola first in case there are other ab_widgets on the page * **/ function collapseTaboolaIframe() { var taboolaElementList = document.getElementsByClassName('ab_taboola'); var taboolaContainer = taboolaElementList && taboolaElementList[0]; var taboolaParentContainer = taboolaContainer && taboolaContainer.parentElement && taboolaContainer.parentElement.parentElement; if (taboolaParentContainer && taboolaParentContainer.style) { taboolaParentContainer.style = 'display: none !important;'; } } /** * * Checks if the iframe is collapsed, and collapses the parent container if it is collapsed * This should catch ad-blockers that automatically set the iframe style to display: none * * @returns {boolean} True if iframe is collapsed already OR if we collapse it ourselves, * otherwise false */ function isIframeCollapsed() { var ifm = document.getElementById('ads_taboola_iframe'); if(!ifm) return true; if (ifm.style.display == 'none' || ifm.style.height === '') { collapseTaboolaIframe(); return true; } return false; } } if (typeof uet == 'function') { uet('bb', 'taboola_legacy', {wb: 1}); } </script> <iframe title="Sponsored Content" id="ads_taboola_iframe" class="taboola-frame__sidebar" scrolling="no" seamless sandbox="allow-popups allow-same-origin allow-scripts" onload="pingTaboola && pingTaboola()"> </iframe> <script> /** Fetches the canonical url from the head for use in the taboola iframe source */ function getCanonicalUrl() { return document.querySelector("link[rel='canonical']") ? document.querySelector("link[rel='canonical']").href : window.location.origin; } var ifm = document.getElementById('ads_taboola_iframe'); var url = getCanonicalUrl(); ifm.src = 'https://m.media-amazon.com/images/S/sash/jKd0AKtg5tHjOMX.html?placement=Legacy Name Right Rail&mode=thumbnails-b' + '&url=' + url; if (typeof uet == 'function') { uet('be', 'taboola_legacy', {wb: 1}); } </script> </div> </div>        </div>

                        
        </span>



            <script type="text/javascript">
                if(typeof uex === 'function'){uex('ld','TaboolaWidget',{wb:1});}
            </script>
        




        </div>
    




    
    
    



    
    
    

<script>
    if (typeof uet == 'function') {
      uet("bb", "RelatedEditorialListsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uet == 'function') {
      uet("be", "RelatedEditorialListsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "RelatedEditorialListsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uet == 'function') {
      uet("bb", "RelatedListsWidget", {wb: 1});
    }
</script>
        <div class="aux-content-widget-2">
            <div id="relatedListsWidget">
                <div class="rightcornerlink">
                    <a href="/list/create?ref_=nm_rls"
>Create a list</a>&nbsp;&raquo;
                </div>
                <h3>User Lists</h3>
                <p>Related lists from IMDb users</p>

    <div class="list-preview even">
        <div class="list-preview-item-narrow">
<a href="/list/ls088813886?ref_=nm_rls_1"
><img height="86" width="86" alt="list image" title="list image" src="https://m.media-amazon.com/images/S/sash/9FayPGLPcrscMjU.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BNjYyNDIxYTAtMWJkMC00MWUyLTk1ODItZDI1ZjcxMjk0ZWQ2XkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UX86_CR0,0,86,86_AL_.jpg" /></a>        </div>
        <div class="list_name">
            <strong><a href="/list/ls088813886?ref_=nm_rls_1"
>
My dearest stars
</a></strong>
        </div>
        <div class="list_meta">
            a list of 45 people
            <br />created 2&nbsp;months&nbsp;ago
            
        </div>
        <div class="clear">&nbsp;</div>
    </div>
    <div class="list-preview odd">
        <div class="list-preview-item-narrow">
<a href="/list/ls000090183?ref_=nm_rls_2"
><img height="86" width="86" alt="list image" title="list image" src="https://m.media-amazon.com/images/S/sash/9FayPGLPcrscMjU.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTUzNjI0Njc5NF5BMl5BanBnXkFtZTYwOTM2MjYz._V1_UX86_CR0,0,86,86_AL_.jpg" /></a>        </div>
        <div class="list_name">
            <strong><a href="/list/ls000090183?ref_=nm_rls_2"
>
Favourite actresses
</a></strong>
        </div>
        <div class="list_meta">
            a list of 30 people
            <br />created 03&nbsp;Mar&nbsp;2011
            
        </div>
        <div class="clear">&nbsp;</div>
    </div>
    <div class="list-preview even">
        <div class="list-preview-item-narrow">
<a href="/list/ls006087050?ref_=nm_rls_3"
><img height="86" width="86" alt="list image" title="list image" src="https://m.media-amazon.com/images/S/sash/9FayPGLPcrscMjU.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTc1MDI0MDg1NV5BMl5BanBnXkFtZTgwMDM3OTAzMTE@._V1_UX86_CR0,0,86,86_AL_.jpg" /></a>        </div>
        <div class="list_name">
            <strong><a href="/list/ls006087050?ref_=nm_rls_3"
>
Divas
</a></strong>
        </div>
        <div class="list_meta">
            a list of 40 people
            <br />created 29&nbsp;Nov&nbsp;2011
            
        </div>
        <div class="clear">&nbsp;</div>
    </div>
                <div class="see-more">
                    <a href="/lists/nm0004376?ref_=nm_rls_sm"
>See all related lists</a>&nbsp;&raquo;
                </div>
            </div>
        </div>
<script>
    if (typeof uet == 'function') {
      uet("be", "RelatedListsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "RelatedListsWidget", {wb: 1});
    }
</script>


    
    
    

<script>
    if (typeof uet == 'function') {
      uet("bb", "DemoReelsWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_DemoReelsWidget_started');
      }
    </script>
    <div class="aux-content-widget-2">
        <h3>Do you have a demo reel?</h3>

        <p>Add it to your IMDbPage</p>
        <div class="video-browser-widget">
             <div id="demoReelShoveler">


<a href="/videoplayer/vi2577045529?ref_=nm_demo_1"
title="My Demo Reel -- No description provided." alt="My Demo Reel -- No description provided." class="video-modal" data-video="vi2577045529" data-context="user" data-rid="" widget-context="nameDemoreels"><img height="90" width="120" alt="My Demo Reel -- No description provided." title="My Demo Reel -- No description provided." src="https://m.media-amazon.com/images/S/sash/LF9ZUTFoX8jwgUD.png" class="loadlate hidden video" loadlate="https://m.media-amazon.com/images/M/MV5BMjM2MTUyNjExNl5BMl5BanBnXkFtZTgwMjUyMzczMzE@._V1_SP229,229,0,C,0,0,0_CR45,62,139,105_PIimdb-blackband-204-14,TopLeft,0,0_PIimdb-blackband-204-28,BottomLeft,0,1_CR0,0,139,105_PIimdb-bluebutton-big,BottomRight,-1,-1_ZA00%253A57,103,1,14,36,verdenab,7,255,255,255,1_.jpg" viconst="vi2577045529" /></a>

<a href="/videoplayer/vi2542180377?ref_=nm_demo_2"
title="My Demo Reel -- Three different genres" alt="My Demo Reel -- Three different genres" class="video-modal" data-video="vi2542180377" data-context="user" data-rid="" widget-context="nameDemoreels"><img height="90" width="120" alt="My Demo Reel -- Three different genres" title="My Demo Reel -- Three different genres" src="https://m.media-amazon.com/images/S/sash/LF9ZUTFoX8jwgUD.png" class="loadlate hidden video" loadlate="https://m.media-amazon.com/images/M/MV5BMTY4OTYxNzE2M15BMl5BanBnXkFtZTcwMDA3MzMyNA@@._V1_SP229,229,0,C,0,0,0_CR45,62,139,105_PIimdb-blackband-204-14,TopLeft,0,0_PIimdb-blackband-204-28,BottomLeft,0,1_CR0,0,139,105_PIimdb-bluebutton-big,BottomRight,-1,-1_ZA02%253A08,103,1,14,36,verdenab,7,255,255,255,1_.jpg" viconst="vi2542180377" /></a>
             </div>
        </div>
        <div id="pro_demo_reel_link">
<a href="https://pro.imdb.com/demoreels/list?rf=cons_nm_demoreel&ref_=cons_nm_demoreel"
>Find out more at IMDb Pro</a> &raquo;
        </div>
    </div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_DemoReelsWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "DemoReelsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "DemoReelsWidget", {wb: 1});
    }
</script>


    
    
    


    
    
    

<div class="aux-content-widget-2 ">
    <h3>How Much Have You Seen?</h3>
How much of <a href="/seen/nm0004376/?ref_=nm_se"
>Franka Potente's work</a> have you seen?
</div>


    
    
    

<script>
    if (typeof uet == 'function') {
      uet("bb", "NameMainDetailsRelatedPolls", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameMainDetailsRelatedPolls_started');
      }
    </script>
<div class="aux-content-widget-2 poll-widget-rhs ">
    <style>
        .aux-content-widget-2.poll-widget-rhs ul li { margin-bottom: 0.5em; clear: left; font-weight: bold;}
        .aux-content-widget-2.poll-widget-rhs span { margin-bottom: 0.5em; clear: left;}
        .aux-content-widget-2.poll-widget-rhs img { float: left; padding: 0 5px 5px 0; height: 86px; width: 86px;}
    </style>
    <h3>User Polls</h3>
    <ul>
        <li>
<a href="/poll/y2wemFAfMMU/?ref_=nm_po_i1"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BODJlYzcxMmMtMDA0MS00YmQ2LWEwODEtNjQ0NTA3M2VmNTU0XkEyXkFqcGdeQXVyNjAwODA4Mw@@._V1_SY86_CR38,0,86,86_.jpg" /></a>        <a href="/poll/y2wemFAfMMU/?ref_=nm_po_q1"
>I Would Walk 500 Miles and I Would Walk 500 More...</a>
        <li>
<a href="/poll/Ysb5MR3cx_Q/?ref_=nm_po_i2"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BOTViYWU2YzMtZTc3Zi00NWU5LTgwZjAtYTQ0OWYwOGQ4MTVkXkEyXkFqcGdeQXVyNTAyNDQ2NjI@._V1_SY86_CR43,0,86,86_.jpg" /></a>        <a href="/poll/Ysb5MR3cx_Q/?ref_=nm_po_q2"
>Characters Stuck in a Time Loop</a>
        <li>
<a href="/poll/TZxQs1eAx0U/?ref_=nm_po_i3"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTg4NDI2NzA3OF5BMl5BanBnXkFtZTcwNDM1OTQyOA@@._V1_SX86_CR0,0,86,86_.jpg" /></a>        <a href="/poll/TZxQs1eAx0U/?ref_=nm_po_q3"
>Favorite Austro-German Actress</a>
        <li>
<a href="/poll/X6_ogzMxUgE/?ref_=nm_po_i4"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTg1MTcwNTg5Nl5BMl5BanBnXkFtZTgwNTE0Mzk5NDE@._V1_SY86_CR17,0,86,86_.jpg" /></a>        <a href="/poll/X6_ogzMxUgE/?ref_=nm_po_q4"
>My Best Movie Friend</a>
        <li>
<a href="/poll/RAtwrDx0P2s/?ref_=nm_po_i5"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMjAwNjg3NzU5OF5BMl5BanBnXkFtZTYwODk4ODU3._V1_SY86_CR7,0,86,86_.jpg" /></a>        <a href="/poll/RAtwrDx0P2s/?ref_=nm_po_q5"
>Favorite 'Bourne' Movie Franchise Character</a>
        <li>
<a href="/poll/S-HixSw8ytk/?ref_=nm_po_i6"
><img height="86" width="86" alt="poll image" title="poll image" src="https://m.media-amazon.com/images/S/sash/ZobKRlv$0TyAyMM.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTg2NTk2MTgxMV5BMl5BanBnXkFtZTgwNjcxMjAzMTI@._V1_SX86_CR0,0,86,86_.jpg" /></a>        <a href="/poll/S-HixSw8ytk/?ref_=nm_po_q6"
>40 is the new 30, right? RIGHT!??!??</a>
    </ul>
    <div class="see-more"><a href="/poll/?ref_=nm_po_sm"
>See more polls &raquo;</a></div>
</div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameMainDetailsRelatedPolls_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameMainDetailsRelatedPolls", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameMainDetailsRelatedPolls", {wb: 1});
    }
</script>


    
    
    

	
        <!-- no content received for slot: btf_rhs2 -->
	


    
    
    

    </div>

    <div id="maindetails_center_bottom" class="maindetails_center">

    
    
    

            <div class="article highlighted">

<script>
    if (typeof uet == 'function') {
      uet("bb", "NameAwardsSummaryWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameAwardsSummaryWidget_started');
      }
    </script>
    <span class="awards-blurb">
        10 wins &amp; 8 nominations.
    </span>
            <span class="see-more inline">
<a href="/name/nm0004376/awards?ref_=nm_awd"
class="btn-full" >See more awards</a>&nbsp;&raquo;            </span>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameAwardsSummaryWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameAwardsSummaryWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameAwardsSummaryWidget", {wb: 1});
    }
</script>
            </div> 


    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

        <div class="article">

        <h2>Photos</h2>
        <div class="mediastrip_container">
    <div class="mediastrip">        	
                
<a href="/name/nm0004376/mediaviewer/rm2695185408?context=default&ref_=nm_phs_md_1"
><img height="99" width="99" alt="Franka Potente in Claws (2017)" title="Franka Potente in Claws (2017)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMjMwNDEwMTYwN15BMl5BanBnXkFtZTgwNTM5OTI5NTM@._V1_UY99_CR25,0,99,99_AL_.jpg" /></a>                
<a href="/name/nm0004376/mediaviewer/rm1091119104?context=default&ref_=nm_phs_md_2"
><img height="99" width="99" alt="Matt Damon and Franka Potente in The Bourne Identity (2002)" title="Matt Damon and Franka Potente in The Bourne Identity (2002)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BOTY3MjYzMjc4OF5BMl5BanBnXkFtZTgwNjAwNTA2MjI@._V1_UY99_CR26,0,99,99_AL_.jpg" /></a>                
<a href="/name/nm0004376/mediaviewer/rm2703298816?context=default&ref_=nm_phs_md_3"
><img height="99" width="99" alt="Franka Potente, Vera Farmiga, Simon McBurney, Patrick Wilson, and Abhi Sinha in The Conjuring 2 (2016)" title="Franka Potente, Vera Farmiga, Simon McBurney, Patrick Wilson, and Abhi Sinha in The Conjuring 2 (2016)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTY2NDgwODc4Ml5BMl5BanBnXkFtZTgwNTk0MDkwOTE@._V1_UY99_CR38,0,99,99_AL_.jpg" /></a>                
<a href="/name/nm0004376/mediaviewer/rm2938179840?context=default&ref_=nm_phs_md_4"
><img height="99" width="99" alt="Franka Potente, Vera Farmiga, Simon McBurney, Patrick Wilson, and Chris Royds in The Conjuring 2 (2016)" title="Franka Potente, Vera Farmiga, Simon McBurney, Patrick Wilson, and Chris Royds in The Conjuring 2 (2016)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BOTgxNTcwMzA5M15BMl5BanBnXkFtZTgwNzk0MDkwOTE@._V1_UY99_CR38,0,99,99_AL_.jpg" /></a>                
<a href="/name/nm0004376/mediaviewer/rm2146681856?context=default&ref_=nm_phs_md_5"
><img height="99" width="99" alt="Franka Potente and Diane Kruger in The Bridge (2013)" title="Franka Potente and Diane Kruger in The Bridge (2013)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BNzI2MjgxMDU1MV5BMl5BanBnXkFtZTgwOTA1MzI3MjE@._V1_UY99_CR25,0,99,99_AL_.jpg" /></a>                
<a href="/name/nm0004376/mediaviewer/rm2575943168?context=default&ref_=nm_phs_md_6"
><img height="99" width="99" alt="Franka Potente in The Shield (2002)" title="Franka Potente in The Shield (2002)" src="https://m.media-amazon.com/images/S/sash/LcDGvOC9oM0y1al.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTczNTg2Mjk5MF5BMl5BanBnXkFtZTgwNzkyNjU1MjE@._V1_UY99_CR16,0,99,99_AL_.jpg" /></a>    </div>

                <div class="see-more">
<a href="/name/nm0004376/mediaindex?ref_=nm_phs_md_sm"
><span class="titlePageSprite showAllVidsAndPics"></span></a>
<a href="/name/nm0004376/mediaindex?ref_=nm_phs_md_sm"
>126 photos</a>
    <span class="ghost">|</span>
<a href="/name/nm0004376/videogallery?ref_=nm_phs_vi"
>17 videos</a>
&raquo;                </div>
        </div>
        </div>

            <div class="article">
<script>
    if (typeof uet == 'function') {
      uet("bb", "NameKnownForWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameKnownForWidget_started');
      }
    </script>
<h2>Known For</h2>
<div id="knownfor">
<div class="knownfor-title">
    <div class="uc-add-wl-widget-container">
    <div class="uc-add-wl-ribbon uc-add-wl--not-in-wl uc-add-wl" data-title-id="tt0130827" data-is-logged-in="false" data-is-watchlisted="false" title="Click to add to watchlist" data-widget-type="wl_ribbon" data-ref-tag-prefix="nm_knf_i1" data-record-metric="true" data-uc-add-wl>
            <div class="uc-add-wl-pending-container"><div class="uc-add-wl-pending-icon"></div></div>
    </div>
<a href="/title/tt0130827/?ref_=nm_knf_i1"
> <img
title="Run Lola Run"
width="148"
height="216"
alt="Run Lola Run"
src="https://m.media-amazon.com/images/M/MV5BMmU5ZjFmYjQtYmNjZC00Yjk4LWI1ZTQtZDJiMjM0YjQyNDU0L2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX148_CR0,0,148,216_AL_.jpg"
class="wtw-option" data-tconst="tt0130827" data-watchtype="icon" data-baseref="nm_knf_i" />
</a>    </div>
    <div class="knownfor-title-role">
        <a href="/title/tt0130827/?ref_=nm_knf_t1"
title="Run Lola Run" class="knownfor-ellipsis" >Run Lola Run</a> 
        <span class="knownfor-ellipsis">Lola</span>
    </div>
    <div class="knownfor-year"><span class="knownfor-ellipsis">(1998)</span></div>
</div>
<div class="knownfor-title">
    <div class="uc-add-wl-widget-container">
    <div class="uc-add-wl-ribbon uc-add-wl--not-in-wl uc-add-wl" data-title-id="tt0258463" data-is-logged-in="false" data-is-watchlisted="false" title="Click to add to watchlist" data-widget-type="wl_ribbon" data-ref-tag-prefix="nm_knf_i2" data-record-metric="true" data-uc-add-wl>
            <div class="uc-add-wl-pending-container"><div class="uc-add-wl-pending-icon"></div></div>
    </div>
<a href="/title/tt0258463/?ref_=nm_knf_i2"
> <img
title="The Bourne Identity"
width="148"
height="216"
alt="The Bourne Identity"
src="https://m.media-amazon.com/images/M/MV5BM2JkNGU0ZGMtZjVjNS00NjgyLWEyOWYtZmRmZGQyN2IxZjA2XkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_UX148_CR0,0,148,216_AL_.jpg"
class="wtw-option" data-tconst="tt0258463" data-watchtype="icon" data-baseref="nm_knf_i" />
</a>    </div>
    <div class="knownfor-title-role">
        <a href="/title/tt0258463/?ref_=nm_knf_t2"
title="The Bourne Identity" class="knownfor-ellipsis" >The Bourne Identity</a> 
        <span class="knownfor-ellipsis">Marie</span>
    </div>
    <div class="knownfor-year"><span class="knownfor-ellipsis">(2002)</span></div>
</div>
<div class="knownfor-title">
    <div class="uc-add-wl-widget-container">
    <div class="uc-add-wl-ribbon uc-add-wl--not-in-wl uc-add-wl" data-title-id="tt0372183" data-is-logged-in="false" data-is-watchlisted="false" title="Click to add to watchlist" data-widget-type="wl_ribbon" data-ref-tag-prefix="nm_knf_i3" data-record-metric="true" data-uc-add-wl>
            <div class="uc-add-wl-pending-container"><div class="uc-add-wl-pending-icon"></div></div>
    </div>
<a href="/title/tt0372183/?ref_=nm_knf_i3"
> <img
title="The Bourne Supremacy"
width="148"
height="216"
alt="The Bourne Supremacy"
src="https://m.media-amazon.com/images/M/MV5BYTIyMDFmMmItMWQzYy00MjBiLTg2M2UtM2JiNDRhOWE4NjBhXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_UX148_CR0,0,148,216_AL_.jpg"
class="wtw-option" data-tconst="tt0372183" data-watchtype="icon" data-baseref="nm_knf_i" />
</a>    </div>
    <div class="knownfor-title-role">
        <a href="/title/tt0372183/?ref_=nm_knf_t3"
title="The Bourne Supremacy" class="knownfor-ellipsis" >The Bourne Supremacy</a> 
        <span class="knownfor-ellipsis">Marie</span>
    </div>
    <div class="knownfor-year"><span class="knownfor-ellipsis">(2004)</span></div>
</div>
<div class="knownfor-title last">
    <div class="uc-add-wl-widget-container">
    <div class="uc-add-wl-ribbon uc-add-wl--not-in-wl uc-add-wl" data-title-id="tt0203632" data-is-logged-in="false" data-is-watchlisted="false" title="Click to add to watchlist" data-widget-type="wl_ribbon" data-ref-tag-prefix="nm_knf_i4" data-record-metric="true" data-uc-add-wl>
            <div class="uc-add-wl-pending-container"><div class="uc-add-wl-pending-icon"></div></div>
    </div>
<a href="/title/tt0203632/?ref_=nm_knf_i4"
> <img
title="The Princess and the Warrior"
width="148"
height="216"
alt="The Princess and the Warrior"
src="https://m.media-amazon.com/images/M/MV5BMTg0ZDA0NDgtNzlmMy00MTY1LTk1NGUtYjE2MWRkODc2OTZmXkEyXkFqcGdeQXVyMzA3Njg4MzY@._V1_UY216_CR2,0,148,216_AL_.jpg"
class="wtw-option" data-tconst="tt0203632" data-watchtype="icon" data-baseref="nm_knf_i" />
</a>    </div>
    <div class="knownfor-title-role">
        <a href="/title/tt0203632/?ref_=nm_knf_t4"
title="The Princess and the Warrior" class="knownfor-ellipsis" >The Princess and the Warrior</a> 
        <span class="knownfor-ellipsis">Sissi</span>
    </div>
    <div class="knownfor-year"><span class="knownfor-ellipsis">(2000)</span></div>
</div>
</div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameKnownForWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameKnownForWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameKnownForWidget", {wb: 1});
    }
</script>
            </div> 


    
    
    

            <div class="article">
<script>
    if (typeof uet == 'function') {
      uet("bb", "NameFilmographyWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameFilmographyWidget_started');
      }
    </script>
<div class="rightcornerlink">
<span class="filmo-show-hide-all"
style="display: inline;"
onclick="showOrHideAll();">
<img src="https://m.media-amazon.com/images/S/sash/BtdC1nhgaXHzlXd.png" alt="Show" width="14" height="12" class="absmiddle">&nbsp;Show all
</span>
<span class="filmo-show-hide-all"
style="display: none;"
onclick="showOrHideAll();">
<img src="https://m.media-amazon.com/images/S/sash/F9$2-orOCMZk3aL.png" alt="Hide" width="14" height="12" class="absmiddle">&nbsp;Hide all
</span>
&nbsp;<span>|</span>&nbsp;
<form name="navform" method="get" action="filmosummary" id="filmoform">
<select name="sort" class="fixed">
<option value="">Show by...</option>
<option value="?nmdp=1">Job</option>
<option value="/filmosearch?sort=year&explore=title_type&role=nm0004376">Year &raquo;</option>
<option value="/filmosearch?sort=user_rating&explore=title_type&role=nm0004376">Rating &raquo;</option>
<option value="/filmosearch?sort=num_votes&explore=title_type&role=nm0004376">Number of Ratings &raquo;</option>
<option value="/filmosearch?sort=moviemeter&explore=genres&role=nm0004376">Genre &raquo;</option>
<option value="/filmosearch?sort=moviemeter&explore=keywords&role=nm0004376">Keyword &raquo;</option>
</select>
</form>
&nbsp;<span>|</span>&nbsp;
<a href="https://contribute.imdb.com/updates?edit=nm0004376/filmography&ref_=nm_flmg_edt"
> Edit
</a> </div>
<h2>Filmography</h2>
<div id="jumpto">
Jump to:
<a href="#actress"
onclick="handleFilmoJumpto(this);" data-category="actress">Actress</a></a>
<span class="ghost">|</span> <a href="#soundtrack"
onclick="handleFilmoJumpto(this);" data-category="soundtrack">Soundtrack</a></a>
<span class="ghost">|</span> <a href="#director"
onclick="handleFilmoJumpto(this);" data-category="director">Director</a></a>
<span class="ghost">|</span> <a href="#writer"
onclick="handleFilmoJumpto(this);" data-category="writer">Writer</a></a>
<span class="ghost">|</span> <a href="#music_department"
onclick="handleFilmoJumpto(this);" data-category="music_department">Music department</a></a>
<span class="ghost">|</span> <a href="#self"
onclick="handleFilmoJumpto(this);" data-category="self">Self</a></a>
<span class="ghost">|</span> <a href="#archive_footage"
onclick="handleFilmoJumpto(this);" data-category="archive_footage">Archive footage</a></a>
</div>
<div id="filmography">
<div id="filmo-head-actress" class="head" data-category="actress" onclick="toggleFilmoCategory(this);">
<span id="hide-actress" class="hide-link"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-actress" class="show-link"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="actress">Actress</a> (57 credits)
</div>
<div class="filmo-category-section"
>
<div class="filmo-row odd" id="actress-tt3520738">
<span class="year_column">
&nbsp;
</span>
<b><a href="/title/tt3520738/?ref_=nm_flmg_act_1"
>Blanco</a></b>
(TV Movie)
<br/>
Leslee
</div>
<div class="filmo-row even" id="actress-tt10933008">
<span class="year_column">
&nbsp;2019
</span>
<b><a href="/title/tt10933008/?ref_=nm_flmg_act_2"
>The Haunted Swordsman</a></b>
(Short)
<br/>
The Onibaba Witch
</div>
<div class="filmo-row odd" id="actress-tt7105440">
<span class="year_column">
&nbsp;2019
</span>
<b><a href="/title/tt7105440/?ref_=nm_flmg_act_3"
>Princess Emmy</a></b>
<br/>
Queen Karla (voice)
</div>
<div class="filmo-row even" id="actress-tt7225386">
<span class="year_column">
&nbsp;2018
</span>
<b><a href="/title/tt7225386/?ref_=nm_flmg_act_4"
>25 km/h</a></b>
<br/>
Ute
</div>
<div class="filmo-row odd" id="actress-tt7295450">
<span class="year_column">
&nbsp;2018
</span>
<b><a href="/title/tt7295450/?ref_=nm_flmg_act_5"
>Between Worlds</a></b>
<br/>
Julie
</div>
<div class="filmo-row even" id="actress-tt5640558">
<span class="year_column">
&nbsp;2018
</span>
<b><a href="/title/tt5640558/?ref_=nm_flmg_act_6"
>Claws</a></b>
(TV Series)
<br/>
Zlata
<div class="filmo-episodes">
- <a href="/title/tt7926836/?ref_=nm_flmg_act_6"
>Breezy</a>
(2018)
... Zlata
</div>
<div class="filmo-episodes">
- <a href="/title/tt7926828/?ref_=nm_flmg_act_6"
>Til Death</a>
(2018)
... Zlata
</div>
<div class="filmo-episodes">
- <a href="/title/tt7926810/?ref_=nm_flmg_act_6"
>Crossroads</a>
(2018)
... Zlata
</div>
<div class="filmo-episodes">
- <a href="/title/tt7926818/?ref_=nm_flmg_act_6"
>Burn</a>
(2018)
... Zlata
</div>
<div class="filmo-episodes">
- <a href="/title/tt7926800/?ref_=nm_flmg_act_6"
>Double Dutch</a>
(2018)
... Zlata
</div>
<div id="more-episodes-tt5640558-actress" style="display:none;">
<img src="https://m.media-amazon.com/images/S/sash/VPO7nZEEVf68gfL.gif" />
</div>
<div class="filmo-episodes">
<a href="#"
data-n="10"
onclick="toggleSeeMoreEpisodes(this,'nm0004376','tt5640558','actress','nm_flmg_act_6',5,'blind','#more-episodes-tt5640558-actress',toggleContent); return false;">Show all 10 episodes</a>
</div>
</div>
<div class="filmo-row odd" id="actress-tt5041296">
<span class="year_column">
&nbsp;2017/II
</span>
<b><a href="/title/tt5041296/?ref_=nm_flmg_act_7"
>Muse</a></b>
<br/>
Susan Gilard
</div>
<div class="filmo-row even" id="actress-tt3647998">
<span class="year_column">
&nbsp;2017
</span>
<b><a href="/title/tt3647998/?ref_=nm_flmg_act_8"
>Taboo</a></b>
(TV Series)
<br/>
Helga
<div class="filmo-episodes">
- <a href="/title/tt4700598/?ref_=nm_flmg_act_8"
>Episode #1.8</a>
(2017)
... Helga
</div>
<div class="filmo-episodes">
- <a href="/title/tt4700686/?ref_=nm_flmg_act_8"
>Episode #1.7</a>
(2017)
... Helga
</div>
<div class="filmo-episodes">
- <a href="/title/tt4700682/?ref_=nm_flmg_act_8"
>Episode #1.6</a>
(2017)
... Helga
</div>
<div class="filmo-episodes">
- <a href="/title/tt4700680/?ref_=nm_flmg_act_8"
>Episode #1.5</a>
(2017)
... Helga
</div>
<div class="filmo-episodes">
- <a href="/title/tt4700678/?ref_=nm_flmg_act_8"
>Episode #1.4</a>
(2017)
... Helga
</div>
<div id="more-episodes-tt3647998-actress" style="display:none;">
<img src="https://m.media-amazon.com/images/S/sash/VPO7nZEEVf68gfL.gif" />
</div>
<div class="filmo-episodes">
<a href="#"
data-n="7"
onclick="toggleSeeMoreEpisodes(this,'nm0004376','tt3647998','actress','nm_flmg_act_8',5,'blind','#more-episodes-tt3647998-actress',toggleContent); return false;">Show all 7 episodes</a>
</div>
</div>
<div class="filmo-row odd" id="actress-tt6202302">
<span class="year_column">
&nbsp;2016
</span>
<b><a href="/title/tt6202302/?ref_=nm_flmg_act_9"
>Der Island-Krimi</a></b>
(TV Series)
<br/>
Solveig Karlsdottir
<div class="filmo-episodes">
- <a href="/title/tt6208864/?ref_=nm_flmg_act_9"
>Tod der Elfenfrau</a>
(2016)
... Solveig Karlsdottir
</div>
<div class="filmo-episodes">
- <a href="/title/tt6206546/?ref_=nm_flmg_act_9"
>Der Tote im Westfjord</a>
(2016)
... Solveig Karlsdottir
</div>
</div>
<div class="filmo-row even" id="actress-tt4159076">
<span class="year_column">
&nbsp;2016
</span>
<b><a href="/title/tt4159076/?ref_=nm_flmg_act_10"
>Dark Matter</a></b>
(TV Series)
<br/>
Chief Inspector Shaddick
<div class="filmo-episodes">
- <a href="/title/tt5498998/?ref_=nm_flmg_act_10"
>Kill Them All</a>
(2016)
... Chief Inspector Shaddick
</div>
<div class="filmo-episodes">
- <a href="/title/tt4991616/?ref_=nm_flmg_act_10"
>Welcome to Your New Home</a>
(2016)
... Chief Inspector Shaddick
</div>
</div>
<div class="filmo-row odd" id="actress-tt3065204">
<span class="year_column">
&nbsp;2016
</span>
<b><a href="/title/tt3065204/?ref_=nm_flmg_act_11"
>The Conjuring 2</a></b>
<br/>
Anita Gregory
</div>
<div class="filmo-row even" id="actress-tt2406376">
<span class="year_column">
&nbsp;2014
</span>
<b><a href="/title/tt2406376/?ref_=nm_flmg_act_12"
>The Bridge</a></b>
(TV Series)
<br/>
Eleanor Nacht
<div class="filmo-episodes">
- <a href="/title/tt3871910/?ref_=nm_flmg_act_12"
>Jubilex</a>
(2014)
... Eleanor Nacht
</div>
<div class="filmo-episodes">
- <a href="/title/tt3871908/?ref_=nm_flmg_act_12"
>Quetzalcoatl</a>
(2014)
... Eleanor Nacht
</div>
<div class="filmo-episodes">
- <a href="/title/tt3871904/?ref_=nm_flmg_act_12"
>Beholder</a>
(2014)
... Eleanor Nacht
</div>
<div class="filmo-episodes">
- <a href="/title/tt3810544/?ref_=nm_flmg_act_12"
>Eidolon</a>
(2014)
... Eleanor Nacht
</div>
<div class="filmo-episodes">
- <a href="/title/tt3779778/?ref_=nm_flmg_act_12"
>Rakshasa</a>
(2014)
... Eleanor Nacht
</div>
<div id="more-episodes-tt2406376-actress" style="display:none;">
<img src="https://m.media-amazon.com/images/S/sash/VPO7nZEEVf68gfL.gif" />
</div>
<div class="filmo-episodes">
<a href="#"
data-n="12"
onclick="toggleSeeMoreEpisodes(this,'nm0004376','tt2406376','actress','nm_flmg_act_12',5,'blind','#more-episodes-tt2406376-actress',toggleContent); return false;">Show all 12 episodes</a>
</div>
</div>
<div class="filmo-row odd" id="actress-tt2006374">
<span class="year_column">
&nbsp;2012-2013
</span>
<b><a href="/title/tt2006374/?ref_=nm_flmg_act_13"
>Copper</a></b>
(TV Series)
<br/>
Eva Heissen
<div class="filmo-episodes">
- <a href="/title/tt3197078/?ref_=nm_flmg_act_13"
>The Place I Called My Home</a>
(2013)
... Eva Heissen (credit only)
</div>
<div class="filmo-episodes">
- <a href="/title/tt3195762/?ref_=nm_flmg_act_13"
>Beautiful Dreamer</a>
(2013)
... Eva Heissen
</div>
<div class="filmo-episodes">
- <a href="/title/tt3137782/?ref_=nm_flmg_act_13"
>Good Heart and Willing Hand</a>
(2013)
... Eva Heissen
</div>
<div class="filmo-episodes">
- <a href="/title/tt3107824/?ref_=nm_flmg_act_13"
>The Fine Ould Irish Gintleman</a>
(2013)
... Eva Heissen
</div>
<div class="filmo-episodes">
- <a href="/title/tt3005416/?ref_=nm_flmg_act_13"
>Think Gently of the Erring</a>
(2013)
... Eva Heissen
</div>
<div id="more-episodes-tt2006374-actress" style="display:none;">
<img src="https://m.media-amazon.com/images/S/sash/VPO7nZEEVf68gfL.gif" />
</div>
<div class="filmo-episodes">
<a href="#"
data-n="22"
onclick="toggleSeeMoreEpisodes(this,'nm0004376','tt2006374','actress','nm_flmg_act_13',5,'blind','#more-episodes-tt2006374-actress',toggleContent); return false;">Show all 22 episodes</a>
</div>
</div>
<div class="filmo-row even" id="actress-tt1844624">
<span class="year_column">
&nbsp;2012
</span>
<b><a href="/title/tt1844624/?ref_=nm_flmg_act_14"
>American Horror Story</a></b>
(TV Series)
<br/>
Anne Frank / Charlotte Brown
<div class="filmo-episodes">
- <a href="/title/tt2378304/?ref_=nm_flmg_act_14"
>I Am Anne Frank: Part 2</a>
(2012)
... Anne Frank / Charlotte Brown
</div>
<div class="filmo-episodes">
- <a href="/title/tt2378296/?ref_=nm_flmg_act_14"
>I Am Anne Frank: Part 1</a>
(2012)
... Anne Frank
</div>
</div>
<div class="filmo-row odd" id="actress-tt1772766">
<span class="year_column">
&nbsp;2011
</span>
<b><a href="/title/tt1772766/?ref_=nm_flmg_act_15"
>Beate Uhse - Das Recht auf Liebe</a></b>
(TV Movie)
<br/>
Beate Uhse
</div>
<div class="filmo-row even" id="actress-tt1504261">
<span class="year_column">
&nbsp;2011
</span>
<b><a href="/title/tt1504261/?ref_=nm_flmg_act_16"
>The Sinking of the Laconia</a></b>
(TV Mini Series)
<br/>
Hilda
<div class="filmo-episodes">
- <a href="/title/tt1810371/?ref_=nm_flmg_act_16"
>Episode #1.2</a>
(2011)
... Hilda
</div>
<div class="filmo-episodes">
- <a href="/title/tt1812861/?ref_=nm_flmg_act_16"
>Episode #1.1</a>
(2011)
... Hilda
</div>
</div>
<div class="filmo-row odd" id="actress-tt1572774">
<span class="year_column">
&nbsp;2010
</span>
<b><a href="/title/tt1572774/?ref_=nm_flmg_act_17"
>Small Lights</a></b>
<br/>
Valerie
</div>
<div class="filmo-row even" id="actress-tt0491738">
<span class="year_column">
&nbsp;2010
</span>
<b><a href="/title/tt0491738/?ref_=nm_flmg_act_18"
>Psych</a></b>
(TV Series)
<br/>
Nadia
<div class="filmo-episodes">
- <a href="/title/tt1654412/?ref_=nm_flmg_act_18"
>One, Maybe Two, Ways Out</a>
(2010)
... Nadia
</div>
</div>
<div class="filmo-row odd" id="actress-tt1092634">
<span class="year_column">
&nbsp;2010
</span>
<b><a href="/title/tt1092634/?ref_=nm_flmg_act_19"
>Shanghai</a></b>
<br/>
Leni Müller
</div>
<div class="filmo-row even" id="actress-tt0412142">
<span class="year_column">
&nbsp;2009
</span>
<b><a href="/title/tt0412142/?ref_=nm_flmg_act_20"
>House</a></b>
(TV Series)
<br/>
Lydia
<div class="filmo-episodes">
- <a href="/title/tt1462220/?ref_=nm_flmg_act_20"
>Broken</a>
(2009)
... Lydia
</div>
</div>
<div class="filmo-row odd" id="actress-tt1119180">
<span class="year_column">
&nbsp;2008
</span>
<b><a href="/title/tt1119180/?ref_=nm_flmg_act_21"
>The Bridge</a></b>
(TV Movie)
<br/>
Elfie Bauer
</div>
<div class="filmo-row even" id="actress-tt1266631">
<span class="year_column">
&nbsp;2008
</span>
<b><a href="/title/tt1266631/?ref_=nm_flmg_act_22"
>The Bourne Conspiracy</a></b>
(Video Game)
<br/>
Marie (voice)
</div>
<div class="filmo-row odd" id="actress-tt0374569">
<span class="year_column">
&nbsp;2008
</span>
<b><a href="/title/tt0374569/?ref_=nm_flmg_act_23"
>Che: Part Two</a></b>
<br/>
Tania (Haydee Tamara Bunke Bider)
</div>
<div class="filmo-row even" id="actress-tt1110221">
<span class="year_column">
&nbsp;2008
</span>
<b><a href="/title/tt1110221/?ref_=nm_flmg_act_24"
>Manhunt</a></b>
(TV Movie)
<br/>
Beate Klarsfeld
</div>
<div class="filmo-row odd" id="actress-tt0901481">
<span class="year_column">
&nbsp;2007
</span>
<b><a href="/title/tt0901481/?ref_=nm_flmg_act_25"
>Eichmann</a></b>
<br/>
Vera Less
</div>
<div class="filmo-row even" id="actress-tt0286486">
<span class="year_column">
&nbsp;2007
</span>
<b><a href="/title/tt0286486/?ref_=nm_flmg_act_26"
>The Shield</a></b>
(TV Series)
<br/>
Diro Kesakhian
<div class="filmo-episodes">
- <a href="/title/tt1019218/?ref_=nm_flmg_act_26"
>Spanish Practices</a>
(2007)
... Diro Kesakhian
</div>
<div class="filmo-episodes">
- <a href="/title/tt1038578/?ref_=nm_flmg_act_26"
>Recoil</a>
(2007)
... Diro Kesakhian
</div>
<div class="filmo-episodes">
- <a href="/title/tt0865248/?ref_=nm_flmg_act_26"
>The Math of the Wrath</a>
(2007)
... Diro Kesakhian
</div>
</div>
<div class="filmo-row odd" id="actress-tt0462023">
<span class="year_column">
&nbsp;2007
</span>
<b><a href="/title/tt0462023/?ref_=nm_flmg_act_27"
>Romulus, My Father</a></b>
<br/>
Christina Gaita
</div>
<div class="filmo-row even" id="actress-tt0362856">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0362856/?ref_=nm_flmg_act_28"
>La mer</a></b>
(Short)
<br/>
</div>
<div class="filmo-row odd" id="actress-tt0430051">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0430051/?ref_=nm_flmg_act_29"
>Atomised</a></b>
<br/>
Annabelle
</div>
<div class="filmo-row even" id="actress-tt0486192">
<span class="year_column">
&nbsp;2005
</span>
<b><a href="/title/tt0486192/?ref_=nm_flmg_act_30"
>A Life in Suitcases</a></b>
<br/>
Trixie Boudain
</div>
<div class="filmo-row odd" id="actress-tt0381966">
<span class="year_column">
&nbsp;2004/I
</span>
<b><a href="/title/tt0381966/?ref_=nm_flmg_act_31"
>Creep</a></b>
<br/>
Kate
</div>
<div class="filmo-row even" id="actress-tt0372183">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt0372183/?ref_=nm_flmg_act_32"
>The Bourne Supremacy</a></b>
<br/>
Marie
</div>
<div class="filmo-row odd" id="actress-tt0408281">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt0408281/?ref_=nm_flmg_act_33"
>The Tulse Luper Suitcases, Part 2: Vaux to the Sea</a></b>
<br/>
Trixie Boudain
</div>
<div class="filmo-row even" id="actress-tt0321473">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0321473/?ref_=nm_flmg_act_34"
>Blueprint</a></b>
<br/>
Iris Sellin / Siri Sellin
</div>
<div class="filmo-row odd" id="actress-tt0322700">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0322700/?ref_=nm_flmg_act_35"
>I Love Your Work</a></b>
<br/>
Mia Lang
</div>
<div class="filmo-row even" id="actress-tt0307596">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0307596/?ref_=nm_flmg_act_36"
>The Tulse Luper Suitcases, Part 1: The Moab Story</a></b>
<br/>
Trixie Boudain
</div>
<div class="filmo-row odd" id="actress-tt0312358">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0312358/?ref_=nm_flmg_act_37"
>Anatomie 2</a></b>
<br/>
Paula Henning
</div>
<div class="filmo-row even" id="actress-tt0311941">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0311941/?ref_=nm_flmg_act_38"
>Try Seventeen</a></b>
<br/>
Jane
</div>
<div class="filmo-row odd" id="actress-tt0258463">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0258463/?ref_=nm_flmg_act_39"
>The Bourne Identity</a></b>
<br/>
Marie
</div>
<div class="filmo-row even" id="actress-tt0250081">
<span class="year_column">
&nbsp;2001
</span>
<b><a href="/title/tt0250081/?ref_=nm_flmg_act_40"
>Storytelling</a></b>
<br/>
Toby's Editor (segment "Non-Fiction")
</div>
<div class="filmo-row odd" id="actress-tt0221027">
<span class="year_column">
&nbsp;2001
</span>
<b><a href="/title/tt0221027/?ref_=nm_flmg_act_41"
>Blow</a></b>
<br/>
Barbara Buckley
</div>
<div class="filmo-row even" id="actress-tt0203632">
<span class="year_column">
&nbsp;2000
</span>
<b><a href="/title/tt0203632/?ref_=nm_flmg_act_42"
>The Princess and the Warrior</a></b>
<br/>
Sissi
</div>
<div class="filmo-row odd" id="actress-tt0187696">
<span class="year_column">
&nbsp;2000
</span>
<b><a href="/title/tt0187696/?ref_=nm_flmg_act_43"
>Anatomy</a></b>
<br/>
Paula Henning
</div>
<div class="filmo-row even" id="actress-tt1796683">
<span class="year_column">
&nbsp;1999
</span>
<b><a href="/title/tt1796683/?ref_=nm_flmg_act_44"
>Winke und lächle!</a></b>
(Short)
<br/>
Susan / Stewardess
</div>
<div class="filmo-row odd" id="actress-tt0173171">
<span class="year_column">
&nbsp;1999
</span>
<b><a href="/title/tt0173171/?ref_=nm_flmg_act_45"
>Paradise Mall</a></b>
<br/>
Mona Wendt
</div>
<div class="filmo-row even" id="actress-tt0173298">
<span class="year_column">
&nbsp;1999
</span>
<b><a href="/title/tt0173298/?ref_=nm_flmg_act_46"
>Our Island in the South Pacific</a></b>
<br/>
Kassiererin
</div>
<div class="filmo-row odd" id="actress-tt0196510">
<span class="year_column">
&nbsp;1999
</span>
<b><a href="/title/tt0196510/?ref_=nm_flmg_act_47"
>Downhill City</a></b>
<br/>
Peggy
</div>
<div class="filmo-row even" id="actress-tt0144106">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0144106/?ref_=nm_flmg_act_48"
>Am I Beautiful?</a></b>
<br/>
Linda
</div>
<div class="filmo-row odd" id="actress-tt0130827">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0130827/?ref_=nm_flmg_act_49"
>Run Lola Run</a></b>
<br/>
Lola
</div>
<div class="filmo-row even" id="actress-tt0158148">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0158148/?ref_=nm_flmg_act_50"
>Rennlauf</a></b>
(TV Movie)
<br/>
Alice
</div>
<div class="filmo-row odd" id="actress-tt0129277">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0129277/?ref_=nm_flmg_act_51"
>Opera Ball</a></b>
(TV Movie)
<br/>
Gabrielle Becker
</div>
<div class="filmo-row even" id="actress-tt0194491">
<span class="year_column">
&nbsp;1997
</span>
<b><a href="/title/tt0194491/?ref_=nm_flmg_act_52"
>Blood Sisters</a></b>
(TV Movie)
<br/>
Lisa Manocci
</div>
<div class="filmo-row odd" id="actress-tt0122439">
<span class="year_column">
&nbsp;1997
</span>
<b><a href="/title/tt0122439/?ref_=nm_flmg_act_53"
>Coming In</a></b>
(TV Movie)
<br/>
Nina
</div>
<div class="filmo-row even" id="actress-tt0119020">
<span class="year_column">
&nbsp;1997
</span>
<b><a href="/title/tt0119020/?ref_=nm_flmg_act_54"
>Babes' Petrol</a></b>
<br/>
Lena
</div>
<div class="filmo-row odd" id="actress-tt0119041">
<span class="year_column">
&nbsp;1997
</span>
<b><a href="/title/tt0119041/?ref_=nm_flmg_act_55"
>Easy Day</a></b>
(Short)
<br/>
Lily
</div>
<div class="filmo-row even" id="actress-tt0882736">
<span class="year_column">
&nbsp;1996
</span>
<b><a href="/title/tt0882736/?ref_=nm_flmg_act_56"
>Zwei Brüder</a></b>
(TV Series)
<br/>
Mara
<div class="filmo-episodes">
- <a href="/title/tt0118226/?ref_=nm_flmg_act_56"
>In eigener Sache</a>
(1996)
... Mara
</div>
</div>
<div class="filmo-row odd" id="actress-tt0117143">
<span class="year_column">
&nbsp;1995
</span>
<b><a href="/title/tt0117143/?ref_=nm_flmg_act_57"
>Nach Fünf im Urwald</a></b>
<br/>
Anna
</div>
</div>
<div id="filmo-head-soundtrack" class="head" data-category="soundtrack" onclick="toggleFilmoCategory(this);">
<span id="hide-soundtrack" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-soundtrack" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="soundtrack">Soundtrack</a> (9 credits)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="soundtrack-tt1873252">
<span class="year_column">
&nbsp;2011
</span>
<b><a href="/title/tt1873252/?ref_=_1"
>Music Nuggets</a></b>
(TV Series) (performer - 1 episode)
<br/>
<div class="filmo-episodes">
- <a href="/title/tt2157659/?ref_=_1"
>Episode dated 16 December 2011</a>
(2011)
... (performer: "Wish (Komm zu mir)")
</div>
</div>
<div class="filmo-row even" id="soundtrack-tt0412142">
<span class="year_column">
&nbsp;2009
</span>
<b><a href="/title/tt0412142/?ref_=_2"
>House</a></b>
(TV Series) (performer - 1 episode)
<br/>
<div class="filmo-episodes">
- <a href="/title/tt1462220/?ref_=_2"
>Broken</a>
(2009)
... (performer: "Kinderszenen Op. 15, No. 1 Von Fremden Ländern Und Menschen", "Impromptu #3 in B flat D.935 op. posth. 142 - Andante" - uncredited)
</div>
</div>
<div class="filmo-row odd" id="soundtrack-tt5230508">
<span class="year_column">
&nbsp;2005
</span>
<b><a href="/title/tt5230508/?ref_=_3"
>AMV Hell 3: The Motion Picture</a></b>
(performer: "Believe")
<br/>
</div>
<div class="filmo-row even" id="soundtrack-tt0352117">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0352117/?ref_=_4"
>Young MacGyver</a></b>
(TV Movie) (performer: "Running Two" - uncredited)
<br/>
</div>
<div class="filmo-row odd" id="soundtrack-tt0313081">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0313081/?ref_=_5"
>The Grubbs</a></b>
(TV Series) (performer - 1 episode)
<br/>
<div class="filmo-episodes">
- <a href="/title/tt0593504/?ref_=_5"
>Pilot</a>
(2002)
... (performer: "Believe")
</div>
</div>
<div class="filmo-row even" id="soundtrack-tt0396880">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0396880/?ref_=_6"
>Stella Shorts 1998-2002</a></b>
(Video) (performer: "Wish")
<br/>
</div>
<div class="filmo-row odd" id="soundtrack-tt0201391">
<span class="year_column">
&nbsp;2000
</span>
<b><a href="/title/tt0201391/?ref_=_7"
>Roswell</a></b>
(TV Series) (performer - 1 episode)
<br/>
<div class="filmo-episodes">
- <a href="/title/tt0690292/?ref_=_7"
>Surprise</a>
(2000)
... (performer: "Wish (Komm Zu Mir)" - uncredited)
</div>
</div>
<div class="filmo-row even" id="soundtrack-tt0217355">
<span class="year_column">
&nbsp;2000
</span>
<b><a href="/title/tt0217355/?ref_=_8"
>Dancing at the Blue Iguana</a></b>
(performer: "Wish" (Komm Zu Mir))
<br/>
</div>
<div class="filmo-row odd" id="soundtrack-tt0130827">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0130827/?ref_=_9"
>Run Lola Run</a></b>
(performer: ) / (performer: "Wish", "Running One", "Running Two", "Running Three")
<br/>
</div>
</div>
<div id="filmo-head-director" class="head" data-category="director" onclick="toggleFilmoCategory(this);">
<span id="hide-director" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-director" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="director">Director</a> (2 credits)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="director-tt10353704">
<span class="year_column">
&nbsp;2020/XV
</span>
<b><a href="/title/tt10353704/?ref_=nm_flmg_dr_1"
>Home</a></b>
<br/>
</div>
<div class="filmo-row even" id="director-tt0496272">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0496272/?ref_=nm_flmg_dr_2"
>Digging for Belladonna</a></b>
(Short)
<br/>
</div>
</div>
<div id="filmo-head-writer" class="head" data-category="writer" onclick="toggleFilmoCategory(this);">
<span id="hide-writer" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-writer" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="writer">Writer</a> (2 credits)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="writer-tt10353704">
<span class="year_column">
&nbsp;2020/XV
</span>
<b><a href="/title/tt10353704/?ref_=nm_flmg_wr_1"
>Home</a></b>
(written by)
<br/>
</div>
<div class="filmo-row even" id="writer-tt0496272">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0496272/?ref_=nm_flmg_wr_2"
>Digging for Belladonna</a></b>
(Short)
<br/>
</div>
</div>
<div id="filmo-head-music_department" class="head" data-category="music_department" onclick="toggleFilmoCategory(this);">
<span id="hide-music_department" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-music_department" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="music_department">Music department</a> (1 credit)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="music_department-tt0130827">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0130827/?ref_=nm_flmg_msdp_1"
>Run Lola Run</a></b>
(composer: theme song "I Wish" and others)
<br/>
</div>
</div>
<div id="filmo-head-self" class="head" data-category="self" onclick="toggleFilmoCategory(this);">
<span id="hide-self" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-self" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="self">Self</a> (27 credits)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="self-tt0390699">
<span class="year_column">
&nbsp;2017
</span>
<b><a href="/title/tt0390699/?ref_=nm_flmg_slf_1"
>Días de cine</a></b>
(TV Series)
<br/>
Self - Interviewee
<div class="filmo-episodes">
- <a href="/title/tt7692278/?ref_=nm_flmg_slf_1"
>Episode dated 9 November 2017</a>
(2017)
... Self - Interviewee
</div>
</div>
<div class="filmo-row even" id="self-tt0800381">
<span class="year_column">
&nbsp;2014
</span>
<b><a href="/title/tt0800381/?ref_=nm_flmg_slf_2"
>World Premiere</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt3859162/?ref_=nm_flmg_slf_2"
>The Bridge: Season 2</a>
(2014)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt2554194">
<span class="year_column">
&nbsp;2012
</span>
<b><a href="/title/tt2554194/?ref_=nm_flmg_slf_3"
>The BAFTA Britannia Awards</a></b>
(TV Special)
<br/>
Self
</div>
<div class="filmo-row even" id="self-tt1907886">
<span class="year_column">
&nbsp;2012
</span>
<b><a href="/title/tt1907886/?ref_=nm_flmg_slf_4"
>Big Morning Buzz Live</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt2326600/?ref_=nm_flmg_slf_4"
>Carrie Underwood/D.L. Hughley/Franka Potente/Glen Hansard</a>
(2012)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0296361">
<span class="year_column">
&nbsp;2003-2008
</span>
<b><a href="/title/tt0296361/?ref_=nm_flmg_slf_5"
>Die Johannes B. Kerner Show</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt1299062/?ref_=nm_flmg_slf_5"
>Episode dated 24 September 2008</a>
(2008)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt0616526/?ref_=nm_flmg_slf_5"
>Episode dated 13 October 2005</a>
(2005)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt0616479/?ref_=nm_flmg_slf_5"
>Episode dated 3 March 2005</a>
(2005)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt0616425/?ref_=nm_flmg_slf_5"
>Episode dated 9 December 2003</a>
(2003)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt0995068">
<span class="year_column">
&nbsp;2007
</span>
<b><a href="/title/tt0995068/?ref_=nm_flmg_slf_6"
>MTV Europe Music Awards 2007</a></b>
(TV Special)
<br/>
Self - Presenter
</div>
<div class="filmo-row odd" id="self-tt0439925">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0439925/?ref_=nm_flmg_slf_7"
>Harald Schmidt</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0910269/?ref_=nm_flmg_slf_7"
>Episode dated 29 November 2006</a>
(2006)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt0298620">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0298620/?ref_=nm_flmg_slf_8"
>Beckmann</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0771014/?ref_=nm_flmg_slf_8"
>Episode dated 27 February 2006</a>
(2006)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0266162">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0266162/?ref_=nm_flmg_slf_9"
>Maischberger</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0770011/?ref_=nm_flmg_slf_9"
>Episode dated 24 February 2006</a>
(2006)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt0772564">
<span class="year_column">
&nbsp;2006
</span>
<b><a href="/title/tt0772564/?ref_=nm_flmg_slf_10"
>Nachtstudio</a></b>
(TV Series documentary)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0776545/?ref_=nm_flmg_slf_10"
>Traumfrauen - Die inszenierte Weiblichkeit im Film</a>
(2006)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0765274">
<span class="year_column">
&nbsp;2005
</span>
<b><a href="/title/tt0765274/?ref_=nm_flmg_slf_11"
>Aeschbacher</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt10305408/?ref_=nm_flmg_slf_11"
>Make up</a>
(2005)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt4642244">
<span class="year_column">
&nbsp;2005
</span>
<b><a href="/title/tt4642244/?ref_=nm_flmg_slf_12"
>Creep: Making of Creep</a></b>
(Video documentary short)
<br/>
Self - 'Kate'
</div>
<div class="filmo-row odd" id="self-tt0437771">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt0437771/?ref_=nm_flmg_slf_13"
>The 2004 European Film Awards</a></b>
(TV Special)
<br/>
Self - Co-Presenter: Best Actor
</div>
<div class="filmo-row even" id="self-tt5213946">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5213946/?ref_=nm_flmg_slf_14"
>The Bourne Supremacy: Keeping It Real</a></b>
(Video short)
<br/>
Self
</div>
<div class="filmo-row odd" id="self-tt5213980">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5213980/?ref_=nm_flmg_slf_15"
>The Bourne Supremacy: On the Move with Jason Bourne</a></b>
(Video short)
<br/>
Self
</div>
<div class="filmo-row even" id="self-tt0872110">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt0872110/?ref_=nm_flmg_slf_16"
>Im freien Fall - Tom Tykwer und das Kino</a></b>
(Documentary)
<br/>
Self
</div>
<div class="filmo-row odd" id="self-tt5210630">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5210630/?ref_=nm_flmg_slf_17"
>The Bourne Identity: From Identity to Supremacy - Jason and Marie</a></b>
(Video short)
<br/>
Self
</div>
<div class="filmo-row even" id="self-tt5214054">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5214054/?ref_=nm_flmg_slf_18"
>The Bourne Supremacy: The Bourne Diagnosis (Part 2)</a></b>
(Video short)
<br/>
Self
</div>
<div class="filmo-row odd" id="self-tt0388619">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt0388619/?ref_=nm_flmg_slf_19"
>Menschen bei Maischberger</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0646436/?ref_=nm_flmg_slf_19"
>Episode dated 15 June 2004</a>
(2004)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt0385406">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0385406/?ref_=nm_flmg_slf_20"
>Into the Night with...</a></b>
(TV Series documentary)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0447941/?ref_=nm_flmg_slf_20"
>Franka Potente und John Carpenter</a>
(2003)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt5210566">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt5210566/?ref_=nm_flmg_slf_21"
>The Bourne Identity: The Birth of 'The Bourne Identity'</a></b>
(Video short)
<br/>
Self
</div>
<div class="filmo-row even" id="self-tt0103569">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0103569/?ref_=nm_flmg_slf_22"
>The Tonight Show with Jay Leno</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0728557/?ref_=nm_flmg_slf_22"
>Episode #10.94</a>
(2002)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0324947">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0324947/?ref_=nm_flmg_slf_23"
>2002 MTV Movie Awards</a></b>
(TV Special)
<br/>
Self - Presenter
</div>
<div class="filmo-row even" id="self-tt0355143">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0355143/?ref_=nm_flmg_slf_24"
>Taff</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt10529708/?ref_=nm_flmg_slf_24"
>Episode dated 2 May 2002</a>
(2002)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0493184">
<span class="year_column">
&nbsp;2002
</span>
<b><a href="/title/tt0493184/?ref_=nm_flmg_slf_25"
>Exclusiv - Das Star-Magazin</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt10615764/?ref_=nm_flmg_slf_25"
>Episode dated 17 April 2002</a>
(2002)
... Self
</div>
</div>
<div class="filmo-row even" id="self-tt0112044">
<span class="year_column">
&nbsp;1996-2000
</span>
<b><a href="/title/tt0112044/?ref_=nm_flmg_slf_26"
>Die Harald Schmidt Show</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0596587/?ref_=nm_flmg_slf_26"
>Show #822 - Late Night in Indien</a>
(2000)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt3089820/?ref_=nm_flmg_slf_26"
>Show #656 - Der Führer hatte fauligen Mundgeruch</a>
(1999)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt2645264/?ref_=nm_flmg_slf_26"
>Show #389</a>
(1998)
... Self
</div>
<div class="filmo-episodes">
- <a href="/title/tt2090817/?ref_=nm_flmg_slf_26"
>Show #90 - 70'er Jahre Festival</a>
(1996)
... Self
</div>
</div>
<div class="filmo-row odd" id="self-tt0211890">
<span class="year_column">
&nbsp;1998
</span>
<b><a href="/title/tt0211890/?ref_=nm_flmg_slf_27"
>Zimmer frei!</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt0754523/?ref_=nm_flmg_slf_27"
>Franka Potente</a>
(1998)
... Self
</div>
</div>
</div>
<div id="filmo-head-archive_footage" class="head" data-category="archive_footage" onclick="toggleFilmoCategory(this);">
<span id="hide-archive_footage" class="hide-link"
style="display:none;"
>Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
<span id="show-archive_footage" class="show-link"
style="display:inline;"
>Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
<a name="archive_footage">Archive footage</a> (7 credits)
</div>
<div class="filmo-category-section"
style="display:none;"
>
<div class="filmo-row odd" id="archive_footage-tt4416750">
<span class="year_column">
&nbsp;2015
</span>
<b><a href="/title/tt4416750/?ref_=nm_flmg_arf_1"
>Welcome to the Basement</a></b>
(TV Series)
<br/>
Lola
<div class="filmo-episodes">
- <a href="/title/tt5657410/?ref_=nm_flmg_arf_1"
>Premium Rush</a>
(2015)
... Lola
</div>
</div>
<div class="filmo-row even" id="archive_footage-tt1873252">
<span class="year_column">
&nbsp;2011
</span>
<b><a href="/title/tt1873252/?ref_=nm_flmg_arf_2"
>Music Nuggets</a></b>
(TV Series)
<br/>
Self
<div class="filmo-episodes">
- <a href="/title/tt2157659/?ref_=nm_flmg_arf_2"
>Episode dated 16 December 2011</a>
(2011)
... Self
</div>
</div>
<div class="filmo-row odd" id="archive_footage-tt0440963">
<span class="year_column">
&nbsp;2007
</span>
<b><a href="/title/tt0440963/?ref_=nm_flmg_arf_3"
>The Bourne Ultimatum</a></b>
<br/>
Marie (uncredited)
</div>
<div class="filmo-row even" id="archive_footage-tt5210598">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5210598/?ref_=nm_flmg_arf_4"
>The Bourne Identity: Access Granted - Co-Writer Tony Gilroy</a></b>
(Video short)
<br/>
Marie
</div>
<div class="filmo-row odd" id="archive_footage-tt5210768">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5210768/?ref_=nm_flmg_arf_5"
>The Bourne Identity: Cloak and Dagger: Covert Ops</a></b>
(Video short)
<br/>
Marie
</div>
<div class="filmo-row even" id="archive_footage-tt5210658">
<span class="year_column">
&nbsp;2004
</span>
<b><a href="/title/tt5210658/?ref_=nm_flmg_arf_6"
>The Bourne Identity: The Bourne Diagnosis</a></b>
(Video short)
<br/>
Marie
</div>
<div class="filmo-row odd" id="archive_footage-tt0892644">
<span class="year_column">
&nbsp;2003
</span>
<b><a href="/title/tt0892644/?ref_=nm_flmg_arf_7"
>Sendung ohne Namen</a></b>
(TV Series)
<br/>
<div class="filmo-episodes">
- <a href="/title/tt5221234/?ref_=nm_flmg_arf_7"
>Es geht um SEX!</a>
(2003)
</div>
</div>
</div>
</div>    <script>
      if ('csm' in window) {
        csm.measure('csm_NameFilmographyWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameFilmographyWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameFilmographyWidget", {wb: 1});
    }
</script>
            </div> 

<script>
    if (typeof uet == 'function') {
      uet("bb", "NameVideoStrip", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameVideoStrip_started');
      }
    </script>

            <div class="article">

            <h2>Related Videos</h2>
    <div class="mediastrip_big">
                <span class="video_slate">

<a href="/name/nm0004376/videoplayer/vi2977870873?ref_=nm_rvd_vi_1"
title="The Conjuring 2 -- Clip: I'm Talking" alt="The Conjuring 2 -- Clip: I'm Talking" class="video-modal" data-video="vi2977870873" data-context="loop media" data-rid="YAQYHQZAPJWQPCYD78VQ" widget-context="nameMaindetails"><img height="150" width="200" alt="The Conjuring 2 -- Clip: I'm Talking" title="The Conjuring 2 -- Clip: I'm Talking" src="https://m.media-amazon.com/images/S/sash/LF9ZUTFoX8jwgUD.png" class="loadlate hidden video" loadlate="https://m.media-amazon.com/images/M/MV5BMmIxMzQwMWMtZDYzNS00OGI2LWE0NTQtZmU1ZGQ5YTk0NWQ4XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_SP330,330,0,C,0,0,0_CR65,90,200,150_PIimdb-blackband-204-14,TopLeft,0,0_PIimdb-blackband-204-28,BottomLeft,0,1_CR0,0,200,150_PIimdb-bluebutton-big,BottomRight,-1,-1_ZAClip,4,123,16,196,verdenab,8,255,255,255,1_ZAon%2520IMDb,4,1,14,196,verdenab,7,255,255,255,1_ZA01%253A02,164,1,14,36,verdenab,7,255,255,255,1_PIimdb-HDIconMiniWhite,BottomLeft,4,-2_ZAThe%2520Conjuring%25202,24,138,14,176,arialbd,7,255,255,255,1_.jpg" viconst="vi2977870873" /></a>            </span>
                <span class="video_slate">

<a href="/name/nm0004376/videoplayer/vi2961093657?ref_=nm_rvd_vi_2"
title="The Conjuring 2 -- Clip: It's Coming" alt="The Conjuring 2 -- Clip: It's Coming" class="video-modal" data-video="vi2961093657" data-context="loop media" data-rid="YAQYHQZAPJWQPCYD78VQ" widget-context="nameMaindetails"><img height="150" width="200" alt="The Conjuring 2 -- Clip: It's Coming" title="The Conjuring 2 -- Clip: It's Coming" src="https://m.media-amazon.com/images/S/sash/LF9ZUTFoX8jwgUD.png" class="loadlate hidden video" loadlate="https://m.media-amazon.com/images/M/MV5BYmY1MDI4ODctZmRlMS00NzA5LTgwMDEtNzI1MDdhYzRjZjQ0XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_SP330,330,0,C,0,0,0_CR65,90,200,150_PIimdb-blackband-204-14,TopLeft,0,0_PIimdb-blackband-204-28,BottomLeft,0,1_CR0,0,200,150_PIimdb-bluebutton-big,BottomRight,-1,-1_ZAClip,4,123,16,196,verdenab,8,255,255,255,1_ZAon%2520IMDb,4,1,14,196,verdenab,7,255,255,255,1_ZA00%253A56,164,1,14,36,verdenab,7,255,255,255,1_PIimdb-HDIconMiniWhite,BottomLeft,4,-2_ZAThe%2520Conjuring%25202,24,138,14,176,arialbd,7,255,255,255,1_.jpg" viconst="vi2961093657" /></a>            </span>
                <span class="video_slate_last">

<a href="/name/nm0004376/videoplayer/vi159824409?ref_=nm_rvd_vi_3"
title="Between Worlds -- Nicolas Cage stars in this twist-filled supernatural thriller that follows Joe (Cage), a struggling truck driver haunted by the memory of his deceased wife and daughter. His life takes a dramatic turn when he meets Julia (Franka Potente), a woman with mysterious spiritual powers, whose daughter Billie lies in a coma." alt="Between Worlds -- Nicolas Cage stars in this twist-filled supernatural thriller that follows Joe (Cage), a struggling truck driver haunted by the memory of his deceased wife and daughter. His life takes a dramatic turn when he meets Julia (Franka Potente), a woman with mysterious spiritual powers, whose daughter Billie lies in a coma." class="video-modal" data-video="vi159824409" data-context="imdb" data-rid="YAQYHQZAPJWQPCYD78VQ" widget-context="nameMaindetails"><img height="150" width="200" alt="Between Worlds -- Nicolas Cage stars in this twist-filled supernatural thriller that follows Joe (Cage), a struggling truck driver haunted by the memory of his deceased wife and daughter. His life takes a dramatic turn when he meets Julia (Franka Potente), a woman with mysterious spiritual powers, whose daughter Billie lies in a coma." title="Between Worlds -- Nicolas Cage stars in this twist-filled supernatural thriller that follows Joe (Cage), a struggling truck driver haunted by the memory of his deceased wife and daughter. His life takes a dramatic turn when he meets Julia (Franka Potente), a woman with mysterious spiritual powers, whose daughter Billie lies in a coma." src="https://m.media-amazon.com/images/S/sash/LF9ZUTFoX8jwgUD.png" class="loadlate hidden video" loadlate="https://m.media-amazon.com/images/M/MV5BZDFlODQ2NDgtNWIwZC00YTIwLTk5OTYtNTgwYTA4ZGYzM2RiXkEyXkFqcGdeQWtlbGFyc2Vu._V1_SP330,330,0,C,0,0,0_CR65,90,200,150_PIimdb-blackband-204-14,TopLeft,0,0_PIimdb-blackband-204-28,BottomLeft,0,1_CR0,0,200,150_PIimdb-bluebutton-big,BottomRight,-1,-1_ZATrailer,4,123,16,196,verdenab,8,255,255,255,1_ZAon%2520IMDb,4,1,14,196,verdenab,7,255,255,255,1_ZA01%253A52,164,1,14,36,verdenab,7,255,255,255,1_PIimdb-HDIconMiniWhite,BottomLeft,4,-2_ZABetween%2520Worlds,24,138,14,176,arialbd,7,255,255,255,1_.jpg" viconst="vi159824409" /></a>            </span>
    </div>

                    <div class="see-more">
<a href="/name/nm0004376/videogallery?ref_=nm_rvd_vi_sm"
>See all 17 videos</a>&nbsp;&raquo;
                    </div>
            </div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameVideoStrip_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameVideoStrip", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameVideoStrip", {wb: 1});
    }
</script>

            <div class="article">
<script>
    if (typeof uet == 'function') {
      uet("bb", "NamePersonalDetailsWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NamePersonalDetailsWidget_started');
      }
    </script>
        <span class="rightcornerlink">
<a href="https://contribute.imdb.com/updates?edit=nm0004376/details&ref_=nm_pdt_edt"
> Edit
</a>        </span>
    <h2>Personal Details</h2>
        <div id="details-other-works" class="see-more inline canwrap">
                <h4 class="inline">Other Works:</h4>
Did a song called 'I wish' together with Thomas D. of 'Die fantastischen Vier'.                    <span class="see-more inline">
                        <a href="/name/nm0004376/otherworks?ref_=nm_pdt_wrk_sm"
>See more</a> 
                    </span>
                    &raquo;
        </div>

            <hr/>
        <div id="details-publicity-listings" class="see-more inline canwrap">
            <h4 class="inline">Publicity Listings:</h4>
    8 Interviews     <span class="ghost">|</span>
    5 Articles     <span class="ghost">|</span>
    3 Pictorials     <span class="ghost">|</span>
    7 Magazine Cover Photos     <span class="ghost">|</span>
            <span class="see-more inline">
                <a href="/name/nm0004376/publicity?ref_=nm_pdt_pub_sm"
>See more</a>
            </span>&raquo;
        </div>
    
    
            <hr/>
        <div id="details-akas" class="see-more inline canwrap">
            <h4 class="inline">Alternate Names:</h4>
            Franke Potente
        </div>
    
            <hr/>
        <div id="details-height" class="see-more inline canwrap">
            <h4 class="inline">Height:</h4>
5'&nbsp;8½"&nbsp;(1.74&nbsp;m)        </div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NamePersonalDetailsWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NamePersonalDetailsWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NamePersonalDetailsWidget", {wb: 1});
    }
</script>
            </div> 
            <div class="article">
<script>
    if (typeof uet == 'function') {
      uet("bb", "NameDidYouKnowWidget", {wb: 1});
    }
</script>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameDidYouKnowWidget_started');
      }
    </script>
        <span class="rightcornerlink">
<a href="https://contribute.imdb.com/updates?edit=nm0004376/fun-facts&ref_=nm_dyk_edt"
> Edit
</a>        </span>
    <h2>Did You Know?</h2>
        <div id="dyk-personal-quote" class="see-more inline canwrap">
                <h4 class="inline">Personal Quote:</h4>
When I was a kid at first I wanted to own a candy shop. I guess every kid wants to - we just want to have access - free access.                    <span class="see-more inline">
                        <a href="/name/nm0004376/bio?ref_=nm_dyk_qt_sm#quotes"
>See more</a> 
                    </span>
                    &raquo;
        </div>
            <hr/>
        <div id="dyk-trivia" class="see-more inline canwrap">
                <h4 class="inline">Trivia:</h4>
Wrote her first book "Los Angeles - Berlin. One Year." together with her good friend, the actor <a href="/name/nm0881992?ref_=nm_dyk_trv1">Max Urlacher</a> 2005.                    <span class="see-more inline">
                        <a href="/name/nm0004376/bio?ref_=nm_dyk_trv_sm#trivia"
>See more</a>
                    </span>
                    &raquo;
        </div>
    
            <hr/>
        <div id="dyk-trademark" class="see-more inline canwrap">

                <h4 class="inline">Trademark:</h4>
Ever-changing hair color        </div>
    
            <hr/>
        <div id="dyk-star-sign" class="see-more inline canwrap">
            <h4 class="inline">Star Sign:</h4>
            <a href="/search/name?star_sign=cancer&ref_=nm_dyk_sign"
>Cancer</a>
        </div>
    <script>
      if ('csm' in window) {
        csm.measure('csm_NameDidYouKnowWidget_finished');
      }
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "NameDidYouKnowWidget", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "NameDidYouKnowWidget", {wb: 1});
    }
</script>
            </div> 

    
    
    


    
    
    
  <script>
    if ('csm' in window) {
      csm.measure('csm_NameContributeWidget_started');
    }
  </script>

    <div id="contribute-main-section" class="article contribute">
        <div class="rightcornerlink">
<a href="https://help.imdb.com/article/contribution/contribution-information/adding-data/G6BXD2JFDCCETUF4?ref_=cons_nm_cn_gs_hlp"
>Getting Started</a>
            <span>|</span>
<a href="/czone/?ref_=nm_cn_cz"
>Contributor Zone</a>&nbsp;&raquo;</div>
        <h2>Contribute to This Page</h2>

                <div id="contribute-main-button" class="button-box">
                    <form method="get" action="https://contribute.imdb.com/updates">
                        <input type="hidden" name="ref_" value="nm_cn_edt" />
                        <input type="hidden" name="edit" value="legacy/name/nm0004376/" />
                            <button class="btn primary large" rel="login" type="submit">Edit page</button>
                    </form>
                </div>


    </div>

  <script>
    if ('csm' in window) {
      csm.measure('csm_NameContributeWidget_finished');
    }
  </script>


    
    
    


    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

    
    
    

    
    
    
    </div>
    <br class="clear"/>
</div> 


    
    
    

    
    
    

                  <br class="clear" />
               </div>


                    <div id="rvi-div">
                        <div class="recently-viewed">
                        <div class="header">
                            <div class="rhs">
                                <a id="clear_rvi" href="#">Clear your history</a>
                            </div>
                            <h3>Recently Viewed</h3>
                        </div>
                            <div class="items">&nbsp;</div>
                        </div>
                    </div>

	
        <!-- no content received for slot: bottom_ad -->
	

    <script type="text/javascript">
        try {
            window.lumierePlayer = window.lumierePlayer || {};
            window.lumierePlayer.weblab = JSON.parse('{"IMDB_VIDEO_PLAYER_162496":"C"}');
        } catch (error) {
            if (window.ueLogError) {
                window.ueLogError(error, {
                    logLevel: "WARN",
                    attribution: "videoplayer",
                    message: "Failed to parse weblabs for video player."
                });
            }
        }
    </script>
            </div>
        </div>
        
<script>
    if (typeof uet == 'function') {
      uet("bb", "desktopFooter", {wb: 1});
    }
</script>
    <div id="9ac3dd46-968d-47de-8226-93c7aa84face">
       <footer class="imdb-footer VUGIPjGgHtzvbHiU19iTQ"><div class="_32mc4FXftSbwhpJwmGCYUQ"><div class="ipc-page-content-container ipc-page-content-container--center" role="presentation"><a class="ipc-button ipc-button--double-padding ipc-button--center-align-content ipc-button--default-height ipc-button--core-accent1 ipc-button--theme-baseAlt imdb-footer__open-in-app-button" role="button" tabindex="0" aria-disabled="false" href="https://slyb.app.link/SKdyQ6A449"><div class="ipc-button__text">Get the IMDb App</div></a></div></div><div class="ipc-page-content-container ipc-page-content-container--center _2AR8CsLqQAMCT1_Q7eidSY" role="presentation"><div class="imdb-footer__links"><div class="_2Wc8yXs8SzGv7TVS-oOmhT"><ul class="ipc-inline-list _1O3-k0VDASm1IeBrfofV4g baseAlt" role="presentation"><li role="presentation" class="ipc-inline-list__item"><a class="ipc-icon-link ipc-icon-link--baseAlt ipc-icon-link--onBase" title="Facebook" role="button" tabindex="0" aria-label="Facebook" aria-disabled="false" target="_blank" rel="nofollow noopener" href="https://facebook.com/imdb"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--facebook" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M20.896 2H3.104C2.494 2 2 2.494 2 3.104v17.792C2 21.506 2.494 22 3.104 22h9.579v-7.745h-2.607v-3.018h2.607V9.01c0-2.584 1.577-3.99 3.882-3.99 1.104 0 2.052.082 2.329.119v2.7h-1.598c-1.254 0-1.496.595-1.496 1.47v1.927h2.989l-.39 3.018h-2.6V22h5.097c.61 0 1.104-.494 1.104-1.104V3.104C22 2.494 21.506 2 20.896 2"></path></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a class="ipc-icon-link ipc-icon-link--baseAlt ipc-icon-link--onBase" title="Instagram" role="button" tabindex="0" aria-label="Instagram" aria-disabled="false" target="_blank" rel="nofollow noopener" href="https://instagram.com/imdb"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--instagram" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M11.997 2.04c-2.715 0-3.056.011-4.122.06-1.064.048-1.79.217-2.426.463a4.901 4.901 0 0 0-1.771 1.151 4.89 4.89 0 0 0-1.153 1.767c-.247.635-.416 1.36-.465 2.422C2.011 8.967 2 9.307 2 12.017s.011 3.049.06 4.113c.049 1.062.218 1.787.465 2.422a4.89 4.89 0 0 0 1.153 1.767 4.901 4.901 0 0 0 1.77 1.15c.636.248 1.363.416 2.427.465 1.066.048 1.407.06 4.122.06s3.055-.012 4.122-.06c1.064-.049 1.79-.217 2.426-.464a4.901 4.901 0 0 0 1.77-1.15 4.89 4.89 0 0 0 1.154-1.768c.247-.635.416-1.36.465-2.422.048-1.064.06-1.404.06-4.113 0-2.71-.012-3.05-.06-4.114-.049-1.062-.218-1.787-.465-2.422a4.89 4.89 0 0 0-1.153-1.767 4.901 4.901 0 0 0-1.77-1.15c-.637-.247-1.363-.416-2.427-.464-1.067-.049-1.407-.06-4.122-.06m0 1.797c2.67 0 2.985.01 4.04.058.974.045 1.503.207 1.856.344.466.181.8.397 1.15.746.349.35.566.682.747 1.147.137.352.3.88.344 1.853.048 1.052.058 1.368.058 4.032 0 2.664-.01 2.98-.058 4.031-.044.973-.207 1.501-.344 1.853a3.09 3.09 0 0 1-.748 1.147c-.35.35-.683.565-1.15.746-.352.137-.88.3-1.856.344-1.054.048-1.37.058-4.04.058-2.669 0-2.985-.01-4.039-.058-.974-.044-1.504-.207-1.856-.344a3.098 3.098 0 0 1-1.15-.746 3.09 3.09 0 0 1-.747-1.147c-.137-.352-.3-.88-.344-1.853-.049-1.052-.059-1.367-.059-4.031 0-2.664.01-2.98.059-4.032.044-.973.207-1.501.344-1.853a3.09 3.09 0 0 1 .748-1.147c.35-.349.682-.565 1.149-.746.352-.137.882-.3 1.856-.344 1.054-.048 1.37-.058 4.04-.058"></path><path d="M11.997 15.342a3.329 3.329 0 0 1-3.332-3.325 3.329 3.329 0 0 1 3.332-3.326 3.329 3.329 0 0 1 3.332 3.326 3.329 3.329 0 0 1-3.332 3.325m0-8.449a5.128 5.128 0 0 0-5.134 5.124 5.128 5.128 0 0 0 5.134 5.123 5.128 5.128 0 0 0 5.133-5.123 5.128 5.128 0 0 0-5.133-5.124m6.536-.203c0 .662-.537 1.198-1.2 1.198a1.198 1.198 0 1 1 1.2-1.197"></path></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a class="ipc-icon-link ipc-icon-link--baseAlt ipc-icon-link--onBase" title="Twitch" role="button" tabindex="0" aria-label="Twitch" aria-disabled="false" target="_blank" rel="nofollow noopener" href="https://twitch.tv/IMDb"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--twitch" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M3.406 2h18.596v12.814l-5.469 5.47H12.47L9.813 22.94H7.001v-2.657H2V5.594L3.406 2zm16.721 11.876v-10H5.125v13.126h4.22v2.656L12 17.002h5l3.126-3.126z"></path><path d="M17.002 7.47v5.469h-1.875v-5.47zM12.001 7.47v5.469h-1.875v-5.47z"></path></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a class="ipc-icon-link ipc-icon-link--baseAlt ipc-icon-link--onBase" title="Twitter" role="button" tabindex="0" aria-label="Twitter" aria-disabled="false" target="_blank" rel="nofollow noopener" href="https://twitter.com/imdb"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--twitter" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M8.29 19.936c7.547 0 11.675-6.13 11.675-11.446 0-.175-.004-.348-.012-.52A8.259 8.259 0 0 0 22 5.886a8.319 8.319 0 0 1-2.356.633 4.052 4.052 0 0 0 1.804-2.225c-.793.46-1.67.796-2.606.976A4.138 4.138 0 0 0 15.847 4c-2.266 0-4.104 1.802-4.104 4.023 0 .315.036.622.107.917a11.728 11.728 0 0 1-8.458-4.203 3.949 3.949 0 0 0-.556 2.022 4 4 0 0 0 1.826 3.348 4.136 4.136 0 0 1-1.858-.503l-.001.051c0 1.949 1.415 3.575 3.292 3.944a4.193 4.193 0 0 1-1.853.07c.522 1.597 2.037 2.76 3.833 2.793a8.34 8.34 0 0 1-5.096 1.722A8.51 8.51 0 0 1 2 18.13a11.785 11.785 0 0 0 6.29 1.807"></path></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a class="ipc-icon-link ipc-icon-link--baseAlt ipc-icon-link--onBase" title="YouTube" role="button" tabindex="0" aria-label="YouTube" aria-disabled="false" target="_blank" rel="nofollow noopener" href="https://youtube.com/imdb/"><svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" class="ipc-icon ipc-icon--youtube" viewBox="0 0 24 24" fill="currentColor" role="presentation"><path d="M9.955 14.955v-5.91L15.182 12l-5.227 2.955zm11.627-7.769a2.505 2.505 0 0 0-1.768-1.768C18.254 5 12 5 12 5s-6.254 0-7.814.418c-.86.23-1.538.908-1.768 1.768C2 8.746 2 12 2 12s0 3.254.418 4.814c.23.86.908 1.538 1.768 1.768C5.746 19 12 19 12 19s6.254 0 7.814-.418a2.505 2.505 0 0 0 1.768-1.768C22 15.254 22 12 22 12s0-3.254-.418-4.814z"></path></svg></a></li></ul></div><div><ul class="ipc-inline-list _1O3-k0VDASm1IeBrfofV4g baseAlt" role="presentation"><li role="presentation" class="ipc-inline-list__item zgFV3U-XECrqVQnyDbx2B"><a href="https://slyb.app.link/SKdyQ6A449" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Get the IMDb App<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item X17C45Q1MH_7XboLL_EEG"><a href="?mode=desktop&amp;ref_=m_ft_dsk" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color">View Full Site</a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://help.imdb.com/imdb" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Help<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://help.imdb.com/article/imdb/general-information/imdb-site-index/GNCX7BHNSPBTFALQ#so" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Site Index<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://pro.imdb.com?ref_=ft_pro&amp;rf=cons_tf_pro" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">IMDbPro<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://www.boxofficemojo.com" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Box Office Mojo<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://developer.imdb.com/" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">IMDb Developer<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li></ul></div><div><ul class="ipc-inline-list _1O3-k0VDASm1IeBrfofV4g baseAlt" role="presentation"><li role="presentation" class="ipc-inline-list__item"><a href="https://www.imdb.com/pressroom/?ref_=ft_pr" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color">Press Room</a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://advertising.amazon.com/resources/ad-specs/imdb/" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Advertising<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://www.amazon.jobs/en/teams/imdb" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Jobs<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><a href="/conditions?ref_=ft_cou" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color">Conditions of Use</a></li><li role="presentation" class="ipc-inline-list__item"><a href="/privacy?ref_=ft_pvc" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color">Privacy Policy</a></li><li role="presentation" class="ipc-inline-list__item"><a href="https://www.amazon.com/b/?&amp;node=5160028011" target="_blank" class="ipc-link ipc-link--baseAlt ipc-link--touch-target ipc-link--inherit-color ipc-link--launch">Interest-Based Ads<svg class="ipc-link__launch-icon" width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg" fill="#000000"><g><path d="M9,9 L1,9 L1,1 L4,1 L4,0 L-1.42108547e-14,0 L-1.42108547e-14,10 L10,10 L10,6 L9,6 L9,9 Z M6,0 L6,1 L8,1 L2.998122,6.03786058 L3.998122,7.03786058 L9,2 L9,4 L10,4 L10,0 L6,0 Z"></path></g></svg></a></li><li role="presentation" class="ipc-inline-list__item"><div id="teconsent" class="_2mulh8fx3PjJyxvyLovP4w"></div></li></ul></div></div><div class="imdb-footer__logo _1eKbSAFyeJgUyBUy2VbcS_"><svg aria-label="IMDb, an Amazon company" title="IMDb, an Amazon company" width="160" height="18" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path d="M26.707 2.45c-3.227 2.374-7.906 3.637-11.935 3.637C9.125 6.087 4.04 4.006.193.542-.11.27.161-.101.523.109 4.675 2.517 9.81 3.968 15.111 3.968c3.577 0 7.51-.74 11.127-2.27.546-.23 1.003.358.47.752z" id="ftr__a"/><path d="M4.113 1.677C3.7 1.15 1.385 1.427.344 1.552c-.315.037-.364-.237-.08-.436C2.112-.178 5.138.196 5.49.629c.354.437-.093 3.462-1.824 4.906-.266.222-.52.104-.401-.19.39-.97 1.261-3.14.848-3.668z" id="ftr__c"/><path d="M.435 1.805V.548A.311.311 0 0 1 .755.23l5.65-.001c.181 0 .326.13.326.317v1.078c-.002.181-.154.417-.425.791L3.378 6.582c1.087-.026 2.236.137 3.224.69.222.125.282.309.3.49v1.342c0 .185-.203.398-.417.287-1.74-.908-4.047-1.008-5.97.011-.197.104-.403-.107-.403-.292V7.835c0-.204.004-.552.21-.863l3.392-4.85H.761a.314.314 0 0 1-.326-.317z" id="ftr__e"/><path d="M2.247 9.655H.528a.323.323 0 0 1-.307-.29L.222.569C.222.393.37.253.554.253h1.601a.323.323 0 0 1 .313.295v1.148h.031C2.917.586 3.703.067 4.762.067c1.075 0 1.75.518 2.23 1.629C7.41.586 8.358.067 9.369.067c.722 0 1.508.296 1.99.963.545.74.433 1.813.433 2.757l-.002 5.551a.324.324 0 0 1-.331.317H9.74a.321.321 0 0 1-.308-.316l-.001-4.663c0-.37.032-1.296-.048-1.647-.128-.593-.514-.76-1.011-.76-.418 0-.85.278-1.027.722-.177.445-.161 1.185-.161 1.685v4.662a.323.323 0 0 1-.331.317H5.137a.322.322 0 0 1-.31-.316l-.001-4.663c0-.981.16-2.424-1.059-2.424-1.236 0-1.188 1.406-1.188 2.424v4.662a.324.324 0 0 1-.332.317z" id="ftr__g"/><path d="M4.037.067c2.551 0 3.931 2.184 3.931 4.96 0 2.684-1.524 4.814-3.931 4.814C1.533 9.84.169 7.656.169 4.935.17 2.195 1.55.067 4.037.067zm.015 1.796c-1.267 0-1.347 1.721-1.347 2.795 0 1.073-.016 3.368 1.332 3.368 1.332 0 1.395-1.851 1.395-2.98 0-.74-.031-1.629-.256-2.332-.193-.61-.578-.851-1.124-.851z" id="ftr__i"/><path d="M2.206 9.655H.493a.321.321 0 0 1-.308-.316L.182.54a.325.325 0 0 1 .33-.287h1.595c.15.007.274.109.305.245v1.346h.033C2.926.641 3.6.067 4.788.067c.77 0 1.524.277 2.006 1.037.449.703.449 1.887.449 2.739v5.535a.325.325 0 0 1-.33.277H5.19a.324.324 0 0 1-.306-.277V4.602c0-.962.113-2.37-1.075-2.37-.418 0-.803.278-.995.704-.24.537-.273 1.074-.273 1.666v4.736a.328.328 0 0 1-.335.317z" id="ftr__k"/><path d="M8.314 8.295c.11.156.134.341-.006.455-.35.294-.974.834-1.318 1.139l-.004-.004a.357.357 0 0 1-.406.04c-.571-.473-.673-.692-.986-1.142-.943.958-1.611 1.246-2.834 1.246-1.447 0-2.573-.89-2.573-2.672 0-1.39.756-2.337 1.833-2.8.933-.409 2.235-.483 3.233-.595V3.74c0-.409.032-.89-.209-1.243-.21-.315-.611-.445-.965-.445-.656 0-1.238.335-1.382 1.029-.03.154-.143.307-.298.315l-1.667-.18c-.14-.032-.297-.144-.256-.358C.859.842 2.684.234 4.32.234c.837 0 1.93.222 2.59.853.836.78.755 1.818.755 2.95v2.67c0 .804.335 1.155.65 1.588zM5.253 5.706v-.37c-1.244 0-2.557.265-2.557 1.724 0 .742.386 1.244 1.045 1.244.483 0 .917-.297 1.19-.78.338-.593.322-1.15.322-1.818z" id="ftr__m"/><path d="M8.203 8.295c.11.156.135.341-.005.455-.352.294-.976.834-1.319 1.139l-.004-.004a.356.356 0 0 1-.406.04c-.571-.473-.673-.692-.985-1.142-.944.958-1.613 1.246-2.835 1.246-1.447 0-2.573-.89-2.573-2.672 0-1.39.756-2.337 1.833-2.8.933-.409 2.236-.483 3.233-.595V3.74c0-.409.032-.89-.21-1.243-.208-.315-.61-.445-.964-.445-.656 0-1.239.335-1.382 1.029-.03.154-.142.307-.298.315l-1.666-.18C.48 3.184.324 3.072.365 2.858.748.842 2.573.234 4.209.234c.836 0 1.93.222 2.59.853.835.78.755 1.818.755 2.95v2.67c0 .804.335 1.155.649 1.588zM5.142 5.706v-.37c-1.243 0-2.557.265-2.557 1.724 0 .742.386 1.244 1.045 1.244.482 0 .917-.297 1.19-.78.338-.593.322-1.15.322-1.818z" id="ftr__o"/><path d="M2.935 10.148c-.88 0-1.583-.25-2.11-.75-.527-.501-.79-1.171-.79-2.011 0-.902.322-1.622.967-2.159.644-.538 1.511-.806 2.602-.806.694 0 1.475.104 2.342.315V3.513c0-.667-.151-1.136-.455-1.408-.304-.271-.821-.407-1.553-.407-.855 0-1.691.123-2.509.37-.285.087-.464.13-.539.13-.148 0-.223-.111-.223-.334v-.5c0-.16.025-.278.075-.352C.79.938.89.87 1.039.808c.383-.173.87-.312 1.459-.417A9.997 9.997 0 0 1 4.255.234c1.177 0 2.045.244 2.602.731.557.489.836 1.233.836 2.233v6.338c0 .247-.124.37-.372.37h-.798c-.236 0-.373-.117-.41-.351l-.093-.612c-.445.383-.939.68-1.477.89-.54.21-1.076.315-1.608.315zm.446-1.39c.41 0 .836-.08 1.282-.241.447-.16.874-.395 1.283-.704v-1.89a8.408 8.408 0 0 0-1.97-.241c-1.401 0-2.1.537-2.1 1.612 0 .47.13.831.39 1.084.26.254.632.38 1.115.38z" id="ftr__q"/><path d="M.467 9.907c-.248 0-.372-.124-.372-.37V.883C.095.635.219.51.467.51h.817c.125 0 .22.026.288.075.068.05.115.142.14.277l.111.686C3 .672 4.24.234 5.541.234c.904 0 1.592.238 2.063.713.471.476.707 1.165.707 2.066v6.524c0 .246-.124.37-.372.37H6.842c-.248 0-.372-.124-.372-.37V3.625c0-.655-.133-1.137-.4-1.445-.266-.31-.684-.464-1.254-.464-.979 0-1.94.315-2.881.946v6.875c0 .246-.125.37-.372.37H.467z" id="ftr__s"/><path d="M4.641 9.859c-1.462 0-2.58-.417-3.355-1.251C.51 7.774.124 6.566.124 4.985c0-1.569.4-2.783 1.2-3.641C2.121.486 3.252.055 4.714.055c.67 0 1.326.118 1.971.353.136.05.232.111.288.185.056.074.083.198.083.37v.501c0 .248-.08.37-.241.37-.062 0-.162-.018-.297-.055a5.488 5.488 0 0 0-1.544-.222c-1.04 0-1.79.262-2.248.787-.459.526-.688 1.362-.688 2.511v.241c0 1.124.232 1.949.697 2.474.465.525 1.198.788 2.203.788a5.98 5.98 0 0 0 1.672-.26c.136-.037.23-.056.279-.056.161 0 .242.124.242.371v.5c0 .162-.025.279-.075.353-.05.074-.148.142-.297.204-.608.259-1.314.389-2.119.389z" id="ftr__u"/><path d="M4.598 10.185c-1.413 0-2.516-.438-3.31-1.316C.497 7.992.1 6.769.1 5.199c0-1.555.397-2.773 1.19-3.65C2.082.673 3.185.235 4.598.235c1.412 0 2.515.438 3.308 1.316.793.876 1.19 2.094 1.19 3.65 0 1.569-.397 2.792-1.19 3.669-.793.878-1.896 1.316-3.308 1.316zm0-1.483c1.747 0 2.62-1.167 2.62-3.502 0-2.323-.873-3.484-2.62-3.484S1.977 2.877 1.977 5.2c0 2.335.874 3.502 2.62 3.502z" id="ftr__w"/><path d="M.396 9.907c-.248 0-.371-.124-.371-.37V.883C.025.635.148.51.396.51h.818a.49.49 0 0 1 .288.075c.068.05.115.142.14.277l.111.594C2.943.64 4.102.234 5.23.234c1.152 0 1.934.438 2.342 1.315C8.798.672 10.025.234 11.25.234c.856 0 1.512.24 1.971.722.458.482.688 1.168.688 2.057v6.524c0 .246-.124.37-.372.37h-1.097c-.248 0-.371-.124-.371-.37V3.533c0-.618-.119-1.075-.354-1.372-.235-.297-.607-.445-1.115-.445-.904 0-1.815.278-2.732.834.012.087.018.18.018.278v6.709c0 .246-.124.37-.372.37H6.42c-.249 0-.372-.124-.372-.37V3.533c0-.618-.118-1.075-.353-1.372-.235-.297-.608-.445-1.115-.445-.942 0-1.847.272-2.714.815v7.006c0 .246-.125.37-.372.37H.396z" id="ftr__y"/><path d="M.617 13.724c-.248 0-.371-.124-.371-.37V.882c0-.247.123-.37.371-.37h.818c.248 0 .39.123.428.37l.093.594C2.897.648 3.944.234 5.096.234c1.203 0 2.15.435 2.845 1.307.693.87 1.04 2.053 1.04 3.548 0 1.52-.365 2.736-1.096 3.65-.731.915-1.704 1.372-2.918 1.372-1.116 0-2.076-.365-2.881-1.094v4.337c0 .246-.125.37-.372.37H.617zM4.54 8.628c1.71 0 2.566-1.149 2.566-3.447 0-1.173-.208-2.044-.624-2.612-.415-.569-1.05-.853-1.904-.853-.88 0-1.711.284-2.491.853v5.17c.805.593 1.623.889 2.453.889z" id="ftr__A"/><path d="M2.971 10.148c-.88 0-1.583-.25-2.11-.75-.526-.501-.79-1.171-.79-2.011 0-.902.322-1.622.967-2.159.644-.538 1.512-.806 2.602-.806.694 0 1.475.104 2.342.315V3.513c0-.667-.15-1.136-.455-1.408-.304-.271-.821-.407-1.552-.407-.855 0-1.692.123-2.509.37-.285.087-.465.13-.54.13-.148 0-.223-.111-.223-.334v-.5c0-.16.025-.278.075-.352.05-.074.148-.142.297-.204.384-.173.87-.312 1.46-.417A9.991 9.991 0 0 1 4.29.234c1.177 0 2.045.244 2.603.731.557.489.836 1.233.836 2.233v6.338c0 .247-.125.37-.372.37h-.799c-.236 0-.372-.117-.41-.351l-.092-.612a5.09 5.09 0 0 1-1.478.89 4.4 4.4 0 0 1-1.608.315zm.446-1.39c.41 0 .836-.08 1.283-.241.446-.16.874-.395 1.282-.704v-1.89a8.403 8.403 0 0 0-1.97-.241c-1.4 0-2.1.537-2.1 1.612 0 .47.13.831.39 1.084.26.254.632.38 1.115.38z" id="ftr__C"/><path d="M.503 9.907c-.248 0-.371-.124-.371-.37V.883C.132.635.255.51.503.51h.818a.49.49 0 0 1 .288.075c.068.05.115.142.14.277l.111.686C3.037.672 4.277.234 5.578.234c.904 0 1.592.238 2.063.713.47.476.706 1.165.706 2.066v6.524c0 .246-.123.37-.371.37H6.879c-.248 0-.372-.124-.372-.37V3.625c0-.655-.133-1.137-.4-1.445-.266-.31-.684-.464-1.254-.464-.98 0-1.94.315-2.882.946v6.875c0 .246-.124.37-.371.37H.503z" id="ftr__E"/><path d="M1.988 13.443c-.397 0-.75-.043-1.059-.13-.15-.037-.251-.1-.307-.185a.684.684 0 0 1-.084-.37v-.483c0-.234.093-.352.28-.352.06 0 .154.013.278.037.124.025.291.037.502.037.459 0 .82-.114 1.087-.343.266-.228.505-.633.716-1.213l.353-.945L.167.675C.08.465.037.316.037.23c0-.149.086-.222.26-.222h1.115c.198 0 .334.03.409.093.075.062.148.197.223.407l2.602 7.19 2.51-7.19c.074-.21.148-.345.222-.407.075-.062.211-.093.41-.093h1.04c.174 0 .261.073.261.222 0 .086-.044.235-.13.445l-4.09 10.377c-.334.853-.725 1.464-1.17 1.835-.446.37-1.017.556-1.711.556z" id="ftr__G"/></defs><g fill="none" fill-rule="evenodd"><g transform="translate(31.496 11.553)"><mask id="ftr__b" fill="currentColor"><use xlink:href="#ftr__a"/></mask><path fill="currentColor" mask="url(#ftr__b)" d="M.04 6.088h26.91V.04H.04z"/></g><g transform="translate(55.433 10.797)"><mask id="ftr__d" fill="currentColor"><use xlink:href="#ftr__c"/></mask><path fill="currentColor" mask="url(#ftr__d)" d="M.05 5.664h5.564V.222H.05z"/></g><g transform="translate(55.433 .97)"><mask id="ftr__f" fill="currentColor"><use xlink:href="#ftr__e"/></mask><path fill="currentColor" mask="url(#ftr__f)" d="M.11 9.444h6.804V.222H.111z"/></g><g transform="translate(33.008 .97)"><mask id="ftr__h" fill="currentColor"><use xlink:href="#ftr__g"/></mask><path fill="currentColor" mask="url(#ftr__h)" d="M.191 9.655h11.611V.04H.192z"/></g><g transform="translate(62.992 .97)"><mask id="ftr__j" fill="currentColor"><use xlink:href="#ftr__i"/></mask><path fill="currentColor" mask="url(#ftr__j)" d="M.141 9.867h7.831V.04H.142z"/></g><g transform="translate(72.063 .97)"><mask id="ftr__l" fill="currentColor"><use xlink:href="#ftr__k"/></mask><path fill="currentColor" mask="url(#ftr__l)" d="M.171 9.655h7.076V.04H.17z"/></g><g transform="translate(46.11 .718)"><mask id="ftr__n" fill="currentColor"><use xlink:href="#ftr__m"/></mask><path fill="currentColor" mask="url(#ftr__n)" d="M.181 10.059h8.225V.232H.18z"/></g><g transform="translate(23.685 .718)"><mask id="ftr__p" fill="currentColor"><use xlink:href="#ftr__o"/></mask><path fill="currentColor" mask="url(#ftr__p)" d="M.05 10.059h8.255V.232H.05z"/></g><g transform="translate(0 .718)"><mask id="ftr__r" fill="currentColor"><use xlink:href="#ftr__q"/></mask><path fill="currentColor" mask="url(#ftr__r)" d="M.03 10.15h7.68V.231H.03z"/></g><g transform="translate(10.33 .718)"><mask id="ftr__t" fill="currentColor"><use xlink:href="#ftr__s"/></mask><path fill="currentColor" mask="url(#ftr__t)" d="M.07 9.907h8.255V.232H.071z"/></g><g transform="translate(84.157 .97)"><mask id="ftr__v" fill="currentColor"><use xlink:href="#ftr__u"/></mask><path fill="currentColor" mask="url(#ftr__v)" d="M.11 9.867h7.046V.04H.11z"/></g><g transform="translate(92.472 .718)"><mask id="ftr__x" fill="currentColor"><use xlink:href="#ftr__w"/></mask><path fill="currentColor" mask="url(#ftr__x)" d="M.08 10.21h9.041V.232H.081z"/></g><g transform="translate(103.811 .718)"><mask id="ftr__z" fill="currentColor"><use xlink:href="#ftr__y"/></mask><path fill="currentColor" mask="url(#ftr__z)" d="M.02 9.907H13.93V.232H.02z"/></g><g transform="translate(120.189 .718)"><mask id="ftr__B" fill="currentColor"><use xlink:href="#ftr__A"/></mask><path fill="currentColor" mask="url(#ftr__B)" d="M.242 13.747H9.01V.232H.242z"/></g><g transform="translate(130.772 .718)"><mask id="ftr__D" fill="currentColor"><use xlink:href="#ftr__C"/></mask><path fill="currentColor" mask="url(#ftr__D)" d="M.06 10.15h7.68V.231H.06z"/></g><g transform="translate(141.102 .718)"><mask id="ftr__F" fill="currentColor"><use xlink:href="#ftr__E"/></mask><path fill="currentColor" mask="url(#ftr__F)" d="M.131 9.907h8.224V.232H.131z"/></g><g transform="translate(150.677 1.222)"><mask id="ftr__H" fill="currentColor"><use xlink:href="#ftr__G"/></mask><path fill="currentColor" mask="url(#ftr__H)" d="M.02 13.455h9.071V0H.021z"/></g></g></svg></div><p class="imdb-footer__copyright _2-iNNCFskmr4l2OFN2DRsf">© 1990-<!-- -->2021<!-- --> by IMDb.com, Inc.</p></div></footer><svg style="width:0;height:0;overflow:hidden;display:block" xmlns="http://www.w3.org/2000/svg" version="1.1"><defs><linearGradient id="ipc-svg-gradient-tv-logo-t" x1="31.973%" y1="53.409%" x2="153.413%" y2="-16.853%"><stop stop-color="#D01F49" offset="21.89%"></stop><stop stop-color="#E8138B" offset="83.44%"></stop></linearGradient><linearGradient id="ipc-svg-gradient-tv-logo-v" x1="-38.521%" y1="84.997%" x2="104.155%" y2="14.735%"><stop stop-color="#D01F49" offset="21.89%"></stop><stop stop-color="#E8138B" offset="83.44%"></stop></linearGradient></defs></svg>
    </div>
<script type="text/javascript">
    if (!window.RadWidget) {
        window.RadWidget = {
            registerReactWidgetInstance: function(input) {
                window.RadWidget[input.widgetName] = window.RadWidget[input.widgetName] || [];
                window.RadWidget[input.widgetName].push({
                    id: input.instanceId,
                    props: JSON.stringify(input.model)
                })
            },
            getReactWidgetInstances: function(widgetName) {
                return window.RadWidget[widgetName] || []
            }
        };
    }
</script>    <script type="text/javascript">
        window['RadWidget'].registerReactWidgetInstance({
            widgetName: "IMDbConsumerSiteFooterFeatureV1",
            instanceId: "9ac3dd46-968d-47de-8226-93c7aa84face",
            model: {"ResponsiveFooterModel":{"showIMDbTVLink":false,"desktopLink":"?mode=desktop&ref_=m_ft_dsk","showDesktopLink":true}}
        });
    </script>
<script>
    if (typeof uet == 'function') {
      uet("be", "desktopFooter", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "desktopFooter", {wb: 1});
    }
</script>

<script>
    if (typeof uet == 'function') {
      uet("bb", "LoadHeaderJS", {wb: 1});
    }
</script>



<script type="text/javascript" src="https://m.media-amazon.com/images/S/sash/EbJ50esdfIcjt2R.js"></script>
<script type="text/javascript" src="https://m.media-amazon.com/images/S/sash/RryLheuao$hWfyB.js"></script>

            <script type="text/javascript">
            function jQueryOnReady(remaining_count) {
                if (window.jQuery && typeof $.fn.watchlistRibbon !== 'undefined') {
                    jQuery(
                            function() {
        $("#demoReelShoveler").shoveler({
            'buttons' : {
                'left' : {
                    'text' : '',
                },
                'right' : {
                    'text' : '',
                }
            },
            'height' : 'auto',
            'itemsPerShovel' : 2,
            'paginate' : false,
            'useExternalCSS' : true,
            'width' : '100%'
        });
    }

                    );
                    jQuery(
                                function() {
           var isAdvertisingThemed = !!(window.custom && window.custom.full_page && window.custom.full_page.theme),
               url = "https://www.facebook.com/widgets/like.php?width=280&show_faces=1&layout=standard&href=http%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0004376%2F&colorscheme=light",
               like = document.getElementById('iframe_like');

           if (!isAdvertisingThemed && like) {
              like.src = url;
              like.onload = function () {
                  if (typeof uex == 'function') { uex('ld', 'facebook_like_iframe', {wb: 1}); }
              };
           } else if (isAdvertisingThemed) {
              $('.social_networking_like').closest('.aux-content-widget-2').hide();
           }
        }

                    );
                } else if (remaining_count > 0) {
                    setTimeout(function() { jQueryOnReady(remaining_count-1) }, 100);
                }
            }
            jQueryOnReady(50);
            </script>


<script type="text/javascript">window.webpackManifest_IMDbConsumerSiteFooterFeature={}</script><script type="text/javascript">window.webpackManifest_IMDbConsumerSiteNavFeature={}</script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/81wMp4HTadL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/61SeeyqsNHL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/31ROAIgElzL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01lfk7y+8rL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/61Ka2ezTX9L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/019vMGkrlkL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/31VYLn8dVDL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01qhBQyMr+L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/21QhnrxvhtL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01EjywnajPL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01eEXY1YetL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/21a9eB+eAFL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/41utkxPA-bL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/81azxdougUL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/61vDTVmJCNL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/31827uXCh4L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/31P6K1kIR-L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/41Dm6cYzV6L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/51GDom0+d0L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01ZyMmZoX7L.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/11UNuUz7BzL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/21n5fdlWBhL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/01X4+ME2ObL.js"></script><script crossorigin="anonymous" type="text/javascript" src="https://m.media-amazon.com/images/I/61JnLkt2NVL.js"></script>


<script>
    if (typeof uet == 'function') {
      uet("be", "LoadFooterJS", {wb: 1});
    }
</script>
<script>
    if (typeof uex == 'function') {
      uex("ld", "LoadFooterJS", {wb: 1});
    }
</script>
        
        <div id="servertime" time="210"/>



<script>
    if (typeof uet == 'function') {
      uet("be");
    }
</script>
        <div id='be' style="display:none;visibility:hidden;"><form name='ue_backdetect' action="get"><input type="hidden" name='ue_back' value='1' /></form>


<script type="text/javascript">
window.ue_ibe = (window.ue_ibe || 0) + 1;
if (window.ue_ibe === 1) {
(function(e,c){function h(b,a){f.push([b,a])}function g(b,a){if(b){var c=e.head||e.getElementsByTagName("head")[0]||e.documentElement,d=e.createElement("script");d.async="async";d.src=b;d.setAttribute("crossorigin","anonymous");a&&a.onerror&&(d.onerror=a.onerror);a&&a.onload&&(d.onload=a.onload);c.insertBefore(d,c.firstChild)}}function k(){ue.uels=g;for(var b=0;b<f.length;b++){var a=f[b];g(a[0],a[1])}ue.deffered=1}var f=[];c.ue&&(ue.uels=h,c.ue.attach&&c.ue.attach("load",k))})(document,window);


if (window.ue && window.ue.uels) {
        var cel_widgets = [ { "c":"celwidget" },{ "s":"#nav-swmslot > div", "id_gen":function(elem, index){ return 'nav_sitewide_msg'; } } ];

                ue.uels("https://images-na.ssl-images-amazon.com/images/I/31YXrY93hfL.js");
}
var ue_mbl=ue_csm.ue.exec(function(e,a){function m(g){b=g||{};a.AMZNPerformance=b;b.transition=b.transition||{};b.timing=b.timing||{};if(a.csa){var c;b.timing.transitionStart&&(c=b.timing.transitionStart);b.timing.processStart&&(c=b.timing.processStart);c&&(csa("PageTiming")("mark","nativeTransitionStart",c),csa("PageTiming")("mark","transitionStart",c))}e.ue.exec(n,"csm-android-check")()&&b.tags instanceof Array&&(g=-1!=b.tags.indexOf("usesAppStartTime")||b.transition.type?!b.transition.type&&-1<
b.tags.indexOf("usesAppStartTime")?"warm-start":void 0:"view-transition",g&&(b.transition.type=g));"reload"===f._nt&&e.ue_orct||"intrapage-transition"===f._nt?d&&d.timing&&d.timing.navigationStart?b.timing.transitionStart=d.timing.navigationStart:delete b.timing.transitionStart:"undefined"===typeof f._nt&&d&&d.timing&&d.timing.navigationStart&&a.history&&"function"===typeof a.History&&"object"===typeof a.history&&a.history.length&&1!=a.history.length&&(b.timing.transitionStart=d.timing.navigationStart);
g=b.transition;c=f._nt?f._nt:void 0;g.subType=c;a.ue&&a.ue.tag&&a.ue.tag("has-AMZNPerformance");f.isl&&a.uex&&a.uex("at","csm-timing");p()}function q(b){a.ue&&a.ue.count&&a.ue.count("csm-cordova-plugin-failed",1)}function n(){return a.cordova&&a.cordova.platformId&&"android"==a.cordova.platformId}function p(){try{a.P.register("AMZNPerformance",function(){return b})}catch(g){}}function k(){if(!b)return"";ue_mbl.cnt=null;for(var a=b.timing,c=b.transition,a=["mts",l(a.transitionStart),"mps",l(a.processStart),
"mtt",c.type,"mtst",c.subType,"mtlt",c.launchType],c="",d=0;d<a.length;d+=2){var f=a[d],e=a[d+1];"undefined"!==typeof e&&(c+="&"+f+"="+e)}return c}function l(a){if("undefined"!==typeof a&&"undefined"!==typeof h)return a-h}function r(a,c){b&&(h=c,b.timing.transitionStart=a,b.transition.type="view-transition",b.transition.subType="ajax-transition",b.transition.launchType="normal",ue_mbl.cnt=k)}var f=e.ue||{},h=e.ue_t0,d=a.performance,b;if(a.P&&a.P.when&&a.P.register)return 1===a.ue_fnt&&(h=a.aPageStart||
e.ue_t0),a.P.when("CSMPlugin").execute(function(a){a.buildAMZNPerformance&&a.buildAMZNPerformance({successCallback:m,failCallback:q})}),{cnt:k,ajax:r}},"mobile-timing")(ue_csm,ue_csm.window);

(function(d){d._uess=function(){var a="";screen&&screen.width&&screen.height&&(a+="&sw="+screen.width+"&sh="+screen.height);var b=function(a){var b=document.documentElement["client"+a];return"CSS1Compat"===document.compatMode&&b||document.body["client"+a]||b},c=b("Width"),b=b("Height");c&&b&&(a+="&vw="+c+"&vh="+b);return a}})(ue_csm);

(function(a){var b=document.ue_backdetect;b&&b.ue_back&&a.ue&&(a.ue.bfini=b.ue_back.value);a.uet&&a.uet("be");a.onLdEnd&&(window.addEventListener?window.addEventListener("load",a.onLdEnd,!1):window.attachEvent&&window.attachEvent("onload",a.onLdEnd));a.ueh&&a.ueh(0,window,"load",a.onLd,1);a.ue&&a.ue.tag&&(a.ue_furl?(b=a.ue_furl.replace(/\./g,"-"),a.ue.tag(b)):a.ue.tag("nofls"))})(ue_csm);

(function(g,h){function d(a,d){var b={};if(!e||!f)try{var c=h.sessionStorage;c?a&&("undefined"!==typeof d?c.setItem(a,d):b.val=c.getItem(a)):f=1}catch(g){e=1}e&&(b.e=1);return b}var b=g.ue||{},a="",f,e,c,a=d("csmtid");f?a="NA":a.e?a="ET":(a=a.val,a||(a=b.oid||"NI",d("csmtid",a)),c=d(b.oid),c.e||(c.val=c.val||0,d(b.oid,c.val+1)),b.ssw=d);b.tabid=a})(ue_csm,ue_csm.window);

ue_csm.ue.exec(function(e,f){var a=e.ue||{},b=a._wlo,d;if(a.ssw){d=a.ssw("CSM_previousURL").val;var c=f.location,b=b?b:c&&c.href?c.href.split("#")[0]:void 0;c=(b||"")===a.ssw("CSM_previousURL").val;!c&&b&&a.ssw("CSM_previousURL",b);d=c?"reload":d?"intrapage-transition":"first-view"}else d="unknown";a._nt=d},"NavTypeModule")(ue_csm,window);
ue_csm.ue.exec(function(c,a){function g(a){a.run(function(e){d.tag("csm-feature-"+a.name+":"+e);d.isl&&c.uex("at")})}if(a.addEventListener)for(var d=c.ue||{},f=[{name:"touch-enabled",run:function(b){var e=function(){a.removeEventListener("touchstart",c,!0);a.removeEventListener("mousemove",d,!0)},c=function(){b("true");e()},d=function(){b("false");e()};a.addEventListener("touchstart",c,!0);a.addEventListener("mousemove",d,!0)}}],b=0;b<f.length;b++)g(f[b])},"csm-features")(ue_csm,window);


(function(b,c){var a=c.images;a&&a.length&&b.ue.count("totalImages",a.length)})(ue_csm,document);
(function(b){function c(){var d=[];a.log&&a.log.isStub&&a.log.replay(function(a){e(d,a)});a.clog&&a.clog.isStub&&a.clog.replay(function(a){e(d,a)});d.length&&(a._flhs+=1,n(d),p(d))}function g(){a.log&&a.log.isStub&&(a.onflush&&a.onflush.replay&&a.onflush.replay(function(a){a[0]()}),a.onunload&&a.onunload.replay&&a.onunload.replay(function(a){a[0]()}),c())}function e(d,b){var c=b[1],f=b[0],e={};a._lpn[c]=(a._lpn[c]||0)+1;e[c]=f;d.push(e)}function n(b){q&&(a._lpn.csm=(a._lpn.csm||0)+1,b.push({csm:{k:"chk",
f:a._flhs,l:a._lpn,s:"inln"}}))}function p(a){if(h)a=k(a),b.navigator.sendBeacon(l,a);else{a=k(a);var c=new b[f];c.open("POST",l,!0);c.setRequestHeader&&c.setRequestHeader("Content-type","text/plain");c.send(a)}}function k(a){return JSON.stringify({rid:b.ue_id,sid:b.ue_sid,mid:b.ue_mid,mkt:b.ue_mkt,sn:b.ue_sn,reqs:a})}var f="XMLHttpRequest",q=1===b.ue_ddq,a=b.ue,r=b[f]&&"withCredentials"in new b[f],h=b.navigator&&b.navigator.sendBeacon,l="//"+b.ue_furl+"/1/batch/1/OE/",m=b.ue_fci_ft||5E3;a&&(r||h)&&
(a._flhs=a._flhs||0,a._lpn=a._lpn||{},a.attach&&(a.attach("beforeunload",a.exec(g,"fcli-bfu")),a.attach("pagehide",a.exec(g,"fcli-ph"))),m&&b.setTimeout(a.exec(c,"fcli-t"),m),a._ffci=a.exec(c))})(window);


(function(k,c){function l(a,b){return a.filter(function(a){return a.initiatorType==b})}function f(a,c){if(b.t[a]){var g=b.t[a]-b._t0,e=c.filter(function(a){return 0!==a.responseEnd&&m(a)<g}),f=l(e,"script"),h=l(e,"link"),k=l(e,"img"),n=e.map(function(a){return a.name.split("/")[2]}).filter(function(a,b,c){return a&&c.lastIndexOf(a)==b}),q=e.filter(function(a){return a.duration<p}),s=g-Math.max.apply(null,e.map(m))<r|0;"af"==a&&(b._afjs=f.length);return a+":"+[e[d],f[d],h[d],k[d],n[d],q[d],s].join("-")}}
function m(a){return a.responseEnd-(b._t0-c.timing.navigationStart)}function n(){var a=c[h]("resource"),d=f("cf",a),g=f("af",a),a=f("ld",a);delete b._rt;b._ld=b.t.ld-b._t0;b._art&&b._art();return[d,g,a].join("_")}var p=20,r=50,d="length",b=k.ue,h="getEntriesByType";b._rre=m;b._rt=c&&c.timing&&c[h]&&n})(ue_csm,window.performance);


(function(c,d){var b=c.ue,a=d.navigator;b&&b.tag&&a&&(a=a.connection||a.mozConnection||a.webkitConnection)&&a.type&&b.tag("netInfo:"+a.type)})(ue_csm,window);


(function(c,d){function h(a,b){for(var c=[],d=0;d<a.length;d++){var e=a[d],f=b.encode(e);if(e[k]){var g=b.metaSep,e=e[k],l=b.metaPairSep,h=[],m=void 0;for(m in e)e.hasOwnProperty(m)&&h.push(m+"="+e[m]);e=h.join(l);f+=g+e}c.push(f)}return c.join(b.resourceSep)}function s(a){var b=a[k]=a[k]||{};b[t]||(b[t]=c.ue_mid);b[u]||(b[u]=c.ue_sid);b[f]||(b[f]=c.ue_id);b.csm=1;a="//"+c.ue_furl+"/1/"+a[v]+"/1/OP/"+a[w]+"/"+a[x]+"/"+h([a],y);if(n)try{n.call(d[p],a)}catch(g){c.ue.sbf=1,(new Image).src=a}else(new Image).src=
a}function q(){g&&g.isStub&&g.replay(function(a,b,c){a=a[0];b=a[k]=a[k]||{};b[f]=b[f]||c;s(a)});l.impression=s;g=null}if(!(1<c.ueinit)){var k="metadata",x="impressionType",v="foresterChannel",w="programGroup",t="marketplaceId",u="session",f="requestId",p="navigator",l=c.ue||{},n=d[p]&&d[p].sendBeacon,r=function(a,b,c,d){return{encode:d,resourceSep:a,metaSep:b,metaPairSep:c}},y=r("","?","&",function(a){return h(a.impressionData,z)}),z=r("/",":",",",function(a){return a.featureName+":"+h(a.resources,
A)}),A=r(",","@","|",function(a){return a.id}),g=l.impression;n?q():(l.attach("load",q),l.attach("beforeunload",q));try{d.P&&d.P.register&&d.P.register("impression-client",function(){})}catch(B){c.ueLogError(B,{logLevel:"WARN"})}}})(ue_csm,window);



var ue_pty = "name";

var ue_spty = "main";



var ue_adb = 4;
var ue_adb_rtla = 1;
ue_csm.ue.exec(function(y,a){function t(){if(d&&f){var a;a:{try{a=d.getItem(g);break a}catch(c){}a=void 0}if(a)return b=a,!0}return!1}function u(){if(a.fetch)fetch(m).then(function(a){if(!a.ok)throw Error(a.statusText);return a.text?a.text():null}).then(function(b){b?(-1<b.indexOf("window.ue_adb_chk = 1")&&(a.ue_adb_chk=1),n()):h()})["catch"](h);else e.uels(m,{onerror:h,onload:n})}function h(){b=k;l();if(f)try{d.setItem(g,b)}catch(a){}}function n(){b=1===a.ue_adb_chk?p:k;l();if(f)try{d.setItem(g,
b)}catch(c){}}function q(){a.ue_adb_rtla&&c&&0<c.ec&&!1===r&&(c.elh=null,ueLogError({m:"Hit Info",fromOnError:1},{logLevel:"INFO",adb:b}),r=!0)}function l(){e.tag(b);e.isl&&a.uex&&uex("at",b);s&&s.updateCsmHit("adb",b);c&&0<c.ec?q():a.ue_adb_rtla&&c&&(c.elh=q)}function v(){return b}if(a.ue_adb){a.ue_fadb=a.ue_fadb||10;var e=a.ue,k="adblk_yes",p="adblk_no",m="https://m.media-amazon.com/images/G/01/csm/showads.v2.js?adtag=csm&ad_box_",b="adblk_unk",d;a:{try{d=a.localStorage;break a}catch(z){}d=void 0}var g=
"csm:adb",c=a.ue_err,s=e.cookie,f=void 0!==a.localStorage,w=Math.random()>1-1/a.ue_fadb,r=!1,x=t();w||!x?u():l();a.ue_isAdb=v;a.ue_isAdb.unk="adblk_unk";a.ue_isAdb.no=p;a.ue_isAdb.yes=k}},"adb")(document,window);




(function(c,l,m){function h(a){if(a)try{if(a.id)return"//*[@id='"+a.id+"']";var b,d=1,e;for(e=a.previousSibling;e;e=e.previousSibling)e.nodeName===a.nodeName&&(d+=1);b=d;var c=a.nodeName;1!==b&&(c+="["+b+"]");a.parentNode&&(c=h(a.parentNode)+"/"+c);return c}catch(f){return"DETACHED"}}function f(a){if(a&&a.getAttribute)return a.getAttribute(k)?a.getAttribute(k):f(a.parentElement)}var k="data-cel-widget",g=!1,d=[];(c.ue||{}).isBF=function(){try{var a=JSON.parse(localStorage["csm-bf"]||"[]"),b=0<=a.indexOf(c.ue_id);
a.unshift(c.ue_id);a=a.slice(0,20);localStorage["csm-bf"]=JSON.stringify(a);return b}catch(d){return!1}}();c.ue_utils={getXPath:h,getFirstAscendingWidget:function(a,b){c.ue_cel&&c.ue_fem?!0===g?b(f(a)):d.push({element:a,callback:b}):b()},notifyWidgetsLabeled:function(){if(!1===g){g=!0;for(var a=f,b=0;b<d.length;b++)if(d[b].hasOwnProperty("callback")&&d[b].hasOwnProperty("element")){var c=d[b].callback,e=d[b].element;"function"===typeof c&&"function"===typeof a&&c(a(e))}d=null}},extractStringValue:function(a){if("string"===
typeof a)return a}}})(ue_csm,window,document);


(function(a){a.ue_cel||(a.ue_cel=function(){function f(a,c){c?c.r=v:c={r:v,c:1};!ue_csm.ue_sclog&&c.clog&&d.clog?d.clog(a,c.ns||q,c):c.glog&&d.glog?d.glog(a,c.ns||q,c):d.log(a,c.ns||q,c)}function m(a,d){"function"===typeof g&&g("log",{schemaId:s+".RdCSI.1",eventType:a,clientData:d},{ent:"all"})}function c(){var a=n.length;if(0<a){for(var c=[],b=0;b<a;b++){var F=n[b].api;F.ready()?(F.on({ts:d.d,ns:q}),e.push(n[b]),f({k:"mso",n:n[b].name,t:d.d()})):c.push(n[b])}n=c}}function h(){if(!h.executed){for(var a=
0;a<e.length;a++)e[a].api.off&&e[a].api.off({ts:d.d,ns:q});A();f({k:"eod",t0:d.t0,t:d.d()},{c:1,il:1});h.executed=1;for(a=0;a<e.length;a++)n.push(e[a]);e=[];b(t);b(x)}}function A(a){f({k:"hrt",t:d.d()},{c:1,il:1,n:a});l=Math.min(w,r*l);y()}function y(){b(x);x=k(function(){A(!0)},l)}function u(){h.executed||A()}var p=a.window,k=p.setTimeout,b=p.clearTimeout,r=1.5,w=p.ue_cel_max_hrt||3E4,s="robotdetection",n=[],e=[],q=a.ue_cel_ns||"cel",t,x,d=a.ue,E=a.uet,B=a.uex,v=d.rid,C=p.csa,g,l=p.ue_cel_hrt_int||
3E3,z=p.requestAnimationFrame||function(a){a()};a.ue_cel_lclia&&C&&(g=C("Events",{producerId:s}));if(d.isBF)f({k:"bft",t:d.d()});else{"function"==typeof E&&E("bb","csmCELLSframework",{wb:1});k(c,0);d.onunload(h);if(d.onflush)d.onflush(u);t=k(h,6E5);y();"function"==typeof B&&B("ld","csmCELLSframework",{wb:1});return{registerModule:function(a,b){n.push({name:a,api:b});f({k:"mrg",n:a,t:d.d()});c()},reset:function(a){f({k:"rst",t0:d.t0,t:d.d()});n=n.concat(e);e=[];for(var r=n.length,g=0;g<r;g++)n[g].api.off(),
n[g].api.reset();v=a||d.rid;c();b(t);t=k(h,6E5);h.executed=0},timeout:function(a,d){return k(function(){z(function(){h.executed||a()})},d)},log:f,csaEventLog:m,off:h}}}())})(ue_csm);
(function(a){a.ue_pdm||!a.ue_cel||a.ue.isBF||(a.ue_pdm=function(){function f(){try{var d=b.screen;if(d){var c={w:d.width,aw:d.availWidth,h:d.height,ah:d.availHeight,cd:d.colorDepth,pd:d.pixelDepth};e&&e.w===c.w&&e.h===c.h&&e.aw===c.aw&&e.ah===c.ah&&e.pd===c.pd&&e.cd===c.cd||(e=c,e.t=s(),e.k="sci",E(e),C&&g&&l("sci",{h:(e.h||"0")+""}))}var k=r.body||{},h=r.documentElement||{},m={w:Math.max(k.scrollWidth||0,k.offsetWidth||0,h.clientWidth||0,h.scrollWidth||0,h.offsetWidth||0),h:Math.max(k.scrollHeight||
0,k.offsetHeight||0,h.clientHeight||0,h.scrollHeight||0,h.offsetHeight||0)};q&&q.w===m.w&&q.h===m.h||(q=m,q.t=s(),q.k="doi",E(q));w=a.ue_cel.timeout(f,n);x+=1}catch(p){b.ueLogError&&ueLogError(p,{attribution:"csm-cel-page-module",logLevel:"WARN"})}}function m(){u("ebl","default",!1)}function c(){u("efo","default",!0)}function h(){u("ebl","app",!1)}function A(){u("efo","app",!0)}function y(){b.setTimeout(function(){r[H]?u("ebl","pageviz",!1):u("efo","pageviz",!0)},0)}function u(a,d,c){t!==c&&(E({k:a,
t:s(),s:d},{ff:!0===c?0:1}),C&&g&&l(a,{t:(s()||"0")+"",s:d}));t=c}function p(){d.attach&&(z&&d.attach(D,y,r),I&&P.when("mash").execute(function(a){a&&a.addEventListener&&(a.addEventListener("appPause",h),a.addEventListener("appResume",A))}),d.attach("blur",m,b),d.attach("focus",c,b))}function k(){d.detach&&(z&&d.detach(D,y,r),I&&P.when("mash").execute(function(a){a&&a.removeEventListener&&(a.removeEventListener("appPause",h),a.removeEventListener("appResume",A))}),d.detach("blur",m,b),d.detach("focus",
c,b))}var b=a.window,r=a.document,w,s,n,e,q,t=null,x=0,d=a.ue,E=a.ue_cel.log,B=a.uet,v=a.uex,C=a.ue_cel_lclia,g=b.csa,l=a.ue_cel.csaEventLog,z=!!d.pageViz,D=z&&d.pageViz.event,H=z&&d.pageViz.propHid,I=b.P&&b.P.when;"function"==typeof B&&B("bb","csmCELLSpdm",{wb:1});return{on:function(a){n=a.timespan||500;s=a.ts;p();a=b.location;E({k:"pmd",o:a.origin,p:a.pathname,t:s()});f();"function"==typeof v&&v("ld","csmCELLSpdm",{wb:1})},off:function(a){clearTimeout(w);k();d.count&&d.count("cel.PDM.TotalExecutions",
x)},ready:function(){return r.body&&a.ue_cel&&a.ue_cel.log},reset:function(){e=q=null}}}(),a.ue_cel&&a.ue_cel.registerModule("page module",a.ue_pdm))})(ue_csm);
(function(a){a.ue_vpm||!a.ue_cel||a.ue.isBF||(a.ue_vpm=function(){function f(){var a=y(),b={w:k.innerWidth,h:k.innerHeight,x:k.pageXOffset,y:k.pageYOffset};c&&c.w==b.w&&c.h==b.h&&c.x==b.x&&c.y==b.y||(b.t=a,b.k="vpi",c=b,r(c,{clog:1}),q&&t&&x("vpi",{t:(c.t||"0")+"",h:(c.h||"0")+"",y:(c.y||"0")+"",w:(c.w||"0")+"",x:(c.x||"0")+""}));h=0;u=y()-a;p+=1}function m(){h||(h=a.ue_cel.timeout(f,A))}var c,h,A,y,u=0,p=0,k=a.window,b=a.ue,r=a.ue_cel.log,w=a.uet,s=a.uex,n=b.attach,e=b.detach,q=a.ue_cel_lclia,t=
k.csa,x=a.ue_cel.csaEventLog;"function"==typeof w&&w("bb","csmCELLSvpm",{wb:1});return{on:function(a){y=a.ts;A=a.timespan||100;f();n&&(n("scroll",m),n("resize",m));"function"==typeof s&&s("ld","csmCELLSvpm",{wb:1})},off:function(a){clearTimeout(h);e&&(e("scroll",m),e("resize",m));b.count&&(b.count("cel.VPI.TotalExecutions",p),b.count("cel.VPI.TotalExecutionTime",u),b.count("cel.VPI.AverageExecutionTime",u/p))},ready:function(){return a.ue_cel&&a.ue_cel.log},reset:function(){c=void 0},getVpi:function(){return c}}}(),
a.ue_cel&&a.ue_cel.registerModule("viewport module",a.ue_vpm))})(ue_csm);
(function(a){if(!a.ue_fem&&a.ue_cel&&a.ue_utils){var f=a.ue||{},m=a.window,c=m.document;!f.isBF&&!a.ue_fem&&c.querySelector&&m.getComputedStyle&&[].forEach&&(a.ue_fem=function(){function h(a,d){return a>d?3>a-d:3>d-a}function A(a,d){var c=m.pageXOffset,b=m.pageYOffset,k;a:{try{if(a){var g=a.getBoundingClientRect(),e,r=0===a.offsetWidth&&0===a.offsetHeight;c:{for(var f=a.parentNode,w=g.left||0,n=g.top||0,p=g.width||0,q=g.height||0;f&&f!==document.body;){var l;d:{try{var s=void 0;if(f)var G=f.getBoundingClientRect(),
s={x:G.left||0,y:G.top||0,w:G.width||0,h:G.height||0};else s=void 0;l=s;break d}catch(v){}l=void 0}var t=window.getComputedStyle(f),u="hidden"===t.overflow,y=u||"hidden"===t.overflowX,z=u||"hidden"===t.overflowY,J=n+q-1<l.y+1||n+1>l.y+l.h-1;if((w+p-1<l.x+1||w+1>l.x+l.w-1)&&y||J&&z){e=!0;break c}f=f.parentNode}e=!1}k={x:g.left+c||0,y:g.top+b||0,w:g.width||0,h:g.height||0,d:(r||e)|0}}else k=void 0;break a}catch(A){}k=void 0}if(k&&!a.cel_b)a.cel_b=k,C({n:a.getAttribute(x),w:a.cel_b.w,h:a.cel_b.h,d:a.cel_b.d,
x:a.cel_b.x,y:a.cel_b.y,t:d,k:"ewi",cl:a.className},{clog:1});else{if(c=k)c=a.cel_b,b=k,c=b.d===c.d&&1===b.d?!1:!(h(c.x,b.x)&&h(c.y,b.y)&&h(c.w,b.w)&&h(c.h,b.h)&&c.d===b.d);c&&(a.cel_b=k,C({n:a.getAttribute(x),w:a.cel_b.w,h:a.cel_b.h,d:a.cel_b.d,x:a.cel_b.x,y:a.cel_b.y,t:d,k:"ewi"},{clog:1}))}}function y(b,g){var h;h=b.c?c.getElementsByClassName(b.c):b.id?[c.getElementById(b.id)]:c.querySelectorAll(b.s);b.w=[];for(var f=0;f<h.length;f++){var e=h[f];if(e){if(!e.getAttribute(x)){var r=e.getAttribute("cel_widget_id")||
(b.id_gen||v)(e,f)||e.id;e.setAttribute(x,r)}b.w.push(e);k(Q,e,g)}}!1===B&&(E++,E===d.length&&(B=!0,a.ue_utils.notifyWidgetsLabeled()))}function u(a,c){g.contains(a)||C({n:a.getAttribute(x),t:c,k:"ewd"},{clog:1})}function p(a){K.length&&ue_cel.timeout(function(){if(q){for(var c=R(),d=!1;R()-c<e&&!d;){for(d=S;0<d--&&0<K.length;){var b=K.shift();T[b.type](b.elem,b.time)}d=0===K.length}U++;p(a)}},0)}function k(a,c,d){K.push({type:a,elem:c,time:d})}function b(a,c){for(var b=0;b<d.length;b++)for(var e=
d[b].w||[],g=0;g<e.length;g++)k(a,e[g],c)}function r(){M||(M=a.ue_cel.timeout(function(){M=null;var c=t();b(W,c);for(var g=0;g<d.length;g++)k(X,d[g],c);0===d.length&&!1===B&&(B=!0,a.ue_utils.notifyWidgetsLabeled());p(c)},n))}function w(){M||N||(N=a.ue_cel.timeout(function(){N=null;var a=t();b(Q,a);p(a)},n))}function s(){return z&&D&&g&&g.contains&&g.getBoundingClientRect&&t}var n=50,e=4.5,q=!1,t,x="data-cel-widget",d=[],E=0,B=!1,v=function(){},C=a.ue_cel.log,g,l,z,D,H=m.MutationObserver||m.WebKitMutationObserver||
m.MozMutationObserver,I=!!H,F,G,O="DOMAttrModified",L="DOMNodeInserted",J="DOMNodeRemoved",N,M,K=[],U=0,S=null,W="removedWidget",X="updateWidgets",Q="processWidget",T,V=m.performance||{},R=V.now&&function(){return V.now()}||function(){return Date.now()};"function"==typeof uet&&uet("bb","csmCELLSfem",{wb:1});return{on:function(b){function e(){if(s()){T={removedWidget:u,updateWidgets:y,processWidget:A};if(I){var a={attributes:!0,subtree:!0};F=new H(w);G=new H(r);F.observe(g,a);G.observe(g,{childList:!0,
subtree:!0});G.observe(l,a)}else z.call(g,O,w),z.call(g,L,r),z.call(g,J,r),z.call(l,L,w),z.call(l,J,w);r()}}g=c.body;l=c.head;z=g.addEventListener;D=g.removeEventListener;t=b.ts;d=a.cel_widgets||[];S=b.bs||5;f.deffered?e():f.attach&&f.attach("load",e);"function"==typeof uex&&uex("ld","csmCELLSfem",{wb:1});q=!0},off:function(){s()&&(G&&(G.disconnect(),G=null),F&&(F.disconnect(),F=null),D.call(g,O,w),D.call(g,L,r),D.call(g,J,r),D.call(l,L,w),D.call(l,J,w));f.count&&f.count("cel.widgets.batchesProcessed",
U);q=!1},ready:function(){return a.ue_cel&&a.ue_cel.log},reset:function(){d=a.cel_widgets||[]}}}(),a.ue_cel&&a.ue_fem&&a.ue_cel.registerModule("features module",a.ue_fem))}})(ue_csm);
(function(a){!a.ue_mcm&&a.ue_cel&&a.ue_utils&&!a.ue.isBF&&(a.ue_mcm=function(){function f(a,b){var h=a.srcElement||a.target||{},f={k:m,w:(b||{}).ow||(A.body||{}).scrollWidth,h:(b||{}).oh||(A.body||{}).scrollHeight,t:(b||{}).ots||c(),x:a.pageX,y:a.pageY,p:p.getXPath(h),n:h.nodeName};y&&"function"===typeof y.now&&a.timeStamp&&(f.dt=(b||{}).odt||y.now()-a.timeStamp,f.dt=parseFloat(f.dt.toFixed(2)));a.button&&(f.b=a.button);h.href&&(f.r=p.extractStringValue(h.href));h.id&&(f.i=h.id);h.className&&h.className.split&&
(f.c=h.className.split(/\s+/));u(f,{c:1})}var m="mcm",c,h=a.window,A=h.document,y=h.performance,u=a.ue_cel.log,p=a.ue_utils;return{on:function(k){c=k.ts;a.ue_cel_stub&&a.ue_cel_stub.replayModule(m,f);h.addEventListener&&h.addEventListener("mousedown",f,!0)},off:function(a){h.addEventListener&&h.removeEventListener("mousedown",f,!0)},ready:function(){return a.ue_cel&&a.ue_cel.log},reset:function(){}}}(),a.ue_cel&&a.ue_cel.registerModule("mouse click module",a.ue_mcm))})(ue_csm);
(function(a){a.ue_mmm||!a.ue_cel||a.ue.isBF||(a.ue_mmm=function(f){function m(a,c){var b={x:a.pageX||a.x||0,y:a.pageY||a.y||0,t:p()};!c&&l&&(b.t-l.t<A||b.x==l.x&&b.y==l.y)||(l=b,v.push(b))}function c(){if(v.length){E=F.now();for(var a=0;a<v.length;a++){var c=v[a],b=a;z=v[g];D=c;var e=void 0;if(!(e=2>b)){e=void 0;a:if(v[b].t-v[b-1].t>h)e=0;else{for(e=g+1;e<b;e++){var f=z,k=D,l=v[e];H=(k.x-f.x)*(f.y-l.y)-(f.x-l.x)*(k.y-f.y);if(H*H/((k.x-f.x)*(k.x-f.x)+(k.y-f.y)*(k.y-f.y))>y){e=0;break a}}e=1}e=!e}(I=
e)?g=b-1:C.pop();C.push(c)}B=F.now()-E;q=Math.min(q,B);t=Math.max(t,B);x=(x*d+B)/(d+1);d+=1;n({k:u,e:C,min:Math.floor(1E3*q),max:Math.floor(1E3*t),avg:Math.floor(1E3*x)},{c:1});v=[];C=[];g=0}}var h=100,A=20,y=25,u="mmm1",p,k,b=a.window,r=b.document,w=b.setInterval,s=a.ue,n=a.ue_cel.log,e,q=1E3,t=0,x=0,d=0,E,B,v=[],C=[],g=0,l,z,D,H,I,F=f&&f.now&&f||Date.now&&Date||{now:function(){return(new Date).getTime()}};return{on:function(a){p=a.ts;k=a.ns;s.attach&&s.attach("mousemove",m,r);e=w(c,3E3)},off:function(a){k&&
(l&&m(l,!0),c());clearInterval(e);s.detach&&s.detach("mousemove",m,r)},ready:function(){return a.ue_cel&&a.ue_cel.log},reset:function(){v=[];C=[];g=0;l=null}}}(window.performance),a.ue_cel&&a.ue_cel.registerModule("mouse move module",a.ue_mmm))})(ue_csm);




ue_csm.ue_unrt = 1500;
(function(d,b,t){function u(a,g){var c=a.srcElement||a.target||{},b={k:v,t:g.t,dt:g.dt,x:a.pageX,y:a.pageY,p:e.getXPath(c),n:c.nodeName};a.button&&(b.b=a.button);c.type&&(b.ty=c.type);c.href&&(b.r=e.extractStringValue(c.href));c.id&&(b.i=c.id);c.className&&c.className.split&&(b.c=c.className.split(/\s+/));h+=1;e.getFirstAscendingWidget(c,function(a){b.wd=a;d.ue.log(b,r)})}function w(a){if(!x(a.srcElement||a.target)){m+=1;n=!0;var g=f=d.ue.d(),c;p&&"function"===typeof p.now&&a.timeStamp&&(c=p.now()-
a.timeStamp,c=parseFloat(c.toFixed(2)));s=b.setTimeout(function(){u(a,{t:g,dt:c})},y)}}function z(a){if(a){var b=a.filter(A);a.length!==b.length&&(q=!0,k=d.ue.d(),n&&q&&(k&&f&&d.ue.log({k:B,t:f,m:Math.abs(k-f)},r),l(),q=!1,k=0))}}function A(a){if(!a)return!1;var b="characterData"===a.type?a.target.parentElement:a.target;if(!b||!b.hasAttributes||!b.attributes)return!1;var c={"class":"gw-clock gw-clock-aria s-item-container-height-auto feed-carousel using-mouse kfs-inner-container".split(" "),id:["dealClock",
"deal_expiry_timer","timer"],role:["timer"]},d=!1;Object.keys(c).forEach(function(a){var e=b.attributes[a]?b.attributes[a].value:"";(c[a]||"").forEach(function(a){-1!==e.indexOf(a)&&(d=!0)})});return d}function x(a){if(!a)return!1;var b=(e.extractStringValue(a.nodeName)||"").toLowerCase(),c=(e.extractStringValue(a.type)||"").toLowerCase(),d=(e.extractStringValue(a.href)||"").toLowerCase();a=(e.extractStringValue(a.id)||"").toLowerCase();var f="checkbox color date datetime-local email file month number password radio range reset search tel text time url week".split(" ");
if(-1!==["select","textarea","html"].indexOf(b)||"input"===b&&-1!==f.indexOf(c)||"a"===b&&-1!==d.indexOf("http")||-1!==["sitbreaderrightpageturner","sitbreaderleftpageturner","sitbreaderpagecontainer"].indexOf(a))return!0}function l(){n=!1;f=0;b.clearTimeout(s)}function C(){b.ue.onunload(function(){ue.count("armored-cxguardrails.unresponsive-clicks.violations",h);ue.count("armored-cxguardrails.unresponsive-clicks.violationRate",h/m*100||0)})}if(b.MutationObserver&&b.addEventListener&&Object.keys&&
d&&d.ue&&d.ue.log&&d.ue_unrt&&d.ue_utils){var y=d.ue_unrt,r="cel",v="unr_mcm",B="res_mcm",p=b.performance,e=d.ue_utils,n=!1,f=0,s=0,q=!1,k=0,h=0,m=0;b.addEventListener&&(b.addEventListener("mousedown",w,!0),b.addEventListener("beforeunload",l,!0),b.addEventListener("visibilitychange",l,!0),b.addEventListener("pagehide",l,!0));b.ue&&b.ue.event&&b.ue.onSushiUnload&&b.ue.onunload&&C();(new MutationObserver(z)).observe(t,{childList:!0,attributes:!0,characterData:!0,subtree:!0})}})(ue_csm,window,document);


ue_csm.ue.exec(function(g,e){if(e.ue_err){var f="";e.ue_err.errorHandlers||(e.ue_err.errorHandlers=[]);e.ue_err.errorHandlers.push({name:"fctx",handler:function(a){if(!a.logLevel||"FATAL"===a.logLevel)if(f=g.getElementsByTagName("html")[0].innerHTML){var b=f.indexOf("var ue_t0=ue_t0||+new Date();");if(-1!==b){var b=f.substr(0,b).split(String.fromCharCode(10)),d=Math.max(b.length-10-1,0),b=b.slice(d,b.length-1);a.fcsmln=d+b.length+1;a.cinfo=a.cinfo||{};for(var c=0;c<b.length;c++)a.cinfo[d+c+1+""]=
b[c]}b=f.split(String.fromCharCode(10));a.cinfo=a.cinfo||{};if(!(a.f||void 0===a.l||a.l in a.cinfo))for(c=+a.l-1,d=Math.max(c-5,0),c=Math.min(c+5,b.length-1);d<=c;d++)a.cinfo[d+1+""]=b[d]}}})}},"fatals-context")(document,window);


(function(m,a){function c(k){function f(b){b&&"string"===typeof b&&(b=(b=b.match(/^(?:https?:)?\/\/(.*?)(\/|$)/i))&&1<b.length?b[1]:null,b&&b&&("number"===typeof e[b]?e[b]++:e[b]=1))}function d(b){var e=10,d=+new Date;b&&b.timeRemaining?e=b.timeRemaining():b={timeRemaining:function(){return Math.max(0,e-(+new Date-d))}};for(var c=a.performance.getEntries(),k=e;g<c.length&&k>n;)c[g].name&&f(c[g].name),g++,k=b.timeRemaining();g>=c.length?h(!0):l()}function h(b){if(!b){b=m.scripts;var c;if(b)for(var d=
0;d<b.length;d++)(c=b[d].getAttribute("src"))&&"undefined"!==c&&f(c)}0<Object.keys(e).length&&(p&&ue_csm.ue&&ue_csm.ue.event&&ue_csm.ue.event({domains:e,pageType:a.ue_pty||null,subPageType:a.ue_spty||null,pageTypeId:a.ue_pti||null},"csm","csm.CrossOriginDomains.2"),a.ue_ext=e)}function l(){!0===k?d():a.requestIdleCallback?a.requestIdleCallback(d):a.requestAnimationFrame?a.requestAnimationFrame(d):a.setTimeout(d,100)}function c(){if(a.performance&&a.performance.getEntries){var b=a.performance.getEntries();
!b||0>=b.length?h(!1):l()}else h(!1)}var e=a.ue_ext||{};a.ue_ext||c();return e}function q(){setTimeout(c,r)}var s=a.ue_dserr||!1,p=!0,n=1,r=2E3,g=0;a.ue_err&&s&&(a.ue_err.errorHandlers||(a.ue_err.errorHandlers=[]),a.ue_err.errorHandlers.push({name:"ext",handler:function(a){if(!a.logLevel||"FATAL"===a.logLevel){var f=c(!0),d=[],h;for(h in f){var f=h,g=f.match(/amazon(\.com?)?\.\w{2,3}$/i);g&&1<g.length||-1!==f.indexOf("amazon-adsystem.com")||-1!==f.indexOf("amazonpay.com")||-1!==f.indexOf("cloudfront-labs.amazonaws.com")||
d.push(h)}a.ext=d}}}));a.ue&&a.ue.isl?c():a.ue&&ue.attach&&ue.attach("load",q)})(document,window);





var ue_wtc_c = 3;
ue_csm.ue.exec(function(b,e){function l(){for(var a=0;a<f.length;a++)a:for(var d=s.replace(A,f[a])+g[f[a]]+t,c=arguments,b=0;b<c.length;b++)try{c[b].send(d);break a}catch(e){}g={};f=[];n=0;k=p}function u(){B?l(q):l(C,q)}function v(a,m,c){r++;if(r>w)d.count&&1==r-w&&(d.count("WeblabTriggerThresholdReached",1),b.ue_int&&console.error("Number of max call reached. Data will no longer be send"));else{var h=c||{};h&&-1<h.constructor.toString().indexOf(D)&&a&&-1<a.constructor.toString().indexOf(x)&&m&&-1<
m.constructor.toString().indexOf(x)?(h=b.ue_id,c&&c.rid&&(h=c.rid),c=h,a=encodeURIComponent(",wl="+a+"/"+m),2E3>a.length+p?(2E3<k+a.length&&u(),void 0===g[c]&&(g[c]="",f.push(c)),g[c]+=a,k+=a.length,n||(n=e.setTimeout(u,E))):b.ue_int&&console.error("Invalid API call. The input provided is over 2000 chars.")):d.count&&(d.count("WeblabTriggerImproperAPICall",1),b.ue_int&&console.error("Invalid API call. The input provided does not match the API protocol i.e ue.trigger(String, String, Object)."))}}function F(){d.trigger&&
d.trigger.isStub&&d.trigger.replay(function(a){v.apply(this,a)})}function y(){z||(f.length&&l(q),z=!0)}var t=":1234",s="//"+b.ue_furl+"/1/remote-weblab-triggers/1/OE/"+b.ue_mid+":"+b.ue_sid+":PLCHLDR_RID$s:wl-client-id%3DCSMTriger",A="PLCHLDR_RID",E=b.wtt||1E4,p=s.length+t.length,w=b.mwtc||2E3,G=1===e.ue_wtc_c,B=3===e.ue_wtc_c,H=e.XMLHttpRequest&&"withCredentials"in new e.XMLHttpRequest,x="String",D="Object",d=b.ue,g={},f=[],k=p,n,z=!1,r=0,C=function(){return{send:function(a){if(H){var b=new e.XMLHttpRequest;
b.open("GET",a,!0);G&&(b.withCredentials=!0);b.send()}else throw"";}}}(),q=function(){return{send:function(a){(new Image).src=a}}}();e.encodeURIComponent&&(d.attach&&(d.attach("beforeunload",y),d.attach("pagehide",y)),F(),d.trigger=v)},"client-wbl-trg")(ue_csm,window);


(function(k,d,h){function f(a,c,b){a&&a.indexOf&&0===a.indexOf("http")&&0!==a.indexOf("https")&&l(s,c,a,b)}function g(a,c,b){a&&a.indexOf&&(location.href.split("#")[0]!=a&&null!==a&&"undefined"!==typeof a||l(t,c,a,b))}function l(a,c,b,e){m[b]||(e=u&&e?n(e):"N/A",d.ueLogError&&d.ueLogError({message:a+c+" : "+b,logLevel:v,stack:"N/A"},{attribution:e}),m[b]=1,p++)}function e(a,c){if(a&&c)for(var b=0;b<a.length;b++)try{c(a[b])}catch(d){}}function q(){return d.performance&&d.performance.getEntriesByType?
d.performance.getEntriesByType("resource"):[]}function n(a){if(a.id)return"//*[@id='"+a.id+"']";var c;c=1;var b;for(b=a.previousSibling;b;b=b.previousSibling)b.nodeName==a.nodeName&&(c+=1);b=a.nodeName;1!=c&&(b+="["+c+"]");a.parentNode&&(b=n(a.parentNode)+"/"+b);return b}function w(){var a=h.images;a&&a.length&&e(a,function(a){var b=a.getAttribute("src");f(b,"img",a);g(b,"img",a)})}function x(){var a=h.scripts;a&&a.length&&e(a,function(a){var b=a.getAttribute("src");f(b,"script",a);g(b,"script",a)})}
function y(){var a=h.styleSheets;a&&a.length&&e(a,function(a){if(a=a.ownerNode){var b=a.getAttribute("href");f(b,"style",a);g(b,"style",a)}})}function z(){if(A){var a=q();e(a,function(a){f(a.name,a.initiatorType)})}}function B(){e(q(),function(a){g(a.name,a.initiatorType)})}function r(){var a;a=d.location&&d.location.protocol?d.location.protocol:void 0;"https:"==a&&(z(),w(),x(),y(),B(),p<C&&setTimeout(r,D))}var s="[CSM] Insecure content detected ",t="[CSM] Ajax request to same page detected ",v="WARN",
m={},p=0,D=k.ue_nsip||1E3,C=5,A=1==k.ue_urt,u=!0;ue_csm.ue_disableNonSecure||(d.performance&&d.performance.setResourceTimingBufferSize&&d.performance.setResourceTimingBufferSize(300),r())})(ue_csm,window,document);


var ue_aa_a = "";
if (ue.trigger && (ue_aa_a === "C" || ue_aa_a === "T1")) {
    ue.trigger("UEDATA_AA_SERVERSIDE_ASSIGNMENT_CLIENTSIDE_TRIGGER_190249", ue_aa_a);
}
(function(f,b){function g(){try{b.PerformanceObserver&&"function"===typeof b.PerformanceObserver&&(a=new b.PerformanceObserver(function(b){c(b.getEntries())}),a.observe(d))}catch(h){k()}}function m(){for(var h=d.entryTypes,a=0;a<h.length;a++)c(b.performance.getEntriesByType(h[a]))}function c(a){if(a&&Array.isArray(a)){for(var c=0,e=0;e<a.length;e++){var d=l.indexOf(a[e].name);if(-1!==d){var g=Math.round(b.performance.timing.navigationStart+a[e].startTime);f.uet(n[d],void 0,void 0,g);c++}}l.length===
c&&k()}}function k(){a&&a.disconnect&&"function"===typeof a.disconnect&&a.disconnect()}if("function"===typeof f.uet&&b.performance&&"object"===typeof b.performance&&b.performance.getEntriesByType&&"function"===typeof b.performance.getEntriesByType&&b.performance.timing&&"object"===typeof b.performance.timing&&"number"===typeof b.performance.timing.navigationStart){var d={entryTypes:["paint"]},l=["first-paint","first-contentful-paint"],n=["fp","fcp"],a;try{m(),g()}catch(p){f.ueLogError(p,{logLevel:"ERROR",
attribution:"performanceMetrics"})}}})(ue_csm,window);


if (window.csa) {
    csa("Events")("setEntity", {
        page:{pageType: "name", subPageType: "main", pageTypeId: ""}
    });
}
csa.plugin(function(e){var i="transitionStart",t="pageVisible",n="PageTiming",a=e("Events",{producerId:"csa"}),o=(e.global.performance||{}).timing,r=["navigationStart","unloadEventStart","unloadEventEnd","redirectStart","redirectEnd","fetchStart","domainLookupStart","domainLookupEnd","connectStart","connectEnd","secureConnectionStart","requestStart","responseStart","responseEnd","domLoading","domInteractive","domContentLoadedEventStart","domContentLoadedEventEnd","domComplete","loadEventStart","loadEventEnd"],d=e.config,c=e.global.document||{},l=(o||{}).navigationStart,u=l,s={},g=0,m=0,f=d[n+".BatchInterval"]||3e3,v=0,p=!0,S=e.blank;if(!d["KillSwitch."+n]){if(!o||null===l||l<=0||void 0===l)return e.error("Invalid navigation timing data: "+l);"boolean"!=typeof c.hidden&&"string"!=typeof c.visibilityState||((p=k())?(E(t,l),b()):S=e.on(c,"visibilitychange",function(){(p=k())&&(u=e.time(),S(),E(t,u),E(i,u),b())})),e.once("$unload",h),e.once("$load",h),e.on("$beforePageTransition",y),e.on("$pageTransition",function(){u=e.time()}),e.register(n,{mark:E})}function E(t,n){null!=t&&(n=n||e.time(),t===i&&(u=n),s[t]=n,b(),e.emit("$timing:"+t,n))}function h(){!function(){if(v)return;for(var t=0;t<r.length;t++)o[r[t]]&&E(r[t],o[r[t]]);v=1}(),g=1,b(!0)}function b(t){g&&p&&!m&&(m=e.timeout(y,t?0:f))}function y(){0<Object.keys(s).length&&(a("log",{markers:function(t,n){var e={};for(var i in t)t.hasOwnProperty(i)&&(e[i]=Math.max(0,t[i]-n));return e}(s,u),markerTimestamps:function(t){for(var n in t)t.hasOwnProperty(n)&&(t[n]=Math.floor(t[n]));return t}(s),navigationStartTimestamp:u?new Date(u).toISOString():null,schemaId:"<ns>.PageLatency.5"},{ent:{page:["pageType","subPageType","requestId"]}}),s={}),m=0}function k(){return!c.hidden||"visible"===c.visibilityState}});csa.plugin(function(e){var m=!!e.config["LCP.elementDedup"],t=!1,n=e("PageTiming"),r=e.global.PerformanceObserver,a=e.global.performance;function i(){return a.timing.navigationStart}function o(){t||function(o){var l=new r(function(e){var t=e.getEntries();if(0!==t.length){var n=t[t.length-1];if(m&&""!==n.id&&n.element&&"IMG"===n.element.tagName){for(var r={},a=t[0],i=0;i<t.length;i++)t[i].id in r||(""!==t[i].id&&(r[t[i].id]=!0),a.startTime<t[i].startTime&&(a=t[i]));n=a}l.disconnect(),o({startTime:n.startTime,renderTime:n.renderTime,loadTime:n.loadTime})}});try{l.observe({type:"largest-contentful-paint",buffered:!0})}catch(e){}}(function(e){e&&(t=!0,n("mark","largestContentfulPaint",Math.floor(e.startTime+i())),e.renderTime&&n("mark","largestContentfulPaint.render",Math.floor(e.renderTime+i())),e.loadTime&&n("mark","largestContentfulPaint.load",Math.floor(e.loadTime+i())))})}r&&a&&a.timing&&(e.once("$unload",o),e.once("$load",o),e.register("LargestContentfulPaint",{}))});csa.plugin(function(r){var e=r("Metrics",{producerId:"csa"}),n=r.global.PerformanceObserver;n&&(n=new n(function(r){var t=r.getEntries();if(0===t.length||!t[0].processingStart||!t[0].startTime)return;!function(r){r=r||0,n.disconnect(),0<=r?e("recordMetric","firstInputDelay",r):e("recordMetric","firstInputDelay.invalid",1)}(t[0].processingStart-t[0].startTime)}),function(){try{n.observe({type:"first-input",buffered:!0})}catch(r){}}())});csa.plugin(function(d){var e="Metrics",r=d.config,u=r[e+".BatchInterval"]||3e3;function n(e){var r=e.producerId,n=e.logger,t=n||d("Events",{producerId:r}),i={},o=(e||{}).dimensions||{},c=0;if(!r&&!n)return d.error("Either a producer id or custom logger must be defined");function s(){Object.keys(i).length&&(t("log",{schemaId:e.schemaId||"<ns>.Metric.3",metrics:i,dimensions:o},e.logOptions||{ent:{page:["pageType","subPageType","requestId"]}}),i={}),c=0}this.recordMetric=function(e,r){i[e]=r,c=c||d.timeout(s,u)},d.on("$beforeunload",s),d.on("$beforePageTransition",s)}r["KillSwitch."+e]||(new n({producerId:"csa"}).recordMetric("baselineMetricEvent",1),d.register(e,{instance:function(e){return new n(e||{})}}))});csa.plugin(function(c){var e="Timers",r=(c.global.performance||{}).timing,u=(r||{}).navigationStart||c.time(),s=c.config[e+".BatchInterval"]||3e3;function n(e){var r=(e=e||{}).producerId,n=e.logger,o={},t=0,i=n||c("Events",{producerId:r});if(!r&&!n)return c.error("Either a producer id or custom logger must be defined");function a(){0<Object.keys(o).length&&(i("log",{markers:o,schemaId:e.schemaId||"<ns>.Timer.1"},e.logOptions),o={}),clearTimeout(t),t=0}this.mark=function(e,r){o[e]=(void 0===r?c.time():r)-u,t=t||c.timeout(a,s)},c.once("$beforeunload",a),c.once("$beforePageTransition",a)}r&&c.register(e,{instance:function(e){return new n(e||{})}})});csa.plugin(function(t){var e="takeRecords",i="disconnect",n="function",o=t("Metrics",{producerId:"csa"}),c=t("PageTiming"),a=t.global,u=t.timeout,r=t.on,f=a.PerformanceObserver,m=0,l=!1,s=0,d=a.performance,h=a.document,v=null,y=!1,g=t.blank;function p(){l||(l=!0,clearTimeout(v),typeof f[e]===n&&f[e](),typeof f[i]===n&&f[i](),o("recordMetric","documentCumulativeLayoutShift",m),c("mark","cumulativeLayoutShiftLastTimestamp",Math.floor(s+d.timing.navigationStart)))}f&&d&&d.timing&&h&&(f=new f(function(t){v&&clearTimeout(v);t.getEntries().forEach(function(t){t.hadRecentInput||(m+=t.value,s<t.startTime&&(s=t.startTime))}),v=u(p,5e3)}),function(){try{f.observe({type:"layout-shift",buffered:!0}),v=u(p,5e3)}catch(t){}}(),g=r(h,"click",function(t){y||(y=!0,o("recordMetric","documentCumulativeLayoutShiftToFirstInput",m),g())}),r(h,"visibilitychange",function(){"hidden"===h.visibilityState&&p()}),t.once("$unload",p))});csa.plugin(function(e){var t,n=e.global,r=n.PerformanceObserver,c=e("Metrics",{producerId:"csa"}),o=0,i=0,a=-1,l=n.Math,f=l.max,u=l.ceil;if(r){t=new r(function(e){e.getEntries().forEach(function(e){var t=e.duration;o+=t,i+=t,a=f(t,a)})});try{t.observe({type:"longtask",buffered:!0})}catch(e){}t=new r(function(e){0<e.getEntries().length&&(i=0,a=-1)});try{t.observe({type:"largest-contentful-paint",buffered:!0})}catch(e){}e.on("$unload",g),e.on("$beforePageTransition",g)}function g(){c("recordMetric","totalBlockingTime",u(i||0)),c("recordMetric","totalBlockingTimeInclLCP",u(o||0)),c("recordMetric","maxBlockingTime",u(a||0)),i=o=0,a=-1}});csa.plugin(function(r){var e="CacheDetection",o="csa-ctoken-",n=r.store,t=r.deleteStored,c=r.config,a=c[e+".RequestID"],i=c[e+".Callback"],s=r.global,u=s.document||{},d=s.Date,f=r("Events"),l=r("Events",{producerId:"csa"});function p(e){try{var n=u.cookie.match(RegExp("(^| )"+e+"=([^;]+)"));return n&&n[2].trim()}catch(e){}}!function(){var e=function(){var e=p("cdn-rid");if(e)return{r:e,s:"cdn"}}()||function(){if(r.store(o+a))return{r:r.UUID().toUpperCase().replace(/-/g,"").slice(0,20),s:"device"}}()||{},n=e.r,c=e.s;if(!!n){var t=p("session-id");!function(e,n,c,t){f("setEntity",{page:{pageSource:"cache",requestId:e,cacheRequestId:a,cacheSource:t},session:{id:c}})}(n,0,t,c),"device"===c&&l("log",{schemaId:"<ns>.CacheImpression.1"},{ent:"all"}),i&&i(n,t,c)}}(),n(o+a,d.now()+36e5),r.once("$load",function(){var c=d.now();t(function(e,n){return 0==e.indexOf(o)&&parseInt(n)<c})})});csa.plugin(function(u){var i,t="Content",e="MutationObserver",n="addedNodes",a="querySelectorAll",s="matches",r="getAttributeNames",o="getAttribute",f="dataset",c="widget",l="producerId",d={ent:{element:1,page:["pageType","subPageType","requestId"]}},h=5,g=u.config[t+".BubbleUp.SearchDepth"]||20,m="csaC",p=m+"Id",y={},v=u.config,b=v[t+".Selectors"]||[],E=v[t+".WhitelistedAttributes"]||{href:1,class:1},I=v[t+".EnableContentEntities"],w=u.global,C=w.document||{},A=C.documentElement,U=w.HTMLElement,k={},L=[],N=function(t,e,n,i){var r=this,o=u("Events",{producerId:t||"csa"});e.type=e.type||c,r.id=e.id,r.l=o,r.e=e,r.el=n,r.rt=i,r.dlo=d,r.log=function(t,e){o("log",t,e||d)},e.id&&o("setEntity",{element:e})},O=N.prototype;function D(t){var e=(t=t||{}).element,n=t.target;return e?function(t,e){var n;n=t instanceof U?B(t)||$(e[l],t,H,u.time()):k[t.id]||_(e[l],0,t,u.time());return n}(e,t):n?S(n):u.error("No element or target argument provided.")}function S(t){var e=function(t){var e=null,n=0;for(;t&&n<g;){if(n++,T(t,p)){e=t;break}t=t.parentElement}return e}(t);return e?B(e):new N("csa",{id:null},null,u.time())}function T(t,e){if(t&&t.dataset)return t.dataset[e]}function j(t,e,n){L.push({n:n,e:t,t:e}),x()}function q(){for(var t=u.time(),e=0;0<L.length;){var n=L.shift();if(y[n.n](n.e,n.t),++e%10==0&&u.time()-t>h)break}i=0,L.length&&x()}function x(){i=i||u.raf(q)}function M(t,e,n){return{n:t,e:e,t:n}}function $(t,e,n,i){var r=u.UUID(),o={id:r},c=S(e);return e[f][p]=r,n(o,e),c.id&&(o.parentId=c.id),_(t,e,o,i)}function _(t,e,n,i){I&&(n.schemaId="<ns>.ContentEntity.2"),n.id=n.id||u.UUID();var r=new N(t,n,e,i);return I&&r.log({schemaId:"<ns>.ContentRender.1",timestamp:i}),u.emit("$content.register",r),k[n.id]=r}function B(t){return k[(t[f]||{})[p]]}function H(t,e){r in e&&(function(n,i){Object.keys(n[f]).forEach(function(t){if(!t.indexOf(m)&&m.length<t.length){var e=function(t){return(t[0]||"").toLowerCase()+t.slice(1)}(t.slice(m.length));i[e]=n[f][t]}})}(e,t),function(e,n){(e[r]()||[]).forEach(function(t){t in E&&(n[t]=e[o](t))})}(e,t))}A&&C[a]&&w[e]&&(b.push({selector:"*[data-csa-c-type]",entity:H}),b.push({selector:".celwidget",entity:function(t,e){H(t,e),t.slotId=t.slotId||e[o]("cel_widget_id")||e.id,t.type=t.type||c}}),y[1]=function(t,e){t.forEach(function(t){t[n]&&t[n].constructor&&"NodeList"===t[n].constructor.name&&Array.prototype.forEach.call(t[n],function(t){L.unshift(M(2,t,e))})})},y[2]=function(o,c){a in o&&s in o&&b.forEach(function(t){for(var e=t.selector,n=o[s](e),i=o[a](e),r=i.length-1;0<=r;r--)L.unshift(M(3,{e:i[r],s:t},c));n&&L.unshift(M(3,{e:o,s:t},c))})},y[3]=function(t,e){var n=t.e;B(n)||$("csa",n,t.s.entity,e)},y[4]=function(){u.register(t,{instance:D})},new w[e](function(t){j(t,u.time(),1)}).observe(A,{childList:!0,subtree:!0}),j(A,u.time(),2),j(null,u.time(),4),u.on("$content.export",function(e){Object.keys(e).forEach(function(t){O[t]=e[t]})}))});csa.plugin(function(n){var i,t="ContentImpressions",e="KillSwitch.",o="IntersectionObserver",r="getAttribute",s="dataset",c="intersectionRatio",a="csaCId",m=1e3,l=n.global,f=n.config,u=f[e+t],g=f[e+t+".ContentViews"],v=((l.performance||{}).timing||{}).navigationStart||n.time(),d={};function h(t){t&&(t.v=1,function(t){t.vt=n.time(),t.el.log({schemaId:"<ns>.ContentView.3",timeToViewed:t.vt-t.el.rt,pageFirstPaintToElementViewed:t.vt-v})}(t))}function I(t){t&&!t.it&&(t.i=n.time()-t.is>m,function(t){t.it=n.time(),t.el.log({schemaId:"<ns>.ContentImpressed.2",timeToImpressed:t.it-t.el.rt,pageFirstPaintToElementImpressed:t.it-v})}(t))}!u&&l[o]&&(i=new l[o](function(t){t.forEach(function(t){var e=function(t){if(t&&t[r])return d[t[s][a]]}(t.target);if(e){var i=t.intersectionRect;t.isIntersecting&&0<i.width&&0<i.height&&(g||e.v||h(e),.5<=t[c]&&!e.is&&(e.is=n.time(),e.timer=n.timeout(function(){I(e)},m))),t[c]<.5&&!e.it&&e.timer&&(l.clearTimeout(e.timer),e.is=0,e.timer=0)}})},{threshold:[0,.5]}),n.on("$content.register",function(t){var e=t.el;e&&(d[t.id]={el:t,v:0,i:0,is:0,vt:0,it:0},i.observe(e))}))});csa.plugin(function(e){e.config["KillSwitch.ContentLatency"]||e.emit("$content.export",{mark:function(t,n){var o=this;o.t||(o.t=e("Timers",{logger:o.l,schemaId:"<ns>.ContentLatency.1",logOptions:o.dlo})),o.t("mark",t,n)}})});csa.plugin(function(o){var t,n,i="normal",s="reload",e="history",d="new-tab",a="ajax",r=1,c=2,u="lastActive",l="lastInteraction",f="used",p="csa-tabbed-browsing",g="visibilityState",v={"back-memory-cache":1,"tab-switch":1,"history-navigation-page-cache":1},b="<ns>.TabbedBrowsing.2",m="visible",y=o.global,I=o("Events",{producerId:"csa"}),h=y.location||{},T=y.document,w=y.JSON,z=((y.performance||{}).navigation||{}).type,P=o.store,S=o.on,k=o.storageSupport(),x=!1,A={},C={},O={},$={},j=!1,q=!1,B=!1;function E(i){try{return w.parse(P(p,void 0,{session:i})||"{}")||{}}catch(i){o.error('Could not parse storage value for key "'+p+'": '+i)}return{}}function J(i,t){P(p,w.stringify(t||{}),{session:i})}function N(i){var t=C.tid||i.id,n=A[u]||{};n.tid===t&&(n.pid=i.id),$={pid:i.id,tid:t,lastInteraction:C[l]||{},initialized:!0},O={lastActive:n,lastInteraction:A[l]||{},time:o.time()}}function D(i){var t=i===d,n=T.referrer,e=!(n&&n.length)||!~n.indexOf(h.origin||""),a=t&&e,r={type:i,toTabId:$.tid,toPageId:$.pid,transitTime:o.time()-A.time||null};a||function(i,t,n){var e=i===s,a=t?A[u]||{}:C,r=A[l]||{},o=C[l]||{},d=t?r:o;n.fromTabId=a.tid,n.fromPageId=a.pid,e||!d.id||d[f]||(n.interactionId=d.id||null,r.id===d.id&&(r[f]=!0),o.id===d.id&&(o[f]=!0))}(i,t,r),I("log",{navigation:r,schemaId:b},{ent:{page:["pageType","subPageType","requestId"]}})}function F(i){B=function(i){return i&&i in v}(i.transitionType),function(){A=E(!1),C=E(!0);var i=A[l],t=C[l],n=!1,e=!1;i&&t&&i.id===t.id&&i[f]!==t[f]&&(n=!i[f],e=!t[f],t[f]=i[f]=!0,n&&J(!1,A),e&&J(!0,C))}(),N(i),j=!0,function(i){var t,n;t=H(),n=K(),(t||n)&&N(i)}(i)}function G(){x&&!B?D(a):(x=!0,D(z===c||B?e:z===r?C.initialized?s:d:C.initialized?i:d))}function H(){return!(!j||!t)&&(C[l]={id:t.messageId,used:!(A[l]={id:t.messageId,used:!1})},!(t=null))}function K(){var i=!1;if(q=T[g]===m,j){var t=A[u]||{};i=function(i,t,n){var e=!1,a=i[u];return q?a&&a.tid===$.tid&&a[m]&&a.pid===n||(i[u]={visible:!0,pid:n,tid:t},e=!0):a&&a.tid===$.tid&&a[m]&&(e=!(a[m]=!1)),e}(A,C.tid||t.tid||$.tid,C.pid||t.pid||$.pid)}return i}k.local&&k.session&&w&&T&&g in T&&(n=function(){try{return y.self!==y.top}catch(i){return!0}}(),S("$pageChange",function(i){n||(F(i),G(),J(!1,O),J(!0,$),C=$,A=O)},{buffered:1}),S("$content.interaction",function(i){t=i,H()&&(J(!1,A),J(!0,C))}),S(T,"visibilitychange",function(){!n&&K()&&J(!1,A)},{capture:!1,passive:!0}))});csa.plugin(function(c){var e=c("Metrics",{producerId:"csa"});c.on(c.global,"pageshow",function(c){c&&c.persisted&&e("recordMetric","bfCache",1)})});


}
/* ◬ */
</script>

</div>

<noscript>
    <img height="1" width="1" style='display:none;visibility:hidden;' src='//fls-na.amazon.com/1/batch/1/OP/A1EVAM02EL8SFB:137-3442349-9635931:YAQYHQZAPJWQPCYD78VQ$uedata=s:%2Frd%2Fuedata%3Fnoscript%26id%3DYAQYHQZAPJWQPCYD78VQ:0' alt=""/>
</noscript>

<script>window.ue && ue.count && ue.count('CSMLibrarySize', 46289)</script>
    </body>
</html>

''';

Stream<String> streamImdbHtmlOfflineData(dynamic dummy) {
  return emitImdbHtmlSample(dummy);
}

Stream<String> emitImdbHtmlSample(dynamic dummy) async* {
  yield imdbHtmlSampleFull;
}
