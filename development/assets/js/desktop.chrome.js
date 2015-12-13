config.body.header={
	text:[
        {div:{
            text:[
				{div:{
					text:[{
						span:{text:config.name, attr:{class:"laisiangtho icon-fire"}}
					}], attr:{class:"logo"}
					}
				},
				{div:{
					text:[{
						div:{attr:{class:'container fA','data-fa':'title'}}
					}], attr:{class:"title"}
					}
				},
				{div:{
					text:[{
						ul:{
							text:[
								{li:{
									text:{a:{attr:{class:'about version fA icon-info',title:'Info'}}}
									}
								},
								{li:{
									text:{a:{attr:{class:'win minimize zO icon-minimize',title:'Minimize'}}}
									}
								},
								{li:{
									text:{a:{attr:{class:'win maximize zO icon-maximize',title:'Maximize',fn:'screen Max name'}}}
									}
								},
								{li:{
									text:{a:{attr:{class:'win close zO icon-close',title:'Close'}}}
									}
								}
							]
						}
					}], attr:{class:"win chrome"}
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
							]
						}
					}], attr:{class:"tab"}
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
										{a:{attr:{href:'#lookup?',class:'lookup result fA','data-fa':'msg',title:'Result'}}},
										{input:{attr:{name:"search",type:"button",value:''}}},
										{span:{attr:{class:'lookup setting fA icon-flag',title:'Setting'}}}
									], attr:{'for':'search'}
									}
								}
							], attr:{method:"get",action:'#lookup?',name:'lookup'}
						}
					},
					{
						div:{
							text:[
								{div:{attr:{id:'setting',class:'scrollbar'}}
								}], attr:{class:'hO'}
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
        },
        {div:{
            text:[
				{div:{
					text:[{
						div:{attr:{class:"container fA","data-fa":"msg"}}
					}], attr:{class:"box"}
					}
				}
			], attr:{class:"notification section"}
            }
        }
    ]
};
