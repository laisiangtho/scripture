Core.prototype.pagebook = function(fn) {
    var p=this.hash(2), lD=fO.lang[fO.query.bible];
    fO.container.main.html($(h.div,{class:'wrp wrp-book'}));
     $.each(bible.catalog,function(testamentID,cL){
         var testamentName=lD.t[testamentID];
         $(h.ol,{class:'testament',id:testamentID}).append(
             $(h.li,{id:'t-'+testamentID}).html(
                 $(h.h1,{text:testamentName})
             )
         ).appendTo(fO.container.main.children()).promise().done(function(){
             $(h.ol,{class:'catalog'}).appendTo(this.children()).promise().done(function(iCat){
                 $.each(cL,function(catalogID,bL){
                     var catalogName=lD.s[catalogID];
                     $(h.li,{id:'c-'+catalogID}).append(
                         $(h.h2,{text:catalogName})
                     ).appendTo(iCat).promise().done(function(iBok){
                        $(h.ol,{class:'book'}).appendTo(this);
                         bL.forEach(function(bookID){
                             var bookName=lD.b[bookID];
                             $(h.li,{id:'b-'+bookID,class:(fO.query.book==bookID?config.css.active:'')}).append(
                                 $(h.p).append(
                                     $(h.a,{href:p+$.param({book:bookID})}).html(bookName)
                                     //, fA.chapter.book(bookID)
                                     // TODO: chapter list for each bible
                                 )
                             ).appendTo(iBok.children()[1]);
                         });
                     });
                 });
             });
         });
     });
};
