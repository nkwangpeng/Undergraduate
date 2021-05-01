<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431
 * This is the tendency view
 */
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
              <li class="nav-item active">
                <a class="nav-link" href="index.php?r=tendency/visual">疫情变化趋势</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="index.php?r=chinamap/page">全国疫情图</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="index.php?r=worldmap/page">世界疫情图</a>
              </li>
              <li class="nav-item">
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
            <h1 class="mb-0 heading text-white">疫情变化趋势</h1>
            <p class="mb-0 text-white">绿色部分为实时数据，柱形图显示的数据截止到5.1 </p>
          </div>
        </div>
      </div>
    </div>
    <!-- END: .cover -->
    

    <!-- BEGIN: #main -->
    <div id="realTimeData">
    <div class="freshDiv">
      <span class="freshBtn">
        <svg viewBox="0 0 1024 1024" width="32" height="32">
          <path
            d="M512 96C283.2 96 96 283.2 96 512s187.2 416 416 416 416-187.2 416-416S740.8 96 512 96z m224 388h-196l89.6-89.6C600.2 363.6 558.2 344 512 344c-92.4 0-168 75.6-168 168s75.6 168 168 168c69.8 0 130.6-42.4 155.2-104h59.6c-27.8 92.6-112.6 160-214.8 160-124.6 0-224-100.8-224-224s100.8-224 224-224c61.6 0 117.6 25.2 158.2 65.8L736 288v196z"
            fill="#3d9006">
          </path>
        </svg>
      </span>
    </div>
    <div class="datatitle">全国疫情实时数据统计</div>
    <div class="datasubtitle">(截至2020-01-31 08:09)</div>
    <div class="process">
      <span class="processValue"></span>
      <span class="processDoc">
        <svg viewBox="0 0 1024 1024" width="16" height="16">
          <path
            d="M492.472287 611.957373H178.826494v219.547859h313.645793V611.957373zM285.516185 580.592077L254.350434 432.550666c-2.848879-13.678507 1.149171-27.189191 9.653851-36.983236l111.237255-137.066475c4.740968-5.845113 10.395747-11.080337 17.229372-12.730927l43.169109-10.434632c-2.656498 12.471008-3.51505 27.145189-1.344622 44.133061 2.340297 18.251653 8.190526 39.225295 19.136811 63.013024a37.993237 37.993237 0 0 0-10.181876 13.447239c-3.690035 8.127082-4.832042 18.063365-2.013863 29.168262l16.976616 66.934325c1.570772 6.290251 7.949027 10.122525 14.243371 8.547659a11.941959 11.941959 0 0 0 1.810225-0.609889l10.471471-3.97042c6.065124-2.281968 9.131966-9.052149 6.845905-15.115226-2.116193-5.632266-8.104569-8.676596-13.805396-7.258296l-13.748092-54.226934c-1.414206-5.584171-0.991582-10.245321 0.630356-13.821769a14.513523 14.513523 0 0 1 8.098429-7.610313 14.60562 14.60562 0 0 1 11.191877 0.319271c3.560075 1.593285 6.951305 4.79111 9.58222 9.891258l25.648096 49.770444c-5.202478 2.693337-7.675804 8.921166-5.565752 14.543199 2.289131 6.063077 9.055218 9.12992 15.122389 6.840788l10.996426-4.164848c6.0641-2.284015 9.12685-9.052149 6.841812-15.115226-0.180102-0.492209-0.394995-0.951673-0.631379-1.39988l-31.55563-61.226334c-5.257737-10.198249-12.705344-16.890658-20.882568-20.547947a37.849974 37.849974 0 0 0-18.315097-3.238758c-10.189039-21.888476-15.567526-40.852348-17.642787-57.107535-2.534724-19.805029-0.146332-35.515817 4.325506-47.533501l13.944566-3.364624a43.561034 43.561034 0 0 1 2.970652-0.296758l41.148083 59.526626v-29.654331l11.764928-11.760835 11.761858 11.760835 5.068426 27.885038 24.101882-58.113443 33.412928 12.899772-13.538314 64.685102c-19.468362 0.020466-35.246688 15.809026-35.246689 35.287621 0 19.485758 15.79777 35.284551 35.284551 35.28455 19.487804-0.002047 35.285574-15.796746 35.285574-35.28455 0-11.042475-5.073542-20.900987-13.014383-27.3652l13.404262-64.04656 24.132581 9.323324c7.604173 5.693664 12.856793 13.550594 15.414031 22.18421L727.292961 448.094656l125.496998 62.743894c21.215142 10.608594 29.810897 36.403022 19.208442 57.61407-10.609617 21.215142-36.403022 29.81499-57.618164 19.212536L675.069657 518.006795c-10.510357-4.640684-19.148067-13.460543-23.227981-25.173282l-30.15882-86.217468v163.555726c34.441348 69.050518 63.22587 127.723708 77.759859 206.560083h-0.026606c0.459464 2.520398 0.69687 5.111404 0.69687 7.753576l-0.061398 180.200791c0.11154 1.248431 0.168845 2.515282 0.168845 3.794412 0 23.813311-19.308726 43.12613-43.127153 43.12613l-15.387425-0.008186v-0.167822c-23.72633 0-42.957285-19.227885-42.957285-42.950122l0.061398-179.802726c-9.636455-49.513595-28.646376-92.259056-50.802958-137.671248h-24.174537v196.188896c0 8.65306-7.016797 15.682136-15.682136 15.682136l-17.951825-0.00307-7.538682 106.654899c-0.417508 23.470504-19.560459 42.349442-43.114874 42.349442l-15.980941-0.00307v-0.077771c-0.949626 0-1.899253-0.018419-2.860135-0.086981-23.72633-1.577935-41.676108-22.096207-40.098173-45.81742l6.991214-103.018075H163.144358c-8.664316 0-15.682136-7.021913-15.682136-15.679067v-250.924411c0-8.65613 7.01782-15.67395 15.682136-15.67395l122.371827-0.00614zM532.539761 12.123084c-51.966455 0-94.097933 42.132502-94.097933 94.094864 0 51.972595 42.131479 94.09384 94.097933 94.09384 51.965432-0.002047 94.088724-42.119199 94.088724-94.09384 0-51.964408-42.123292-94.092817-94.088724-94.092817v-0.002047zM369.945941 564.010457a42.941935 42.941935 0 0 1 0.192381 16.585714l36.268969-0.004094-0.019443-224.033001-63.613702 78.399424 27.171795 129.051957z"
            fill="#82AC28"></path>
          <path
            d="M304.284606 643.317552h62.725475v47.054595h47.046409v62.725475h-47.046409v47.050501h-62.725475v-47.050501h-47.051524V690.372147h47.051524z"
            fill="#82AC28"></path>
        </svg>
      </span>
    </div>

    <ul class="statistics">
      <li>
        <strong id="1" style="color: #f74c31;" dataContent="">0</strong>
        <span dataContent="">现有确诊</span>
      </li>
      <li>
        <strong id="2" style="color:#a25a4e;" dataContent="">0</strong>
        <span dataContent="">现有重症</span>
      </li>
      <li>
        <strong id="3" style="color: #f78207;" dataContent="">0</strong>
        <span dataContent="">现有疑似</span>
      </li>
      <li>
        <strong id="4" style="color: #ae212c;" dataContent="">0</strong>
        <span dataContent="">累计确诊</span>
      </li>

      <li>
        <strong id="5" style="color: #5d7092;" dataContent="">0</strong>
        <span dataContent="">累计死亡</span>
      </li>
      <li>
        <strong id="6" style="color: #28b7a3;" dataContent="">0</strong>
        <span dataContent="">累计治愈</span>
      </li>
    </ul>
  </div>
  
  <div id="main" style="margin-top: 20px;"></div>
  <script type="text/javascript" >
    var yesterday_confirmed = 0, yesterday_died = 0, yesterday_cured = 0,
      yesterday_current_unconfirmed = 0, yesterday_current_serious = 0, yesterday_current_confirmed = 0;

    var progress = 0;
    var processDocTipsbg = 'rgba(235, 75, 30, 0.9)';

    //3218435e78f4d1873ab412313d6d77c5
    var dataApi = '';
    dataApi = 'https://yiqing.ahusmart.com/overall';
    dataApi = 'https://api.tianapi.com/txapi/ncov/index?key=9d2ed450b9692452c645db9bb9febd8b';

    var myChart = echarts.init(document.getElementById('main'));
    var dataSource = [];
    var dimensions = ['日期', '累计确诊', '现有确诊（含重症）', '现有疑似', '现有重症', '累计死亡', '累计治愈',
      '累计确诊+现有疑似', '新增确诊', '新增疑似', '新增(疑似+确诊)', '观察中', '死亡/确诊'];
    option = {
      title: {
        text: '全国新型肺炎疫情趋势',
        x: 'center',
        y: 'top',
        top: '15px',
        subtext: '(支持缩放及左右滑动)',
        subtextStyle: {
          fontSize: 12
        }
      },
      legend: {
        type: 'scroll',
        x: 'center',
        y: 'bottom',
        padding: [0, 20],
        itemGap: 3,
        selected: {}
      },
      grid: {
        left: '15%',
        bottom: '40px'
      },
      tooltip: {},
      dataset: {
        dimensions: dimensions,
        source: dataSource,
      },
      xAxis: { type: 'category' },
      yAxis: {},
      dataZoom: [
        {
          type: 'inside',
          throttle: '50',
          minValueSpan: 7,
          start: 100,
          end: 100
        }],
      series: [
        { type: 'bar' },
        { type: 'bar' },
        { type: 'bar' },
        { type: 'bar' },
        { type: 'bar' },
        { type: 'bar' },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
            },


          }
        },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
            },


          }
        },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
            },


          }
        },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
            }
          }
        },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
            }
          }
        },
        {
          type: 'line',
          label: {
            normal: {
              show: true,
              position: 'top',
              formatter: function (params) {
                str = params.data['死亡/确诊'] + '%'
                return str;
              }
            }
          },
          tooltip: {
            formatter: function (item) {
              str = item.seriesName + "<br>"
                + item.marker + ' ' + item.data['日期'] + ' : ' + item.data['死亡/确诊'] + '%';
              return str;
            }

          }
        }
      ]
    };

    $.ajaxSettings.async = false;
    $.getJSON("index.php?r=tendency/give", function (data) {
      dataSource = data;
      console.log(data);
      option.legend.selected['累计确诊'] = true;
      option.legend.selected['累计确诊+现有疑似'] = true;
      option.legend.selected['观察中'] = true;
      option.legend.selected['死亡/确诊'] = true;
      option.legend.selected['新增确诊'] = true;
      option.legend.selected['新增疑似'] = true;
      option.legend.selected['新增(疑似+确诊)'] = true;
      option.dataset.source = dataSource;
    })


    myChart.setOption(option);
    window.onresize = () => this.myChart.resize();

    update();

    $('.tooltip').tooltipster({
      theme: 'tooltipster-shadow'
    });

    $(".statistics>li>strong").each(function () {
      $(this).bind("click", function () {
        $(this).attr('dataContent', '');
        $(this).removeClass('popshow');
      })


    });

        var PHPconfirmedCount;

        /*累计死亡*/
        var PHPdeadCount ;

        /*累计治愈*/
        var PHPcuredCount ;

        /*现有确诊*/
        var PHPcurrentConfirmedCount ;

        /*现有重症*/
        var PHPseriousCount;

        /*现有疑似*/
       var PHPsuspectedCount ;
    window.setInterval(() => update(), 1000 * 60 * 10);
    function update() {// + "?" + Date.parse(new Date())
      $.getJSON(dataApi, function (newpneumoniadata) {

        var summaryDataIn = newpneumoniadata.newslist[0].desc;

        $(".datasubtitle").text("(截至 "
          + new Date(summaryDataIn.modifyTime).Format("yyyy-MM-dd hh:mm:ss") + ")");

        /*累计确诊*/
        let confirmedCount = summaryDataIn.confirmedCount;
        PHPconfirmedCount =confirmedCount;
        /*累计死亡*/
        let deadCount = summaryDataIn.deadCount;
        PHPdeadCount=deadCount;
        /*累计治愈*/
        let curedCount = summaryDataIn.curedCount;
        PHPcuredCount=curedCount;
        /*现有确诊*/
        let currentConfirmedCount = summaryDataIn.currentConfirmedCount;
        PHPcurrentConfirmedCount=currentConfirmedCount;
        /*现有重症*/
        let seriousCount = summaryDataIn.seriousCount;
        PHPseriousCount=seriousCount;
        /*现有疑似*/
        let suspectedCount = summaryDataIn.suspectedCount;
        PHPsuspectedCount=suspectedCount;

        freshDataNum($(".statistics>li>strong").eq(0), currentConfirmedCount || yesterday_current_confirmed);
        freshDataNum($(".statistics>li>strong").eq(1), seriousCount || yesterday_current_serious);
        freshDataNum($(".statistics>li>strong").eq(2), suspectedCount || yesterday_current_unconfirmed);

        freshDataNum($(".statistics>li>strong").eq(3), confirmedCount || yesterday_confirmed);
        freshDataNum($(".statistics>li>strong").eq(4), deadCount || yesterday_died);
        freshDataNum($(".statistics>li>strong").eq(5), curedCount || yesterday_cured);

        freshbackgroud(currentConfirmedCount || yesterday_current_confirmed, confirmedCount || yesterday_confirmed);

        updateIncrease($(".statistics>li>span").eq(0), currentConfirmedCount, yesterday_current_confirmed);
        updateIncrease($(".statistics>li>span").eq(1), seriousCount, yesterday_current_serious);
        updateIncrease($(".statistics>li>span").eq(2), suspectedCount, yesterday_current_unconfirmed);

        updateIncrease($(".statistics>li>span").eq(3), confirmedCount, yesterday_confirmed);
        updateIncrease($(".statistics>li>span").eq(4), deadCount, yesterday_died);
        updateIncrease($(".statistics>li>span").eq(5), curedCount, yesterday_cured);

        console.log(summaryDataIn);

      })
    }


    function freshDataNum(target, newNum) {

      var oldNum = ~~(target.text());
      var increaseNum = ~~(target.attr('dataContent'));
      /* 右上角 即时新增数据*/
      if (oldNum != 0 && (newNum - oldNum) != 0) {
        target.attr('dataContent',
          ((increaseNum + (newNum - oldNum)) >= 0 ? '+' : '')
          + (increaseNum + (newNum - oldNum))
        );
        target.addClass('popshow');
      }
      else {
        //target.attr('dataContent', '');
      }

      target
        .prop('number', oldNum)
        .animateNumber({ number: newNum }, 3000);
    }

    function updateIncrease(target, newNum, oldNum) {
      if (newNum > 0 && oldNum > 0) {
        target.attr('dataContent', (newNum >= oldNum ? '+' : '') + (newNum - oldNum)
        );
      }
    }
    /* 动态改变背景 及 进度 刷新按钮动画*/
    function freshbackgroud(currentConfirmedCount, confirmedCount) {
      progress = 1 - currentConfirmedCount / confirmedCount;

      /*实时数据背景*/
      $('#realTimeData').css({ 'background-color': 'rgba(130, 210, 10, ' + 0 + ')' });
      $('#realTimeData').animate({ backgroundColor: 'rgba(130, 210, 10, ' + progress + ')' }, 3000);

      /*进度条进度*/
      $('.processValue').css({ 'width': 0 * 100 + '%' });
      $('.processValue').animate({ width: progress * 100 + '%' }, 3000);

      /*医生卡通位置*/
      $('.processDoc').css({ 'left': 0 * 100 + '%' });
      $('.processDoc').animate({ left: progress * 100 + '%' }, 3000);

      /*卡通提示背景*/
      let bgR = 255 * (1 - progress);
      let bgG = 255 * progress;
      processDocTipsbg = 'rgba(' + bgR + ', ' + bgG + ', 0, 0.9)'

      /*刷新按钮动画*/
      $(".freshBtn>svg").addClass("animation-rotate");
      window.setTimeout(() => $(".freshBtn>svg").removeClass("animation-rotate"), 3000);

    }

    var tipContent = ""
      + "1、数据每10分钟自动刷新一次，如有更新会在数字右上角提示。<br>"
      + "2、数字右下角为当前相对昨天24时官方数据的增（减）量。<br>"
      + "3、(实时数据采集自网络，仅供参考！实际数据以官方为准！！)<br>"
      + "4、2020年5月1日起每日数据不再更新，请参考卫健委官方数据。<br>";
    var tip_index = 0;
    $(".datasubtitle").bind("mouseenter",
      function () {
        var that = this;
        tip_index = layer.tips(tipContent,
          that,
          {
            tips: [1, 'rgba(10,140,15,0.9)'],
            time: 0
          });
      }).bind("mouseleave", () => layer.close(tip_index))

    var docTipContent = "任务进度："
      + (progress * 100).toFixed(2)
      + "%<br>全民战“疫”，坚持到底！";
    $(".processDoc").bind("mouseenter",
      function () {
        var that = this;
        if (progress < 1) {
          tip_index = layer.tips(docTipContent,
            that,
            {
              tips: [1, processDocTipsbg],
              time: 0
            });
        }
      }).bind("mouseleave", () => layer.close(tip_index))
    $(".freshBtn").click(function () {
      update();
    });

  </script>
  <script>
    var _hmt = _hmt || [];
    (function () {
      var hm = document.createElement("script");
      hm.src = "https://hm.baidu.com/hm.js?cdcc4d7a702f0597c5bfc96ec9508cbf";
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
  </script>
    <!-- END: #main -->
    <!-- <?php $temp="<script>document.writeln(PHPconfirmedCount);</script>"; $temp2=(string)$temp; $model->confirmedCount=$temp?>
    <?php $model->deadCount="<script>document.writeln(PHPdeadCount);</script>"; ?>
    <?php $model->curedCount="<script>document.writeln(PHPcuredCount);</script>"; ?>
    <?php $model->currentConfirmedCount="<script>document.writeln(PHPcurrentConfirmedCount);</script>"; ?>
    <?php $model->seriousCount="<script>document.writeln(PHPseriousCount);</script>"; ?>
    <?php $model->suspectedCount="<script>document.writeln(PHPsuspectedCount);</script>"; ?>
    <?php $model->id=1;?>
    <?= $model->confirmedCount;?>
    <?= $model->deadCount;?>
    <?= $model->curedCount;?>
    <?= $model->currentConfirmedCount;?>
    <?php if(!$model->save())
          echo json_encode($model->errors);
       ?>
    <script>document.writeln(confirmedCount)</script> -->
    <script type="text/javascript">

      $(function () {
    $.ajax({
    type : "post",
    url : "index.php?r=current/update-current",
    dateType : "json",
    data:{confirmedCount:PHPconfirmedCount, deadCount:PHPdeadCount, curedCount:PHPcuredCount,currentConfirmedCount:PHPcurrentConfirmedCount,seriousCount:PHPseriousCount,suspectedCount:PHPsuspectedCount},
    success : function(data) {  
        
    }
})
  });  
    </script>

    <div>
      <a href="http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml" target="_blank" style="margin-left: 1700px;"> (数据来源：国家卫健委)</a>
  </div>
    
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