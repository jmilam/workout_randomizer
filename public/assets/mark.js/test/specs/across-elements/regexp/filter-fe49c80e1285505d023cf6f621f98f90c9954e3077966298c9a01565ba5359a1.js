"use strict";describe("mark with acrossElements, regular expression and filter callback",function(){var e;beforeEach(function(){loadFixtures("across-elements/regexp/filter.html"),e=$(".across-elements-regexp-filter")}),it("should call the callback with the right parameters",function(t){var r=0,a=["Lorem","ipsum"];new Mark(e[0]).markRegExp(/(Lore?m)|(ipsum)/gim,{acrossElements:!0,filter:function(e,t,n){return expect(e.nodeType).toBe(3),expect($.inArray(t,a)).toBeGreaterThan(-1),expect(r).toBe(n),"ipsum"!==t&&(r++,!0)},done:function(){expect(e.find("mark")).toHaveLength(4),t()}})})});