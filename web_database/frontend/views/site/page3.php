<?php

use frontend\widgets\article\ArticleWidget;
use frontend\widgets\rumour\RumourWidget;
use yii\helpers\Html;
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

<body>
  
  <!-- BEGIN: .site-wrap -->
  <div class="site-wrap">
  
    <!-- BEGIN: #site-header -->  
    <!-- 
      Add class '.position-relative' to display it as stack.
      Add '.navbar-light' to make the text dark or black.
    -->
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
              <li class="nav-item active">
                <a class="nav-link" href="index.php?r=site/page3">辟谣与防护</a>
              </li>
              <li class="nav-item">
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
    <!-- END: #site-header -->

    <!-- BEGIN: .cover -->
    <div class="page-heading-85912" style="background-image: url('img/hero_bg_3.jpg')">
      <div class="container">
        <div class="row align-items-end">
          <div class="col-lg-7">
            <h1 class="mb-0 heading text-white">辟谣与防护</h1>
            <p class="mb-0 text-white">辟谣列表</p>
          </div>
        </div>
      </div>
    </div>

      <?=RumourWidget::widget()?>

    <!-- BEGIN: #footer -->
    <footer id="footer" style="margin-top: 20px">
      <div class="container">
        
        <!-- BEGIN: .footer-subscribe -->
        <div class="row footer-subscribe">
          <div class="col-md-6">
            <h3 class="mt-2">Get our newsletter, join the community.</h3>
          </div>
          <div class="col-md-6">
            <form action="#" id="mc-form" class="form-subscribe">
              <div class="d-flex align-items-stretch w-100">
                <input type="email" id="mc-email" placeholder="Email address" class="form-control">
                <input type="submit" value="Sign up" class="btn btn-outline-white-reverse">
              </div>
              <div class="form-group">
                <label for="mc-email"></label>
              </div>
            </form>
          </div>
        </div>
        <!-- END: .footer-subscribe -->

        <div class="row">
          <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
            <!-- BEGIN: .widget -->
            <div class="widget">
              <h3>About</h3>
              <ul class="nav-link">
                <li><a href="#">Home</a></li>
                <li><a href="#">Situation</a></li>
                <li><a href="#">Prevention</a></li>
                <li><a href="#">Symptoms</a></li>
                <li><a href="#">Community</a></li>
              </ul>
            </div>
            <!-- END: .widget -->
          </div>
          <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
            <!-- BEGIN: .widget -->
            <div class="widget">
              <h3>Helpful Links</h3>
              <ul class="nav-link">
                <li><a href="#">Reduce The Spread</a></li>
                <li><a href="#">Who Are At Risk</a></li>
                <li><a href="#">Social Distancing</a></li>
                <li><a href="#">Community Advice</a></li>
                <li><a href="#">Technical Guidance</a></li>
              </ul>
            </div>
            <!-- END: .widget -->
          </div>
          <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
            <!-- BEGIN: .widget -->
            <div class="widget">
              <h3>Protect Yourself</h3>
              <ul class="nav-link">
                <li><a href="#">Wash Your Hands Often</a></li>
                <li><a href="#">Wear a Face Mask</a></li>
                <li><a href="#">Avoid Contact With Sick People</a></li>
                <li><a href="#">Always Cover Your Cough or Sneeze</a></li>
                <li><a href="#">Protect Your Family</a></li>
              </ul>
            </div>
            <!-- END: .widget -->
          </div>
          <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
            <div class="d-block">
              <ul class="list-unstyled d-flex social-29021">
                <li><a href="#"><span class="icon-facebook"></span></a></li>
                <li><a href="#"><span class="icon-twitter"></span></a></li>
                <li><a href="#"><span class="icon-instagram"></span></a></li>
                <li><a href="#"><span class="icon-linkedin"></span></a></li>
              </ul>
            </div>

            <div class="d-block mb-4">
              <a href="#" class="d-flex call align-items-center">
                <span class="lni lni-mobile wrap-icon"></span>
                <span class="number">329 4902 392</span>
              </a>
            </div>
            <div class="d-block">
              <p>If you have any question, please contact us at <a href="#" class="link-underline text-primary">info@unslate.co</a></p>
            </div>
          </div>
        </div>
        
        <!-- BEGIN: .copyright -->
        <div class="row copyright">
          <div class="col-md-6 order-2 text-center text-md-right"><a href="#" class="js-top"><span class="icon-long-arrow-up mr-2"></span> Go to Top</a></div>
          <div class="col-md-6 text-center text-md-left">
            <p>&copy; 2020. All Rights Reserved. Design by <a href="http://www.bootstrapmb.com" target="_blank" class="link-underline text-primary">Unslate.co</a></p>
          </div>
        </div>
        <!-- END: .copyright -->
      </div>
    </footer>
    <!-- END: #footer -->

  </div>
  <!-- END: .site-wrap -->

  <!-- Loader -->
  <div id="site-overlayer"></div>
  <div class="site-loader-wrap">
    <div class="site-loader"></div>
  </div>

  <!-- BEGIN: JavaScripts -->
  <script src="js/jquery-3.4.1.min.js"></script>
  <script src="js/popper.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/jquery.waypoints.min.js"></script>
  <script src="js/jquery.animateNumber.min.js"></script>
  <script src="js/tiny-slider.js"></script>
  <script src="js/jquery.fancybox.min.js"></script>
  <script src="js/jquery.lavalamp.min.js"></script>
  <script src="js/jquery.ajaxchimp.min.js"></script>
  <script src="js/jquery.validate.min.js"></script>
  <script src="js/jquery.easing.1.3.js"></script>
  <script src="js/main.js"></script>
  <!-- END: JavaScripts -->
 
</body>