laisiangtho.orange = function() {
    console.log("laisiangtho.__proto__.orange");
};

laisiangtho.inits = function() {
    console.log("laisiangtho.__proto__.init");
};

laisiangtho.Apple = function() {
    console.log("laisiangtho.prototype.apple", this.arg);
};

laisiangtho.DesktopLoad = function() {
    console.log("DesktopLoad");
};