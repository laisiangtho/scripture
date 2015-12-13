function fN(){
    this.abc='fN';
    this.f1=function(){
        console.log('this.f1');
    };
}
fA=fU=new fN();
fN.__proto__=fU.__proto__;
fA.__proto__=fU.__proto__;

fN.__proto__.f2=function(){
    console.log('fN.__proto__.f2');
};
fN.prototype.f3=function(){
    console.log('fN.prototype.f3');
};
/*
fN.dProperty('f4',{
    value:function(){
        console.log('fN.dProperty.f4');
    }
});
*/
fU.__proto__.f5=function(){
    console.log('fU.__proto__.f5');
};
fA.__proto__.f6=function(){
    console.log('fA.__proto__.f6');
};
/*
fN.f1();
fN.f2();
fN.f4();
fN.f1();
fN.f2();
fN.f4();
*/
/* YES
fU.f6();fU.f5();fU.f3();fU.f2();fU.f1();
fA.f6();fA.f5();fA.f3();fA.f2();fA.f1();
fN.f6();fN.f5();fN.f4();fN.f3();fN.f2();
this.fN().f6();this.fN().f5();this.fN().f3();this.fN().f2();this.fN().f1();
*/
this.fN().f1();
/* NO
fU.f4();fA.f4();fN.f1();this.fN().f4();

*/

//fA=new A();fN=new N();fU=new U();
fA.__proto__.a2=function(){
};
//EXTEND
var obj = {name: 'stack',finish: 'overflow'};
var replacement = {name:'function(){}',love:function(){console.log('love()');}};
obj.extend(replacement);
obj.love();
//CREATE OBJECT

//fA Core
function fA(){
    this.arguments=arguments;
    this.a1=function(x){
        return 'fA '+ q +' '+ x;
    };
}

A.prototype.a1=function(){
    var parentQuery=this.arguments[0], parentObj=this.arguments[1], currentQuery=arguments;
};
function fN(){
    this.arguments=arguments;
    this.a1=function(x){
        return 'fA '+ q +' '+ x;
    };
}
function fU(){
    this.arguments=arguments;
    this.a1=function(x){
        return 'fA '+ q +' '+ x;
    };
    this.requestFileSystem=function(success,error){
        window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,success,error);
    };
    this.resolveFileSystem=function(url,success,error){
        window.resolveLocalFileSystemURL(url,success,error);
    };
}
fU.prototype={
    //'ok'.fU().a2()
    //'not ok'.fU().a1()
    a2:function(){
        return 'html';
    }
};
//defineProperty
Object.defineProperty($fA,'a2',{
    value:function(){
        console.log('abc '+ q);
    }
});
//defineProperty using dProperty
fA.dProperty('apple',{
    value:function(){
        console.log('apple ok ');
    }
});
fA.apple();
//defineProperty for A read ARGUMENTS
A.prototype.testab=function(){
    var parentQuery=this.arguments[0], parentObj=this.arguments[1], currentQuery=arguments;
   //console.log(this.arguments[1],arguments[0]);
   console.log(parentObj);
  return 'fA.abc '+ 1 +' '+ 1;
};
Object.defineProperties(Object.prototype, {
    fA:{
        value:function(){
            return new fA(arguments,this);
        }
    },
    fU:{
        value:function(){
            return new fU(arguments,this);
        }
    },
    fN:{
        value:function(){
            return new fN(arguments,this);
        }
    },
    extend:{
        enumerable: false,
        value:function(x){
            var o=this;
            Object.getOwnPropertyNames(x).forEach(function(name) {
                o.dProperty(name, Object.getOwnPropertyDescriptor(x, name));
                //if(name in o)Object.defineProperty(o, name, Object.getOwnPropertyDescriptor(x, name));
            }); return this;
        }
    },
    dProperty:{
        value:function(n,v){
            Object.defineProperty(this, n, v);
        }
    },
    dProperties:{
        value:function(v){
            Object.defineProperties(this,v);
        }
    },
    createProperty:{
        value:function(n,v){
            this.dProperty(n, {value:v});
        }
    }
});