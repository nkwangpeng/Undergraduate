<?php

/* @var $this \yii\web\View */
/* @var $content string */

use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use frontend\assets\AppAsset;
use common\widgets\Alert;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>

<div class="wrap">
    <?php
    NavBar::begin([
        'brandLabel' => '&#x9996;&#x9875;',//Ê×Ò³µÄ±àÂë
        'brandUrl' => Yii::$app->homeUrl,
        'options' => [
            'class' => 'navbar-inverse navbar-fixed-top',
        ],
    ]);
    /*$menuItems = [
        ['label' => 'Home', 'url' => ['/site/index']],
        ['label' => 'About', 'url' => ['/site/about']],
        ['label' => 'Contact', 'url' => ['/site/contact']],
    ];*/
    if (Yii::$app->user->isGuest) {
        $menuItems[] = ['label' => 'signup', 'url' => ['/site/signup']];
        $menuItems[] = ['label' => 'login', 'url' => ['/site/login']];
    } else {
        $menuItems[] = [
            'label' => 'Logout (' . Yii::$app->user->identity->username . ')',
            'url' => ['/site/logout'],
            'linkOptions' => ['data-method' => 'post']
        ];
    }
    echo Nav::widget([
        'options' => ['class' => 'navbar-nav navbar-right'],
        'items' => $menuItems,
    ]);
    NavBar::end();
    ?>
    <div class="blank" style="margin-top: 50px"</div>
    <div class="page-heading-85912" style="background-image: url('img/hero_bg_3.jpg')">
      <div class="container">
        <div class="row align-items-end">
          <div class="col-lg-7">
            <h1 class="mb-0 heading text-white">this is the articles, click title to see details</h1>
            <p class="mb-0 text-white">page description</p>
          </div>
        </div>
      </div>
    </div>
    <div class="container">
        <?= Breadcrumbs::widget([
            'links' => isset($this->params['breadcrumbs']) ? $this->params['breadcrumbs'] : [],
        ]) ?>
        <?= Alert::widget() ?>
        <?= $content ?>
    </div>
</div>
    <div class="page-heading-85912" style="background-image: url('img/hero_bg_3.jpg')">
      <div class="container">
        <div class="row align-items-end">
          <div class="col-lg-7">
            <h1 class="mb-0 heading text-white">Article</h1>
            <p class="mb-0 text-white">this is article</p>
          </div>
        </div>
      </div>
    </div>
<footer class="footer">
    <div class="container">
        <p class="pull-left">&copy; NKtoString <?= date('Y') ?></p>

        <p class="pull-right"><?= Yii::powered() ?></p>
    </div>
</footer>

<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
