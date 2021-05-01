<?php

namespace backend\models;

/**
 * This is the ActiveQuery class for [[Wishes]].
 *
 * @see Wishes
 */
class RumourQuery extends \yii\db\ActiveQuery
{

    /**
     * {@inheritdoc}
     * @return Wishes[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * {@inheritdoc}
     * @return Wishes|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}
