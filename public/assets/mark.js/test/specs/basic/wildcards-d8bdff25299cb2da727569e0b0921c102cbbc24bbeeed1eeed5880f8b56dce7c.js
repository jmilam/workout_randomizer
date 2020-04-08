"use strict";describe("basic mark with wildcards",function(){var a,d,i,c;beforeEach(function(e){loadFixtures("basic/wildcards.html"),a=$(".basic-wildcards > div:nth-child(1)"),d=$(".basic-wildcards > div:nth-child(2)"),i=$(".basic-wildcards > div:nth-child(3)"),c=$(".basic-wildcards > div:nth-child(4)"),new Mark(a[0]).mark("lor?m",{separateWordSearch:!1,diacritics:!1,wildcards:"enabled",done:function(){new Mark(d[0]).mark("lor*m",{separateWordSearch:!1,diacritics:!1,wildcards:"enabled",done:function(){new Mark(i[0]).mark(["lor?m","Lor*m"],{separateWordSearch:!1,diacritics:!1,wildcards:"enabled",done:function(){new Mark(c[0]).mark(["lor?m","Lor*m"],{separateWordSearch:!1,diacritics:!1,wildcards:"disabled",done:e})}})}})}})}),it("should find '?' wildcard matches",function(){expect(a.find("mark")).toHaveLength(6)}),it("should find '*' wildcard matches",function(){expect(d.find("mark")).toHaveLength(8)}),it("should find both '?' and '*' matches",function(){expect(i.find("mark")).toHaveLength(14)}),it("should find wildcards as plain characters when disabled",function(){expect(c.find("mark")).toHaveLength(2)})});