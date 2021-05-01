<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel frontend\models\Rumourearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Rumour';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="article-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <!--<?= Html::a('Create Rumour', ['create'], ['class' => 'btn btn-success']) ?>-->
    </p>

    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,

        'columns' => [
            //['class' => 'yii\grid\SerialColumn'],

           [
                'attribute' => 'id',
                'value' => 'id',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style' => 'white-space: normal;', 'width' => '5%'],
            ],
            [
                'attribute' => 'title',
                'value' => function ($model, $key, $index, $column) {return Html::a($model->title,['rumour/view', 'id' => $key]);    },   'format' => 'raw',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style' => 'white-space: normal;', 'width' => '20%'],
            ],
           // 'content',
           [
                'attribute' => 'article brief',
                'value' => 'content',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style'=>'max-width: 300px ; overflow: hidden;'],
            ],
            //['class' => 'yii\grid\ActionColumn','header' => 'more detail', 'template' => '{view} ',],
            // [   'attribute' => 'title',   'value' => function ($model, $key, $index, $column) {return Html::a($model->title,['article/view', 'id' => $key]);    },   'format' => 'raw',],
        ],
    ]); ?>


</div>
