<?php



/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the article widget
 */

namespace frontend\widgets\rumour;

use frontend\models\Rumour;
use frontend\models\ArticleForm;
use frontend\models\RumourForm;
use yii\base\Widget;
use yii\data\Pagination;
use yii\helpers\Url;
use Yii;

class RumourWidget extends Widget
{
    public $title = '';
    public function run()
    {
        $res = RumourForm::getList();
        $result['title'] = $this->title?$this->title: 'new rumour';
        $result['more'] = Url::to(['rumour/view']);
        $result['body'] = $res?$res:[];

        return $this->render('index',['data'=>$result]);
    }
}