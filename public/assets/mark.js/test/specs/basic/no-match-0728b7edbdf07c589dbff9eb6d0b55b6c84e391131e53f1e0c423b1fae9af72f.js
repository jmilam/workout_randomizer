"use strict";describe("basic mark with noMatch callback",function(){var t,a;beforeEach(function(c){loadFixtures("basic/main.html"),a=[],t=$(".basic"),new Mark(t[0]).mark("test",{diacritics:!1,separateWordSearch:!1,noMatch:function(t){a.push(t)},done:function(){c()}})}),it("should call the noMatch callback for not found terms",function(){expect(a).toEqual(["test"])})});