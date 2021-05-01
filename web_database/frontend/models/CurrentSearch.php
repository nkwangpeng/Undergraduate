<?php

namespace frontend\models;

use yii\base\Model;
use yii\data\ActiveDataProvider;
use frontend\models\Current;

/**
 * CurrentSearch represents the model behind the search form of `frontend\models\Current`.
 */
class CurrentSearch extends Current
{
    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['currentConfirmedCount', 'seriousCount', 'suspectedCount', 'confirmedCount', 'deadCount', 'curedCount'], 'safe'],
            [['id'], 'integer'],
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
        $query = Current::find();

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
        $query->andFilterWhere([
            'id' => $this->id,
        ]);

        $query->andFilterWhere(['like', 'currentConfirmedCount', $this->currentConfirmedCount])
            ->andFilterWhere(['like', 'seriousCount', $this->seriousCount])
            ->andFilterWhere(['like', 'suspectedCount', $this->suspectedCount])
            ->andFilterWhere(['like', 'confirmedCount', $this->confirmedCount])
            ->andFilterWhere(['like', 'deadCount', $this->deadCount])
            ->andFilterWhere(['like', 'curedCount', $this->curedCount]);

        return $dataProvider;
    }
}
