
        // invoked when device is ready 
        function deviceInfo() {
            document.getElementById('window.device.phonegap').innerHTML = 'window.device.phonegap = ' + window.device.phonegap;
        }
        // register PhoneGap event listeners when DOM content loaded
        function init() {
            console.log('init()');
            document.addEventListener("deviceready", deviceInfo, true); 
        }
 
        // retrieves root file system entry
        var getFileSystemRoot = (function() {
            // private
            var root;
            
            // one-time retrieval of the root file system entry
            var init = function() {
                window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,
                    function(fileSystem) {
                        root = fileSystem.root;
                    }, 
                    onFileSystemError);
            };
            document.addEventListener("deviceready", init, true); 
            // public function returns private root entry
            return function() {
                return root;
            };
        }()); // execute immediately
        // file system error handler
        function onFileSystemError(error) {
            var msg = 'file system error: ' + error.code;
            navigator.notification.alert(msg, null, 'File System Error');
        }
        // logs file events
        function onFileEvent(event) {
            console.log('file event: ' + event.target.fileName + ' ' + event.type);
        }
      
        // called when error reading file
        function onFileError(event) {
            console.log('file error: ' + event.target.error.code);
        }
        // called when file is written
        function onFileWrite(event) {
            onFileEvent(event);
            console.log('FileWriter position=' + 
                event.target.position + ", length=" + event.target.length);
        }
        // writes a text file to the device
        function writeFile() {
                // root file system entry
            var root = getFileSystemRoot(),
            
                // writes a file
                write_file = function(writer) {
                    var lineCount = 1;
                              
                    // set the callbacks
                    writer.onwritestart = onFileEvent;
                    writer.onprogress = onFileEvent;
                    writer.onwrite = onFileWrite;
                    writer.onabort = onFileEvent;
                    writer.onerror = onFileError;
                    writer.onwriteend = function(event) {
                        onFileEvent(event);
                        lineCount += 1;
                        if (lineCount <= 3) {
                            // append a new line   
                            writer.write('Line ' + lineCount + '.\r\n');  
                        } 
                        else {
                            alert(writer.fileName + 
                                ' length=' + writer.length + 
                                ', position=' + writer.position);
                        }
                    }
                    
                    // append
                    writer.seek(writer.length);
          
                    // write to file
                    writer.write('Line ' + lineCount + '.\r\n');   
                },
                
                // creates a FileWriter object
                create_writer = function(fileEntry) {
                    fileEntry.createWriter(write_file, onFileSystemError);
                };
            
            // create a file and write to it
            root.getFile('bbgap.txt', {create: true}, create_writer, onFileSystemError);
        }
        
        // remove file system entry
        function removeFile() {
            var root = getFileSystemRoot();
            var remove_file = function(entry) {
                entry.remove(function() {
                    navigator.notification.alert(entry.toURI(), null, 'Entry deleted');                    
                }, onFileSystemError);
            };
            
            // retrieve a file and truncate it
            root.getFile('bbgap.txt', {create: false}, remove_file, onFileSystemError);
        } 