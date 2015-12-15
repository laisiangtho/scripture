fileSystask -- _Javascript file System task_
========
Version 1.0.2

https://khensolomonlethil.github.io/laisiangtho/fileSystask

(c) 2013-2015

Name: (javascript file system,requestFileSystem)
fileSystem, localFiles, fileLocal, jDrive, fileRequest, fileTask, jDoctask, jFiletask, fileTask,  fileSystask
fileDocal, file, fileSyctem, falSystem, fileDocuments, fileRequest, file, fileSystem

lileSystem, letFileRequest
FalRequest, LequestFile, FalRequest,jileSystem
dokSystem, DudeDoc,LoadFileSystem, RequestFile, LocalFileRequest, LocalDocument,DocumentRequest, docalRequest
localDok, docalFile, localFile,
jRequest, jDocReqLoc,  jLocalDoc  jDoks, jLetRequest, lokalfileSystem

FIXED
- fileStatus is undefined,
- create Global variables
- init calback(succes,fail,done)
    - fail,done always return Object now!
- Base:Other now also try if navigator.webkitPersistentStorage


Setup:
```javascript
var file=new fileSystask(
    {
        Base:Other, //{Chrome,Cordova,Other} Default: Other
        RequestQuota:1073741824, //{Bytes} Default: 0
        Permission:0 //{1:PERSISTENT, 0:TEMPORARY} Default: TEMPORARY
    }
    {
        done: complatedCallback, //executed even success or error,
        fail: failCallback,
        success: successCallback
    }
);
var file=new fileSystask();
var file=new fileSystask('Chrome');
var file=new fileSystask('Chrome',{});
var file=new fileSystask(null,{});
var fileSystem = new fileSystask({
    Base: 'Cordova',
    RequestQuota: 1073741824,
    Permission: 1
}, {
    done: function(status) {
        // NOTE: complatedCallback, return value can be string, depend on success or error!
        // REVIEW: executed either succes or fail!
        console.log('init.done', status.message);
    },
    fail: function(status) {
        // NOTE: failCallback, return value can be string!
        // REVIEW: executed to warn the Browser does not support 'requestFileSystem', message might be different Browser to Browser!
        console.log('init.fail', status.message);
    },
    success: function(fs) {
        // NOTE: successCallback! Can be started from 'fs.root'!
        // REVIEW: Browser supports 'requestFileSystem'!
        console.warn('init.success', fs);
    }
});
```
Working
```javascript
var fileSystem = new fileSystask({
    Base: 'Other',
    RequestQuota: 1073741824,
    Permission: 1
    },
    {
        done: function(status) {
            console.log('init.done', status);
        },
        fail: function(status) {
            console.log('init.fail', status);
        },
        success: function(fs) {
            console.warn('init.success', fs);
        }
    }
);
```
NOTE: how **get** work!
```javascript
file.get(
    {
        // fileName:'styles.css',
        fileName:'delete.css',
        fileOption: {},
        fileObject:function(/*fileSystem, fileEntry*/){
            this.fileEntry.file(function(file) {
                var reader = new FileReader();
                reader.onloadend = function(e) {
                    var txtArea = document.createElement('textarea');
                    txtArea.value = this.result;
                    document.body.appendChild(txtArea);
                };
                reader.readAsText(file);
            }, function(file) {
                // console.warn(1, file);
            });
            var elem = document.createElement('link');
            elem.rel = 'stylesheet';
            elem.type = 'text/css';
            elem.href = this.fileEntry.toURL();
            document.head.appendChild(elem); //or document.body
            // console.log('file.get.Object');
        },
        fileNotExists:function(/*fileSystem, fileStatus*/){
            console.warn('fileNotExists',this.fileStatus);
        },
        fileError:function(status/*String or Object*/){
            console.warn('s',status);
        }
    }
).then(function(e/*As Object -> e.fileSystem{if get success}, e.fileEntry{if found}, e.fileStatus{if not found}*/){
    console.log('file.get.then',e);
});
```
NOTE: how **download** work!
```javascript
file.download({
    Method:'GET',
    fileUrl:'assets/jstest/delete.css',
    fileCache:true,
    // fileUrl:'assets/jstest/include.Tmp.js',
    // fileUrl:'assets/jstest/kjvCopy.xml',
    // fileUrl:'//api.laisiangtho.com/laisiangtho/kjv.xml',
    before:function(evt){
        evt.setRequestHeader("Access-Control-Allow-Origin", "*");
    },
    progress:function(Percentage){
        // REVIEW: as Web developer we mention what our scripts does or doing! this 'promise' is Promised to return max:'100'% at the end of progress!
        console.log(Percentage);
    },
    done:function(evt){
        // REVIEW: since we'd like to know the 'progress' is completed. however 'load' is executed even download is not success!
        console.log('done');
    },
    fail:function(evt){
        // REVIEW: occur on major error like 'NoAPI/Method'
        console.log('fail');
    },
    success:function(evt){
        console.log('success');
    }
}).then(function(e){
    console.log('then->',e);
});
```
NOTE: how **save** work!
```javascript
fileSystem.save(
    {
        fileName:'style-new.css',
        fileOption: {create:true},
        fileExtension: 'css',
        // fileUrlLocal: 'del/fee/style-new.css',
        fileUrlLocal: 'del/'+new Date().getTime()+'/style-new.css',
        fileUrl: 'slsl/sss/style-new.css',
        // fileSize: '',
        // fileCharset: '',
        // fileContentType: '',
        fileContent:'body {color:#888;}',
        // responseXML: '',
        done:function(status/*String or Object*/){
            console.log('file.save.done->',status);
        },
        fail:function(status/*String or Object*/){
            console.log('file.save.fail->',status);
        },
        success:function(fileEntry/*fileSystem, fileEntry*/){
            fileEntry.file(function(file) {
                var reader = new FileReader();
                reader.onloadend = function(e) {
                    var txtArea = document.createElement('textarea');
                    txtArea.value = this.result;
                    document.body.appendChild(txtArea);
                };
                reader.readAsText(file);
            });
        }
    }
).then(function(fileEntry/*fileEntry if success, if not status*/){
    fileEntry.file(function(file) {
        var reader = new FileReader();
        reader.onloadend = function(e) {
            var txtArea = document.createElement('textarea');
            txtArea.value = this.result;
            document.body.appendChild(txtArea);
        };
        reader.readAsText(file);
    });
});
```
NOTE: how **download** then **save** work!
```javascript
fileSystem.download({
    Method: 'GET',
    fileUrl: 'assets/delete/deletes.css',
    fileCache: false,
    before: function(evt) {
        evt.setRequestHeader("Access-Control-Allow-Origin", "*");
    },
    progress: function(Percentage) {
        console.log(Percentage);
    },
    done: function(evt) {
        console.log('download.done');
    },
    fail: function(evt) {
        console.log('download.fail');
    },
    success: function(evt) {
        console.log('download.success');
    }
}).then(function(e) {
    console.log(e);
    fileSystem.save(e).then(function(s) {
        console.log('download.then.save.then',s);
    });
});
```
NOTE: how **request** work!
```javascript
file.request(
    function(fs,status){
        // NOTE: successCallback
        console.warn('resolve.success');
    },
    function(err){
        // NOTE: errorCallback
        console.error('resolve.error',err);
    }
);
```
NOTE: how **resolve** work!
```javascript
file.resolve(
    'filesystem:http://localhost/persistent/style.css',
    function(fs,status){
        // NOTE: successCallback
        console.warn('resolve.success');
    },
    function(err){
        // NOTE: errorCallback
        console.error('resolve.error',err);
    }
);
document.addEventListener('DOMContentLoaded', function() {
    var elem = document.getElementById("ClickMe"),
        obj = {
            handleEvent: function() {
                console.log(this.dude);
            },
            dude: "holla"
        };
    elem.addEventListener("click", obj, false);
});
```
