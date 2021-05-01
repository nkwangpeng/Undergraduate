<?php

namespace frontend\models;

use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Worldmap;

/**
 * WorldmapSearch represents the model behind the search form of `app\models\Worldmap`.
 */
class WorldmapSearch extends Worldmap
{
    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['name', 'currentConfirmedCount', 'confirmedCount', 'curedCount', 'deadCount'], 'safe'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function scenarios()
    {
        // bypass scenarios() implementation in the parent class
        return Model::scenarios();
    }

    /**
     * Creates data provider instance with search query applied
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search($params)
    {
        $query = Worldmap::find();

        // add conditions that should always apply here

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }

        // grid filtering conditions
        $query->andFilterWhere(['like', 'name', $this->name])
            ->andFilterWhere(['like', 'currentConfirmedCount', $this->currentConfirmedCount])
            ->andFilterWhere(['like', 'confirmedCount', $this->confirmedCount])
            ->andFilterWhere(['like', 'curedCount', $this->curedCount])
            ->andFilterWhere(['like', 'deadCount', $this->deadCount]);

        return $dataProvider;
    }
}
