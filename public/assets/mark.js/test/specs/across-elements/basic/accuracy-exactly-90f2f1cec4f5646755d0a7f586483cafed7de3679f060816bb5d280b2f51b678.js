"use strict";describe("mark with acrossElements and accuracy exactly",function(){var e,a,t;beforeEach(function(c){loadFixtures("across-elements/basic/accuracy-exactly.html"),e=$(".across-elements-accuracy-exactly > div:nth-child(1)"),a=$(".across-elements-accuracy-exactly > div:nth-child(2)"),t=$(".across-elements-accuracy-exactly > div:nth-child(3)"),new Mark(e[0]).mark("ipsu",{accuracy:"exactly",separateWordSearch:!1,acrossElements:!0,done:function(){new Mark(a[0]).mark("ipsu dolo",{accuracy:"exactly",separateWordSearch:!0,acrossElements:!0,done:function(){new Mark(t[0]).mark("ipsu",{accuracy:"exactly",separateWordSearch:!1,acrossElements:!0,done:c})}})}})}),it("should wrap the right matches",function(){expect(e.find("mark")).toHaveLength(1),expect(e.find("mark").text()).toBe("ipsu"),expect(e.find(".not mark")).toHaveLength(0)}),it("should work with separateWordSearch",function(){expect(a.find("mark")).toHaveLength(2);var e=["ipsu","dolo"];a.find("mark").each(function(){expect($.inArray($(this).text(),e)).toBeGreaterThan(-1)}),expect(a.find(".not mark")).toHaveLength(0)}),it("should work with diacritics",function(){expect(t.find("mark")).toHaveLength(4);var e=["ipsu","ips\xfc","\u012bpsu","\u012bps\xfc"];t.find("mark").each(function(){expect($.inArray($(this).text(),e)).toBeGreaterThan(-1)}),expect(t.find(".not mark")).toHaveLength(0)})});