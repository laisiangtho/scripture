var lang=fO.lang[fO.query.bible].l;
var ol=$(h.ol).appendTo(fO.container.main.children().empty().attr({class:'wrp wrp-todo'}));
$(config.page).each(function(i,v){
    var isReady=$.isFunction(fn.page[v]), isClass=(isReady)?'icon-right':'icon-wrong';
    $(h.li,{class:(isReady)?v:'notready'}).append(
        $(h.p).append(
            $(h.a,{href:fn.string([35,v,63]),class:isClass}).html((lang[v])?lang[v]:v)
        )
    ).appendTo(ol);
});
// $content.html(con);
// if(page != 'todo') {
//     var msg = db[bible].l.pageisnotready.replace("{is}",db[bible].l[page]);
//     //$(l.css.content).prepend($('<h3>',{html:msg}));
// }
// var con = $(l.h.ol,{class:'rows row-todo'});
// $(l.page).each(function(i,v){
//     con.append(
//         $(l.h.li,{class:($.isFunction(z.page[v]))?v:'notready'}).append($(l.h.p).append(
//             $(l.h.a,{href:z.is([35,v]),text:lLG[v]}),
//             $(l.h.span,{class:($.isFunction(z.page[v]))?'icon-right':'icon-wrong'})
//         ))
//     );
// });
// $content.html(con);
// if(page != 'todo') {
//     var msg = db[bible].l.pageisnotready.replace("{is}",db[bible].l[page]);
//     //$(l.css.content).prepend($('<h3>',{html:msg}));
// }
