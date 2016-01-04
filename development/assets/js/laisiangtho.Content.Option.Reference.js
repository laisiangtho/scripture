//Oj.Option(olc).Reference(Oj.VERSE.ref)
var li=$(h.li,{class:'ref'}).appendTo(container), reference=new Regex(q).ref(d).result;
$.each(reference,function(bID,ref){
    $.each(ref,function(cID,vID){
        if(vID.length)$(h.a).html(lA.BFBCV.replace(/{b}/, lB[bID]).replace(/{c}/, Oa.Num(cID)).replace(/{v}/,Oa.Num(new Regex(q).nameVerse(vID)))).on(fO.Click,function(){
            $.extend(q,{ref:d}); Oa.reference(li);
        }).appendTo(li);
    });
}); return li;
