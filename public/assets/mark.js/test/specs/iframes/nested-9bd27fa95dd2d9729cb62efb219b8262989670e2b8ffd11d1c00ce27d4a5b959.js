"use strict";describe("mark in nested iframes",function(){var e,r,t;beforeEach(function(a){loadFixtures("iframes/nested.html"),r=$(),e=$(".iframes-nested"),t=0;try{new Mark(e[0]).mark("lorem",{diacritics:!1,separateWordSearch:!1,iframes:!0,each:function(e){r=r.add($(e))},done:a})}catch(i){t++}},3e4),it("should wrap matches inside iframes recursively",function(){expect(t).toBe(0),expect(r).toHaveLength(12)})});