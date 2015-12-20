fileSystask -- _Javascript file System task_
========
Version 1.0.3

https://khensolomonlethil.github.io/laisiangtho

(c) 2013-2015

Name: (javascript file system,requestFileSystem)
fileSystem, localFiles, fileLocal, jDrive, fileRequest, fileTask, jDoctask, jFiletask, fileTask,  fileSystask
fileDocal, file, fileSyctem, falSystem, fileDocuments, fileRequest, file, fileSystem

lileSystem, letFileRequest
FalRequest, LequestFile, FalRequest,jileSystem
dokSystem, DudeDoc,LoadFileSystem, RequestFile, LocalFileRequest, LocalDocument,DocumentRequest, docalRequest
localDok, docalFile, localFile,
jRequest, jDocReqLoc,  jLocalDoc  jDoks, jLetRequest, lokalfileSystem

#### FIXED
- fileStatus is undefined,
- create Global variables
- init calback(_succes, fail, done_)
    - fail,done always return Object now!
- Base: _Other now also try if navigator.webkitPersistentStorage_

#### TODO
- [ ] Initiation should be completed, before other Method execute!
- [x] fn -> fileSystask have been changed!
- [x] assigning multi arguments are completed!
- [x] arguments should be flexiable!

#### Prototype!
- [x] get (Ok) :sparkles:
- [x] download (Ok) :sparkles:
- [x] save (Ok) :sparkles:
- [x] remove (Ok) :sparkles:

:sparkles: :camel: :boom:

#### Setup:
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
    },
    {
        done: function(status) {
            // NOTE: complatedCallback, return value can be string, depend on success or error!
            // REVIEW: executed either success or fail!
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
    }
);
```
NOTE: how **get** work!

- if fileOption.create is true, fileContent, fileContentType are expected to be written!
- default {fileReadAs} is 'readAsText', can be used [readAsText, readAsArrayBuffer, readAsBinaryString, readAsDataURL]
```javascript
fileSystem.get({
    // fileName: null,
    fileOption: {
        create: false
    },
    // fileExtension: null,
    // fileUrl: null,
    // fileCharset: null,
    fileContentType: 'text/css',
    // fileSize: null,
    fileUrlLocal: 'styles/blue.css',
    fileReadAs: 'readAsText',
    fileContent: 'body { color:red;}',
    // responseXML: null,
    // responseURL: null,
    before: function(e) {
        // NOTE: before task!
        console.log('before',e);
    },
    progress: function(e) {
        // NOTE: task is in progress!
        console.log('progress',e);
    },
    done: function(e) {
        // NOTE: task completed, and always returned! (either in success or failure).
        console.log('done',e);
    },
    fail: function(e) {
        // NOTE: only when task fail
        console.error('fail',e);
    },
    success: function(e) {
        // NOTE: only when task successfully completed!
        console.warn('success',e);
    }
}).then(function(e) {
    // NOTE: arguments is depend of success or fail!
    console.log('get.then',e);
});
```
NOTE: how **download** work!
```javascript
fileSystem.download({
    requestMethod:'GET',
    // fileName: fileName,
    fileOption: {
        create: true
    },
    // fileExtension: fileExtension,
    fileUrl: 'assets/delete/style1.css?qer=love',
    // fileCharset: fileCharset,
    fileContentType: 'text/css',
    // fileSize: e.total,
    // fileUrlLocal: 'love/me/with.css', // if not provided, if the download success and if fileOption.create:true then file name from fileUrl will be use to save, if ===true then remove the domain
    // fileUrlLocal: 'delete/'+fileNameTmp+'/laisiangtho/tedim1.css?loev',
    fileReadAs: 'readAsTexts',
    fileContent: 'body { color:red;}',
    fileCreation: '', // return true if file is created or updated, if not its message
    // responseXML: e.target.responseXML,
    // responseURL: e.target.responseURL,
    before: function(e) {
        // NOTE: before task!
        console.log('download.before',e);
    },
    progress: function(e) {
        // NOTE: task is in progress!
        console.log('download.progress',e);
    },
    done: function(e) {
        // NOTE: task completed, and always returned either success or fail!
        console.log('download.done',e);
    },
    fail: function(e) {
        // NOTE: only task fail
        console.error('download.fail',e);
    },
    success: function(e) {
        // NOTE: only task successfully completed!
        console.warn('download.success',e);
    }
}).then(function(e) {
    // NOTE: arguments is depend of success or fail!
    console.log('download.done.then',e);
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
    requestMethod: 'GET',
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
NOTE: how **remove** work!
```javascript
fileSystem.remove({
    fileOption: {
        create: false
    },
    fileUrlLocal: 'laisiangtho/tedim.xml',
    fileNotFound: true, // if true return successCallback, even the file is not found!
    done: function(e) {
        // NOTE: task completed, and always returned either success or fail!
        console.log(e);
    },
    fails: function(e) {
        // NOTE: only task fail
        console.error(e);
    },
    success: function(e) {
        // NOTE: only task successfully completed!
        console.warn(e);
    }
}).then(function(e) {
    // NOTE: arguments is depend of success or fail!
    console.log(e);
});
```
NOTE: how **request** work!
```javascript
fileSystem.request(
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
fileSystem.resolve(
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
NOTE: how **Promise** process in Javascript!
```javascript
return new Promise(function(resolve, reject) {
    // NOTE: resolve, reject
}).then(function(e) {
    // NOTE: if success
    Obj.success(e);
    return e;
}, function(e) {
    // NOTE: if fail
    Obj.fail(e);
    return e;
}).then(function(e){
    // NOTE: when done
    Obj.done(e);
    return e;
});
```
