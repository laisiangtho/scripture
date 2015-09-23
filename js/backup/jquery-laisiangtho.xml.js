				var o=z.utility.Url(config.id,[q.bible],config.file.bible);
				var xml={
					get:function(){
						if($.isEmptyObject(lai[q.bible].bible)){
							if(sO.isCordova){
								z.load.loading();
								window.resolveLocalFileSystemURL(o.local, xml.local.content, xml.local.download);
							}else{
								db.get({table:q.bible}).then(function(storeBible){
									if(storeBible){
										lai[q.bible].bible=storeBible;
										if($.isEmptyObject(lai[q.bible].bible)){
											xml.load();
										}else{
											xml.done({msg:'from Store',status:true});
										}
									}else{
										xml.load();
									}
								});
							}
						}else{
							this.done({msg:'Already load',status:true});
						}
					},
					load:function(x){
						$.ajax({
							//headers:{}, xhrFields:{"withCredentials": true},
							xhr:function(){
								var xhr=new window.XMLHttpRequest();
								xhr.addEventListener("progress", function(evt){
									if(evt.lengthComputable) {
										var Percentage=Math.floor(evt.loaded / evt.total * 100);
										xml.msg(lD.l.PercentLoaded.replace("{Percent}", z.utility.Num(Percentage)));
									}else{
										xml.msg(lD.l.Downloading);
									}
								}, false);
								/*
								//Upload progress
								XMLHttpRequest.upload.addEventListener("progress", function(evt){
									if(evt.lengthComputable) {
										var Percent=Math.floor(evt.loaded / evt.total * 100);
										xml.msg(lD.l.PercentLoaded.replace("{Percent}", Percent));
									}else{
										xml.msg(lD.l.Downloading);
									}
								}, false); 
								*/
								return xhr;
							},
							url:(x)?x+o.url:o.url,dataType:o.data,contentType:o.content,cache:false,crossDomain:true,async:true,
							beforeSend:function(xhr){
								xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
								z.load.loading();
							}
						}).done(function(j, status, d){
							xml.jobType(j);
						}).fail(function(jqXHR, textStatus){
							if(api){
								if(x){
									xml.done({msg:textStatus,status:false});
								}else{
									z.load.loaded();
									xml.load(api);
								}
							}else{
								xml.done({msg:textStatus,status:false});
							}
						}).always(function(){});
					},
					local:{
						download:function(){
							var fileTransfer = new FileTransfer();
							fileTransfer.onprogress = function(evt) {
								if (evt.lengthComputable) {
									var Percentage = Math.floor(evt.loaded / evt.total * 100);
									xml.msg(lD.l.PercentLoaded.replace("{Percent}", z.utility.Num(Percentage)));
								} else {
									xml.msg(lD.l.Downloading);
								}
							};
							fileTransfer.download(encodeURI(api+o.url), o.local, xml.local.content, xml.local.error);
						},
						content:function(fileEntry){
							fileEntry.file(function(file) {
								//file.name, file.localURL, file.type, new Date(file.lastModifiedDate), file.size
								var reader=new FileReader();
								reader.onloadend=function(e){
									var parser=new DOMParser();
									xml.jobType(parser.parseFromString(e.target.result,o.type));
								};
								reader.readAsText(file);
							},function(error){
								xml.done({msg:'error on Reading',status:false});
							});
						},
						error:function(error){
							xml.done({msg:'Unable to Download',status:false});
						}
					},
					jobType:function(j){
						var jobType=$(j).children().get(0).tagName;
						if($.isFunction(xml.job[jobType])){
							lai[q.bible].bible={id:q.bible,info:{},book:{}};
							this.job[jobType](j);
						}else{
							this.done({msg:'no '+jobType+' Method found',status:false});
						}
					},
					job:{
						bible:function(j){
							var theTitle=[], theRef=[], index=0;
							$(j).children().each(function(o,i1){
								var j1=$(i1), d1=j1.children(), id=j1.attr('id');
								if(d1.length){
									d1.each(function(b,i2){
										var j2=$(i2), d2=j2.children(), i2=j2.attr('id'), t2=j2.get(0).tagName.toLowerCase(), contentIndex=0;
										if($.type(lai[q.bible].bible[t2]) ==='undefined')lai[q.bible].bible[t2]={};
										if(d2.length){
											lai[q.bible].bible[t2][i2]={};
											setTimeout(function(){
												d2.each(function(c,i3){
													var j3=$(i3), d3=j3.children(), i3=j3.attr('id'), t3=j3.get(0).tagName.toLowerCase();
													if($.type(lai[q.bible].bible[t2][i2][t3]) ==='undefined')lai[q.bible].bible[t2][i2][t3]={};
													if(d3.length){
														lai[q.bible].bible[t2][i2][t3][i3]={};
														lai[q.bible].bible[t2][i2][t3][i3].verse={};
														setTimeout(function(){
															d3.each(function(v,i4){
																var j4=$(i4), d4=j4.children(), i4=j4.attr('id'), t4=j4.get(0).tagName.toLowerCase();
																i4='v'+i4;
																lai[q.bible].bible[t2][i2][t3][i3].verse[i4]={};
																lai[q.bible].bible[t2][i2][t3][i3].verse[i4].text=j4.text();
																if(j4.attr('ref'))lai[q.bible].bible[t2][i2][t3][i3].verse[i4].ref=j4.attr('ref').split(',');
																if(j4.attr('title'))lai[q.bible].bible[t2][i2][t3][i3].verse[i4].title=j4.attr('title').split(',');
																if(d1.length == b+1){
																	if(d2.length == c+1){
																		if(d3.length == v+1){
																			if(sO.isCordova){
																				xml.done({msg:'Localed',status:true});
																			}else{
																				db.put({table:q.bible,data:lai[q.bible].bible}).then(function(){
																					xml.done({msg:'Stored',status:true});
																				});
																			}
																		}
																	}
																}
															});
														},50/b*c);
														//chapter
													}else if(i3){
														//info
														lai[q.bible].bible[t2][i2][t3][i3]=j3.text();
													}else{
														//content
														contentIndex++;
														lai[q.bible].bible[t2][i2][t3][contentIndex]={ref:j3.attr('ref').split(','), title:j3.text()};
													}
												}).promise().done(function(){
													xml.msg(lai[q.bible].lang.b[i2]);
												});
											},150*b);
										}else{
											lai[q.bible].bible[t2][i2]=j2.text();
										}
									});
								}else{
									var name=j1.attr('id');
									var text=j1.text();
								}
							});
						}
					},
					msg:function(m){
						fn.msg(m);
					},
					done:function(m){
						z.load.loaded();
						if(m.status===false){z.utility.remove.lai(q.bible);}
						callback(m);
					}
				}; 