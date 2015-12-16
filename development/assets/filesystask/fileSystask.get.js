this.get = function(Obj) {
    // NOTE: Obj{fileName,fileOption,fileObject,fileNotExists,fileError}
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        fileSystask.request(
            function(fs, status) {
                fs.root.getFile(Obj.fileUrlLocal, Obj.fileOption,
                    function(fileEntry) {
                        if(Obj.fileOption.create === true && Obj.fileContent && Obj.fileContentType){
                            // NOTE: since fileContent and fileContentType are provided, it must be written!
                            fileWriter(fileEntry,Obj,function(isFileWritten, fileWriterMsg){
                                if(isFileWritten){
                                    resolve(fileWriterMsg);
                                } else {
                                    reject(fileWriterMsg);
                                }
                            });
                        } else {
                            // NOTE: just reading, if file is empty fileReaderMsg will be empty
                            fileReader(fileEntry,Obj,function(isFileRead, fileReaderMsg){
                                if(isFileRead){
                                    resolve(fileReaderMsg);
                                } else {
                                    reject(fileReaderMsg);
                                }
                            });
                        }
                    },
                    function(e) {
                        // NOTE: file not found!
                        if(typeof Obj.fileOption == 'object' && Obj.fileOption.create === true){
                            var isBecauseDir = dirCheck(Obj.fileUrlLocal);
                            if(isBecauseDir){
                                // NOTE: file not found, and can not create file because the given dir is not exists!
                                // NOTE: so we create according to user Obj.fileUrlRequest
                                dirCreator(fs.root, isBecauseDir, function(isDirCreated, dirCreatorMsg){
                                    if(isDirCreated){
                                        // NOTE: dir have been created, let create a file and write its content!
                                        fileCreator(fs.root,Obj,function(isFileCreated, fileCreatorMsg){
                                            if(isFileCreated){
                                                resolve(fileCreatorMsg);
                                            }else{
                                                reject(fileCreatorMsg);
                                            }
                                        });
                                    } else{
                                        // NOTE: fail to create dir, so we reject with message
                                        reject(hasMsg);
                                    }
                                });
                            } else {
                                // NOTE: we reject because there is nothing we can do!
                                reject(e);
                            }
                        } else {
                            // NOTE: since Obj.fileOption.create is not true, just reject!
                            if(Obj.fileNotFound){
                                // REVIEW: user set, to return 'success' When file is not Found! Obj.fileNotFound
                                resolve(e);
                            } else {
                                // NOTE: otherwise return fail!
                                reject(e);
                            }
                        }
                    }
                );
            },
            function(e) {
                // NOTE: fileSystem Invalid
                reject(e);
            }
        );
    }).then(function(e) {
        Obj.success(e);
        return e;
    }, function(e) {
        Obj.fail(e);
        return e;
    }).then(function(e){
        Obj.done(e);
        return e;
    });
};
/*
fs.root.getFile(Obj.fileUrlLocal, Obj.fileOption,
    function(fileEntry) {
        if(Obj.fileReadAs){
            fileEntry.file(function(file) {
                // NOTE: reading
                var reader = new FileReader();
                reader.onloadend = function(e) {
                    resolve(this.result);
                };
                if(Obj.fileReadAs === true){
                    Obj.fileReadAs = 'readAsText';
                }
                reader[Obj.fileReadAs](file);
                // reader.readAsText(file);
            },function(e){
                // NOTE: reading fail
                reject(e);
            });
            console.log(fileEntry);
        } else {
            resolve(fileEntry);
        }
    }
*/
function fileCreator(fileSystemRoot,Obj,callback) {
    fileSystemRoot.getFile(
        Obj.fileUrlLocal,
        Obj.fileOption,
        function(fileEntry){
            if(Obj.fileContent && Obj.fileContentType){
                // NOTE: since fileContent and fileContentType are provided, it must be written!
                fileWriter(fileEntry,Obj,function(isFileWritten, fileWriterMsg){
                    callback(isFileWritten, fileWriterMsg);
                });
            }else{
                // NOTE: just reading, if file is empty fileReaderMsg will be empty
                fileReader(fileEntry,Obj,function(isFileRead, fileReaderMsg){
                    callback(isFileRead, fileReaderMsg);
                });
            }
        },
        function(e){
            // NOTE: Creating file failed!
            callback(false, e);
        }
    );
};
function fileReader(fileEntry,Obj,callback) {
    fileEntry.file(
        function(file) {
            if(Obj.fileReadAs){
                // NOTE: Reading file success
                var reader = new FileReader();
                reader.onloadend = function(e) {
                    callback(true, this.result);
                };
                if(Obj.fileReadAs === true){
                    Obj.fileReadAs = 'readAsText';
                }
                reader[Obj.fileReadAs](file);
            } else {
                callback(true, fileEntry);
            }
        },
        function(file){
            // NOTE: Reading file failed!
            callback(false, file);
        }
    );
};
function fileWriter(fileEntry,Obj,callback) {
    fileEntry.createWriter(
        function(writer) {
            writer.onwriteend = function(e) {
                // NOTE: Writing file success!
                this.onwriteend = null;
                this.truncate(this.position); //in case a longer file was already here
                // console.log(e);
                callback(true, Obj.fileContent);
            };
            writer.onerror = function() {
                // NOTE: Writing file failed!
                callback(false, this);
            };
            writer.write(new Blob([Obj.fileContent], {type:Obj.fileType}));
        },
        function(writer){
            // NOTE: Error!
            callback(false, writer);
        }
    );
};
function dirCreator(fileSystemRoot, folders, callback) {
    // NOTE: fileSystemRoot = fs.root
    if (folders[0] == '.' || folders[0] == '') {
        folders = folders.slice(1);
    }
    fileSystemRoot.getDirectory(
        folders[0],
        {create: true},
        function(dirEntry){
            if (folders.length) {
                // NOTE: processing to sub dirs...
                dirCreator(dirEntry, folders.slice(1), callback);
            } else {
                // NOTE: Creating directory success!
                callback(true);
            }
        },
        function(e){
            // NOTE: Creating directory failed!
            callback(false, e);
        }
    );
};
function dirCheck(dir) {
    // NOTE: if Obj.fileUrlLocal has a listed directory, meaning having sub directorys
    var dirList = dir.split('/').slice(0, -1);
    if(dirList.length >= 1){
        return dirList;
    } else {
        return false;
    }
}
//Example for Writing and Reading
/*
function fileCreator(fileSystemRoot,Obj,callback) {
    //fileContent,fileType
    fileSystemRoot.getFile(
        Obj.fileUrlLocal,
        Obj.fileOption,
        function(fileEntry){
            fileEntry.createWriter(
                function(writer) {
                    this.onwriteend = function() {
                        // NOTE: Writing file success!
                        this.onwriteend = null;
                        this.truncate(this.position); //in case a longer file was already here
                        callback(true, this);
                    };
                    this.onerror = function() {
                        // NOTE: Writing file failed!
                        callback(false, this);
                    };
                    this.write(new Blob([Obj.fileContent], {type:Obj.fileType}));
                },
                function(writer){
                    // NOTE: Error!
                    callback(false, writer);
                }
            );
            fileEntry.file(
                function(file) {
                    var reader = new FileReader();
                    reader.onloadend = function(e) {
                        // NOTE: Reading file success!
                        // var txtArea = document.createElement('textarea');
                        // txtArea.value = this.result;
                        // document.body.appendChild(txtArea);
                        callback(true, this.result);
                    };
                    reader.readAsText(file);
                },
                function(file){
                    // console.log(2, file);
                    // NOTE: Reading file failed!
                    callback(false, file);
                }
            );
        },
        function(e){
            // NOTE: Creating file failed!
            callback(false, e);
        }
    );
};
*/
/*
fileEntry.createWriter(
    function(writer) {
        // NOTE: Method
        this.onwriteend = function() {
            this.onwriteend = null;
            this.truncate(this.position); //in case a longer file was already here
        };
        var someCSSCode = 'body { color:#ccc; }';
        this.write(new Blob([someCSSCode], {type:'text/css'}));
        // NOTE: Method
        writer.onwriteend = function(e) {
            console.log('Write completed.');
        };
        writer.onerror = function(e) {
            console.log('Write failed: ' + e.toString());
        };
        // Create a new Blob and write it to log.txt.
        var blob = new Blob(['Lorem Ipsum'], {
            type: 'text/plain'
        });
        writer.write(blob);
    }
);
*/
// return new Promise(function(resolve, reject) {
//     // Obj.fileSystem = {};
//     fileSystask.request(
//         function(fs, status) {
//             try {
//                 Obj.fileSystem = fs;
//                 Obj.fileStatus = {};
//                 fs.root.getFile(Obj.fileName, Obj.fileOption,
//                     function(fileEntry) {
//                         Obj.fileEntry = fileEntry;
//                         if (typeof Obj.fileObject === 'function') {
//                             Obj.fileObject.apply(Obj);
//                         }
//                         resolve(Obj);
//                     },
//                     function(e) {
//                         Obj.fileStatus = e;
//                         if (typeof Obj.fileNotExists === 'function') {
//                             Obj.fileNotExists.apply(Obj);
//                         }
//                         resolve(Obj);
//                     }
//                 );
//             } catch (e) {
//                 f1(Obj.fileError, e.message ? e.message : {
//                     message: e
//                 });
//                 reject(Obj);
//             } finally {}
//         },
//         function(e) {
//             f1(Obj.fileError, e.message ? e : {
//                 message: e
//             });
//             reject(Obj);
//         }
//     );
// }).then(function(e) {
//     return e;
// }, function(e) {
//     return e;
// });
