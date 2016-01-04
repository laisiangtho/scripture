return $(h.span,{class:'icon-language'}).on(fO.Click,function(event){
    var e=$(event.target), li=e.parent(), ul=li.children().eq(1), y=li.attr('class');
    if(ul.length){
        ul.fadeOut(200).remove();
    }else{
        ul=$(h.ul,{class:'mO parallel'}).appendTo(li);
        new fn.menu(function(Om){
            var ic=f(Om.bID).is('class').name;
            return $(h.li,{class:(y===Om.bID)?config.css.active:(container.children(ic).length)?'has':Om.bID}).html(Om.lang.name).on(fO.Click,function(){
                callback($(this),Om.lang.name,ic,Om.bID);
            });
        }).bible(ul);
        f().doClick(function(evt){
            if(!$(evt.target).closest(li).length)ul.remove();
        });
    }
});
