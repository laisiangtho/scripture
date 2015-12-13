// TODO: copy is and get to laisiangtho Prototype
document.addEventListener('DOMContentLoaded', function () {});
var fO={App:'win'};
(function(){
    var application='laisiangtho';
    // function f() {
    //     //f.*();__proto__ f().*();prototype
    //     var args=arguments;
    //     function extending(){
    //          Lai.apply(this, args);
    //     }
    //     extending.prototype = Object.create(Lai.prototype);
    //     extending.prototype.constructor = Lai;
    //     return new extending;
    // };
    // window[fO.App]=Object.create(Lai.prototype);
    // Object.prototype.f=Object.create(Lai,{
    //     hate: {
    //         value: function(){
    //             return this.name;
    //         }
    //     }
    // });
    // function f() {
    //     this.arg = arguments; this.name=Lai; this.element;
    //     Lai.prototype.constructor = this.name;
    //     Lai.prototype.arg= this.arg;
    //     return Object.create(Lai.prototype);
    //     return Object.create(Lai.prototype, {
    //         name: { value: "Lai Siangtho" },
    //         arg: { value: this.arg },
    //         element: { value: null }
    //     });
    // }
    // var Core=function() {
    //     this.arg = arguments; this.name=Core; this.element;
    //     return (this);
    // }
    // var f=window[fO.App]=function() {
    //     Core.prototype.constructor = Core;
    //     //Core.__proto__ = Core.prototype;
    //     Core.prototype.name;
    //     Core.prototype.element;
    //     Core.prototype.arg=arguments;
    //     return Object.create(Core.prototype);
    // }

})();
document.addEventListener('DOMContentLoaded', function () {
    // console.log(f('fa').is('attr').get('fn').split('-'));
    // console.log(f('data-fa').is('attr').element.attr('id'));
    // console.log(f('abc').is('attr').element.html('ssssssssssssss'));
    // console.log(f('a').bbb());
    // console.log(f('a').is('class').get('title'));
    // <p class="x y z" id="a-b-c" fa="FA" fn="fN" title="Title!">string</p>
    // console.log(f('fa').is('attr').element);// return element
    console.log(f('fn').is('id').get('fa'));// return object
    // console.log(f('fn').is('id').get('fa').element);// return element
    // console.log(f('a-b-c').is('id').get('class').element);// return array(class)
    // console.log(f('a-b-c').is('id').get('class').name);// return class
    // console.log(f('a-b-c').is('id').name);// return id
    // console.log(f('a-b-c').is('id').element);// return element
    // console.log(f('x').is('class').element);// return element
    // console.log(f('x').is('class').name);// return element
});
var application=this, Core = function() {
    this.arg = arguments;
    return (this);
}
var f=window[fO.App]=function() {
    var args = arguments;
    function x(){
         Core.apply(this, args);
    }
    x.prototype = Object.create(Core.prototype);
    x.prototype.constructor = Core;
    return new x;
};
Core.prototype.is = function(x) {
    var arg = this.arg[0], art='*';
    this.class = function() {
        return this.name = '.*'.replace(art, arg);
    };
    this.id = function() {
        return this.name = '#*'.replace(art, arg);
    };
    this.tag = function() {
        this.name = '<*>'.replace(art, arg);
        return arg;
    };
    this.link = function() {
        return this.name = 'link[rel="*"]'.replace(art, arg);
    };
    this.form = function() {
        return this.name = 'form[name="*"]'.replace(art, arg);
    };
    this.input = function() {
        return this.name = 'input[name="*"]'.replace(art, arg);
    };
    this.meta = function() {
        return this.name = 'meta[name="*"]'.replace(art, arg);
    };
    this.attr = function() {
        return this.name = '[*]'.replace(art, arg);
    };
    this.fn = function(tmp) {
        this.element = $(tmp);
        this.arg[0] = this.element;
        return this;
    };
    if ($.isFunction(this[x])) {
        return this.fn(this[x]());
    } else if (this[x]) {
        return this[x];
    } else {
        return this;
    }
};


Core.prototype.get = function(x) {
    var arg = this.arg[0],
        d = {
            id: '-',
            class: ' '
        };
    this.class = function() {
        return this.name = arg.attr('class');
    };
    this.id = function() {
        return this.name = arg.attr('id');
    };
    this.content = function() {
        return this.name = arg.attr('content');
    };
    this.href = function() {
        return this.name = arg.attr('href');
    };
    this.tag = function() {
        return this.name = arg.get(0).tagName;
    };
    // NOTE: f(*).get(*)
    this.attr = function() {
        return this.name = arg.attr(x);
    };
    this.check = function() {
        return this.name || '';
    };
    this.split = function(y) {
        return this.check().split(y);
    };
    this.fn = function(tmp) {
        if (d[x]) {
            this.element=this.split(d[x]);
        }
        return this;
    };
    if ($.isFunction(this[x])) {
        return this.fn(this[x]());
    } else if (this[x]) {
        return this[x];
    } else if (x) {
        return this.fn(this.attr());
    } else {
        return this;
    }
};
/*
Array.prototype.loop=function(callback){
    for (var i = 0, len = this.length; i < len; i++) {

        callback(i,this[i]);
    }
};
*/
/*
Core.prototype.loop = function(x) {

    for (var i = 0, len = fO.E.length; i < len; i++) {
        return callback();
        var j=fO.E[i],x = ($.type(j) === 'object') ? Object.keys(j)[0] : j;
        f(j[x]).exe(x.split(' '));
    }
}
*/

// var AppName='ll';
// //window[AppName]=
// function Mammal(){
//     this.args = arguments;
//     console.log('Mammal');
//     return this;
// }
// Mammal.prototype.breathe = function(){
//     console.log('Mammal.prototype.breathe',this.args[0]);
// }
// function Cat(){
//     this.args = arguments;
//     console.log('Mammal');
//     return this;
// }
// Cat.prototype = new Mammal();
// Cat.prototype.constructor = Cat;
// console.log(new Cat().breathe());

// f=function(){
//     console.log('f');
//     var args = arguments;
//     var constructor = Core;
//     function Fake(){
//          constructor.apply(this, args);
//     }
//     Fake.prototype = constructor.prototype;
//     //Fake.__proto__ = constructor.__proto__;
//     return new Fake;
// }
// Core.prototype.love = function(){
//     console.log('f.prototype.love',this.args[0]);
// }
// Object.prototype.f=f('-> sss');
// //new Core(' -> ok').breathe();
// //f('-> ok too').breathe();
// //f.breathe();
// //Core.breathe();
// Object.f.breathe();

/*
Function.prototype.f= function(){
    var args = arguments;
    var constructor = this;
    function Fake(){
         constructor.apply(this, args);
    }
    Fake.prototype = constructor.prototype;
    return new Fake;
}
function f(){
    return this;
}
f.prototype = new Core();
f.prototype.constructor = f;

*/
/*
var Core = function(){
    this.args = arguments;
    return this;
};
Core.prototype.breathe = function(){
    console.log('Mammal.prototype.breathe',this.args[0]);
}
this.__proto__ = new Core(arguments);
*/
/*
var f={
    name:'Lethil'
};
//f().breathe();
//Cat.f().breathe();
//Cat.breathe();
//f().breathe();

f().*()
f.*();
new Cat().breathe();
abc=new Mammal();
abc.breathe();
*/
// now cat too can breathe!
/*
f = new Core();
Core.prototype.c1 = function() {
    console.log('Core.prototype.c1');
};
Core.__proto__.c2 = function() {
    console.log('Core.__proto__.c2');
};

f.prototype.f1 = function() {
    console.log('f.prototype.f1');
};

f.__proto__.f2 = function() {
    console.log('f.__proto__.f2');
};

f().c2();
*/
//f.f2();
//Core().c1();
//Core.c2();
