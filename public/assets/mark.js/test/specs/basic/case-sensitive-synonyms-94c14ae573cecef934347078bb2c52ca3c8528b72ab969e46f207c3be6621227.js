"use strict";describe("basic mark with caseSensitive synonyms",function(){var e,s;beforeEach(function(n){loadFixtures("basic/case-sensitive-synonyms.html"),e=$(".basic-case-sensitive-synonyms > div:nth-child(1)"),s=$(".basic-case-sensitive-synonyms > div:nth-child(2)"),new Mark(e[0]).mark("Lorem",{synonyms:{Lorem:"ipsum"},separateWordSearch:!1,diacritics:!1,caseSensitive:!0,done:function(){new Mark(s[0]).mark(["one","2","l\xfcfte"],{separateWordSearch:!1,diacritics:!1,caseSensitive:!0,synonyms:{"\xfc":"ue",one:"1",two:"2"},done:n})}})}),it("should wrap keywords and synonyms",function(){expect(e.find("mark")).toHaveLength(6),expect(s.find("mark")).toHaveLength(5)})});