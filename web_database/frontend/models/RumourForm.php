<?php


/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the Rumour form
 */


namespace frontend\models;

/**
 * 文章表单模型
 */

use frontend\models\Rumour;
use yii\base\Model;

class RumourForm extends Model
{
    public $id;
    public $title;
    public $content;

    public $_lastError="";

    public function rules()
    {
        return [
            [['info', 'content', 'created_at', 'title'], 'required'],
            [['created_at'], 'integer'],
            [['title'], 'string', 'max' => 255],
            [['info', 'content'], 'string', 'max' => 3000],
        ];
    }

    public static function getList( $orderBy = ['id'=> SORT_DESC])
    {
        $model = new Rumour();
        //构造查询语句
        //查询字段
        $select = ['id', 'title','content', 'info'];
        $res = $model->find()
            ->select($select)
            ->orderBy($orderBy)
            ->asArray()
            ->all();

        //把获取到的数据返回出去
        return $res?:[];

    }
}
