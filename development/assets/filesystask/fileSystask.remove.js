this.remove = function(Obj) {
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        fileSystask.request(
            function(fs, status) {
                fs.root.getFile(Obj.fileUrlLocal, Obj.fileOption,
                    function(fileEntry) {
                        fileEntry.remove(function(e) {
                            // NOTE: remove success
                            resolve(fileEntry);
                        },function(e){
                            // NOTE: remove fail
                            reject(e);
                        });
                    },
                    function(e) {
                        // NOTE: file not found!
                        if(Obj.fileNotFound){
                            // REVIEW: user set, to return 'success' When file is not Found! Obj.fileNotExists, Obj.fileNotFound
                            resolve(e);
                        }else {
                            // NOTE: otherwise return fail!
                            reject(e);
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
