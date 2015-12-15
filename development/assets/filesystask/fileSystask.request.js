this.request = function(success, error) {
    if (OS.Ok === false) {
        return f1(error, OS);
    }
    return Task.Request[OS.Base](
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
