<?php

namespace frontend\models;

/**
 * This is the ActiveQuery class for [[China]].
 *
 * @see China
 */
class ChinaQuery extends \yii\db\ActiveQuery
{
    /*public function active()
    {
        return $this->andWhere('[[status]]=1');
    }*/

    /**
     * {@inheritdoc}
     * @return China[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * {@inheritdoc}
     * @return China|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}
