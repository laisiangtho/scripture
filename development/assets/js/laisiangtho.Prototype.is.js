/*
Usage:
    <p class="x y z" id="a-b-c" fa="FA" fn="fN" title="Title!">string</p>

    f(*).is([id,class,href,content,tag,etc...])
    if not in the prototype found for what you are looking, you can use 'attr' as:
        f(*).is(attr)
    supposed to be work as f(this).is(what).get(that)
    .get([id,class,href,content,tag])

    f('a').is('class')
        .name; return ".a"
        .element; return jQuery

    f('a').is('class').get('title'));
    f('fa').is('attr').element return element
    f('fn').is('id').get('fa') return object
    f('fn').is('id').get('fa').element return element
    f('a-b-c').is('id').get('class').element return array(class)
    f('a-b-c').is('id').get('class').name return class
    f('a-b-c').is('id').name return id
    f('a-b-c').is('id').element return element
    f('x').is('class').element return element
    f('x').is('class').name return element
    f('p').is('tag').name return <p>
*/
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
