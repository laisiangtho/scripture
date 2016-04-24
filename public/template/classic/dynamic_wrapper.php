<?php 
/*
				<div class="bible">
					<div class="version">
						<h2>King James Version</h2>
                        <div class="book">
                        	<h3>Genesis</h3>
							<div class="chapter">
                            	<h4>Chapter 2</h4>
								<div class="verse">
                                	<span>170</span>
                                	<p>shall I do, that I may havAnd, behold, one came and said unto him, Good Master, what good thing e eternal life?shall I do, that I may havAnd, behold, one came and said unto him, Good Master, what good thing e eternal life?shall I do, that I may havAnd, behold, one came and said unto him, Good Master, what good thing e eternal life?</p>
								</div>
							</div>
						</div>
					</div>                                    
				</div>    

$template['search']['result']['start']='<div class="result">';
$template['search']['result']['end']='</div>';
$template['search']['language']['start']='<div class="language">';
$template['search']['language']['end']='</div>';
$template['search']['book']['start']='<div class="book">';
$template['search']['book']['end']='</div>';
$template['search']['chapter']['start']='<div class="chapter">';
$template['search']['chapter']['end']='</div>';
$template['search']['verse']['start']='<div class="verse">';
$template['search']['verse']['end']='</div>';
*/
$template['search']['bible']='
			<div class="bible">
				{@data}
			</div>
';
$template['search']['version']='
			<div class="version {@version_class}">
				<h2>{@version}</h2>
				{@data}
			</div>
';
$template['search']['book']='
			<div class="book {@book_class}">
				<h3>{@book}</h3>
				{@data}
			</div>
';
$template['search']['chapter']='
			<div class="chapter {@chapter_class}">
				<h4>{@chapter}</h4>
				{@data}
			</div>
';
$template['search']['verse']='
			<div class="verse {@verse_class}">
				<span>{@verse_num}</span>
				<p>{@verse}</p>
			</div>
';
?>