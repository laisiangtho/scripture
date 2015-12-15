this.resolve = function(file, success, error) {
    if (OS.Ok === false) {
        return f1(error, OS);
    }
    // NOTE: OS.Root
    return Task.Resolve[OS.Base](
        file,
        function(e) {
            return f1(success, e);
        },
        function(e) {
            if (typeof e !== 'string') {
                if (e.message) {
                    e = e.message
                }
            }
            return f1(error, e);
        }
    );
};
