<?php

namespace frontend\models;

use Yii;

/**
 * This is the model class for table "news".
 *
 * @property string $topic
 * @property string $content
 */
class News extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'news';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['topic', 'content'], 'required'],
            [['content'], 'string'],
            [['topic'], 'string', 'max' => 255],
            [['topic'], 'unique'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'topic' => 'Topic',
            'content' => 'Content',
        ];
    }

    /**
     * {@inheritdoc}
     * @return NewsQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new NewsQuery(get_called_class());
    }
}
