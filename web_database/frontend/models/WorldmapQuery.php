<?php

namespace app\models;

/**
 * This is the ActiveQuery class for [[Worldmap]].
 *
 * @see Worldmap
 */
class WorldmapQuery extends \yii\db\ActiveQuery
{
    /*public function active()
    {
        return $this->andWhere('[[status]]=1');
    }*/

    /**
     * {@inheritdoc}
     * @return Worldmap[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * {@inheritdoc}
     * @return Worldmap|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}
