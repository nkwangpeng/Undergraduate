<?php


/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the article form
 */


namespace frontend\models;
 
/**
 * 文章表单模型
 */
 
use frontend\models\Article;
use yii\base\Model;
 
class ArticleForm extends Model
{
    public $id;
    public $title;
    public $content;
 
    public $_lastError="";
 
    public function rules()
    {
        return [
            [['id','title','content'],'required'],
            [['id'],'integer'],
            ['title','string','min'=>1,'max'=>60],
        ];
    }
     
     public static function getList( $orderBy = ['id'=> SORT_DESC])
    {
        $model = new Article();
        //构造查询语句
        //查询字段
        $select = ['id', 'title','content'];
        $res = $model->find()
          ->select($select)
          ->orderBy($orderBy)
          ->asArray()
          ->all();

        //把获取到的数据返回出去
        return $res?:[];
 
    }
}
