<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model backend\models\Rumour */

$this->title = 'Create Rumour';
$this->params['breadcrumbs'][] = ['label' => 'Rumour', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="wishes-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
