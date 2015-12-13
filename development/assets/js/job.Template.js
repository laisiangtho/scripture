var help,json,job={
    help:function(){
        var h={
            "help":'...',
            "job.clean()":"remove all uncessary data (remove,empty,iframe,input_stat)",
            "'body'.get()":"job.get('body')",
            "'header'.get()":'...',
            "'main'.get()":'...',
            "'footer'.get()":'...',
            "'div'.get()":'...',
            "job.result()":'...',
        };
        help=Object.keys(h).join('; ');
        h.each(function(i,v){
            console.log(i,v);
        });
        /*
        help.forEach(function(i){
            console.log(i);
        });
        */
    },
    result:function(){
        var textarea='t100'.tagID();
        if(!textarea){
            textarea = document.createElement('textarea');
            textarea.id = "t100";
            document.body.appendChild(textarea);
        }
        textarea.value=JSON.stringify(json);
    },
    clean:function(){
        var rm = '[remove],[input_stat]'.attrNameAll();
        for (var i=rm.length-1; i>=0;i-=1){
            if (rm[i]) rm[i].parentNode.removeChild(rm[i]);
            //if (rm[i]) ety[i].remove();
        }
        var ety = '[empty]'.attrNameAll();
        for (var i=ety.length-1; i>=0;i-=1){
            if (ety[i]){
                while(ety[i].hasChildNodes()) {
                    ety[i].removeChild(ety[i].firstChild);
                }
                ety[i].removeAttribute("empty");
            }
        }
        var ifr ='iframe'.tagName();
        for (var i=ifr.length-1; i>=0;i-=1){
            if (ifr[i]) ifr[i].remove();
        }
        return 'done';
        /*
        .removeAttribute("category");
        .removeAttributeNode(attnode);
        */
    },
    get:function(tag){
        var element=tag.tagName()[0];
        if(element){
            json=this.dom(element);
            return json;
        }
        return tag+' not exists!';
    },
    dom:function(element){
        var obj={}, parser, docNode;
        if (typeof element === "string") {
            if (window.DOMParser){
                parser=new DOMParser(); docNode=parser.parseFromString(element,"text/html");
            }else{
                docNode=new ActiveXObject("Microsoft.XMLDOM"); docNode.async=false; docNode.loadXML(element);
            }
            element=docNode.firstChild;
            //element=docNode.lastChild;
        }
        this.objTree(element, obj);
        return obj;
    },
    objTree:function(el, o){
        var tag=el.nodeName.toLowerCase();
        o[tag]={};
        var nodeList =el.childNodes;
        if (nodeList != null) {
            if (nodeList.length) {
                o[tag]["text"] = [];
                for (var i = 0; i < nodeList.length; i++) {
                    if (nodeList[i].nodeType == 3) {
                        if(nodeList[i].nodeValue.replace(/^\s+|\s+$/g, '').trim()){
                            o[tag]["text"].push(nodeList[i].nodeValue);
                        }
                    } else {
                        o[tag]["text"].push({});
                        this.objTree(nodeList[i], o[tag]["text"][o[tag]["text"].length -1]);
                    }
                }
            }
        }
        if (el.attributes != null) {
            if (el.attributes.length) {
                o[tag]["attr"] = {};
                for (var i = 0; i < el.attributes.length; i++) {
                    o[tag]["attr"][el.attributes[i].nodeName] = el.attributes[i].nodeValue;
                }
            }
        }
    }
};
Object.defineProperties(Object.prototype,{
    each:{
        value:function(callback){
            for(var i in this) {
                callback(i, this[i]);
                /*
               if (object.hasOwnProperty(i)) {
                   callback(i, this[i]);
               }*/
            }
        }
    },
    get:{
        value:function(){
            return job.get(this);
        }
    },
    tagID:{
        value:function(){
            return document.getElementById(this);
        }
    },
    tagClass:{
        value:function(){
            return document.getElementsByClassName(this);
        }
    },
    tagName:{
        value:function(){
            return document.getElementsByTagName(this);
        }
    },
    attrNameAll:{
        value:function(){
            return document.querySelectorAll(this);
            //document.querySelectorAll('[someAttr]')
            //document.querySelector('[someAttr]')
        }
    },
    attrName:{
        value:function(){
            return document.querySelector(this);
        }
    }
});
document.addEventListener('DOMContentLoaded', function () {
    job.help();
});
