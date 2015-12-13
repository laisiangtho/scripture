config.body.header={
    text:[{div:{
        text:[{div:
                {text:[{
                    ul:{
                        text:[
                                {li:{
                                    text:{span:{text:config.name,attr:{class:'laisiangtho icon-fire',title:'Bible'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main book zO icon-info',href:'#info'}}}
                                    }
                                }
                            ]
                        }
                    }],
                    attr:{class:"tab"}
                }
            }], 
            attr:{class:"status section"}
        }
    }]
};
config.body.footer={
    text:[{div:
        {text:[{div:
            {text:[{
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
                    ]
                }
            }], attr:{class:"tab"}
            }
        }], 
        attr:{class:"status section"}
        }
    }]
};
config.header.book={
    text:[{div:
        {text:[{div:
            {text:[{
                ul:{
                    text:[
                        {li:{
                            text:{span:{text:'1',attr:{class:'testament new'}}}
                            }
                        },
                        {li:{
                            text:{span:{text:'2',attr:{class:'testament old'}}}
                            }
                        }
                        ],
                        attr:{class:"Mobile fA",'data-fa':'Testament'}
                    }
                }],
                attr:{class:"tab"}
            }
        }], attr:{class:"status section"}
        }
    }]
};
config.header.reader={
    text:[{div:
        {text:[{div:
            {text:[{
                ul:{
                    text:[
                        {li:{
                            text:{span:{attr:{class:'Mobile fA icon-bookmark','data-fa':'Bookmark'}}}
                            }
                        },
                        {li:{
                            text:{span:{attr:{class:'Mobile fA icon-fire','data-fa':'Chapter'}}}
                            }
                        },
                        {li:{
                            text:{span:{attr:{class:'Mobile fA icon-language','data-fa':'Parallel'}}}
                            }
                        },
                        {li:{
                            text:{a:{attr:{class:'lookup result fA icon-search',href:'#lookup','data-fa':'msg'}}}
                            }
                        }
                    ]
                }
                }],
                attr:{class:"tab"}
            }
        }], attr:{class:"status section"}
        }
    }]
};
config.footer.reader={
    text:[{div:
        {text:[{
            div:{
                text:[{
                    ul:{
                        text:[
                            {li:{
                                text:{span:{attr:{class:'chapter previous fA icon-previous','data-fa':'namePrevious',title:'Previous'}}}
                                }
                            },
                            {li:{
                                text:{span:{attr:{class:'chapter next fA icon-next','data-fa':'nameNext',title:'Next'}}}
                                }
                            },
                            {li:{
                                text:{a:{attr:{class:'main book zO icon-bible',title:'Book',href:'#book'}}}
                                }
                            },
                            {li:{
                                text:{a:{attr:{class:'main note zO icon-note',title:'Note',href:'#note'}}}
                                }
                            }
                        ]
                    }
                }], attr:{class:"tab"}
                }
            }], attr:{class:"status section"}
        }
    }]
};
config.header.lookup={
    text:[{
        div:{text:[{
            div:{
                text:[{
                    ul:{
                        text:[
                            {li:{
                                text:{span:{text:'search form',attr:{class:'search form'}}}
                                }
                            },
                            {li:{
                                text:{a:{attr:{class:'icon-search',href:'#lookup'}}}
                                }
                            }
                        ]
                        }
                    }],attr:{class:"tab"}
                }
            }], attr:{class:"status section"}
        }
    }]
};
config.footer.lookup={
    text:[{
        div:{text:[{
            div:{
                text:[{
                        ul:{
                            text:[
                                {li:{
                                    text:{span:{attr:{class:'chapter previous fA icon-previous','data-fa':'namePrevious',title:'Previous'}}}
                                    }
                                },
                                {li:{
                                    text:{span:{attr:{class:'chapter next fA icon-next','data-fa':'nameNext',title:'Next'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main book zO icon-bible',title:'Book',href:'#book'}}}
                                    }
                                },
                                {li:{
                                    text:{a:{attr:{class:'main note zO icon-chapter',title:'Note',href:'#reader'}}}
                                    }
                                }
                            ]
                        }
                    }], attr:{class:"tab"}
                }
            }], attr:{class:"status section"}
        }
    }]
};
config.header.note={
    text:[{div:{
        text:[{
                div:{
                    text:[{
                            ul:{
                            text:[
                                {li:{
                                    text:{span:{text:config.name,attr:{class:'laisiangtho icon-fire',title:'Bible'}}}
                                    }
                                }
                                ]
                            }
                        }],attr:{class:"tab"}
                    }
            }], attr:{class:"status section"}
        }
    }]
};
/*
laisiangtho.reader=function(){
	console.log('custom reader for mobile');
}

laisiangtho.lookup=function(){
	console.log('custom lookup for mobile');
}
*/