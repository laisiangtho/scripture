laisiangtho.prototype.win={
    full:{
        name:function(e){
            this.screen=e.arg[0];
        },
        is:function(x){
            if(x) {
                this.screen.addClass('icon-screen-small');
            } else {
                this.screen.removeClass('icon-screen-small');
            }
        }
    },
    max:{
        name:function(e){
            this.screen=e.arg[0];
        },
        is:function(x){
            if(x) {
                this.screen.addClass(config.css.winActive);
            } else {
                this.screen.removeClass(config.css.winActive);
            }
        }
    },
    Status:function(){
        if(window.screenStatus) {
            if(screenStatus.isFullscreen())this.full.is(true);
            if(screenStatus.isMaximized())this.max.is(true);
        }
    },
    minimize:function(){
        screenStatus.minimize();
    },
    maximize:function(event){
        if(screenStatus.isFullscreen() || screenStatus.isMaximized()) {
            screenStatus.restore();
        } else {
            screenStatus.maximize();
        }
    },
    fullscreen:function(x,b){
        if(screenStatus.isFullscreen()) {
            screenStatus.restore();
        } else {
            screenStatus.fullscreen();
        }
    },
    close:function(event){
        screenStatus.close();
    }
};
screenStatus.onBoundsChanged.addListener(function(){
});
screenStatus.onClosed.addListener(function(){
});
screenStatus.onRestored.addListener(function(){
    if(!screenStatus.isFullscreen())new laisiangtho().win.full.is();
    if(!screenStatus.isMaximized())new laisiangtho().win.max.is();
});
screenStatus.onFullscreened.addListener(function(){
    new laisiangtho().win.full.is(true);
});
screenStatus.onMaximized.addListener(function(){
    new laisiangtho().win.max.is(true);
});
screenStatus.onMinimized.addListener(function(){
});
screenStatus.focus();
