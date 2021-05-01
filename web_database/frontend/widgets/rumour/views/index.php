<?php

/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the article widget index
 */
use yii\helpers\Url;
?>
<style type="text/css">
.panell-body h1 {
    width:150px;
    font-size: 18px;
    height:30px;
    line-height: 30px;
    margin: 0;
    white-space:nowrap; 
    overflow:hidden; 
    text-overflow:ellipsis;
}
.panell-body p {
    width:1000px;
    white-space:nowrap; 
    overflow:hidden; 
    text-overflow:ellipsis;
}
.panell {
    position:relative;
    top:10px;
    left:260px;
}

</style>
<div class="panell" style="margin-left: 110px ">
    <div class="panell-title box-title">
        <span><?=$data['title']?></span>
    </div>
    <div class="new-list">
        <?php foreach ($data['body'] as $list):?>
            <div class="panell-body border-bottom " style="margin-top: 20px">
                <div class="row">
                    
                    <div class="col-lg-8 btn-group" >
                        <h1><a href="<?=Url::to(['rumour/view','id'=>$list['id']])?>"><?=$list['title']?></a></h1>
                        
                        <p class="post-content"><?=$list['content']?></p>
                        <a href="<?=Url::to(['rumour/view','id'=>$list['id']])?>"><button class="btn btn-warning no-radius btn-sm pull-right">阅读全文</button></a>
                    </div>
                </div>
                
            </div>
        <?php endforeach;?>
    </div>
    
</div>