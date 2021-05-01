<?php


/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200524
 * This is the worlpmap model
 */


namespace app\models;

use Yii;

/**
 * This is the model class for table "worldmap".
 *
 * @property string $name
 * @property string|null $currentConfirmedCount
 * @property string|null $confirmedCount
 * @property string|null $curedCount
 * @property string|null $deadCount
 */
class Worldmap extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'worldmap';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['name'], 'required'],
            [['name', 'currentConfirmedCount', 'confirmedCount', 'curedCount', 'deadCount'], 'string', 'max' => 255],
            [['name'], 'unique'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'name' => 'Name',
            'currentConfirmedCount' => 'Current Confirmed Count',
            'confirmedCount' => 'Confirmed Count',
            'curedCount' => 'Cured Count',
            'deadCount' => 'Dead Count',
        ];
    }

    /**
     * {@inheritdoc}
     * @return WorldmapQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new WorldmapQuery(get_called_class());
    }
}
