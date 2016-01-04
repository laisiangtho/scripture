(function() {
    'use strict';
    Object.defineProperties(Object.prototype, {
        hashChange: {
            value: function(page) {
                window.location.hash = this.toString()+jQuery.param(page);
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
        /*
        XMLHttp: {
            value: function(success, error) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", this, false);
                xmlhttp.send();
                return xmlhttp.responseText;
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
        */
    });
}());
