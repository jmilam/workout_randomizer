"use strict";describe("basic mark in a context with script-tags and style-tags",function(){var t;beforeEach(function(e){loadFixtures("basic/script-style.html"),t=$(".basic-script-style"),new Mark(t[0]).mark("lorem",{diacritics:!1,separateWordSearch:!1,done:e})}),it("should wrap matches",function(){expect(t.find("mark")).toHaveLength(4)}),it("should not wrap anything inside these tags",function(){expect(t.find("style, script")).not.toContainElement("mark")})});