var config = {
    name: "Lai Siangtho beta",
    description: "the Holy Bible",
    version: "1.1.7",
    build: "1.9.84",
    id: "laisiangtho",
    developer: "Khen Solomon Lethil",
    file: {
        bible: "xml",
        lang: "json",
        template: "z.html header, main, footer"
    },
    css: {
        active: "active",
        winActive: "cur",
        available: "now",
        notAvailable: "later",
        deactivate: "deactivate",
        header: "header",
        content: "main",
        footer: "footer",
        scrollbar: ".scrollbar-inner",
        working: "working",
        wait: "wait",
        disable: "disable"
    },
    bible: {
        available: [ "tedim", "mcl", "judson", "kjv", "bbe", "web", "hakha", "falam", "sizang", "paite", "mizo", "bokmal1906", "danish1933", "ostervald1877", "luther1912", "swedish1917", "niv", "finish1938" ],
        ready: 1
    },
    header: {},
    footer: {},
    page: [ "bible", "book", "reader", "lookup", "bookmark", "note", "setting", "more", "parallel", "about", "verse", "todo" ],
    google: {
        analytics: {
            permission: true,
            tracker: "UA-18644721-2"
        }
    },
    setting: {}
};

config.store = {
    name: config.id,
    info: "0",
    lang: "1",
    query: "2",
    lookup: "3",
    note: "4",
    noteData: {
        bookmarks: {
            name: "Bookmarks"
        },
        note: {
            name: "Notes"
        },
        pin: {
            name: "Pin"
        },
        map: {
            name: "Map"
        },
        message: {
            name: "Message"
        }
    }
};

config.language = {
    t: bible.testament,
    s: bible.section,
    b: bible.book,
    l: {
        bible: "Bible",
        book: "Book",
        chapter: "Chapter",
        verse: "Verse",
        lookup: "Lookup",
        setting: "Setting",
        more: "More",
        parallel: "Parallel",
        bookmarks: "Bookmarks",
        todo: "Todo",
        about: "About",
        note: "Note",
        BFCVB: "{b}...",
        BFVBC: "{b} {c}...",
        BFBCV: "{b} {c}:{v}...",
        Loading: "Loading",
        Checking: "Checking",
        Searching: "Searching",
        Downloading: "Downloading",
        PercentLoaded: "{Percent}%",
        Ready: "Ready",
        Error: "Error",
        Success: "Success",
        Discover: "Discover!",
        Paused: "Paused!",
        PleaseWait: "Please wait!",
        IsNotReady: "{is} not ready yet, for using!",
        WouldYouLikeToRemove: 'Would you like to remove "{is}" from local?',
        WouldYouLikeToAdd: 'Would you like to add "{is}" to local?',
        NotFound: "not found",
        IsNotFound: '"{is}" not found!',
        IsNotFoundIn: '"{is}" not found in {in}!',
        IsNotFoundInAt: '"{is}" not found in {in} at {at}!',
        Selection: "Selection",
        AddBookmarks: "Add Bookmarks",
        BookmarkedAlready: "Bookmarked already!",
        Bookmarked: "Bookmarked!",
        NoBookmarks: "No bookmarks!",
        NoMatchFor: "No matches for {for}!",
        BookMustSelected: "Book must be selected!",
        ChapterMustSelected: "Chapter must be selected!",
        VerseMustSelected: "Verse must be selected!",
        FoundV: "Found {v} verses!",
        FoundBCV: "Found book:{b}, chapter:{c} & verse:{v}!",
        NoBookSelected: "You have not selected any Book!",
        NoChapterSelected: "You have not selected any chapter!",
        NoVerseSelected: "You have not selected any verse!",
        ShowMe: "show me"
    },
    n: {},
    name: bible.name,
    info: {
        name: "",
        shortname: "",
        des: "",
        copyright: "",
        year: "",
        lang: "en"
    }
};

config.aboutcontent = 'is the continuous version of what we have released in 2008 that was saying <span>some how we wanna serve resource which may seem any sense with you</span>. There has been a huge improvement, and one of the biggest was running on Multi-platform such as Chrome OS, Mac, Windows & Linux. <a target="_blank" href="https://plus.google.com/u/0/communities/102261448761422230627">g+</a>';

config.developerlink = "https://plus.google.com/u/0/+KhenSolomonLethil/posts";