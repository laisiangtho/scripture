this.download = function(Obj) {
    // NOTE: Obj{fileCache,Method,fileUrl}
    Obj=Task.Arguments(Obj,arguments);
    return new Promise(function(resolve, reject) {
        // NOTE: resolve, reject
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
            Obj.fileUrlResponse = e.target.responseURL;
            Obj.fileName = Obj.fileUrl.replace(/[\#\?].*$/, '').substring(Obj.fileUrl.lastIndexOf('/') + 1);
            Obj.fileExtension = Obj.fileName.split('.').pop();
            if(Obj.fileUrlLocal){
                // NOTE: Requested to save!
                if(Obj.fileUrlLocal === true){
                    // NOTE: if true, then extract path from url
                    var fileUrlLocalTmp = Obj.fileUrl.match(/\/\/[^\/]+\/([^\.]+)/);
                    if(fileUrlLocalTmp){
                        Obj.fileUrlLocal = fileUrlLocalTmp[1].replace(/[\#\?].*$/, '');
                    } else {
                        Obj.fileUrlLocal = Obj.fileUrl.replace(/[\#\?].*$/, '');
                    }
                } else {
                    Obj.fileUrlLocal = Obj.fileUrlLocal.replace(/[\#\?].*$/, '');
                }
            } else {
                Obj.fileUrlLocal=Obj.fileName;
            }
            if (e.target.responseXML) {
                Obj.fileCharset = e.target.responseXML.charset;
                Obj.fileContentType = e.target.responseXML.contentType;
            } else {
                Obj.fileCharset = 'UTF-8';
                if (Task.extension[Obj.fileExtension]) {
                    Obj.fileContentType = Task.extension[Obj.fileExtension].ContentType;
                }
            }
            Obj.responseXML = e.target.responseXML;
            Obj.responseURL = e.target.responseURL;
            if (xmlHttp.status == 200) {
                Obj.fileSize = e.total;
                Obj.fileContent = e.target.responseText;
                if(typeof Obj.fileOption == 'object' && Obj.fileOption.create === true && Obj.fileUrlLocal && OS.Ok === true){
                    fileRequest(Obj,function(fileRequestHas,o) {
                        if(fileRequestHas == 1){
                            // NOTE: file found {o:fileEntry}
                            fileWriter(o,Obj,function(isFileWritten, fileWriterMsg){
                                if(isFileWritten){
                                    Obj.fileCreation=true;
                                    resolve(Obj);
                                } else {
                                    Obj.fileCreation=fileWriterMsg;
                                    reject(Obj);
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
                                                Obj.fileCreation=true;
                                                resolve(Obj);
                                            }else{
                                                Obj.fileCreation=fileCreatorMsg;
                                                reject(Obj);
                                            }
                                        });
                                    } else{
                                        Obj.fileCreation=dirCreatorMsg;
                                        reject(Obj);
                                    }
                                });
                            } else {
                                Obj.fileCreation=o;
                                reject(Obj);
                            }
                        } else{
                            // NOTE: error {o:status response}
                            Obj.fileCreation=o;
                            reject(Obj);
                        }
                    });
                } else {
                    // NOTE: file Not to be saved!
                    Obj.fileCreation=false;
                    resolve(Obj);
                }
            } else if (xmlHttp.statusText) {
                reject({message:xmlHttp.statusText+': '+ Obj.fileUrl,code:xmlHttp.status});
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
        if(Obj.fileUrl){
            xmlHttp.open(Obj.requestMethod ? Obj.requestMethod : 'GET', Obj.fileUrlRequest, true);
            Obj.before(xmlHttp);
            // NOTE: how 'before' function should do!
            // xmlHttp.setRequestHeader("Access-Control-Allow-Origin", "*");
            // xmlHttp.withCredentials = true;
            xmlHttp.send();
        }else{
            reject({message:'fileUrl not provided',code:0});
        }
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
