<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model backend\models\knowledge */

$this->title = 'Update Knowledge: ' . $model->question;
$this->params['breadcrumbs'][] = ['label' => 'Knowledges', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->question, 'url' => ['view', 'id' => $model->question]];
$this->params['breadcrumbs'][] = 'Update';
?>
<div class="knowledge-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
