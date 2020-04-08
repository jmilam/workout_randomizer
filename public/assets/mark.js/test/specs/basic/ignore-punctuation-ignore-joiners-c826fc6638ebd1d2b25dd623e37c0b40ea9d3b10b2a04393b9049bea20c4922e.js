"use strict";describe("basic mark with ignorePunctuation and ignoreJoiners",function(){function i(){return":;.,-\u2013\u2014\u2012_(){}[]!'\"+=".replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&").split("")}var n,e,t,r=i(),o=new RegExp("[\xad\u200b\u200c\u200d"+r.join("")+"]","g");beforeEach(function(i){loadFixtures("basic/ignore-punctuation-ignore-joiners.html"),t=$(".basic-ignore-punctuation-ignore-joiners"),n=t.children("div:nth-child(1)"),e=t.children("div:nth-child(2)"),new Mark(n[0]).mark("Lorem ipsum",{separateWordSearch:!1,diacritics:!1,ignoreJoiners:!0,ignorePunctuation:r,done:function(){new Mark(e[0]).mark(["ipsum"],{separateWordSearch:!1,diacritics:!1,ignoreJoiners:!0,ignorePunctuation:r,done:i})}})}),it("should find matches containing spaces and ignore joiners",function(){expect(n.find("mark")).toHaveLength(6);var i=0,e=/lorem\s+ipsum/i;n.find("mark").each(function(){e.test($(this).text().replace(o,""))&&i++}),expect(i).toBe(6)}),it("should find matches containing ignore joiners",function(){expect(e.find("mark")).toHaveLength(6);var i=0;e.find("mark").each(function(){"ipsum"===$(this).text().replace(o,"")&&i++}),expect(i).toBe(6)})});