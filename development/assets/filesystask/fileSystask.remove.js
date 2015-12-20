this.remove = function(Obj) {
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        fileRequest(Obj,function(fileRequestHas,o) {
            if(fileRequestHas == 1){
                // NOTE: file found {o:fileEntry}
                fileRemover(o,Obj,function(isFileRemoved, fileRemoverMsg){
                    if(isFileRemoved){
                        resolve(o);
                    } else {
                        reject(fileRemoverMsg);
                    }
                });
            }else if(fileRequestHas == 2){
                // NOTE: file not found {o:fileSystemRoot}
                if(Obj.fileNotFound){
                    // REVIEW: user set, to return 'success' When file is not Found! Obj.fileNotExists, Obj.fileNotFound
                    resolve(o);
                }else {
                    // NOTE: otherwise return fail!
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
