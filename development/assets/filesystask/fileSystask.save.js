this.save = function(Obj) {
    Obj=Object.assign({},Task.Callback,Obj);
    return new Promise(function(resolve, reject) {
        fileSystask.request(
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
                                                    resolve(fileSystask.save(Obj));
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
