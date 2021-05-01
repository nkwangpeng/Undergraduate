<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model backend\models\knowledge */

$this->title = 'Create Knowledge';
$this->params['breadcrumbs'][] = ['label' => 'Knowledges', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="knowledge-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
