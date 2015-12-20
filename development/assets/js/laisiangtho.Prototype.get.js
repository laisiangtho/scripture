/*
Usage:
    <p class="x y z" id="a-b-c" fa="FA" fn="fN" title="Title!">string</p>

    f(*).get([id,class,href,content,tag,etc...])
    if not in the prototype found for what you are looking, you can use any 'attrName' as:
        f(*).get('attrName')
    supposed to be work as f(this).get(that).
    class and id return array in element

    f('#a-b-c').get('class')
        .name; return "x y z"
        .element; return array(x,y,z)
    f('#a-b-c').get('fn')
        .name; return "fN"
        .element; return undefined
*/
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
        y = y || ' ';
        return this.check().split(y);
    };
    this.fe = function(tmp) {
        if (d[x]) {
            this.element=this.split(d[x]);
        }
        return this;
    };
    if ($.isFunction(this[x])) {
        return this.fe(this[x]());
    } else if (this[x]) {
        return this[x];
    } else if (x) {
        return this.fe(this.attr());
    } else {
        return this;
    }
};
/*
Example
f($(.ClickTest)).get(class);
f(ClickTest).is(class).name -> .ClickTest
f(ClickTest).is(class).element -> $(.ClickTest)
f(ClickTest).is(class).get([id,class,href,content,tag]) -> []
*/
