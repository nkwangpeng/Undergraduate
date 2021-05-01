<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431,
 * This is the wish model
 */

namespace common\models;

use Yii;

/**
 
 *
 * @property int $id
 * @property int $user_id 用户id
 * @property string $content 内容
 * @property int $created_at 创建时间
 * @property string $username
 *
 * @property User $user
 */
class Wishes extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%Wishes}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['user_id', 'content', 'created_at', 'username'], 'required'],
            [['user_id', 'created_at'], 'integer'],
            [['content', 'username'], 'string', 'max' => 255],
            [['user_id'], 'exist', 'skipOnError' => true, 'targetClass' => User::className(), 'targetAttribute' => ['user_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'user_id' => '用户id',
            'content' => '内容',
            'created_at' => '创建时间',
            'username' => 'Username',
        ];
    }

    /**
     * Gets query for [[User]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getUser()
    {
        return $this->hasOne(User::className(), ['id' => 'user_id']);
    }
}
