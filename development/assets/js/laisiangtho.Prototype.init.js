Core.prototype.init = function() {
    var fn = this,
        s0 = {
            page: config.page[0],
            bible: config.bible.available[0],
            book: 1,
            testament: 1,
            catalog: 1,
            chapter: 1,
            verses: '',
            verse: '',
            q: '',
            result: ''
        };
    // NOTE: 'fO.query.bible' only for testing, before Initiation is not completed
    //fO.query.bible='tedim';
    this.hash(function(q) {
        var f0 = {
            page: function(i, o, d) {
                fO.query[i] = ($.inArray(o.toLowerCase(), config.page) >= 0) ? o : d;
                config.css.currentPage = f(fO.query[i]).is('class').name;
            },
            bible: function(i, o, d) {
                fO.query[i] = ($.inArray(o.toLowerCase(), config.bible.available) >= 0) ? o : d;
            },
            book: function(i, o, d) {
                if ($.isNumeric(o)) {
                    fO.query[i] = (bible.book[o]) ? o : d;
                } else {
                    fO.query[i] = d;
                    var o = o.replace(new RegExp('-', 'g'), ' ').toLowerCase(),
                        books = fO.lang[fO.query.bible].b;
                    for (var k in books) {
                        // TODO: what is lang
                        if (books[k].toLowerCase() == q || lang.b[k].toLowerCase() == o) {
                            fO.query[i] = k;
                            break;
                        }
                    }
                }
            },
            testament: function(i, o, d) {
                fO.query[i] = bible.info[fO.query.book].t;
            },
            catalog: function(i, o, d) {
                fO.query[i] = bible.info[fO.query.book].s;
            },
            chapter: function(i, o, d) {
                fO.query[i] = (bible.info[fO.query.book].c >= o && o > 0) ? o : d;
            },
            verse: function(i, o, d) {
                fO.query[i] = (bible.info[fO.query.book].v[fO.query.chapter - 1] >= o) ? o : d;
            },
            verses: function(i, o, d) {},
            q: function(i, o, d) {
                if (q.q) {
                    fO.query.q = q.q;
                }
            },
            bookmark: function() {}
        };
        if ($.isEmptyObject(fO.query)) {
            fO.query = $.extend({}, s0, q);
        } else {
            q.page = (q.page) ? q.page : fO.query.page;
            $.extend(fO.query, q);
        }
        fO.query.loop(function(i,v){
            if ($.isFunction(f0[i])) f0[i](i, v, s0[i]);
        })
    });
    // TODO: switch active class, faster way
    // fn.header($(config.css.header));
    // fn.footer($(config.css.footer));
    $(config.css.header).find('*').removeClass(config.css.active).siblings(config.css.currentPage).addClass(config.css.active);
    var lookupForm=f('lookup').is('form').element;
    if(lookupForm.length){
        lookupForm.off().on('submit',function(){
            var x=$(this); x.serializeObject(fO.query);
            // console.log(fO.query,fO.query.page);
            if(fO.query.page == x.attr('name')){
                // NOTE: page is already lookup
                x.find(f('q').is('input').name).attr('autocomplete', 'off').focus().select().promise().done(f().lookup());
            }else{
                x.attr('action').hashChange({q:fO.query.q});
            }
            return false;
        });
        f('search').is('input').element.off().on(fO.Click,function(){
            $(this.form).submit();
        }).promise().done(function(){
            f('q').is('input').element.attr('autocomplete', 'off').focus().select();
        });
    }
    fO.container.main=$(config.css.content).children(config.css.currentPage);
    // NOTE: find Method for current page, if not found send to the last config.page
    fO.container.main.fadeIn(300).siblings().hide().promise().done(
        this[$.isFunction(this[fO.query.page])?fO.query.page:$(config.page).get(-1)]()
    );
    // TODO: 'data-fa' might require to work on production
    f('fn').is('attr').get('fn').element.each(function(){
        // TODO: call Method dynamically
        $(this).append('...');
    }).promise().done(function(){
        // NOTE: save current bible query and page
        db.update.query();
    });
    // $(f('fO').is('class').name).each(function(){
    //     var y=$(this), d=f(y).get('data-fa').split('-'), i=f(y).get('class').element;
    //     if(fA[i[0]]){
    //         if(d[0] && $.isFunction(fA[i[0]][d[0]]))fA[i[0]][d[0]](y,d,i);
    //         if(i[1] && $.isFunction(fA[i[0]][i[1]]))y.off().on(fO.Click,function(e){fA[i[0]][i[1]](e);});
    //     }
    // }).promise().done(function(){
    //     db.update.query();
    // });
    // TODO: request Google Analytics
    // z.isAnalytics(function(o){
    //     o.sendPage(fO.query.page);
    // });
    // TODO: Orientation change detecting, require for Mobile and Tablet
    if(fO.todo.Orientation){
        application.Orientation();
        delete fO.todo.Orientation;
    }
    // console.log(fO.query.bible);
    var x=new f({bible:'tedim',reading:1}).xml(function(response){
        console.log(response);
        // return response;
    }).is();
    console.log(x);
};
Core.prototype.bible = function() {
    // console.log('no bible?');
};
Core.prototype.book = function() {
    // console.log('no book?');
};
Core.prototype.lookup = function() {
    // console.log('no lookup?');
};
Core.prototype.note = function() {
    // console.log('no note?');
};
Core.prototype.todo = function() {
    // console.log('nothing todo?');
};
