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
