<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model frontend\models\CurrentSearch */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="current-search">

    <?php $form = ActiveForm::begin([
        'action' => ['index'],
        'method' => 'get',
        'options' => [
            'data-pjax' => 1
        ],
    ]); ?>

    <?= $form->field($model, 'currentConfirmedCount') ?>

    <?= $form->field($model, 'seriousCount') ?>

    <?= $form->field($model, 'suspectedCount') ?>

    <?= $form->field($model, 'confirmedCount') ?>

    <?= $form->field($model, 'deadCount') ?>

    <?php // echo $form->field($model, 'curedCount') ?>

    <?php // echo $form->field($model, 'id') ?>

    <div class="form-group">
        <?= Html::submitButton('Search', ['class' => 'btn btn-primary']) ?>
        <?= Html::resetButton('Reset', ['class' => 'btn btn-outline-secondary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
