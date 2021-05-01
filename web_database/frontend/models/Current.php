<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431,
 * This is the current model
 */

namespace frontend\models;

use Yii;

/**
 *
 * @property string $currentConfirmedCount
 * @property string $seriousCount
 * @property string $suspectedCount
 * @property string $confirmedCount
 * @property string $deadCount
 * @property string $curedCount
 * @property int $id
 */
class Current extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%current}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['currentConfirmedCount', 'seriousCount', 'suspectedCount', 'confirmedCount', 'deadCount', 'curedCount', 'id'], 'required'],
            [['id'], 'integer'],
            [['currentConfirmedCount', 'seriousCount', 'suspectedCount', 'confirmedCount', 'deadCount', 'curedCount'], 'string', 'max' => 255],
            [['id'], 'unique'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'currentConfirmedCount' => 'Current Confirmed Count',
            'seriousCount' => 'Serious Count',
            'suspectedCount' => 'Suspected Count',
            'confirmedCount' => 'Confirmed Count',
            'deadCount' => 'Dead Count',
            'curedCount' => 'Cured Count',
            'id' => 'ID',
        ];
    }

    /**
     * {@inheritdoc}
     * @return CurrentQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new CurrentQuery(get_called_class());
    }
     public function findModel($id)
    {
        if (($model = Current::findOne($id)) !== null) {
            return $model;
        }

        throw new NotFoundHttpException('The requested page does not exist.');
    }
}
