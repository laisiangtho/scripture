function Regex(q){
    // NOTE: fO.lang, bible
    var name=fO.lang[q.bible].name,info=bible.info,book,chapter,Start,End, setting={book:";",chapter:",",verse:"-"};
    this.result={};
    this.search=function(e){
        var y;
        for(var i in name){
            var x=name[i].map(function(value){
                return value.toLowerCase();
            }).indexOf(e.trim().toLowerCase());
            if(x >= 0){ y=i; break; }
        }
        return parseInt(y);
    };
    this.options=function(){
        if(!this.result[book])this.result[book]={};
        if(chapter <=info[book].c){
            var Verses=info[book].v[chapter-1];
            if(!this.result[book][chapter])this.result[book][chapter]=[];
            if(Start && End){
                var vs=(Start <= Verses)?Start:Verses,ve=(End <= Verses)?End:Verses;
                for (i = vs; i < ve+1; i++) { this.push(this.result[book][chapter],i); }
            }else if(Start){
                this.push(this.result[book][chapter],(Start <= Verses)?Start:Verses);
            }
        }else if(Object.getOwnPropertyNames(this.result[book]).length === 0){
            delete this.result[book];
        }
    };
    this.push=function(o,i){
        if(o.indexOf(i) <= 0){
            o.push(i); o.sort( function(a,b) { return a > b ? 1 : a < b ? -1 : 0; } );
        }
    };
    this.nameVerse=function(e){
        var verse;
        function dashed(str,n){
            var d=(str.toString().slice(-1)!=setting.verse)?setting.verse:'';
            return str+d+n;
        };
        e.filter(function(v, k, a){
            var c=parseInt(v), o=parseInt(a[k-1]), n=parseInt(a[k+1]);
            if(k==0){
                verse=c;
            }else if(c>=(o+1)){
                if(c>(o+1)){
                    verse=verse+setting.chapter+c;
                }else if((c+1)<n){
                    verse=dashed(verse,c);
                }else{
                    if(k==a.length-1){
                        if(c>o){
                            verse=dashed(verse,c);
                        }
                    }else{
                        verse=dashed(verse,'');
                    }
                }
            }
        });
        return verse;
    };
    //obj, object
    this.obj=function(e){
        for(var b in e) {
            book=b;
            for(var c in e[b]) {
                chapter=c;
                for(var v in e[b][c]) {
                    var R=e[b][c][v].split(setting.verse);
                    Start=parseInt(R[0]),End=(R.length>1)?parseInt(R[1]):false;
                    this.options();
                }
            }
        }
        return this;
    };
    //ref,reference
    this.ref=function(e){
        if(!Array.isArray(e))e=e.split(setting.book);
        for(var i in e) {
            var R=/(((\w+)\.(\d+)\.(\d+))([\-–]?)?((\w+)\.(\d+)\.(\d+))?)/.exec(e[i]);
            if(Array.isArray(R)){
                book=this.search(R[3]);
                if(book){ chapter=parseInt(R[4]),Start=parseInt(R[5]),End=parseInt(R[10]); this.options();}
            }
        }
        return this;
    };
    //str, string
    this.str=function(e){
        if(!Array.isArray(e))e=e.split(setting.book);
        for(var i in e) {
            if(e[i]){
                var c=e[i].trim().split(setting.chapter);
                for (var x in c) {
                    if(x==0){
                        var R=/(\d?(\w+?)?(\s?)\w+(\s+?)?(\s?)\w+(\s+?))?((\d+)((\s+)?\:?(\s+)?)?)((\d+)([\-–])?(\d+)?)?/.exec(c[x]);
                        if(R && R[1]){
                            book=this.search(R[1]);
                            if(book){ chapter=parseInt(R[8]),Start=parseInt(R[13]),End=parseInt(R[15]); this.options();}
                            else{ break; }
                        }else{ break; }
                    }else if(book){
                        var R=/(\s?(\d+?)(\s+)?\:(\s+)?)?(\s?\d+)?(\s?(\d+?)?([\-–])?(\s?\d+)?)/.exec(c[x]);
                        if(R){ chapter=parseInt(R[2])||chapter,Start=parseInt(R[5]), End=parseInt(R[9]); this.options();}
                        else{break;}
                    }
                }
            }
        }
        return this;
    };
    this.is=function(e){
        if(Object.getOwnPropertyNames(this.str(e).result).length > 0){
            return this.result;
        }else if(Object.getOwnPropertyNames(this.ref(e).result).length > 0){
            return this.result;
        }
    };
}
