<?php

namespace frontend\models;

use Yii;

/**
 * This is the model class for table "umour".
 *
 */
class Rumour extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'rumour';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['info', 'content', 'created_at', 'title'], 'required'],
            [['created_at'], 'integer'],
            [['title'], 'string', 'max' => 255],
            [['info', 'content'], 'string', 'max' => 3000],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'info' => '简介',
            'content' => '内容',
            'created_at' => '创建时间',
            'title' => '标题',
        ];
    }
}
