/*
var util =require('util');
var error=clc.red.bold, warn=clc.yellow, notice=clc.blue, success=clc.green;
*/
//DEFAULT
var path = require('path'),
    Argv = require('minimist')(process.argv);
//COMMON PACKAGE
var fs = require('fs-extra'),
    clc = require('cli-color'),
    extend = require('node.extend');
//REQUIRE PACKAGE
var Message = {
    "NoOS": "No OS specified: {-- --os=?}",
    "NoOSValid": "the specified: {os} is not valid",
    "DataCopied": "Data Copied...",
    "MsgOk": "Ok: {msg}",
    "MsgError": "{msg}"
};
// REQUIRE DATA
var Package = JSON.parse(fs.readFileSync('package.json'));
// SETTING, TASK
var Setting = {},
    Task = {
        todo: [],
        init: function() {
            if (Argv.os) {
                if (Package.config.individual.hasOwnProperty(Argv.os)) {
                    Setting = extend(true, Package.config.common, Package.config.individual[Argv.os]);
                    if (!Setting.development.main) Setting.development.main = Argv.os;
                    Setting.os = Argv.os;
                    Setting.unique = Setting.unique.replace('.n', process.env.npm_package_name).replace('.o', Argv.os).replace('.v', Setting.version).replace('.b', Setting.build);
                    Setting.development.dir = path.join(Setting.development.root);
                    Setting.production.dir = path.join(Setting.production.root, Setting.unique);
                    Task.create.production(Setting.production.dir, function(msg) {
                        console.log('Creating', Setting.os);
                        Task.read.development(Setting.development.dir, function(file, state) {
                            Task.todo.push(file);
                        });
                        Task.copy(function() {
                            console.log('Copied development');
                            Task.todo.push({
                                'src': path.join('image', Setting.os),
                                'des': path.join(Setting.production.dir, 'img')
                            });
                            Task.copy(function() {
                                console.log('Copied image');
                                Task.todo.push({
                                    'src': path.join('configuration', Setting.os),
                                    'des': Setting.production.dir
                                });
                                Task.copy(function() {
                                    console.log('Copied configuration');
                                });
                            });
                        });
                    });
                } else {
                    Task.exit(Message.NoOSValid.replace('{os}', Argv.os));
                }
            } else {
                Task.exit(Message.NoOS);
            }
        },
        create: {
            production: function(dir, callback) {
                dir.Exists(function(err) {
                    if (err) {
                        //directory exists
                        dir.Empty(function(err) {
                            //make it empty
                            if (err) {
                                Task.exit(err);
                            } else {
                                callback('current directory destroyed and rebuild empty!');
                            }
                        });
                    } else {
                        //new directory
                        dir.Create(function(err) {
                            if (err) {
                                Task.exit(err);
                            } else {
                                callback('new directory created!');
                            }
                        });
                    }
                });
            }
        },
        read: {
            development: function(o, callback) {
                fs.readdirSync(o).forEach(function(fileName) {
                    var dir = path.join(o, fileName);
                    var file = path.parse(dir);
                    var state = fs.statSync(dir);
                    if (state.isFile()) {
                        file.src = dir;
                        var dirName = file.dir.split(path.sep).pop();
                        if (dirName == Setting.development.root) {
                            if (Setting.development.main == file.name) {
                                if (file.ext == '.html') {
                                    file.des = path.join(Setting.production.dir, Setting.production.main + file.ext);
                                } else {
                                    file.des = path.join(Setting.production.dir, fileName);
                                }
                                callback(file, state);
                            }
                        } else {
                            if (Object.keys(Setting.production.file[dirName]).every(function(reg) {
                                    return new RegExp(reg).test(fileName) === Setting.production.file[dirName][reg];
                                })) {
                                file.des = path.join(dir.replace(Setting.development.root, Setting.production.dir));
                                callback(file, state);
                            }
                        }
                    } else if (state.isDirectory()) {
                        if (Setting.production.file.hasOwnProperty(fileName)) Task.read.development(dir, callback);
                    }
                });
            }
        },
        copy: function(callback) {
            if (Task.todo.length) {
                var file = Task.todo.shift();
                file.Copy(function(err) {
                    if (err) {
                        Task.msg.error(Message.MsgError.replace('{msg}', err));
                    } else {
                        Task.msg.success(Message.MsgOk.replace('{msg}', file.src));
                    }
                    Task.copy(callback);
                });
            } else {
                callback();
            }
        },
        msg: {
            error: function(msg) {
                console.log(clc.red(msg));
            },
            success: function(msg) {
                console.log(clc.green(msg));
            }
        },
        exit: function(msg) {
            Task.msg.error(msg);
            process.exit(0);
        }

    };
Object.defineProperties(Object.prototype, {
    Exists: {
        value: function(callback) {
            //callback(fs.existsSync(this.toString()));
            fs.exists(this.toString(), function(error) {
                callback(error);
            });
        }
    },
    Create: {
        value: function(callback) {
            fs.ensureDir(this.toString(), callback);
        }
    },
    Empty: {
        value: function(callback) {
            fs.emptyDir(this.toString(), callback);
        }
    },
    Copy: {
        value: function(callback) {
            fs.copy(this.src.toString(), this.des.toString(), function(error) {
                callback(error);
            });
        }
    },
    Read: {
        value: function(callback) {
            var o = this.toString();
            fs.readdirSync(o).forEach(function(fileName) {
                var dir = path.join(o, fileName);
                var file = path.parse(dir);
                var state = fs.statSync(dir);
                //file.src=dir;
                //file.dest='';
                callback(dir, file, state);
            });
        }
    }
});
Task.init();
