Core.prototype.Database = function(e) {
    var t = this;
    this.deleteDatabase = function() {
        return localforage.clear(function(e) {
            return console.log(e || "Deleted entirely!");
        });
    }, this.add = function(e) {
        return localforage.setItem(e.table, e.data);
    };
    this.get = function(e) {
        return localforage.getItem(e.table);
    };
    this.read = function(e) {
        localforage.keys(e);
    };
    this.delete = function(e) {
        return localforage.removeItem(e.table);
    };
    this.UpdateQuery = function() {
        return this.put({
            table: config.store.query,
            data: fO.query
        });
    };
    this.UpdateLang = function() {
        return this.add({
            table: config.store.lang,
            data: fO.lang
        });
    };
    this.UpdateNote = function() {
        return this.put({
            table: config.store.note,
            data: fO.note
        });
    };
    this.UpdateLookUp = function() {
        return this.put({
            table: config.store.lookup,
            data: fO.lookup
        });
    };
    this.update = {
        query: function() {
            return t.add({
                table: config.store.query,
                data: fO.query
            });
        },
        lang: function() {
            return t.add({
                table: config.store.lang,
                data: fO.lang
            });
        },
        note: function() {
            return t.add({
                table: config.store.note,
                data: fO.note
            });
        },
        lookup: function() {
            return t.add({
                table: config.store.lookup,
                data: fO.lookup
            });
        }
    };
    this.remove = {
        query: function() {},
        lang: function(e, n) {
            delete fO[e];
            delete fO.lang[e];
            config.bible.available.splice(config.bible.available.indexOf(e), 1);
            t.update.lang().then(function() {
                if (n) n();
                return t;
            });
        },
        note: function() {},
        lookup: function() {}
    };
    this.RemoveLang = function(e, t) {
        delete fO[e];
        delete fO.lang[e];
        config.bible.available.splice(config.bible.available.indexOf(e), 1);
        this.UpdateLang().then(function() {
            if (t) t();
        });
    };
    localforage.config({
        name: config.store.name,
        storeName: "store",
        version: config.store.version,
        description: config.description,
        size: 3e8
    });
    localforage.setDriver([ localforage.INDEXEDDB, localforage.WEBSQL, localforage.LOCALSTORAGE ]).then(function() {
        return true;
    });
    localforage.ready().then(function() {
        return e.apply(t);
    });
    return "...!";
};