"use strict";describe("basic mark with wildcards and diacritics",function(){var i,a;beforeEach(function(c){loadFixtures("basic/wildcards-diacritics.html"),i=$(".basic-wildcards-diacritics > div:nth-child(1)"),a=$(".basic-wildcards-diacritics > div:nth-child(2)"),new Mark(i[0]).mark("lor?m",{separateWordSearch:!1,diacritics:!0,wildcards:"enabled",done:function(){new Mark(a[0]).mark("l\xf6r*m",{separateWordSearch:!1,diacritics:!0,wildcards:"enabled",done:c})}})}),it("should find wildcard matches containing diacritics",function(){expect(i.find("mark")).toHaveLength(7),expect(a.find("mark")).toHaveLength(13)})});