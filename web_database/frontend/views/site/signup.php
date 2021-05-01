<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model \frontend\models\SignupForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = '前台注册';
$fieldOptions1 = [
    'options' => ['class' => 'form-group has-feedback'],
    'inputTemplate' => "{input}<span class='glyphicon glyphicon-envelope form-control-feedback'></span>"
];

$fieldOptions2 = [
    'options' => ['class' => 'form-group has-feedback'],
    'inputTemplate' => "{input}<span class='glyphicon glyphicon-lock form-control-feedback'></span>"
];
?>
<head>
<style type="text/css">
.login-page {
background: url("img/back.png") no-repeat center center fixed;
background-size: cover; 
}
</style>
</head>
<div class="login-box">
    <div class="login-logo">
        <a href="#"><b>前台</b>注册</a>
    </div>
<div class="login-box-body">
        
        <p class="login-box-msg">注册登录之后才可以留言噢</p>
  
            <?php $form = ActiveForm::begin(['id' => 'form-signup']); ?>
            <?= $form
            ->field($model, 'username', $fieldOptions1)
            ->label(false)
            ->textInput(['placeholder' => $model->getAttributeLabel('username')]) ?>

        <?= $form
            ->field($model, 'email', $fieldOptions1)
            ->label(false)
            ->textInput(['placeholder' => $model->getAttributeLabel('email')]) ?>

        <?= $form
            ->field($model, 'password', $fieldOptions2)
            ->label(false)
            ->passwordInput(['placeholder' => $model->getAttributeLabel('password')]) ?>

                <div class="form-group">
                    <?= Html::submitButton('注册', ['class' => 'btn btn-primary btn-block btn-flat', 'name' => 'signup-button']) ?>
                </div>

            <?php ActiveForm::end(); ?>

        </div>
</div>