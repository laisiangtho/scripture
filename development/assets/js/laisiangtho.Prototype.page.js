Core.prototype.page={
    bible:function(){
        //=require laisiangtho.Prototype.page.bible.js
    },
    book:function(){
        //=require laisiangtho.Prototype.page.book.js
    },
    reader:function(){
        new Content(fO.query).chapter(fO.container.main.children());
    },
    lookup:function(){
        new Content(fO.query).lookup(fO.container.main.children());
    },
    note:function(){
        new Note(fO.query).page(fO.container.main.children());
    },
    todo:function(){
        //=require laisiangtho.Prototype.page.todo.js
    }
};
