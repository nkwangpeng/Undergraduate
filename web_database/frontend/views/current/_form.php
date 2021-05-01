<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model frontend\models\Current */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="current-form">

    <?php $form = ActiveForm::begin(); ?>

    <?= $form->field($model, 'currentConfirmedCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'seriousCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'suspectedCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'confirmedCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'deadCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'curedCount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'id')->textInput() ?>

    <div class="form-group">
        <?= Html::submitButton('Save', ['class' => 'btn btn-success']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
