"use strict";describe("basic mark with ignorePunctuation and synonyms with diacritics",function(){function i(){return":;.,-\u2013\u2014\u2012_(){}[]!'\"+=".replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&").split("")}var n,t=i();beforeEach(function(i){loadFixtures("basic/ignore-punctuation-synonyms-diacritics.html"),n=$(".basic-ignore-punctuation-synonyms-diacritics"),new Mark(n[0]).mark(["Do\u0142or","Sed","Lor\xe8m ipsum"],{separateWordSearch:!1,diacritics:!0,ignorePunctuation:t,synonyms:{Sed:"just\xf8","Do\u0142or":"\xe3met"},done:i})}),it("should find synonyms with diacritics",function(){expect(n.find("mark")).toHaveLength(33)})});