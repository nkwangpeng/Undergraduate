<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431,
 * This is the tendency model
 */
namespace frontend\models;

use Yii;

/**
 *
 * @property string $日期
 * @property int $累计确诊
 * @property int $现有确诊(含重症)
 * @property int $现有疑似
 * @property int $新增确诊
 * @property int $新增疑似
 * @property int $新增(疑似+确诊)
 * @property float $死亡/确诊
 * @property int $观察中
 * @property int $现有重症
 * @property int $累计死亡
 * @property int $累计治愈
 * @property int $累计确诊+现有疑似
 */
class Tendency extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%tendency}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['日期', '累计确诊', '现有确诊(含重症)', '现有疑似', '新增确诊', '新增疑似', '新增(疑似+确诊)', '死亡/确诊', '观察中', '现有重症', '累计死亡', '累计治愈', '累计确诊+现有疑似'], 'required'],
            [['日期'], 'safe'],
            [['累计确诊', '现有确诊(含重症)', '现有疑似', '新增确诊', '新增疑似', '新增(疑似+确诊)', '观察中', '现有重症', '累计死亡', '累计治愈', '累计确诊+现有疑似'], 'integer'],
            [['死亡/确诊'], 'number'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            '日期' => '日期',
            '累计确诊' => '累计确诊',
            '现有确诊(含重症)' => '现有确诊(含重症)',
            '现有疑似' => '现有疑似',
            '新增确诊' => '新增确诊',
            '新增疑似' => '新增疑似',
            '新增(疑似+确诊)' => '新增(疑似+确诊)',
            '死亡/确诊' => '死亡/确诊',
            '观察中' => '观察中',
            '现有重症' => '现有重症',
            '累计死亡' => '累计死亡',
            '累计治愈' => '累计治愈',
            '累计确诊+现有疑似' => '累计确诊+现有疑似',
        ];
    }

    /**
     * {@inheritdoc}
     * @return TendencyQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new TendencyQuery(get_called_class());
    }
}
