"use strict";describe("mark with acrossElements and each callback",function(){var e,a;beforeEach(function(c){loadFixtures("across-elements/basic/main.html"),a=0,e=$(".across-elements"),new Mark(e[0]).mark("lorem ipsum",{diacritics:!1,separateWordSearch:!1,acrossElements:!0,each:function(){a++},done:c})}),it("should call the each callback for each marked element",function(){expect(a).toBe(6)})});