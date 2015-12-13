var config={
    name:'Lai Siangtho beta', version:'1.1.7', build:'1.9.85',id:'laisiangtho',developer:'Khen Solomon Lethil',
    file:{bible:'xml',lang:'json'},
    css:{active:'active',winActive:'cur',available:'now',notAvailable:'later',deactivate:'deactivate',header:'header',content:'main',footer:'footer',scrollbar:'.scrollbar-inner',working:'working',wait:'wait',disable:'disable'},
    //bible:["1966","tedim", "mcl", "judson", "kjv", "bbe", "web", "hakha", "falam", "sizang", "paite", "mizo", "bokmal1906", "danish1933", "ostervald1877", "luther1912", "swedish1917","niv"],
    bible:{
        //exclusive:["tedim","judson","kjv"],
        available:["tedim", "mcl", "judson", "kjv", "bbe", "web", "hakha", "falam", "sizang", "paite", "mizo", "bokmal1906", "danish1933", "ostervald1877", "luther1912", "swedish1917", "niv","finish1938"],
        ready:1//1=active,2=all
    },
    header:{}, footer:{},
    page:['bible','book','reader','lookup','bookmark','note','setting','more','parallel','about','verse','todo'],
    google:{
        analytics:{
            permission:true, tracker:'UA-18644721-2'
        }
    },
    setting:{}
};

config.store={
    name:config.id, version:4, info:'0', lang:'1', query:'2', lookup:'3', note:'4',
    noteData:{bookmarks:{name:'Bookmarks'},note:{name:'Notes'},pin:{name:'Pin'},map:{name:'Map'},message:{name:'Message'}}
};
//index,
config.language={
    t:bible.testament, s:bible.section, b:bible.book,
    l:{
        bible:'Bible',book:'Book',chapter:'Chapter',verse:'Verse',lookup:'Lookup',setting:'Setting',more:'More',parallel:'Parallel',bookmarks:'Bookmarks',todo:'Todo',about:'About',note:'Note',
        BFCVB:'{b}...', BFVBC:'{b} {c}...', BFBCV:'{b} {c}:{v}...',
        Loading:'Loading',Checking:'Checking', Searching:'Searching',Downloading:"Downloading",
        PercentLoaded:"{Percent}%",
        Ready:'Ready', Error:'Error', Success:'Success', Discover:'Discover!', Paused:'Paused!',
        PleaseWait:'Please wait!',
        IsNotReady:'{is} not ready yet, for using!',
        WouldYouLikeToRemove:'Would you like to remove "{is}" from local?',
        WouldYouLikeToAdd:'Would you like to add "{is}" to local?',
        NotFound:'not found', IsNotFound:'"{is}" not found!', IsNotFoundIn:'"{is}" not found in {in}!', IsNotFoundInAt:'"{is}" not found in {in} at {at}!',
        Selection:'Selection',
        AddBookmarks:'Add Bookmarks', BookmarkedAlready:'Bookmarked already!', Bookmarked:'Bookmarked!', NoBookmarks:'No bookmarks!',
        NoMatchFor:'No matches for {for}!',
        BookMustSelected:'Book must be selected!', ChapterMustSelected:'Chapter must be selected!', VerseMustSelected:'Verse must be selected!',
        FoundV:'Found {v} verses!', FoundBCV:'Found book:{b}, chapter:{c} & verse:{v}!',
        NoBookSelected:'You have not selected any Book!', NoChapterSelected:'You have not selected any chapter!', NoVerseSelected:'You have not selected any verse!',
        ShowMe:'show me'
    },
    n:{},
    name:bible.name,
    info:{name:'',shortname:'',des:'',copyright:'',year:'',lang:'en'}
};
config.loader={
    div:{text:[{
        div:{
            text:[
                {span:{attr:{class:'l1'}}},
                {span:{attr:{class:'l2'}}},
                {span:{attr:{class:'l2'}}}
            ],attr:{class:"loading"}
        }
    }
    ],attr:{id:'popup'}
    }
};
config.loader1={
    div:{
        text:'love',attr:{class:"abc"}
    }
};
config.body={
    header:{},
    main:{
        text:[
            {div:{attr:{class:'container fA','data-fa':'msg'}}},
            {div:{attr:{class:'bible book bookmark note setting todo'}}},
            {div:{
                text:[
                    {div:{
                        attr:{class:'con con-lookup d1'}
                        }
                    }
                ],
                attr:{class:"lookup"}
                }
            },
            {div:{
                text:[
                    {div:{
                        attr:{class:'con con-chapter d1',contenteditable:false}
                        }
                    }
                ],
                attr:{class:"reader"}
                }
            }
        ]
    },
    footer:{}
};
config.body.header={
    text:[
    {div:{
        text:[
            {div:{
                text:[
                    {
                    span:{text:config.name, attr:{class:"laisiangtho icon-fire"}}
                    }
                ], attr:{class:"logo"}
                }
            },
            {div:{
                text:[
                    {
                    div:{attr:{class:'container fA','data-fa':'title'}}
                    }
                ], attr:{class:"title"}
                }
            },
            {div:{
                text:[
                    {
                    ul:{
                        text:[
                            {li:{
                                text:{a:{attr:{href:"#setting",class:'page setting icon-setting',title:'Setting'}}}
                                }
                            },
                            {li:{
                                text:{a:{attr:{class:'page update icon-code',title:'Change'}}}
                                }
                            },
                            {li:{
                                text:{a:{attr:{class:'about version fA icon-info',title:'Info'}}}
                                }
                            }
                        ]
                    }
                }
                ], attr:{class:"win"}
                }
            }
        ], attr:{class:"main section"}
        }
    },
    {div:{
        text:[
            {div:{
                text:[{
                        ul:{
                            text:[
                                {li:{
                                    text:{a:{attr:{class:'main bible zO icon-cross',title:'Bible',href:'#bible',fn:'icon bible'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main book zO icon-bible',title:'Book',href:'#book'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main reader zO icon-chapter',title:'Chapter',href:'#reader'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main note zO icon-note',title:'Note',href:'#note'}}}
                                    }
                                }
                                /*
                                {li:{
                                    text:{a:{attr:{class:'main setting zO icon-setting',title:'Setting',href:'#setting'}}}
                                    }
                                }
                                */
                            ]
                        }
                    }
                ], attr:{class:"tab"}
                }
            },
            {div:{
                text:[{
                    form:{
                        text:[
                            {label:{
                                text:[
                                    {input:{attr:{name:"q",type:"text"}}}
                                ]}
                            },
                            {label:{
                                text:[
                                    {a:{text:'၁၂၆',attr:{href:'#lookup?',class:'lookup result fA','data-fa':'msg',title:'Result'}}},
                                    {input:{attr:{name:"search",type:"button",value:''}}},
                                    {span:{attr:{class:'lookup setting fA icon-flag',title:'Setting'}}}
                                ], attr:{for:'search'}
                                }
                            }
                        ], attr:{method:"get",action:'#lookup?',name:'lookup'}
                    }
                },
                {
                    div:{
                        text:[
                            {div:{
                                attr:{id:'setting',class:'scrollbar'}
                                }
                            }
                        ], attr:{class:'hO'}
                    }
                }
                ], attr:{class:"lookup"}
            }
            },
            {div:{
                    text:[{
                        div:{
                            text:[
                                {span:{attr:{class:'win fullscreen zO icon-screen-full',title:'Fullscreen',fn:'screen Full name'}}},
                                {span:{attr:{class:'chapter previous fA icon-previous','data-fa':'namePrevious',title:'Previous'}}},
                                {div:{text:[{
                                    span:{
                                        attr:{class:'chapter list fA','data-fa':'nameCurrent',title:'Chapter'}}
                                    },
                                    {
                                    div:{
                                        text:[
                                            {div:{attr:{id:'list',class:'scrollbar'}}}
                                        ], attr:{class:'hO'}
                                        }
                                    }]
                                }},
                                {span:{attr:{class:'chapter next fA icon-next','data-fa':'nameNext',title:'Next'}}}
                            ], attr:{class:"wrap"}
                        }
                    }], attr:{class:"control"}
                    }
            }], attr:{class:"status section"}
        }
    }
    ]
};
config.aboutcontent='is the continuous version of what we have released in 2008 that was saying <span>some how we wanna serve resource which may seem any sense with you</span>. There has been a huge improvement, and one of the biggest was running on Multi-platform such as Chrome OS, Mac, Windows & Linux. <a target="_blank" href="https://plus.google.com/u/0/communities/102261448761422230627">g+</a>';
config.developerlink='https://plus.google.com/u/0/+KhenSolomonLethil/posts';
