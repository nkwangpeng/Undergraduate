<?php



/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the article widget
 */

namespace frontend\widgets\article;
 
/**
 * 自定义文章列表组件
 */
 
use frontend\models\Article;
use frontend\models\ArticleForm;
use yii\base\Widget;
use yii\data\Pagination;
use yii\helpers\Url;
use Yii;
 
class ArticleWidget extends Widget
{
 
    //文章列表的标题
    public $title = '';
 
    public function run()
    {
        
        
        //获取文章列表数据
        $res = ArticleForm::getList();
        //设置文章列表属性
        $result['title'] = $this->title?$this->title: 'new article';
        $result['more'] = Url::to(['article/view']);
        $result['body'] = $res?$res:[];
 
             
        return $this->render('index',['data'=>$result]);
    }
}