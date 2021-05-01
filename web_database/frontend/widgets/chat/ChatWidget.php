<?php 
namespace frontend\widgets\chat;

/**
 * 留言板组件
 */
use Yii;
use yii\bootstrap\Widget;
use yii\base\BaseObject;
use frontend\models\WishForm;

class ChatWidget extends Widget
{
     public function run()
     {
     	$Wish = new WishForm();
     	$data['Wish'] = $Wish->getList();
     	return $this->render('index',['data'=>$data]);
     }

}