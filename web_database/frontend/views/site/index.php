<?php
/* @var $this \yii\web\View */
/* @var $content string */
use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use frontend\assets\AppAsset;
use common\widgets\Alert;
use yii\base\widget;
use yii\helpers\Url;
use frontend\widgets\chat\ChatWidget;
use frontend\widgets\article\ArticleWidget;

AppAsset::register($this);
?>
<?php $this->beginPage()  ?>
<!DOCTYPE html>
<html lang="en">

<head>

    <script src='js/jquery.js'></script>
<!--    <script src="js/jquery.min.js"></script>-->
    <script src="js/jquery.knob.js"></script>
    <script src="js/jquery.throttle.js"></script>
    <script src="js/jquery.classycountdown.js"></script>
    <script src="js/index.js"></script>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>同心协力，共克时艰</title>

  <!-- Bootstrap Core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom Fonts -->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">
  <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet">

  <!-- Custom CSS -->
  <link href="css/stylish-portfolio.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/reset.css">
    <link rel="stylesheet" href="css/style.css" media="screen" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/jquery.classycountdown.css" />
    <link href="css/nav_style.css" rel="stylesheet">
    <link href="css/bootstrapmin.css" rel="stylesheet" type="text/css">
    <meta charset="utf-8">
<!-- Stylesheets -->
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/responsive.css" rel="stylesheet">
<link href="css/color.css" rel="stylesheet">

<link rel="shortcut icon" href="img/favicon.png" type="image/x-icon">
<link rel="icon" href="img/favicon.png" type="image/x-icon">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <script>
        $(function () {
            //说一说
            $(".j-wish").click(function(){
                var url = $(this).attr("data-url");
                var content = $("textarea").val(); //获取文本框内容

                if(content == ''){
                    $(".field-wish-content").addClass("has-error");
                    return false;
                }
                $.ajax(url,{
                    type:"post",
                    dataType:"json",
                    data:{ content:content },
                    success:function(data){
                        if(data.status){
                            location.reload();
                        }else{
                            alert(data.msg);
                        }
                    },
                })
            })
        });
    </script>

</head>

<body id="page-top">

  <!-- Navigation -->
  <a class="menu-toggle rounded" href="#">
    <i class="fas fa-bars"></i>
  </a>
  <nav id="sidebar-wrapper">
    <ul class="sidebar-nav">
      <li class="sidebar-brand">
        <a class="js-scroll-trigger" href="#page-top">首页导航</a>
      </li>
      <li class="sidebar-nav-item">
        <a class="js-scroll-trigger" href="#page-top">主页</a>
      </li>
      <li class="sidebar-nav-item">
        <a class="js-scroll-trigger" href="#team">关于团队</a>
      </li>
      <li class="sidebar-nav-item">
        <a class="js-scroll-trigger" href="#services">服务</a>
      </li>
      <li class="sidebar-nav-item">
        <a class="js-scroll-trigger" href="#portfolio">什么</a>
      </li>
      <li class="sidebar-nav-item">
        <a class="js-scroll-trigger" href="#contact">联系</a>
      </li>
    </ul>
  </nav>

  <!-- Header -->
  <header class="masthead d-flex">
  </header>
  <div id="topNav">
    <div class="container" style="padding-left:0px;padding-right:0px;">
        <!-- Mobile Menu Button -->
        <button class="btn btn-mobile" data-toggle="collapse" data-target=".nav-main-collapse">
            <i class="fa fa-bars"></i>
        </button>
        <!-- Top Nav -->
        <div>
            <div class="navbar-collapse nav-main-collapse collapse" frag="面板102">
                <nav class="nav-main">
                    <ul id="topMain" class="nav nav-pills nav-main" style="text-align:center;">
                        <li class="mega-menu logo-menu" frag="窗口10200">
                            <a style="position: absolute;top: -52px;"><img src="https://seeklogo.com/images/C/coronavirus-logo-AD40B821EB-seeklogo.com.png" style="width:150px"></a>
                            <!-- No Data -->
                        </li>
                             <?php if (Yii::$app->user->isGuest) {echo  
                            '<li class="mega-menu  mega-menu-right1" >
                            <a class="js-scroll-trigger" href="#page-top">首页</a>
                            </li>
                            <li class="mega-menu">
                            <a class="js-scroll-trigger" href="index.php?r=site/signup">注册</a>
                            </li>
                            <li class="mega-menu" frag="窗口10202">
                            <a class="js-scroll-trigger" href="index.php?r=site/login">登录</a>
                            </li>';}
                            else{echo
                            '<li class="mega-menu  mega-menu-right1" >
                            <a href="javascript:void(0);" onclick="document.getElementById(\'myform\').submit();">退出登录</a>
                            <form id="myform"  method= "post" action="index.php?r=site/logout">
                            </form>
                            </li>';} ?>
                        <li class="mega-menu" frag="窗口10203">
                            <a class="js-scroll-trigger" href="#comment">留言板</a>
                        </li>
                        <li class="mega-menu" frag="窗口10204">
                            <a class="js-scroll-trigger" href="index.php?r=tendency/visual">疫情可视化</a>
                        </li>
                        <li class="mega-menu active" >
                            <a class="js-scroll-trigger" href="../../backend/web">登录后台</a>
                            </li>
                        <li class="mega-menu" frag="窗口10206">
                            <a class="js-scroll-trigger" href="#team">关于团队</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        <!-- /Top Nav -->
    </div><!-- /.container -->
</div>
<section class="features-section-one" style="padding-bottom: 0px; padding-top: 0px;">
    <div class="auto-container">
      <!--Sec Title-->
      <div class="sec-title centered">
        <div class="title-icon">
          <span class="icon"><img src="img/icons/separater.png" alt="" /></span>
        </div>
        <h2>新型冠状病毒传播</h2>
        <div class="text">冠状病毒是一个大型病毒家族，已知可引起感冒以及中东呼吸综合征（MERS）和严重急性呼吸综合征（SARS）等较严重疾病。新型冠状病毒是以前从未在人体中发现的冠状病毒新毒株。</div>
      </div>
      <div class="row clearfix">
        <!-- Feature Block One -->
        <div class="feature-block-one col-lg-4">
          <div class="inner-box wow fadeInLeft" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <span class="icon"><img src="img/icons/1.png" alt="" /></span>
              </div>
              <h3><a href="#">直接传播</a></h3>
              <div class="text">手接触许多表面并可能吸收病毒。一旦被污染，双手就可以传播病毒。</div>
            </div>
          </div>
        </div>
        
        <!-- Feature Block One -->
        <div class="feature-block-one col-lg-4">
          <div class="inner-box wow fadeInRight" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <span class="icon"><img src="img/icons/2.png" alt="" /></span>
              </div>
              <h3><a href="#">气溶胶传播</a></h3>
              <div class="text">是指飞沫混合在空气中，形成气溶胶，吸入后导致感染</div>
            </div>
          </div>
        </div>
        
        <!-- Feature Block One -->
        <div class="feature-block-one col-lg-4">
          <div class="inner-box wow fadeInLeft" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <span class="icon"><img src="img/icons/3.png" alt="" /></span>
              </div>
              <h3><a href="#">接触传播</a></h3>
              <div class="text">是指飞沫沉积在物品表面，接触污染手后，再接触口腔、鼻腔、眼睛等黏膜，导致感染。</div>
            </div>
          </div>
        </div>        
      </div>
    </div>
  </section>
<section class="features-section-five" style="padding-bottom: 0px; padding-top: 0px;">
    <!--Title Box-->
    <div class="title-box" style="background-image:url(img/background/2.jpg)">
      <div class="auto-container">
        <h2>新冠知识小贴士：</h2>
      </div>
    </div>
    
    <div class="auto-container">
      <div class="inner-container">
        <div class="row clearfix">
          
          <!--Feature Block Five-->
          <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
            <div class="inner-box wow fadeInUp" data-wow-delay="0ms" data-wow-duration="1500ms">
              <div class="icon-box">
                <img src="img/icons/7.png" alt="" title="">
              </div>
              <h3><a href="#">出门戴口罩</a></h3>
              <div class="text">阻挡大部分带有病毒的飞沫进入呼吸道
              </div>
            </div>
          </div>
          
          <!--Feature Block Five-->
          <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
            <div class="inner-box wow fadeInUp" data-wow-delay="300ms" data-wow-duration="1500ms">
              <div class="icon-box">
                <img src="img/icons/8.png" alt="" title="">
              </div>
              <h3><a href="#">咳嗽时掩盖口鼻</a></h3>
              <div class="text">对他人和自己负责</div>
            </div>
          </div>
          
          <!--Feature Block Five-->
          <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
          <div class="inner-box wow fadeInLeft" data-wow-delay="600ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <img src="img/icons/12.png" alt="" title="">
              </div>
              <h3><a href="#">勤洗手哟</a></h3>
              <div class="text">使用肥皂或含酒精成分的洗手液，流水洗手</div>
            </div>
          </div>
        </div>
          <!-- Feature Block One -->
        <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
          <div class="inner-box wow fadeInLeft" data-wow-delay="900ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <img src="img/icons/13.png" alt="" title="">
              </div>
              <h3><a href="#">如果出现症状立刻就医</a></h3>
              <div class="text">主动隔离，及时到医疗机构就诊</div>
            </div>
          </div>
        </div>
        
        <!-- Feature Block One -->
        <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
          <div class="inner-box wow fadeInRight" data-wow-delay="1200ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <img src="img/icons/14.png" alt="" title="">
              </div>
              <h3><a href="#">避免接触野生禽畜</a></h3>
              <div class="text">避免接触禽畜、野生动物及其排泄物和分泌物</div>
            </div>
          </div>
        </div>
        
        <!-- Feature Block One -->
        <div class="feature-block-five col-lg-4 col-md-6 col-sm-12">
          <div class="inner-box wow fadeInLeft" data-wow-delay="1500ms" data-wow-duration="1500ms">
            <div class="content">
              <div class="icon-box">
                <img src="img/icons/15.png" alt="" title="">
              </div>
              <h3><a href="#">避开集市和拥挤的地方</a></h3>
              <div class="text">减少外出，避免近距离接触有感冒症状的人</div>
            </div>
          </div>
        </div>  
          
        </div>
      </div>
    </div>
  </section>

<section class="index-news commit_title" id="comment" style="padding-bottom: 20px; padding-top: 30px;">
    <center>
        <h1 style="padding-bottom:20px;font-family:华文中宋;
        border-bottom:1px solid #ddd;text-align: center;">
        同心协力，共克时艰
        </h1>
    </center>
    <div class="container">
        <header class="text-center">

        </header>
        <div class="body-content">
            <div class="col-lg-9">
                <div class="timeline" style="margin-bottom:0px;">
                     <div class="timeline-left" id="liuyan-div">
                        <?=ChatWidget::widget()?>
                    </div> 
                </div>
            </div>
            <div class="col-lg-3">
                <span class="input-group-btn">
                    <button type="button" data-url="<?=Url::to(['site/add-wish'])?>" 
                    class='btn btn-success btn-wish j-wish'>留言</button>
                </span>
            </div>
        </div>
        </div>
</section>

  <section class="symptoms-section" style="padding-bottom: 20px; padding-top: 30px;">
    <div class="auto-container">
      <div class="row clearfix">

        <!--Content Column-->
        <div class="content-column col-lg-7 col-md-12 col-sm-12 order-lg-2">
          <div class="inner-column wow fadeInRight" data-wow-delay="0ms" data-wow-duration="1500ms">
            <!--Sec Title-->
            <div class="sec-title">
              <div class="title-icon">
                <span class="icon"><img src="img/icons/separater.png" alt="" /></span>
              </div>
              <div class="title">关于新冠病毒</div>
              <h2>新冠肺炎症状</h2>
            </div>
            <div class="text">
              <p>注意监测体温，如有发热、乏力、咳嗽等症状及时就诊。如发病前两周内有疫源地居住或旅行史、有与确诊或疑似患者接触病史，或者有集体发病表现，需及时就诊并主动隔离</p>
            </div>
            <ul class="list-style-two mb-4">
              <li>头痛、喉咙痛</li>
              <li>发热</li>
              <li>咳嗽</li>
              <li>呼吸困难</li>
              <li>乏力</li>
            </ul>
          </div>
        </div>
        
        <!--Image Column-->
        <div class="image-column col-lg-5 col-md-12 col-sm-12">
          <div class="inner-column wow fadeInLeft" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="image">
              <a href="img/resource/image-2.png" data-fancybox="rule" data-caption=""><img src="img/resource/image-2.png" alt="" /></a>
            </div>
          </div>
        </div>
        
      </div>
    </div>
  </section>
  <!--End Section-->


  <!--Features Section Two-->
  <section class="features-section-two" style="padding-bottom: 20px; padding-top: 30px;">
    <div class="outer-container">
      <div class="clearfix">
        
        <!--Content Column-->
        <div class="content-column">
          <div class="inner-column">
            <!--Sec Title-->
            <div class="sec-title">
              <div class="title-icon">
                <span class="icon"><img src="img/icons/separater.png" alt="" /></span>
              </div>
              <div class="title">How To Protect Ourselves and Others</div>
              <h2>了解疫情并听从您的医疗保健提供者的建议</h2>
            </div>
            <!-- List Style One -->
            <ul class="list-style-two">
              <li>分享最新事实，避免谣言惑众</li>
              <li>向受影响的人声援</li>
              <li>治愈患者分享经历，激励其他患者积极接受治疗</li>
              <li>......</li>
            </ul>
          </div>
        </div>
        
        <!--Image Column-->
        <div class="image-column wow fadeInRight">
          <div class="inner-column clearfix">
            <div class="big-image">
              <img src="img/resource/image-1.png" alt="" />
              <div class="small-image">
                <img src="img/resource/image-5.png" alt="" />
              </div>
            </div>
          </div>
        </div>
        
      </div>
    </div>
  </section>
 
  <section class="hand-wash-process-section" style="padding-bottom: 20px; padding-top: 30px;">
    <div class="auto-container">
      <!--Sec Title-->
      <div class="sec-title centered">
        <div class="title-icon">
          <span class="icon"><img src="img/icons/separater.png" alt="" /></span>
        </div>
        <h2>六步洗手法</h2>
      </div>
      <div class="row">
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-1.png" alt=""></div>
            <h4>Water and Soap</h4>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="300ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-2.png" alt=""></div>
            <h4>Palm to Palm</h4>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-3.png" alt=""></div>
            <h4>Between Fingers</h4>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-4.png" alt=""></div>
            <h4>Focus on Thumbs</h4>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="300ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-5.png" alt=""></div>
            <h4>Back to Hands</h4>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 process-block">
          <div class="inner-box wow fadeInUp" data-wow-delay="0ms" data-wow-duration="1500ms">
            <div class="image"><img src="img/resource/process-6.png" alt=""></div>
            <h4>Focus on Wrist</h4>
          </div>
        </div>
      </div>
    </div>
  </section>
  <div class="scroll-to-top scroll-to-target" data-target="html"><span class="flaticon-right-arrow"></span></div>
  
</div>
<!--End pagewrapper-->

<script src="js/jquery.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<!--<script src="js/jquery.fancybox.js"></script>-->
<script src="js/appear.js"></script>
<script src="js/owl.js"></script>
<script src="js/wow.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/script.js"></script>
  <!-- Portfolio -->
  <section class="content-section" id="team" style="padding-bottom: 10px; padding-top: 0px;">
    <center>
        <h1 style="font-family:华文中宋;border-bottom:1px solid #ddd">
        </h1>
    </center>
    <div class="container">
      <div class="content-section-heading text-center">
        <h2 class="mb-5" >关于团队</h2>
      </div>
      <div class="row no-gutters">
        <div class="col-lg-6">
          <a class="portfolio-item" href="#">
            <span class="caption">
              <span class="caption-content">
                <h2>王鹏</h2>
                <p class="mb-0">1811431</p>
              </span>
            </span>
            <img class="img-fluid" src="img/portfolio-1.jpg" alt="">
          </a>
        </div>
        <div class="col-lg-6">
          <a class="portfolio-item js-scroll-trigger" href="#team">
            <span class="caption">
              <span class="caption-content">
                <h2>王润泽</h2>
                <p class="mb-0">1811432</p>
              </span>
            </span>
            <img class="img-fluid" src="img/portfolio-2.jpg" alt="">
          </a>
        </div>
        <div class="col-lg-6">
          <a class="portfolio-item" href="#">
            <span class="caption">
              <span class="caption-content">
                <h2>黄林澜</h2>
                <p class="mb-0">1811364</p>
              </span>
            </span>
            <img class="img-fluid" src="img/portfolio-3.jpg" alt="">
          </a>
        </div>
        <div class="col-lg-6">
          <a class="portfolio-item" href="#">
            <span class="caption">
              <span class="caption-content">
                <h2>刘衍辰、陈横</h2>
                <p class="mb-0">1811391、1811340</p>
              </span>
            </span>
            <img class="img-fluid" src="img/portfolio-4.jpg" alt="">
          </a>
        </div>
      </div>
    </div>
  </section>

  <!-- Map -->


  <!-- article -->
  <?=ArticleWidget::widget()?>



  <!-- Footer -->
  <footer class="main-footer">
    <!--Widgets Section-->
    <div class="auto-container">
      
      <!--Widgets Section-->
            <div class="widgets-section">
              <div class="row clearfix">
                  
                    <!--Column-->
                    <div class="big-column col-lg-6 col-md-12 col-sm-12">
            <div class="row clearfix">
              
              <!--Footer Column-->
                            <div class="footer-column col-lg-6 col-md-6 col-sm-12">
                                <div class="widget widget_about">
                  <div class="logo">
                    <a href="index.php"><img src="img/logo.png" alt="" /></a>
                  </div>
                  
                </div>
              </div>
              
              <!--Footer Column-->
                            <div class="footer-column col-lg-6 col-md-6 col-sm-12 pl-lg-5">
                                <div class="widget widget_links">
                  <h2>About Us</h2>
                  <ul class="list">
                    <li><a href="#">About</a></li>
                    <li><a href="#">Faq's</a></li>
                    <li><a href="#">Team</a></li>
                    <li><a href="#">Prevention</a></li>
                    <li><a href="#">Contact</a></li>
                  </ul>
                </div>
              </div>
              
            </div>
          </div>
          
          <!--Column-->
                    <div class="big-column col-lg-6 col-md-12 col-sm-12">
            <div class="row clearfix">
              
              <!--Footer Column-->
                            <div class="footer-column col-lg-6 col-md-6 col-sm-12">
                                <div class="widget widget_links">
                  <h2>Usefull Links</h2>
                  <ul class="list">
                    <li><a href="#">Situation Reports</a></li>
                    <li><a href="#">Advice For Public</a></li>
                    <li><a href="#">Prevention</a></li>
                    <li><a href="#">Coronavirus Symptoms</a></li>
                    <li><a href="#">Donor & Partners</a></li>
                  </ul>
                </div>
              </div>
              
              <!--Footer Column-->
                            <div class="footer-column col-lg-6 col-md-6 col-sm-12">
                                <div class="widget widget_contact">
                  <h2>Contact us</h2>
                  <div class="widget-content">
                    <div class="text">3407  Wilkinson Court, Denver <br> Colorado 33901</div>
                    <ul class="social-icon-one clearfix">
                      <li><a href="#" class="fa fa-facebook"></a></li>
                      <li><a href="#" class="fa fa-twitter"></a></li>
                      <li><a href="#" class="fa fa-google-plus"></a></li>
                      <li><a href="#" class="fa fa-linkedin"></a></li>
                    </ul>
                  </div>
                </div>
              </div>
              
            </div>
          </div>
          
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="auto-container">
        <div class="copyright tex-center">Copyrights 2020 All Rights <a href="http://www.bootstrap.com/">Reserved</a>.</div>
      </div>
    </div>
  </footer>

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded js-scroll-trigger" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Plugin JavaScript -->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for this template -->
  <script src="js/stylish-portfolio.min.js"></script>
<?php $this->endBody() ?>
</body>
