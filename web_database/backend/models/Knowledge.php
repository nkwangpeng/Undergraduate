<?php

namespace backend\models;

use Yii;

/**
 * This is the model class for table "knowledge".
 *
 * @property string $question
 * @property string $answer
 */
class Knowledge extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'knowledge';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['question', 'answer'], 'required'],
            [['answer'], 'string'],
            [['question'], 'string', 'max' => 255],
            [['question'], 'unique'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'question' => 'Question',
            'answer' => 'Answer',
        ];
    }

    /**
     * {@inheritdoc}
     * @return KnowledgeQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new KnowledgeQuery(get_called_class());
    }
}
