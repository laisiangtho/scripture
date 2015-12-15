this.download = function(Obj) {
    Obj=Object.assign({},Task.Callback,Obj);
    return new Promise(function(resolve, reject) {
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
            // NOTE: promise should return responseText, responseType, responseURL and responseXML if success!
            var fileUrl = Obj.fileUrl;
            var fileUrlResponse = e.target.responseURL;
            var fileName = fileUrl.replace(/[\#\?].*$/, '').substring(fileUrl.lastIndexOf('/') + 1);
            var fileUrlLocal = Obj.fileUrlLocal?Obj.fileUrlLocal:fileName;
            var fileExtension = fileName.split('.').pop();
            // NOTE: these are required when saving....
            var fileCharset, fileContentType;
            if (e.target.responseXML) {
                fileCharset = e.target.responseXML.charset;
                fileContentType = e.target.responseXML.contentType;
            } else {
                fileCharset = 'UTF-8';
                if (Task.extension[fileExtension]) {
                    fileContentType = Task.extension[fileExtension].ContentType;
                }
            }
            Obj.done(e);
            if (xmlHttp.status == 200) {
                resolve({
                    fileName: fileName,
                    fileOption: {
                        create: true,
                        exclusive: true
                    },
                    fileExtension: fileExtension,
                    fileUrl: fileUrl,
                    fileCharset: fileCharset,
                    fileContentType: fileContentType,
                    fileSize: e.total,
                    fileUrlLocal: fileUrlLocal,
                    fileContent: e.target.responseText,
                    responseXML: e.target.responseXML
                });
            } else if (xmlHttp.statusText) {
                reject({message:xmlHttp.statusText+': '+ fileUrl,code:xmlHttp.status});
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
        xmlHttp.open(Obj.Method ? Obj.Method : 'GET', Obj.fileUrlRequest, true);
        Obj.before(xmlHttp);
        // NOTE: how 'before' function should do!
        // xmlHttp.setRequestHeader("Access-Control-Allow-Origin", "*");
        // xmlHttp.withCredentials = true;
        xmlHttp.send();
    }).then(function(e) {
        Obj.success(e);
        return e;
    }, function(e) {
        Obj.fail(e);
        return e;
    });
};
