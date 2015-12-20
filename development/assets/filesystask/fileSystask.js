/*!
    fileSystask -- Javascript file System task
    Version 1.0.2
    https://khensolomonlethil.github.io/laisiangtho/fileSystask
    (c) 2013-2015
*/
(function(o) {
    'use strict';
    // TODO: none exists Method call(???) should do something?
    // TODO: callback return value(object,string) must be certain -> so far there isn't any array returned.
    // REVIEW: variables that being used here fileSystask, OS, Task and the 'ClassName' of course!
    // REVIEW: well checkout the comment line....
    // XXX: and Thanks to Atom Editor & NodeJs, without it 'fileSystask' will be probably looking for where to start or waiting for fileSystask.js to be loaded!
    // REVIEW: fn -> fileSystask
    window.requestfileSystask;
    window.resolvefileSystask;
    window[o] = function(Setting, Init) {
        var fileSystask = this,
            OS = {
                // Ok:false
            };
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
            Arguments:function(o,arg){
                for (var i in arg) {
                    if (arg.hasOwnProperty(i) && i == 0) {
                        o=Object.assign({},this.Callback,arg[i]);
                    }else if (arg.hasOwnProperty(i)) {
                        o=Object.assign({},this.Callback,o,arg[i]);
                    }
                }
                return o;
            },
            ReadAs:['readAsText','readAsArrayBuffer', 'readAsBinaryString', 'readAsDataURL'],
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
                    fileSystask.support=OS.Ok;
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
                                window.requestfileSystask=window.webkitRequestFileSystem;
                                window.resolvefileSystask=window.webkitResolveLocalFileSystemURL;
                                window.requestfileSystask(
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
                        window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestfileSystask) {
                            if (window.LocalFileSystem) {
                                window.PERSISTENT = window.LocalFileSystem.PERSISTENT;
                                window.TEMPORARY = window.LocalFileSystem.TEMPORARY;
                            } else if (window.cordova && location.protocol === 'file:') {
                                // window.PERSISTENT =window.PERSISTENT; window.TEMPORARY =window.TEMPORARY;
                            }
                            window.requestfileSystask(
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
                        window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.requestfileSystask(
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
                        // if (window.requestfileSystask) {
                        //     window.requestfileSystask(
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
                                // window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                                // window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                                window.requestfileSystask(
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
                        return window.requestfileSystask;
                    }
                },
                Cordova: function(done, error) {
                    try {
                        // window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        // window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestfileSystask) {
                            window.requestfileSystask(
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
                        return window.requestfileSystask;
                    }
                },
                Other: function(done, error) {
                    try {
                        // window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        // window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestfileSystask) {
                            window.requestfileSystask(
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
                        return window.requestfileSystask;
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
                                window.resolvefileSystask(url, done, error);
                            },
                            function(e) {
                                error(e);
                            }
                        );
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolvefileSystask;
                    }
                },
                Cordova: function(url, done, error) {
                    try {
                        // REVIEW: file:///example.txt
                        window.resolvefileSystask(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolvefileSystask;
                    }
                },
                Other: function(url, done, error) {
                    try {
                        window.resolvefileSystask(url, done, error);
                    } catch (e) {
                        error(e);
                    } finally {
                        return window.resolvefileSystask;
                    }
                }
            }
        };
        Task.Assigns(Setting);
        //=require fileSystask.utility.js
        //=require fileSystask.setting.js
        //=require fileSystask.permission.js
        //=require fileSystask.request.js
        //=require fileSystask.resolve.js
        //=require fileSystask.get.js
        //=require fileSystask.remove.js
        //=require fileSystask.download.js
        //=require fileSystask.save.js
    };
}('fileSystask'));
