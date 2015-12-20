this.save = function(Obj) {
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        // NOTE: resolve, reject
        fileRequest(Obj,function(fileRequestHas,o) {
            if(fileRequestHas == 1){
                // NOTE: file found {o:fileEntry}
                fileWriter(o,Obj,function(isFileWritten, fileWriterMsg){
                    if(isFileWritten){
                        resolve(Obj);
                    } else {
                        reject(fileWriterMsg);
                    }
                });
            }else if(fileRequestHas == 2){
                // NOTE: file not found {o:fileSystemRoot}
                var isBecauseDir = dirCheck(Obj.fileUrlLocal);
                if(isBecauseDir){
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
                            reject(o);
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
};
