<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model backend\models\Wishes */

$this->title = 'Create Wishes';
$this->params['breadcrumbs'][] = ['label' => 'Wishes', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="wishes-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
