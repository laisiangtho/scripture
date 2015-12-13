// NOTE:
// FIXME: f
// REVIEW: r
// TODO: t
// HACK: h
// XXX: x
// IDEA: i
// (function() { 'use strict'; }()); ->ii

// this.createProperties({
//     method:{
//         value: function() {
//         }
//     }
// });
// this.createProperty('example',function(){
// });
// this.makeProperty('example', {
//     value: function() {
//     }
// });
(function() {
    'use strict';
    Object.defineProperties(Object.prototype, {
        loop: {
            value: function(callback) {
                var fn = {
                    object: function(o) {
                        for (var i in o) {
                            callback(i, o[i], o);
                        }
                    },
                    array: function(o) {
                        for (var i = 0, len = o.length; i < len; i++) {
                            callback(o, i, o[i]);
                        }
                    }
                };
                return fn[typeof this](this);
            }
        },
        requestFileSystem: {
            value: function(success, error) {
                // NOTE: Cordova
                // TODO: Chrome App
                // REVIEW: http://www.html5rocks.com/en/tutorials/file/filesystem/
                window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, success, error);
            }
        },
        resolveFileSystem: {
            value: function(success, error) {
                // NOTE: Cordova
                // TODO: Chrome App
                window.resolveLocalFileSystemURL(this, success, error);
            }
        },
        XMLHttp: {
            value: function(success, error) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", this, false);
                xmlhttp.send();
                return xmlhttp.responseText;
            }
        },
        hashChange: {
            value: function(page) {
                // TODO: try without jQuery
                window.location.hash = this + jQuery.param(page);
                // x.attr('action').hashChange();
            }
        },
        tagID: {
            value: function() {
                return document.getElementById(this);
            }
        },
        tagClass: {
            value: function() {
                return document.getElementsByClassName(this);
            }
        },
        tagName: {
            value: function() {
                return document.getElementsByTagName(this);
            }
        },
        attrNameAll: {
            value: function() {
                return document.querySelectorAll(this);
                //document.querySelectorAll('[someAttr]')
                //document.querySelector('[someAttr]')
            }
        },
        attrName: {
            value: function() {
                return document.querySelector(this);
            }
        },
        createElement: {
            value: function() {
                return document.createElement(this);
            }
        },
        serializeObject: {
            value: function(o) {
                this.serializeArray().forEach(function(v) {
                    o[v.name] = v.value;
                });
                return o;
            }
        },
        // serializeJSON:{value:function(o){}},
        // isAnalytics:{value:function(callback){if(Object.prototype.hasOwnProperty.call(this, "analytics"))callback(this.analytics);}},
        // extend:{enumerable:false,value:function(x){var o=this;Object.getOwnPropertyNames(x).forEach(function(n){o.dProperty(n,Object.getOwnPropertyDescriptor(x,n));});return o;}},
        makeProperty: {
            value: function(n, v) {
                Object.defineProperty(this, n, v);
            }
        },
        createProperties: {
            value: function(v) {
                Object.defineProperties(this, v);
            }
        },
        createProperty: {
            value: function(n, v) {
                this.makeProperty(n, {
                    value: v
                });
            }
        },
        hasProperty: {
            value: function(obj) {
                return Object.prototype.hasOwnProperty.call(this, obj);
            }
        }
    });
}());
