<?php

namespace frontend\models;

use Yii;

/**
 * Team:NKtoString
 * Coding by wangrunze 1811432,
 * This is the China model
 */
class China extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%china}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['id', 'province', 'diagnosis'], 'required'],
            [['id', 'diagnosis'], 'integer'],
            [['province'], 'string', 'max' => 255],
            [['id'], 'unique'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'province' => 'Province',
            'diagnosis' => 'Diagnosis',
        ];
    }

    /**
     * {@inheritdoc}
     * @return ChinaQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new ChinaQuery(get_called_class());
    }
}
