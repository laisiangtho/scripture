/*!
    fileSystask -- Javascript file System task
    Version 1.0.2
    https://khensolomonlethil.github.io/laisiangtho/fileSystask
    (c) 2013-2015
*/
/*
    FIXED
    - fileStatus is undefined,
    - create Global variables
    - init calback(succes,fail,done)
        - fail,done always return Object now!
    - Base:Other now also try if navigator.webkitPersistentStorage
*/
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
                done: complatedCallback, executed even success or error,
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
*/
(function(o) {
    'use strict';
    // TODO: none exists Method call(???) should do something?
    // TODO: callback return value(object,string) must be certain -> so far there isn't any array returned.
    // REVIEW: variables that being used here fn, OS, Task and the 'ClassName' of course!
    // REVIEW: well checkout the comment line....
    // XXX: and Thanks to Atom Editor & NodeJs, without it 'fileSystask' will be probably looking for where to start or waiting for fileSystask.js to be loaded!
    window.requestFileSystask;
    window.resolveFileSystask;
    window[o] = function(Setting, Init) {
        var fn = this,
            OS = {
                // Ok:false
            }; // Chrome,Cordova,Other
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
                RequestFileSystem: 'requestFileSystem API/Method supported!',
                NoRequestFileSystem: 'No requestFileSystem API/Method!',
                PleaseSeeStatus: 'Please see {status}!'
            },
            Callback:{
                before:function(){
                    // NOTE: before processing the task!
                },
                progress:function(){
                    // NOTE: while processing!  completed 'Percentage' return!
                },
                done:function(){
                    // NOTE: upon completion, either success or fail!
                },
                fail:function(){
                    // NOTE: only the task fail, if not success!
                },
                success:function(){
                    // NOTE: only the task success, if not fail
                }
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

                // function errorResponse(e) {
                //     if (typeof e === 'string') {
                //         OS.message = e;
                //     } else if (e.message) {
                //         OS = e;
                //     } else {
                //         OS.message = e;
                //     }
                //     return f1(Init.fail, OS);
                // }
                // Init=Object.assign({},Task.Callback,Init);
                new Promise(function(resolve, reject) {
                    Task.Initiate[OS.Base](
                        function(e) {
                            // NOTE: success
                            OS.Ok = true;
                            OS.message = Task.message.RequestFileSystem;
                            resolve(e);
                        },
                        function(e) {
                            // NOTE: fail
                            OS.Ok = false;
                            if (typeof e === 'string') {
                                OS.message = e;
                            } else if (e.message) {
                                OS.message = e.message;
                                if(e.name)OS.name = e.name;
                                if(e.code)OS.code = e.code;
                            } else {
                                OS.status = e;
                                OS.message = Task.message.PleaseSeeStatus;
                            }
                            reject(OS);
                        }
                    );
                }).then(function(e) {
                    f1(Init.success, e);
                }, function(e) {
                    f1(Init.fail, e);
                }).then(function(){
                    fn.support=OS.Ok;
                    f1(Init.done, OS);
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
                                window.requestFileSystask=window.webkitRequestFileSystem;
                                window.resolveFileSystask=window.webkitResolveLocalFileSystemURL;
                                window.requestFileSystask(
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
                        window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestFileSystask) {
                            if (window.LocalFileSystem) {
                                window.PERSISTENT = window.LocalFileSystem.PERSISTENT;
                                window.TEMPORARY = window.LocalFileSystem.TEMPORARY;
                            } else if (window.cordova && location.protocol === 'file:') {
                                // window.PERSISTENT =window.PERSISTENT; window.TEMPORARY =window.TEMPORARY;
                            }
                            window.requestFileSystask(
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
                        window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.requestFileSystask(
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
                        // if (window.requestFileSystask) {
                        //     window.requestFileSystask(
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
                        if(navigator.webkitPersistentStorage){
                            // console.log('must be Chrome');
                            this.Chrome(done, error);
                        }else{
                            error(e);
                        }
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
                                // window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                                // window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                                window.requestFileSystask(
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
                        return window.requestFileSystask;
                    }
                },
                Cordova: function(done, error) {
                    try {
                        // window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        // window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        // window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        if (window.requestFileSystask) {
                            window.requestFileSystask(
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
                        return window.requestFileSystask;
                    }
                },
                Other: function(done, error) {
                    try {
                        // window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
                        // window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        // window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestFileSystask) {
                            window.requestFileSystask(
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
                        return window.requestFileSystask;
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
                                window.resolveFileSystask(url, done, error);
                            },
                            function(e) {
                                error(e);
                            }
                        );
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveFileSystask;
                    }
                },
                Cordova: function(url, done, error) {
                    try {
                        // REVIEW: file:///example.txt
                        window.resolveFileSystask(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveFileSystask;
                    }
                },
                Other: function(url, done, error) {
                    try {
                        window.resolveFileSystask(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolveFileSystask;
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
            Obj=Object.assign({},Task.Callback,Obj);
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
                    var fileUrl = Obj.fileUrl;
                    var fileUrlResponse = e.target.responseURL;
                    var fileName = fileUrl.replace(/[\#\?].*$/, '').substring(fileUrl.lastIndexOf('/') + 1);
                    var fileUrlLocal = Obj.fileUrlLocal?Obj.fileUrlLocal:fileName;
                    var fileExtension = fileName.split('.').pop();
                    // NOTE: these are required when saving....
                    var fileCharset, fileContentType;
                    if (e.target.responseXML) {
                        fileCharset = e.target.responseXML.charset;
                        fileContentType = e.target.responseXML.contentType;
                    } else {
                        fileCharset = 'UTF-8';
                        if (Task.extension[fileExtension]) {
                            fileContentType = Task.extension[fileExtension].ContentType;
                        }
                    }
                    Obj.done(e);
                    if (xmlHttp.status == 200) {
                        resolve({
                            fileName: fileName,
                            fileOption: {
                                create: true,
                                exclusive: true
                            },
                            fileExtension: fileExtension,
                            fileUrl: fileUrl,
                            fileCharset: fileCharset,
                            fileContentType: fileContentType,
                            fileSize: e.total,
                            fileUrlLocal: fileUrlLocal,
                            fileContent: e.target.responseText,
                            responseXML: e.target.responseXML
                        });
                    } else if (xmlHttp.statusText) {
                        reject({message:xmlHttp.statusText+': '+ fileUrl,code:xmlHttp.status});
                    } else if(xmlHttp.status) {
                        reject({message:'Error',code:xmlHttp.status});
                    }else{
                        reject({message:'Unknown Error',code:0});
                    }
                }, false);
                xmlHttp.addEventListener("error", function(e) {
                    reject(e);
                }, false);
                xmlHttp.addEventListener("abort", function(e) {
                    reject(e);
                }, false);
                // request.onreadystatechange = callbackMethod;
                // TODO: delete next line Obj.fileUrl
                // Obj.fileUrl='assets/jstest/deletes.mp3';
                if (Obj.fileCache) {
                    Obj.fileUrlRequest = Obj.fileUrl + (Obj.fileUrl.indexOf("?") > 0 ? "&" : "?") + "_=" + new Date().getTime();
                }else{
                    Obj.fileUrlRequest = Obj.fileUrl;
                }
                xmlHttp.open(Obj.Method ? Obj.Method : 'GET', Obj.fileUrlRequest, true);
                Obj.before(xmlHttp);
                // NOTE: how 'before' function should do!
                // xmlHttp.setRequestHeader("Access-Control-Allow-Origin", "*");
                // xmlHttp.withCredentials = true;
                xmlHttp.send();
            }).then(function(e) {
                Obj.success(e);
                return e;
            }, function(e) {
                Obj.fail(e);
                return e;
            });
        };
        this.save = function(Obj) {
            Obj=Object.assign({},Task.Callback,Obj);
            return new Promise(function(resolve, reject) {
                fn.request(
                    function(fs, status) {
                        try {
                            if(typeof Obj !== 'object' || !Obj.fileName){
                                return reject(Obj);
                            }
                            Obj.fileUrlLocal=Obj.fileUrlLocal?Obj.fileUrlLocal:Obj.fileName;
                            fs.root.getFile(Obj.fileUrlLocal, Obj.fileOption,
                                function(fileEntry) {
                                    fileEntry.createWriter(
                                        function(writer) {
                                            // IDEA: return Object and assign Object are merged, let me know if we should return just done or error
                                            // Object.assign(writer,Obj);
                                            writer.onwriteend = function() {
                                                this.onwriteend = null; this.truncate(this.position);
                                                Obj.filefoldersCreatedFinal=true;
                                                resolve(fileEntry);
                                            };
                                            writer.onerror = function(e) {
                                                reject(e.message ? e : {
                                                    message: e
                                                });
                                            };
                                            if (!Obj.fileContentType) {
                                                if (Task.extension[Obj.fileExtension]) {
                                                    Obj.fileContentType = Task.extension[Obj.fileExtension].ContentType;
                                                } else {
                                                    Obj.fileContentType = Task.extension.other.ContentType;
                                                }
                                            }
                                            writer.write(new Blob([Obj.fileContent], {
                                                type: Obj.fileContentType
                                            }));

                                        }
                                    );
                                },
                                function(e) {
                                    if(Obj.filefoldersCreated){
                                        if(typeof Obj ==='object'){
                                            Obj.fileStatus = e;
                                        }else{
                                            Obj= e;
                                        }
                                        reject(Obj);
                                    }else{
                                        Obj.filefolders=Obj.fileUrlLocal.split('/').slice(0, -1);
                                        if(Obj.filefolders.length >= 1){
                                            Obj.filefoldersCreated=true;
                                                function ObjCreateDir(rootDirEntry, folders) {
                                                    if (folders[0] == '.' || folders[0] == '') {
                                                        folders = folders.slice(1);
                                                    }
                                                    rootDirEntry.getDirectory(folders[0], {create: true}, function(dirEntry) {
                                                        if (folders.length) {
                                                            ObjCreateDir(dirEntry, folders.slice(1));
                                                        }else{
                                                            resolve(fn.save(Obj));
                                                        }
                                                    }, function(e){
                                                        if(typeof Obj ==='object'){
                                                            Obj.fileStatus = e;
                                                        }else{
                                                            Obj= e;
                                                        }
                                                        reject(Obj);
                                                    });
                                                };
                                                ObjCreateDir(fs.root, Obj.filefolders);
                                        }else{
                                            if(typeof Obj ==='object'){
                                                Obj.fileStatus = e;
                                            }else{
                                                Obj= e;
                                            }
                                            reject(Obj);
                                        }
                                    }
                                }
                            );
                        } catch (e) {
                            reject(e.message?e.message:{message:e});
                        } finally {
                            if(Obj.filefoldersCreated){
                                if(Obj.filefoldersCreatedFinal){
                                    Obj.done(Obj);
                                }
                            }else {
                                Obj.done(Obj);
                            }
                        }
                    },
                    function(e) {
                        Obj.done(e);
                        reject(e.message?e:{message: e});
                    }
                );
            }).then(function(e) {
                if(Obj.filefoldersCreated){
                    if(Obj.filefoldersCreatedFinal){
                        Obj.success(e);
                    }
                }else {
                    Obj.success(e);
                }
                return e;
            }, function(e) {
                if(Obj.filefoldersCreated){
                    if(Obj.filefoldersCreatedFinal){
                        Obj.fail(e);
                    }
                }else {
                    Obj.fail(e);
                }
                return e;
            });
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
// var fileSystem = new fileSystask({
//     Base: 'Other',
//     RequestQuota: 1073741824,
//     Permission: 1
//     },
//     {
//         done: function(status) {
//             console.log('init.done', status);
//         },
//         fail: function(status) {
//             console.log('init.fail', status);
//         },
//         success: function(fs) {
//             console.warn('init.success', fs);
//         }
//     }
// );
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
//     done:function(evt){
//         // REVIEW: since we'd like to know the 'progress' is completed. however 'load' is executed even download is not success!
//         console.log('done');
//     },
//     fail:function(evt){
//         // REVIEW: occur on major error like 'NoAPI/Method'
//         console.log('fail');
//     },
//     success:function(evt){
//         console.log('success');
//     }
// }).then(function(e){
//     console.log('then->',e);
// });
// NOTE: how 'save' work!
// fileSystem.save(
//     {
//         fileName:'style-new.css',
//         fileOption: {create:true},
//         fileExtension: 'css',
//         // fileUrlLocal: 'del/fee/style-new.css',
//         fileUrlLocal: 'del/'+new Date().getTime()+'/style-new.css',
//         fileUrl: 'slsl/sss/style-new.css',
//         // fileSize: '',
//         // fileCharset: '',
//         // fileContentType: '',
//         fileContent:'body {color:#888;}',
//         // responseXML: '',
//         done:function(status/*String or Object*/){
//             console.log('file.save.done->',status);
//         },
//         fail:function(status/*String or Object*/){
//             console.log('file.save.fail->',status);
//         },
//         success:function(fileEntry/*fileSystem, fileEntry*/){
//             fileEntry.file(function(file) {
//                 var reader = new FileReader();
//                 reader.onloadend = function(e) {
//                     var txtArea = document.createElement('textarea');
//                     txtArea.value = this.result;
//                     document.body.appendChild(txtArea);
//                 };
//                 reader.readAsText(file);
//             });
//         }
//     }
// ).then(function(fileEntry/*fileEntry if success, if not status*/){
//     fileEntry.file(function(file) {
//         var reader = new FileReader();
//         reader.onloadend = function(e) {
//             var txtArea = document.createElement('textarea');
//             txtArea.value = this.result;
//             document.body.appendChild(txtArea);
//         };
//         reader.readAsText(file);
//     });
// });
// NOTE: how 'download' then 'save' work!
// fileSystem.download({
//     Method: 'GET',
//     fileUrl: 'assets/delete/deletes.css',
//     fileCache: false,
//     before: function(evt) {
//         evt.setRequestHeader("Access-Control-Allow-Origin", "*");
//     },
//     progress: function(Percentage) {
//         console.log(Percentage);
//     },
//     done: function(evt) {
//         console.log('download.done');
//     },
//     fail: function(evt) {
//         console.log('download.fail');
//     },
//     success: function(evt) {
//         console.log('download.success');
//     }
// }).then(function(e) {
//     console.log(e);
//     fileSystem.save(e).then(function(s) {
//         console.log('download.then.save.then',s);
//     });
// });
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
                // fileEntry.file(function(file) {
                //     var reader = new FileReader();
                //     reader.onloadend = function(e) {
                //         var txtArea = document.createElement('textarea');
                //         txtArea.value = this.result;
                //         document.body.appendChild(txtArea);
                //     };
                //     reader.readAsText(file);
                // }, function(file) {
                //     // NOTE: file is
                //     console.warn(1, file);
                // });
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
