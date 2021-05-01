<?php



/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200603
 * This is the article index
 */


use yii\helpers\Html;
use yii\grid\GridView;
use yii\widgets\Pjax;
/* @var $this yii\web\View */
/* @var $searchModel backend\models\ArticleSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Articles';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="article-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Create Article', ['create'], ['class' => 'btn btn-success']) ?>
    </p>
    <?php Pjax::begin(); ?>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            [
                'attribute' => 'id',
                'value' => 'id',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style' => 'white-space: normal;', 'width' => '5%'],
            ],
            [
                'attribute' => 'title',
                'value' => 'title',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style' => 'white-space: normal;', 'width' => '20%'],
            ],
           // 'content',
           [
                'attribute' => 'content',
                'value' => 'content',
                //"headerOptions" => ["width" => "100"],
                'contentOptions' => ['style' => 'white-space: normal;', 'width' => '65%'],
            ],

            ['class' => 'yii\grid\ActionColumn'],
            
        ],

    ]); 
    ?>


</div>
