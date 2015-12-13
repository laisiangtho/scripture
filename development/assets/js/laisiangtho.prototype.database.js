Core.prototype.Database = function(callback) {
    var fn=this;
    this.deleteDatabase=function(){
        return localforage.clear(function(err) {
            return console.log(err || 'Deleted entirely!');
        });
    },
    this.add=function(q){
        return localforage.setItem(q.table, q.data);
    };
    this.get=function(q){
        return localforage.getItem(q.table);
    };
    this.read=function(q){
        localforage.keys(q);
    };
    this.delete=function(q){
        return localforage.removeItem(q.table);
    };
    this.UpdateQuery=function(){
        return this.put({table:config.store.query,data:fO.query});
    };
    this.UpdateLang=function(){
        return this.add({table:config.store.lang,data:fO.lang});
    };
    this.UpdateNote=function(){
        return this.put({table:config.store.note,data:fO.note});
    };
    this.UpdateLookUp=function(){
        return this.put({table:config.store.lookup,data:fO.lookup});
    };
    //NOT YET USED
    this.update={
        query:function(){
            return fn.add({table:config.store.query,data:fO.query});
        },
        lang:function(){
            return fn.add({table:config.store.lang,data:fO.lang});
        },
        note:function(){
            return fn.add({table:config.store.note,data:fO.note});
        },
        lookup:function(){
            return fn.add({table:config.store.lookup,data:fO.lookup});
        }
    };
    this.remove={
        query:function(){
        },
        lang:function(x,callback){
            delete fO[x]; delete fO.lang[x];
            config.bible.available.splice(config.bible.available.indexOf(x), 1);
            fn.update.lang().then(function(){
                if(callback)callback();
                return fn;
            });
        },
        note:function(){
        },
        lookup:function(){
        }
    };
    this.RemoveLang=function(x,callback){
        delete fO[x]; delete fO.lang[x];
        config.bible.available.splice(config.bible.available.indexOf(x), 1);
        this.UpdateLang().then(function(){
            if(callback)callback();
        });
    };
    localforage.config({name:config.store.name,storeName:'store',version:config.store.version,description:config.description,size:300000000});
    localforage.setDriver([localforage.INDEXEDDB,localforage.WEBSQL,localforage.LOCALSTORAGE]).then(function(){return true});
    //short and good but object being merged!
    localforage.ready().then(function(){
        return callback.apply(fn);
    });
    return '...!';
};
