!function(t,e){"object"==typeof exports&&"undefined"!=typeof module?module.exports=e(require("jquery")):"function"==typeof define&&define.amd?define(["jquery"],e):t.Util=e(t.jQuery)}(this,function(t){"use strict";return function(r){function a(t){return{}.toString.call(t).match(/\s([a-z]+)/i)[1].toLowerCase()}function t(){return{bindType:i,delegateType:i,handle:function e(t){return r(t.target).is(this)?t.handleObj.handler.apply(this,arguments):undefined}}}function e(t){var e=this,n=!1;return r(this).one(f.TRANSITION_END,function(){n=!0}),setTimeout(function(){n||f.triggerTransitionEnd(e)},t),this}function n(){r.fn.emulateTransitionEnd=e,r.event.special[f.TRANSITION_END]=t()}var i="transitionend",o=1e6,u=1e3,f={TRANSITION_END:"bsTransitionEnd",getUID:function s(t){for(;t+=~~(Math.random()*o),document.getElementById(t););return t},getSelectorFromElement:function c(t){var e=t.getAttribute("data-target");e&&"#"!==e||(e=t.getAttribute("href")||"");try{return document.querySelector(e)?e:null}catch(n){return null}},getTransitionDurationFromElement:function d(t){if(!t)return 0;var e=r(t).css("transition-duration");return parseFloat(e)?(e=e.split(",")[0],parseFloat(e)*u):0},reflow:function l(t){return t.offsetHeight},triggerTransitionEnd:function p(t){r(t).trigger(i)},supportsTransitionEnd:function g(){return Boolean(i)},isElement:function y(t){return(t[0]||t).nodeType},typeCheckConfig:function h(t,e,n){for(var r in n)if(Object.prototype.hasOwnProperty.call(n,r)){var i=n[r],o=e[r],u=o&&f.isElement(o)?"element":a(o);if(!new RegExp(i).test(u))throw new Error(t.toUpperCase()+': Option "'+r+'" provided type "'+u+'" but expected type "'+i+'".')}}};return n(),f}(t=t&&t.hasOwnProperty("default")?t["default"]:t)});