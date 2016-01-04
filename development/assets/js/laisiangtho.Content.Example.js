var olb, olc, olv, ol;
new Page(function(Ob) {
    var d=new $.Deferred();
    // var msg=lA.BFBCV.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA).replace(/{v}/,Ob.VNA);
    // f().working({msg:msg});
    var msg=lA.BFVBC.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA);
    // console.log(msg);
    // Ob.Result.verse++;
    if(Ob.Result.NewBook){
        console.log('yes new book', Ob.BNA);
    } else {
        console.log('no old book', Ob.BNA);
    }
    d.notify();
    d.resolve();
    return d.promise();
}).get(function(Ob) {
    Ob.xml(function(response){
        if(response.status){
            if(Ob.query.lookup('verseSearch')){
                if(Ob.query.is()){
                    ol=$(h.ol,{class:q.bible}).appendTo(container);
                    Ob.book(Ob.Result.Booklist).progress(function(e){
                        // NOTE: reading bible, 'lookup.progress'
                        // NOTE: progress only return if callbackBible has notify!
                        // console.log('Example.process');
                        // var msg=lA.BFBCV.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA).replace(/{v}/,Ob.VNA);
                        var msg=lA.BFVBC.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA);
                        f().working({msg:msg});
                    }).done(function(){
                        // NOTE: reading done
                        // NOTE: done only return if callbackBible has resolve!
                        console.log('Example.done');
                    }).fail(function(){
                        // NOTE: reading fail
                    }).always(function(){
                        // NOTE: task completed
                        f().done();
                    });
                } else {
                    // NOTE: Ob.query.is empty!
                    console.log('Ob.query.is empty');
                }
            } else {
                // NOTE: Ob.query.* is empty
                console.log('Ob.query.lookup empty');
            }
        } else {
            // NOTE: download fail
            console.log('download fail');
        }
    });
});
