//hash,url(string),num, string, index, array, working, done, body, header
Core.prototype.hash = function(callback) {
    var q = location.hash,
        r = {
            page: q.split("?")[0].replace('#', '')
        },
        m, search = /([^\?#&=]+)=([^&]*)/g,
        d = function(s) {
            return decodeURIComponent(s.replace(/\+/g, " "));
        };
    while (m = search.exec(q)) r[d(m[1])] = d(m[2]);
    callback(r);
};
Core.prototype.url = function(l, x, y) {
    var Url = this.string([l, 47, x.join('/'), 46, y]),
        Filename = Url.substring(Url.lastIndexOf('/') + 1),
        Type = this.string(['application', 47, y]),
        Path = null,
        Local = null;
    if (fO.isCordova) {
        Path = cordova.file.dataDirectory;
        Local = cordova.file.dataDirectory + Filename;
    }
    return {
        url: Url,
        data: y,
        content: Type + ';charset=utf-8',
        filename: Filename,
        type: Type,
        path: Path,
        local: Local
    };
};
Core.prototype.num = function(n, l) {
    if (!l) l = fO.query.bible;
    return (Object.getOwnPropertyNames(fO.lang[l].n).length === 0) ? n : n.toString().replace(/[0123456789]/g, function(s) {
        return fO.lang[l].n[s];
    });
};
Core.prototype.string = function(x) {
    return $.map(x, function(v) {
        return $.isNumeric(v) ? String.fromCharCode(v) : v;
    }).join('');
};
Core.prototype.index = function() {
    config.bible.available = [];
    $.map(fO.lang, function(e, i) {
        return {
            id: i,
            index: e.index
        };
    }).sort(function(a, b) {
        return a.index - b.index;
    }).forEach(function(e) {
        config.bible.available.push(e.id);
    });
};
Core.prototype.array = function(d, o) {
    //f.array(lC[n][i]).merge(jB).data
    return {
        merge: function(y) {
            if ($.type(y) === 'array') o = y;
            this.data = d = d.concat(o).sort(function(a, b) {
                return a - b;
            });
            return this;
        },
        unique: function() {
            return d.filter(function(item, index) {
                return d.indexOf(item) === index;
            });
        },
        removeIfduplicate: function(y) {
            return $.map(d, function(v, i) {
                d[i] === d[i + 1] && (d[i] = d[i + 1] = null);
                return d[i];
            });
        },
        to: function(y) {
            return {
                sentence: function(x) {
                    return (d.length > 1) ? [d.slice(0, -1).join(y || ', '), d.slice(-1)[0]].join(x || ' & ') : d[0];
                }
            };
        }
    };
};
Core.prototype.working = function(q) {
    if (fO.msg.info.is(":hidden")) {
        $('body').addClass(config.css.working).promise().done(fO.msg.info.slideDown(200));
    }
    if (q.wait === true) {
        $('body').addClass(config.css.wait);
    }
    if (q.disable === true) {
        $('body').addClass(config.css.disable);
    }
    return (q.msg) ? fO.msg.info.html(q.msg) : fO.msg.info;
};
Core.prototype.done = function(callback) {
    var fn = this;
    fO.msg.info.slideUp(200).empty().promise().done(function() {
        fn.body().promise().done(function() {
            if (callback) callback();
        });
    });
};
Core.prototype.template=function(dl,position){
    //this.iQ=arguments[0]; this.obj=arguments[1];
    //f().template();
    //fN.fN({header:config.header[fO.query.page]}).Content();
    var j=$(), o=this.obj;
    var fn=this;
    $.each(this.arg[0], function(key,v){
        (function mmm(k,item,container,x){
            //f(k).is('tag').name
            //o.is(k).tag
            var attr=item.attr,child=item.text,y=false,tag=$(f(k).is('tag').name,attr);
            if(attr && attr.fn){y=item.attr.fn.split(' '); delete attr.fn;}
            if($.type(child) === 'string'){
                tag.html(child);
            }else if(item.value){
                tag.val(item.value);
            }else if(!child){
            }else{
                for(i in child){
                    if($.isNumeric(i)){
                        var k=Object.keys(child[i]); mmm(k,child[i][k], tag);
                    }else{
                        mmm(i,child[i], tag);
                    }
                }
            }
            // if(y && Object.prototype.hasOwnProperty.call(o, "Watch"))o.Watch(y).go(tag);
            if(x){j=container.add(tag);}else{container.append(tag);}
        })(key,v, j,true);
    });
    if(dl){($.type(dl) !== 'object'?$(dl):dl)[position||'append'](j);}
    return j;
};
Core.prototype.activeClass=function(container){
    return container.find(f(config.css.active).is('class').name).removeClass(config.css.active).promise().done($(config.css.currentPage).addClass(config.css.active));
};
// Core.prototype.body = function() {
//     return $('body').attr({
//         id: fO.query.page,
//         class: ''
//     });
// };
// NOTE: previously used
//return {ol:this.is('ol').tag, ul:this.is('ul').tag, li:this.is('li').tag, a:this.is('a').tag, div:this.is('div').tag,p:this.is('p').tag,h1:this.is('h1').tag, h2:this.is('h2').tag,h3:this.is('h3').tag,h4:this.is('h4').tag, span:this.is('span').tag,em:this.is('em').tag,sup:this.is('sup').tag};
// TODO: currently not using
Core.prototype.header = function(container) {
    if(config.header[fO.query.page]){
        if(fO.todo.headerChanged !=fO.query.page){
            container.replaceWith(f({header:config.header[fO.query.page]}).template()).promise().done(function(){
                fO.todo.headerChanged=fO.query.page;
                container.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                //z.screen.Status();
                fO.todo.Orientation=true;
            });
        }
    }else if(fO.todo.headerChanged){
        container.replaceWith(f({header:config.body.header}).template()).promise().done(function(){
            delete fO.todo.headerChanged;
            container.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
            //z.screen.Status();
            fO.todo.Orientation=true;
        });
    }else{
        this.activeClass(container);
    }
};
// TODO: currently not using
Core.prototype.footer = function(container) {
    if(config.footer[fO.query.page]){
        if(fO.todo.footerChanged !=fO.query.page){
            container.replaceWith(f({footer:config.footer[fO.query.page]}).template()).promise().done(function(){
                fO.todo.footerChanged=fO.query.page;
                $(config.css.currentPage).addClass(config.css.active);
                fO.todo.Orientation=true;
            });
        }
    }else if(fO.todo.footerChanged){
        container.replaceWith(f({footer:config.body.footer}).template()).promise().done(function(){
            delete fO.todo.footerChanged;
            $(config.css.currentPage).addClass(config.css.active);
            fO.todo.Orientation=true;
        });
    }else{
        this.activeClass(container);
    }
};
