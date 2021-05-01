<?php

namespace frontend\models;

/**
 * This is the ActiveQuery class for [[Tendency]].
 *
 * @see Tendency
 */
class TendencyQuery extends \yii\db\ActiveQuery
{
    /*public function active()
    {
        return $this->andWhere('[[status]]=1');
    }*/

    /**
     * {@inheritdoc}
     * @return Tendency[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * {@inheritdoc}
     * @return Tendency|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}
