<?php

use yii\helpers\Html;
use yii\grid\GridView;
use yii\widgets\Pjax;
/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Knowledge';

?>
<head>
  <!-- BEGIN: Title -->
  <title>疫情变化趋势</title>
  <!-- END: Title -->

  <!-- BEGIN: Meta -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- END: Meta -->
  
  <!-- BEGIN: Favicon -->
  <!-- END: Favicon -->

  <!-- BEGIN: Stylesheets -->
  <link rel="stylesheet" href="css/bootstrap.css">
  <link rel="stylesheet" href="css/tiny-slider.css">
  <link rel="stylesheet" href="fonts/lineicons/LineIcons.min.css">
  <link rel="stylesheet" href="fonts/icomoon/style.css">
  <link rel="stylesheet" href="css/animate.min.css">
  <link rel="stylesheet" href="css/jquery.lavalamp.css">
  <link rel="stylesheet" href="css/jquery.fancybox.min.css">
  <link rel="stylesheet" href="css/visualstyle.css">
  <!-- END: Stylesheets -->

  <link href="css/tendency/index.css" rel="stylesheet">

  <script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/4.4.0-rc.1/echarts.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-color/2.1.2/jquery.color.min.js"></script>
  <script
    src="https://cdnjs.cloudflare.com/ajax/libs/jquery-animateNumber/0.0.14/jquery.animateNumber.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/tooltipster/3.3.0/js/jquery.tooltipster.min.js"></script>

  <!--
  <script src="../Js/jquery.min.js"></script>
  <script src="../Js/echarts.min.js"></script>
  <script src="../Js/Date.prototype.js"></script>
  <script src="../Js/jquery.color.min.js"></script>
  <script src="../Js/jquery.animateNumber.min.js"></script>
  <script src="../Js/jquery.tooltipster.min.js"></script> 
  -->
  <script src="js/tendency/Date.prototype.js"></script>
  <script src="js/tendency/layer.js"></script>
  <style> </style>
</head>
<header id="site-header" class="position-relative">

      <!-- Add '.navbar_dark' class if you want the color of the text to -->
      <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">

          <!-- BEGIN: .navbar-brand -->
          <a class="navbar-brand" href="index.php">
                <a class="nav-link active" href="index.php" style="color:grey; font-size: 1.5rem">返回首页</a>
          </a>
          <!-- END: .navbar-brand -->

          <!-- BEGIN: .navbar-toggler -->
          <a href="#" class="burger-toggle-menu js-burger-toggle-menu ml-auto py-4" data-toggle="collapse" data-target="#main-nav" aria-controls="main-nav" aria-expanded="false" aria-label="Toggle navigation">
            <span></span>
            <span></span>
            <span></span>
          </a>
          <!-- END: .navbar-toggler -->

          <!-- BEGIN: #main-nav -->
          <div class="collapse navbar-collapse" id="main-nav">

            <ul class="navbar-nav ml-auto">
              <li class="nav-item ">
                <a class="nav-link" href="index.php?r=tendency/visual">疫情变化趋势</a>
              </li>
              <li class="nav-item ">
                <a class="nav-link" href="index.php?r=chinamap/page">全国疫情图</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="index.php?r=worldmap/page">世界疫情图</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="index.php?r=site/page3">辟谣与防护</a>
              </li>
              <li class="nav-item active">
                <a class="nav-link" href="index.php?r=knowledge/index">疾病知识</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="index.php?r=news/index">疫情新闻</a>
              </li>
            </ul>

          </div>
          <!-- END: #main-nav -->

        </div>
      </nav>
    </header>
<div class="knowledge-index">

    <h1><?= Html::encode($this->title) ?></h1>


    <?php Pjax::begin(); ?>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            'question',
            'answer:ntext',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>

    <?php Pjax::end(); ?>

</div>
