"use strict";describe("mark with acrossElements and regular expression",function(){var e;beforeEach(function(s){loadFixtures("across-elements/regexp/main.html"),e=$(".across-elements-regexp"),new Mark(e[0]).markRegExp(/lorem[\s]+ipsum/gim,{acrossElements:!0,done:s})}),it("should wrap matches",function(){expect(e.find("mark")).toHaveLength(6)})});