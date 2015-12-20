//fileRequest, fileCreator, fileReader, fileWriter, dirCreator, dirCheck, f1

function fileRequest(Obj,callback) {
    // NOTE: Obj{fileUrlLocal,fileOption}
    Obj.fileUrlLocal = Obj.fileUrlLocal.replace(/[\#\?].*$/, '');
    fileSystask.request(
        function(fs, status) {
            fs.root.getFile(Obj.fileUrlLocal, Obj.fileOption,
                function(fileEntry) {
                    // NOTE: file found or created if {create:true}
                    callback(1, fileEntry);
                    // REVIEW: with this callback (fileReader, fileWriter) can be call!
                },
                function(e) {
                    // NOTE: file not found!
                    callback(2, fs.root);
                    // REVIEW: with this callback (dirCreator and fileCreator) can be call!
                }
            );
        },
        function(e) {
            // NOTE: fileSystem Invalid
            callback(3, e);
        }
    );
};
function fileCreator(fileSystemRoot,Obj,callback) {
    // NOTE: Obj{fileUrlLocal,fileOption,fileContent,fileContentType}
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
    // NOTE: Obj{fileReadAs}
    fileEntry.file(
        function(file) {
            if(Obj.fileReadAs){
                // NOTE: Reading file...
                // REVIEW: https://developer.mozilla.org/en-US/docs/Web/API/FileReader
                var reader = new FileReader();
                reader.onloadstart = function(e) {
                    // NOTE: Reading file started
                    // callback(false, e);
                    Obj.before(e);
                };
                reader.onprogress = function(e) {
                    // NOTE: Reading file in progress"
                    // callback(false, e);
                    Obj.progress(e);
                };
                reader.onabort = function(e) {
                    // NOTE: Reading file cancal!
                    callback(false, e);
                };
                reader.onerror = function(e) {
                    // NOTE: Reading file fail!
                    callback(false, e);
                };
                // reader.onloadend = function(e) {
                //     // NOTE: Reading file done!
                //     callback(true, this.result);
                // };
                reader.onload = function(e) {
                    // NOTE: Reading file success!
                    callback(true, this.result);
                };
                if(Task.ReadAs === true){
                    Obj.fileReadAs = Task.ReadAs[0];
                } else if(Task.ReadAs.indexOf(Obj.fileReadAs) < 0){
                    Obj.fileReadAs = Task.ReadAs[0];
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
function fileRemover(fileEntry,Obj,callback) {
    fileEntry.remove(function(e) {
        // NOTE: remove success
        callback(true, e);
    },function(e){
        // NOTE: remove fail
        callback(false, e);
    });
};
function fileWriter(fileEntry,Obj,callback) {
    // NOTE: Obj{fileContent,fileContentType}
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
            // Obj.fileUrlLocal = Obj.fileUrlLocal.replace(/[\#\?].*$/, '');
            // if (!Obj.fileContentType) {
                // if (Task.extension[Obj.fileExtension]) {
                //     Obj.fileContentType = Task.extension[Obj.fileExtension].ContentType;
                // } else {
                //     Obj.fileContentType = Task.extension.other.ContentType;
                // }
            // }
            if (!Obj.fileContentType) {
                if(!Obj.fileExtension){
                    Obj.fileExtension = Obj.fileUrlLocal.split('.').pop();
                }
                if (Task.extension[Obj.fileExtension]) {
                    Obj.fileContentType = Task.extension[Obj.fileExtension].ContentType;
                } else {
                    Obj.fileContentType = Task.extension.other.ContentType;
                }
            }
            writer.write(new Blob([Obj.fileContent], {type:Obj.fileContentType}));
        },
        function(writer){
            // NOTE: Error!
            callback(false, writer);
        }
    );
};
function dirCreator(fileSystemRoot, folders, callback) {
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
};
function f1(n, e) {
    if (typeof n === 'function') {
        return n(e);
    } else {
        return e;
    }
};
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
                        callback(true, this.result);
                    };
                    reader.readAsText(file);
                },
                function(file){
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
