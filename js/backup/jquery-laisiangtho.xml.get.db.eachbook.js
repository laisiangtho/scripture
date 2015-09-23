				var jobCollection=($.inArray(q.bible,config.bible.books) >=0)?true:false;
				var jobList=[q.bible],
				xml={
					get:function(){
						if($.isEmptyObject(lai[q.bible].bible)){this.db();}else{this.done({msg:'Already load',status:true});}
					},
					db:function(){
						db.get({table:q.bible}).then(function(storeBible){
							if(storeBible){
								lai[q.bible].bible=storeBible;
								if($.isEmptyObject(lai[q.bible].bible)){xml.prepare();}else{xml.done({msg:'from Store',status:true});}
							}else{
								xml.prepare();
							}
						});
					},
					prepare:function(){
						lai[q.bible].bible={id:q.bible,info:{},book:{}};
						if(jobCollection){
							jobList=Object.keys(bible.book);
						}
						z.load.loading();
						this.next();
					},
					next:function(){
						var y=jobList.shift();
						if(jobCollection){
							this.msg(lai[q.bible].lang.b[y]);
							db.get({table:q.bible+'.'+y}).then(function(currentstoreBible){
								if(currentstoreBible){
									//console.log('each book from store....');
									lai[q.bible].bible.book[y]=currentstoreBible;
									if(jobList.length){
										xml.msg('from db....');
										xml.next();
									}else{
										xml.done({msg:'from Store',status:true});
									}
								}else{
									var o=z.utility.Url(config.id,[q.bible,y],config.file.bible);
									xml.load(o.url,o.data,o.content,false);
								}
							});
						}else{
							this.msg(lai[q.bible].lang.l.Loading);
							var o=z.utility.Url(config.id,[q.bible],config.file.bible);
							this.load(o.url,o.data,o.content,false);
						}
					},
					load:function(url,data,content,x){
						//cache:false,
						$.ajax({
							url:url,dataType:data,contentType:content,crossDomain:true,async:true,
							beforeSend:function(xhr){
								xhr.setRequestHeader("Access-Control-Allow-Origin", "*"); 
							}
						}).done(function(j, statusText, d){
							var jobType=$(j).children().get(0).tagName;
							if($.isFunction(xml.job[jobType])){
								xml.job[jobType](j);
							}else{
								z.utility.remove.lai(q.bible); xml.done({msg:'no '+jobType+' Method found',status:false});
							}
						}).fail(function(jqXHR, statusText){
							if(api){
								if(x){
									z.utility.remove.lai(q.bible);
									xml.done({msg:'getting Access Error, removed variables',status:false});
								}else{
									xml.load(api+url,data,content,true);
								}
							}else{
								xml.done({msg:textStatus,status:false});
							}
						}).always(function(){});
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
																			if(jobList.length){
																				
																				db.put({table:q.bible+'.'+i2,data:lai[q.bible].bible[t2][i2]}).then(function(){
																					xml.next();
																				});
																			}else{
																				if(jobCollection){
																					db.put({table:q.bible+'.'+i2,data:lai[q.bible].bible[t2][i2]}).then(function(){
																						xml.done({msg:'Stored',status:true});
																					});
																				}else{
																					db.put({table:q.bible,data:lai[q.bible].bible}).then(function(){
																						xml.done({msg:'Stored',status:true});
																					});
																				}
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
						z.load.loaded(); callback(m);
						//$('.data-chapter').html(JSON.stringify(m));
						console.log(m);
					}
				}; return xml;