function _objectSpread(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{},i=Object.keys(n);"function"==typeof Object.getOwnPropertySymbols&&(i=i.concat(Object.getOwnPropertySymbols(n).filter(function(e){return Object.getOwnPropertyDescriptor(n,e).enumerable}))),i.forEach(function(e){_defineProperty(t,e,n[e])})}return t}function _defineProperty(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function _defineProperties(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}function _createClass(e,t,n){return t&&_defineProperties(e.prototype,t),n&&_defineProperties(e,n),e}var Collapse=function(g){var t="collapse",n="4.1.1",h="bs.collapse",e="."+h,i=".data-api",r=g.fn[t],a={toggle:!0,parent:""},s={toggle:"boolean",parent:"(string|element)"},c={SHOW:"show"+e,SHOWN:"shown"+e,HIDE:"hide"+e,HIDDEN:"hidden"+e,CLICK_DATA_API:"click"+e+i},f={SHOW:"show",COLLAPSE:"collapse",COLLAPSING:"collapsing",COLLAPSED:"collapsed"},l={WIDTH:"width",HEIGHT:"height"},_={ACTIVES:".show, .collapsing",DATA_TOGGLE:'[data-toggle="collapse"]'},o=function(){function o(e,t){this._isTransitioning=!1,this._element=e,this._config=this._getConfig(t),this._triggerArray=g.makeArray(g('[data-toggle="collapse"][href="#'+e.id+'"],[data-toggle="collapse"][data-target="#'+e.id+'"]'));for(var n=g(_.DATA_TOGGLE),i=0;i<n.length;i++){var r=n[i],a=Util.getSelectorFromElement(r);null!==a&&0<g(a).filter(e).length&&(this._selector=a,this._triggerArray.push(r))}this._parent=this._config.parent?this._getParent():null,this._config.parent||this._addAriaAndCollapsedClass(this._element,this._triggerArray),this._config.toggle&&this.toggle()}var e=o.prototype;return e.toggle=function(){g(this._element).hasClass(f.SHOW)?this.hide():this.show()},e.show=function(){var e,t,n=this;if(!this._isTransitioning&&!g(this._element).hasClass(f.SHOW)&&(this._parent&&0===(e=g.makeArray(g(this._parent).find(_.ACTIVES).filter('[data-parent="'+this._config.parent+'"]'))).length&&(e=null),!(e&&(t=g(e).not(this._selector).data(h))&&t._isTransitioning))){var i=g.Event(c.SHOW);if(g(this._element).trigger(i),!i.isDefaultPrevented()){e&&(o._jQueryInterface.call(g(e).not(this._selector),"hide"),t||g(e).data(h,null));var r=this._getDimension();g(this._element).removeClass(f.COLLAPSE).addClass(f.COLLAPSING),(this._element.style[r]=0)<this._triggerArray.length&&g(this._triggerArray).removeClass(f.COLLAPSED).attr("aria-expanded",!0),this.setTransitioning(!0);var a=function(){g(n._element).removeClass(f.COLLAPSING).addClass(f.COLLAPSE).addClass(f.SHOW),n._element.style[r]="",n.setTransitioning(!1),g(n._element).trigger(c.SHOWN)},s="scroll"+(r[0].toUpperCase()+r.slice(1)),l=Util.getTransitionDurationFromElement(this._element);g(this._element).one(Util.TRANSITION_END,a).emulateTransitionEnd(l),this._element.style[r]=this._element[s]+"px"}}},e.hide=function(){var e=this;if(!this._isTransitioning&&g(this._element).hasClass(f.SHOW)){var t=g.Event(c.HIDE);if(g(this._element).trigger(t),!t.isDefaultPrevented()){var n=this._getDimension();if(this._element.style[n]=this._element.getBoundingClientRect()[n]+"px",Util.reflow(this._element),g(this._element).addClass(f.COLLAPSING).removeClass(f.COLLAPSE).removeClass(f.SHOW),0<this._triggerArray.length)for(var i=0;i<this._triggerArray.length;i++){var r=this._triggerArray[i],a=Util.getSelectorFromElement(r);if(null!==a)g(a).hasClass(f.SHOW)||g(r).addClass(f.COLLAPSED).attr("aria-expanded",!1)}this.setTransitioning(!0);var s=function(){e.setTransitioning(!1),g(e._element).removeClass(f.COLLAPSING).addClass(f.COLLAPSE).trigger(c.HIDDEN)};this._element.style[n]="";var l=Util.getTransitionDurationFromElement(this._element);g(this._element).one(Util.TRANSITION_END,s).emulateTransitionEnd(l)}}},e.setTransitioning=function(e){this._isTransitioning=e},e.dispose=function(){g.removeData(this._element,h),this._config=null,this._parent=null,this._element=null,this._triggerArray=null,this._isTransitioning=null},e._getConfig=function(e){return(e=_objectSpread({},a,e)).toggle=Boolean(e.toggle),Util.typeCheckConfig(t,e,s),e},e._getDimension=function(){return g(this._element).hasClass(l.WIDTH)?l.WIDTH:l.HEIGHT},e._getParent=function(){var n=this,e=null;Util.isElement(this._config.parent)?(e=this._config.parent,"undefined"!=typeof this._config.parent.jquery&&(e=this._config.parent[0])):e=g(this._config.parent)[0];var t='[data-toggle="collapse"][data-parent="'+this._config.parent+'"]';return g(e).find(t).each(function(e,t){n._addAriaAndCollapsedClass(o._getTargetFromElement(t),[t])}),e},e._addAriaAndCollapsedClass=function(e,t){if(e){var n=g(e).hasClass(f.SHOW);0<t.length&&g(t).toggleClass(f.COLLAPSED,!n).attr("aria-expanded",n)}},o._getTargetFromElement=function(e){var t=Util.getSelectorFromElement(e);return t?g(t)[0]:null},o._jQueryInterface=function(i){return this.each(function(){var e=g(this),t=e.data(h),n=_objectSpread({},a,e.data(),"object"==typeof i&&i?i:{});if(!t&&n.toggle&&/show|hide/.test(i)&&(n.toggle=!1),t||(t=new o(this,n),e.data(h,t)),"string"==typeof i){if("undefined"==typeof t[i])throw new TypeError('No method named "'+i+'"');t[i]()}})},_createClass(o,null,[{key:"VERSION",get:function(){return n}},{key:"Default",get:function(){return a}}]),o}();return g(document).on(c.CLICK_DATA_API,_.DATA_TOGGLE,function(e){"A"===e.currentTarget.tagName&&e.preventDefault();var n=g(this),t=Util.getSelectorFromElement(this);g(t).each(function(){var e=g(this),t=e.data(h)?"toggle":n.data();o._jQueryInterface.call(e,t)})}),g.fn[t]=o._jQueryInterface,g.fn[t].Constructor=o,g.fn[t].noConflict=function(){return g.fn[t]=r,o._jQueryInterface},o}($);