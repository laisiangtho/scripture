/*!
    fileSystask -- Javascript file System task
    Version 1.0.0
    https://khensolomonlethil.github.io/laisiangtho/fileSystask
    (c) 2013-2015
*/
(function(o) {
    'use strict';
    // TODO: none exists Method call(???) should do something?
    // TODO: callback return value(object,string) must be certain -> so far there isn't any array returned.
    // REVIEW: variables that being used here fn, OS, Task and the 'ClassName' of course!
    // REVIEW: well checkout the comment line....
    // XXX: and Thanks to Atom Editor & NodeJs, without it 'fileSystask' will be probably looking for where to start or waiting for fileSystask.js to be loaded!
    window[o] = function(Setting, Init) {
        var fn = this,
            OS = {}; // Chrome,Cordova,Other,
        // NOTE: Method should return callback  success or error according to it's result!
        var Task = {
            base: {
                Chrome: {
                    RequestQuota: 1073741824,
                    // system:'window',
                    // Permission:[window.LocalFileSystem.PERSISTENT,'window.LocalFileSystem.TEMPORARY']
                    // ResponseQuota:0,
                    // Root:null,
                    // msg:{},
                    // status:{}
                },
                Cordova: {
                    RequestQuota: 0,
                    // system:'window',
                    // Permission:['window.PERSISTENT','window.TEMPORARY']
                    // ResponseQuota:0,
                    // Root:null,
                    // msg:{},
                    // status:{}
                },
                Other: {
                    RequestQuota: 0,
                    // system:'window',
                    // Permission:['window.PERSISTENT','window.TEMPORARY']
                    // ResponseQuota:0,
                    // Root:null,
                    // msg:{},
                    // status:{}
                }
            },
            message: {
                NoRequestFileSystem: 'No requestFileSystem API/Method'
            },
            extension: {
                mp3: {
                    ContentType: 'audio/mp3'
                },
                mp4: {
                    ContentType: 'audio/mp4'
                },
                txt: {
                    ContentType: 'text/plain'
                },
                css: {
                    ContentType: 'text/css'
                },
                avi: {
                    ContentType: 'video/x-msvideo'
                },
                html: {
                    ContentType: 'text/html'
                },
                mxml: {
                    ContentType: 'application/xv+xml'
                },
                rss: {
                    ContentType: 'application/rss+xml'
                },
                xml: {
                    ContentType: 'application/xml'
                },
                js: {
                    ContentType: 'application/javascript'
                },
                json: {
                    ContentType: 'application/json'
                },
                xhtml: {
                    ContentType: 'application/xhtml+xml'
                },
                pdf: {
                    ContentType: 'application/pdf'
                },
                jpg: {
                    ContentType: 'image/jpeg'
                },
                jpeg: {
                    ContentType: 'image/jpeg'
                },
                png: {
                    ContentType: 'image/png'
                },
                other: {
                    ContentType: 'text/plain',
                    Charset: 'UTF-8',
                    fileName: 'Uknown',
                    fileExtension: ''
                }
            },
            Assigns: function(i) {
                var defaultName = Object.keys(this.base).pop();
                if (i) {
                    if (typeof i === 'object') {
                        if (i.Base && this.base.hasOwnProperty(i.Base)) {
                            // NOTE: if Object contain one of these (Chrome, Cordova, Other)
                            Object.assign(OS, this.base[i.Base], i);
                        } else {
                            Object.assign(OS, this.base[defaultName], i, {
                                Base: defaultName
                            });
                        }
                    } else if (typeof i === 'string' && this.base[i]) {
                        // NOTE: if String is equal to one of these (Chrome, Cordova, Other)
                        Object.assign(OS, this.base[i], {
                            Base: i
                        });
                    } else {
                        Object.assign(OS, this.base[defaultName], {
                            Base: defaultName
                        });
                    }
                } else {
                    Object.assign(OS, this.base[defaultName], {
                        Base: defaultName
                    });
                }

                function errorResponse(e) {
                    if (typeof e === 'string') {
                        OS.message = e;
                    } else if (e.message) {
                        OS = e;
                    } else {
                        OS.message = e;
                    }
                    return f1(Init.error, OS);
                }
                new Promise(function(resolve, reject) {
                    Task.Initiate[OS.Base](
                        function(e) {
                            // NOTE: onDone
                            OS.Ok = true;
                            f1(Init.done, e);
                            resolve(e);
                        },
                        function(e) {
                            // NOTE: onError
                            OS.Ok = false;
                            errorResponse(e);
                            reject(e);
                        }
                    );
                }).then(function(e) {
                    fn.status = OS;
                    return e;
                }, function(e) {
                    return errorResponse(e);
                });
            },
            Initiate: {
                Chrome: function(done, error) {
                    // NOTE: see Chrome App API, navigator.webkitTemporaryStorage, navigator.webkitPersistentStorage (1024*1024*1024)
                    try {
                        navigator.webkitPersistentStorage.requestQuota(
                            OS.RequestQuota,
                            function(grantedBytes) {
                                OS.ResponseQuota = grantedBytes;
                                window.resolveLocalFileSystemURL = window.webkitResolveLocalFileSystemURL;
                                window.requestFileSystem = window.webkitRequestFileSystem(
                                    OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                                    grantedBytes,
                                    function(fileSystem) {
                                        OS.Root = fileSystem.root.toURL();
                                        done(fileSystem);
                                    },
                                    function(e) {
                                        error(e);
                                    }
                                );
                            },
                            function(e) {
                                error(e);
                            }
                        );
                    } catch (e) {
                        error(e);
                    } finally {
                        // 'No API';
                    }
                },
                Cordova: function(done, error) {
                    // NOTE: see Cordova API
                    try {
                        window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveLocalFileSystemURL = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestFileSystem) {
                            if (window.LocalFileSystem) {
                                window.PERSISTENT = window.LocalFileSystem.PERSISTENT;
                                window.TEMPORARY = window.LocalFileSystem.TEMPORARY;
                            } else if (window.cordova && location.protocol === 'file:') {
                                // window.PERSISTENT =window.PERSISTENT; window.TEMPORARY =window.TEMPORARY;
                            }
                            window.requestFileSystem(
                                OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                                OS.RequestQuota,
                                function(fileSystem) {
                                    OS.Root = fileSystem.root.toURL();
                                    done(fileSystem);
                                },
                                function(e) {
                                    error(e);
                                }
                            );
                        } else {
                            error(Task.message.NoRequestFileSystem);
                        }
                    } catch (e) {
                        error(e);
                    } finally {
                        // 'No API';
                    }
                },
                Other: function(done, error) {
                    // NOTE: see ??? API, probabbly Chrome is the only Browser that support!
                    try {
                        window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveLocalFileSystemURL = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.requestFileSystem(
                            OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                            OS.RequestQuota,
                            function(fileSystem) {
                                OS.Root = fileSystem.root.toURL();
                                done(fileSystem);
                            },
                            function(e) {
                                error(e);
                            }
                        );
                        // if (window.requestFileSystem) {
                        //     window.requestFileSystem(
                        //         OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                        //         OS.RequestQuota,
                        //         function(fileSystem) {
                        //             OS.Root = fileSystem.root.toURL();
                        //             done(fileSystem);
                        //         },
                        //         function(e) {
                        //             error(e);
                        //         }
                        //     );
                        // } else {
                        //     error('No FileSystem API');
                        // }
                    } catch (e) {
                        error(e);
                    } finally {
                        // 'No API';
                    }
                }
            },
            Request: {
                Chrome: function(done, error) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(
                            OS.RequestQuota,
                            function(grantedBytes) {
                                OS.ResponseQuota = grantedBytes;
                                window.requestFileSystem = window.webkitRequestFileSystem(
                                    OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                                    grantedBytes,
                                    function(fileSystem) {
                                        OS.Root = fileSystem.root.toURL();
                                        done(fileSystem);
                                    },
                                    function(e) {
                                        error(e);
                                    }
                                );
                            },
                            function(e) {
                                error(e);
                            }
                        );
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.webkitRequestFileSystem;
                    }
                },
                Cordova: function(done, error) {
                    try {
                        window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        if (window.requestFileSystem) {
                            window.requestFileSystem(
                                OS.Permission > 0 ? window.PERSISTENT : window.TEMPORARY,
                                OS.RequestQuota,
                                function(fileSystem) {
                                    done(fileSystem);
                                },
                                function(e) {
                                    error(e);
                                }
                            );
                        } else {
                            error(Task.message.NoRequestFileSystem);
                        }
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.requestFileSystem;
                    }
                },
                Other: function(done, error) {
                    try {
                        window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        if (window.requestFileSystem) {
                            window.requestFileSystem(
                                window.PERSISTENT,
                                OS.RequestQuota,
                                function(fileSystem) {
                                    done(fileSystem);
                                },
                                function(e) {
                                    error(e);
                                }
                            );
                        } else {
                            error(Task.message.NoRequestFileSystem);
                        }
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.requestFileSystem;
                    }
                }
            },
            Resolve: {
                Chrome: function(url, done, error) {
                    try {
                        // REVIEW: 'filesystem:http://localhost/temporary/myfile.png';
                        navigator.webkitPersistentStorage.requestQuota(
                            OS.RequestQuota,
                            function(grantedBytes) {
                                OS.ResponseQuota = grantedBytes;
                                window.resolveLocalFileSystemURL = window.webkitResolveLocalFileSystemURL(url, done, error);
                            },
                            function(e) {
                                error(e);
                            }
                        );
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveLocalFileSystemURL;
                    }
                },
                Cordova: function(url, done, error) {
                    try {
                        // REVIEW: file:///example.txt
                        window.resolveLocalFileSystemURL = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.resolveLocalFileSystemURL(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveLocalFileSystemURL;
                    }
                },
                Other: function(url, done, error) {
                    try {
                        window.resolveLocalFileSystemURL = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.resolveLocalFileSystemURL(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveLocalFileSystemURL;
                    }
                }
            }

        };
        Task.Assigns(Setting);
        this.setting = function(arg) {
            return Task.Assigns(arg);
        };
        this.permission = function() {};
        this.request = function(success, error) {
            if (OS.Ok === false) {
                return f1(error, OS);
            }
            return Task.Request[OS.Base](
                function(e) {
                    return f1(success, e);
                },
                function(e) {
                    if (typeof e !== 'string') {
                        if (e.message) {
                            e = e.message
                        }
                    }
                    return f1(error, e);
                }
            );
        };
        this.resolve = function(file, success, error) {
            if (OS.Ok === false) {
                return f1(error, OS);
            }
            // NOTE: OS.Root
            return Task.Resolve[OS.Base](
                file,
                function(e) {
                    return f1(success, e);
                },
                function(e) {
                    if (typeof e !== 'string') {
                        if (e.message) {
                            e = e.message
                        }
                    }
                    return f1(error, e);
                }
            );
        };
        this.get = function(Obj) {
            // NOTE: Obj{fileName,fileOption,fileObject,fileNotExists,fileError}
            return new Promise(function(resolve, reject) {
                Obj.fileSystem = {};
                fn.request(
                    function(fs, status) {
                        try {
                            Obj.fileSystem = fs;
                            Obj.fileStatus = {};
                            fs.root.getFile(Obj.fileName, Obj.fileOption,
                                function(fileEntry) {
                                    Obj.fileEntry = fileEntry;
                                    if (typeof Obj.fileObject === 'function') {
                                        Obj.fileObject.apply(Obj);
                                    }
                                    resolve(Obj);
                                },
                                function(e) {
                                    Obj.fileStatus = e;
                                    if (typeof Obj.fileNotExists === 'function') {
                                        Obj.fileNotExists.apply(Obj);
                                    }
                                    resolve(Obj);
                                }
                            );
                        } catch (e) {
                            f1(Obj.fileError, e.message ? e.message : {
                                message: e
                            });
                            reject(Obj);
                        } finally {}
                    },
                    function(e) {
                        f1(Obj.fileError, e.message ? e : {
                            message: e
                        });
                        reject(Obj);
                    }
                );
            }).then(function(e) {
                return e;
            }, function(e) {
                return e;
            });
        };
        this.download = function(Obj) {
            // Obj=Object.assign({},Obj);
            //{Before:function(){},Progress:function(){},Load:function(){},Error:function(){},Aborts:function(){}}
            return new Promise(function(resolve, reject) {
                var xmlHttp = (window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
                var Percentage = 0;
                xmlHttp.addEventListener("progress", function(e) {
                    Percentage++;
                    if (e.lengthComputable) {
                        Percentage = Math.floor(e.loaded / e.total * 100);
                        Obj.progress(Percentage);
                    } else if (xmlHttp.readyState == XMLHttpRequest.DONE) {
                        Obj.progress(100);
                    } else if (xmlHttp.status != 200) {
                        Obj.progress(Math.floor(Percentage / 7 * 100));
                        Percentage++;
                    }
                }, false);
                xmlHttp.addEventListener("load", function(e) {
                    // NOTE: promise should return responseText, responseType, responseURL and responseXML if success!
                    var fileUrl = e.target.responseURL;
                    var fileName = fileUrl.replace(/[\#\?].*$/, '').substring(fileUrl.lastIndexOf('/') + 1);
                    var fileExtension = fileName.split('.').pop();
                    // NOTE: these are required when saving....
                    var fileCharset, fileType;
                    if (e.target.responseXML) {
                        fileCharset = e.target.responseXML.charset;
                        fileType = e.target.responseXML.contentType;
                    } else {
                        fileCharset = 'UTF-8';
                        if (Task.extension[fileExtension]) {
                            fileType = Task.extension[fileExtension].ContentType;
                        }
                    }
                    // NOTE: Obj.Load() returned even 'Not Found'! since we might need to know the progress is completed,
                    // NOTE: therefore promise.then should determine the return value is object or not.
                    Obj.load(e);
                    if (xmlHttp.status == 200) {
                        resolve({
                            fileName: fileName,
                            fileOption: {
                                create: true
                            },
                            fileExtension: fileExtension,
                            fileUrl: fileUrl,
                            fileSize: e.total,
                            fileCharset: fileCharset,
                            fileType: fileType,
                            fileContent: e.target.responseText,
                            responseXML: e.target.responseXML
                        });
                    } else if (xmlHttp.status == 404) {
                        reject('Not Found: ' + xmlHttp.status);
                    } else {
                        reject('Error: ' + xmlHttp.status);
                    }
                }, false);
                xmlHttp.addEventListener("error", function(e) {
                    Obj.error(e);
                    reject(e);
                }, false);
                xmlHttp.addEventListener("abort", function(e) {
                    Obj.abort(e);
                    reject(e);
                }, false);
                // request.onreadystatechange = callbackMethod;
                // TODO: delete next line Obj.fileUrl
                // Obj.fileUrl='assets/jstest/deletes.mp3';
                if (Obj.fileCache) {
                    Obj.fileUrl = Obj.fileUrl + (Obj.fileUrl.indexOf("?") > 0 ? "&" : "?") + "timestamp=" + new Date().getTime();
                }
                xmlHttp.open(Obj.Method ? Obj.Method : 'GET', Obj.fileUrl, true);
                if (typeof Obj.before === 'function') {
                    Obj.before(xmlHttp);
                }
                // NOTE: how 'before' function should do!
                // xmlHttp.setRequestHeader("Access-Control-Allow-Origin", "*"); xmlHttp.withCredentials = true;
                xmlHttp.send();
            }).then(function(e) {
                return e;
            }, function(e) {
                Obj.error(e);
                return e;
            });
        };
        this.save = function(Obj) {
            return new Promise(function(resolve, reject) {
                // Obj.fileSystem={};
                fn.request(
                    function(fs, status) {
                        try {
                            fs.root.getFile(Obj.fileName, Obj.fileOption,
                                function(fileEntry) {
                                    fileEntry.createWriter(
                                        function(writer) {
                                            // IDEA: return Object and assign Object are merged, let me know if we should return just done or error
                                            // Object.assign(writer,Obj);
                                            writer.onwriteend = function() {
                                                // this.onwriteend = null; this.truncate(this.position);
                                                if (typeof Obj.done === 'function') {
                                                    Obj.done.apply(this);
                                                }
                                                resolve(writer);
                                            };
                                            writer.onerror = function(e) {
                                                f1(Obj.error, e.message ? e : {
                                                    message: e
                                                });
                                                reject(e);
                                            };
                                            if (!Obj.fileType) {
                                                if (Task.extension[Obj.fileExtension]) {
                                                    Obj.fileType = Task.extension[Obj.fileExtension].ContentType;
                                                } else {
                                                    Obj.fileType = Task.extension.other.ContentType;
                                                }
                                            }
                                            writer.write(new Blob([Obj.fileContent], {
                                                type: Obj.fileType
                                            }));
                                        }
                                    );
                                },
                                function(e) {
                                    Obj.fileStatus = e;
                                    reject(Obj);
                                }
                            );
                        } catch (e) {
                            Obj.fileStatus = e;
                            f1(Obj.error, e.message ? e.message : {
                                message: e
                            });
                            reject(Obj);
                        } finally {}
                    },
                    function(e) {
                        Obj.fileStatus = e;
                        f1(Obj.fileError, e.message ? e : {
                            message: e
                        });
                        reject(Obj);
                    }
                );
            }).then(function(e) {
                return e;
            }, function(e) {
                return e;
            })
        };

        function f1(n, e) {
            if (typeof n === 'function') {
                return n(e);
            } else {
                return e;
            }
        };
    };
}('fileSystask'));
/*
    Name: (javascript file system,requestFileSystem)
    fileSystem, localFiles, fileLocal, jDrive, fileRequest, fileTask, jDoctask, jFiletask, fileTask,  fileSystask
    fileDocal, file, fileSyctem, falSystem, fileDocuments, fileRequest, file, fileSystem

    lileSystem, letFileRequest
    FalRequest, LequestFile, FalRequest,jileSystem
    dokSystem, DudeDoc,LoadFileSystem, RequestFile, LocalFileRequest, LocalDocument,DocumentRequest, docalRequest
    localDok, docalFile, localFile,
    jRequest, jDocReqLoc,  jLocalDoc  jDoks, jLetRequest, lokalfileSystem

    Setup:
        var file=new fileSystask(
            {
                Base:Other, {Chrome,Cordova,Other} Default: Other
                RequestQuota:1073741824, {Bytes} Default: 0
                Permission:0 {1:PERSISTENT, 0:TEMPORARY} Default: TEMPORARY
            }
            {
                done:successCallback,
                error:errorCallback
            }
        );
        var file=new fileSystask();
        var file=new fileSystask('Chrome');
        var file=new fileSystask('Chrome',{});
        var file=new fileSystask(null,{});
*/
var file = new fileSystask({
    Base: 'Other', //[Chrome,Cordova,Other]
    RequestQuota: 1073741824, //Bytes
    Permission: 1
}, {
    done: function(fs, status) {
        // NOTE: successCallback, can be started from 'fs.root'!
        // REVIEW: Browser supports 'requestFileSystem'!
        console.warn('init.success', fs, status);
    },
    error: function(err) {
        // NOTE: errorCallback
        // NOTE: function executed to warn the Browser does not support 'requestFileSystem', message might be different Browser to Browser!
        console.log('init.error', err.message);
    }
});
// NOTE: how 'get' work!
// file.get(
//     {
//         // fileName:'styles.css',
//         fileName:'delete.css',
//         fileOption: {},
//         fileObject:function(/*fileSystem, fileEntry*/){
//             this.fileEntry.file(function(file) {
//                 var reader = new FileReader();
//                 reader.onloadend = function(e) {
//                     var txtArea = document.createElement('textarea');
//                     txtArea.value = this.result;
//                     document.body.appendChild(txtArea);
//                 };
//                 reader.readAsText(file);
//             }, function(file) {
//                 // console.warn(1, file);
//             });
//             var elem = document.createElement('link');
//             elem.rel = 'stylesheet';
//             elem.type = 'text/css';
//             elem.href = this.fileEntry.toURL();
//             document.head.appendChild(elem); //or document.body
//             // console.log('file.get.Object');
//         },
//         fileNotExists:function(/*fileSystem, fileStatus*/){
//             console.warn('fileNotExists',this.fileStatus);
//         },
//         fileError:function(status/*String or Object*/){
//             console.warn('s',status);
//         }
//     }
// ).then(function(e/*As Object -> e.fileSystem{if get success}, e.fileEntry{if found}, e.fileStatus{if not found}*/){
//     console.log('file.get.then',e);
// });
// NOTE: how 'download' work!
// file.download({
//     Method:'GET',
//     fileUrl:'assets/jstest/delete.css',
//     fileCache:true,
//     // fileUrl:'assets/jstest/include.Tmp.js',
//     // fileUrl:'assets/jstest/kjvCopy.xml',
//     // fileUrl:'//api.laisiangtho.com/laisiangtho/kjv.xml',
//     before:function(evt){
//         evt.setRequestHeader("Access-Control-Allow-Origin", "*");
//     },
//     progress:function(Percentage){
//         // REVIEW: as Web developer we mention what our scripts does or doing! this 'promise' is Promised to return max:'100'% at the end of progress!
//         console.log(Percentage);
//     },
//     load:function(evt){
//         // REVIEW: since we'd like to know the 'progress' is completed. however 'load' is executed even download url{is not success}!
//         console.log('load');
//     },
//     error:function(evt){
//         // REVIEW: occur on major error like 'NoAPI/Method'
//         console.log('error');
//     },
//     abort:function(evt){
//         console.log('abort');
//     }
// }).then(function(e){
//     console.log('then->',e);
// });
// NOTE: how 'save' work!
// file.save(
//     {
//         fileName:'style-new.css',
//         fileOption: {create:true},
//         fileExtension: 'css',
//         fileUrl: '',
//         fileSize: '',
//         fileCharset: '',
//         fileType: '',
//         fileContent:'body{color:#ccc;}',
//         responseXML: '',
//         done:function(/*fileSystem, fileEntry*/){
//             console.log('file.save.done');
//         },
//         error:function(status/*String or Object*/){
//             console.log('file.save.error');
//         }
//     }
// ).then(function(e){
//     console.log('save.then->',e);
// });
// NOTE: how 'download' then 'save' work!
file.download({
    Method: 'GET',
    fileUrl: 'assets/jstest/delete.css',
    fileCache: true,
    before: function(evt) {
        evt.setRequestHeader("Access-Control-Allow-Origin", "*");
    },
    progress: function(Percentage) {
        console.log(Percentage);
    },
    load: function(evt) {
        console.log('load');
    },
    error: function(evt) {
        console.log('error');
    },
    abort: function(evt) {
        console.log('abort');
    }
}).then(function(e) {
    file.save(e).then(function(s) {
        console.log(s);
    });
});
// OS={};
// ithis={
//     base:{
//         Chrome:{
//             love:0,
//             hate:1
//         },
//         Cordova:{
//             love:2,
//             hate:3
//         },
//         Other:{
//             love:4,
//             hate:5
//         }
//     }
// };
// var defaultName='Other'
// Object.assign(OS, ithis.base[defaultName], {
//     Base: 'Chrome'
// });

// console.log(file);
// file.request(
//     function(fs, status) {
//         // NOTE: successCallback
//         // console.warn('request.success', fs);
//         // e.root.getFile('style.css', { create: false }, Exists, NotExists);
//         fs.root.getFile('style.css', {
//                 create: false
//             },
//             function(fileEntry) {
//                 // NOTE: file Exists
//                 /*
//                 fileEntry.createWriter(
//                     function(writer) {
//                         // NOTE: Method
//                         this.onwriteend = function() {
//                             this.onwriteend = null;
//                             this.truncate(this.position); //in case a longer file was already here
//                         };
//                         var someCSSCode = 'body { color:#ccc; }';
//                         this.write(new Blob([someCSSCode], {type:'text/css'}));
//                         // NOTE: Method
//                         writer.onwriteend = function(e) {
//                             console.log('Write completed.');
//                         };
//                         writer.onerror = function(e) {
//                             console.log('Write failed: ' + e.toString());
//                         };
//                         // Create a new Blob and write it to log.txt.
//                         var blob = new Blob(['Lorem Ipsum'], {
//                             type: 'text/plain'
//                         });
//                         writer.write(blob);
//                     }
//                 );
//                 */
//                 // NOTE: show
//                 fileEntry.file(function(file) {
//                     var reader = new FileReader();
//                     reader.onloadend = function(e) {
//                         var txtArea = document.createElement('textarea');
//                         txtArea.value = this.result;
//                         document.body.appendChild(txtArea);
//                     };
//                     reader.readAsText(file);
//                 }, function(file) {
//                     // NOTE: file is
//                     console.warn(1, file);
//                 });
//                 // NOTE: link
// var elem = document.createElement('link');
// elem.rel = 'stylesheet';
// elem.type = 'text/css';
// elem.href = fileEntry.toURL();
// document.head.appendChild(elem); //or document.body
//             },
//             function(file) {
//                 // NOTE: file NotExists
//                 console.log(file);
//             }
//         );
//         /*
//         fs.root.getFile('style.css', {},
//             function(fileEntry) {
//                 fileEntry.file(function(file) {
//                     var reader = new FileReader();
//                     reader.onloadend = function(e) {
//                         var txtArea = document.createElement('textarea');
//                         txtArea.value = this.result;
//                         document.body.appendChild(txtArea);
//                     };
//                     reader.readAsText(file);
//                 }, function(file) {
//                     // NOTE: file is
//                     console.warn(1, file);
//                 });
//             },
//             function(file) {
//                 // NOTE: file NotExists
//                 console.warn(2, file);
//             }
//         );
//         */
//         // NOTE: how to remove
//         /*
//         fs.root.getFile('log.txt', {
//                 create: false
//             },
//             function(fileEntry) {
//                 fileEntry.remove(function() {
//                     // NOTE: removed
//                 }, function(file) {
//                     // NOTE: remove error
//                 });
//             },
//             function(file) {
//                 // NOTE: file NotExists
//             }
//         );
//         */
//         /*
//         fs.root.getFile('styles-.css', {},
//             function(file) {
//                 // NOTE: file Exists
//             },
//             function(file) {
//                 // NOTE: file NotExists
//                 // console.log(file);
//             }
//         );
//         */
//     },
//     function(err) {
//         // NOTE: errorCallback
//         console.error('request.error', err);
//     }
// );
// NOTE: how request work!
// file.request(
//     function(fs,status){
//         // NOTE: successCallback
//         console.warn('resolve.success');
//     },
//     function(err){
//         // NOTE: errorCallback
//         console.error('resolve.error',err);
//     }
// );
// NOTE: how resolve work!
// file.resolve(
//     'filesystem:http://localhost/persistent/style.css',
//     function(fs,status){
//         // NOTE: successCallback
//         console.warn('resolve.success');
//     },
//     function(err){
//         // NOTE: errorCallback
//         console.error('resolve.error',err);
//     }
// );
// document.addEventListener('DOMContentLoaded', function() {
//     var elem = document.getElementById("ClickMe"),
//         obj = {
//             handleEvent: function() {
//                 console.log(this.dude);
//             },
//             dude: "holla"
//         };
//     elem.addEventListener("click", obj, false);
// });
/*
Path = cordova.file.dataDirectory;
Local = cordova.file.dataDirectory + Filename;
*/
