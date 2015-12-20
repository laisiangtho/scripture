this.get = function(Obj) {
    // NOTE: Obj{fileOption,fileUrlLocal,fileNotFound,fileContent,fileContentType}
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        fileRequest(Obj,function(fileRequestHas,o) {
            if(fileRequestHas == 1){
                // NOTE: file found {o:fileEntry}
                if(Obj.fileOption.create === true && Obj.fileContent && Obj.fileContentType){
                    fileWriter(o,Obj,function(isFileWritten, fileWriterMsg){
                        if(isFileWritten){
                            resolve(Obj);
                        } else {
                            reject(fileWriterMsg);
                        }
                    });
                } else {
                    fileReader(o,Obj,function(isFileRead, fileReaderMsg){
                        Obj.fileContent=fileReaderMsg;
                        if(isFileRead){
                            resolve(Obj);
                        } else {
                            reject(fileWriterMsg);
                        }
                    });
                }
            }else if(fileRequestHas == 2){
                // NOTE: file not found {o:fileSystemRoot}
                var isBecauseDir = dirCheck(Obj.fileUrlLocal);
                if(isBecauseDir && Obj.fileOption.create === true && Obj.fileContent && Obj.fileContentType){
                    dirCreator(o, isBecauseDir, function(isDirCreated, dirCreatorMsg){
                        if(isDirCreated){
                            fileCreator(o,Obj,function(isFileCreated, fileCreatorMsg){
                                if(isFileCreated){
                                    resolve(Obj);
                                }else{
                                    reject(fileCreatorMsg);
                                }
                            });
                        } else{
                            reject(dirCreatorMsg);
                        }
                    });
                } else {
                    reject(o);
                }
            } else{
                // NOTE: error {o:status response}
                reject(o);
            }
        });
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
