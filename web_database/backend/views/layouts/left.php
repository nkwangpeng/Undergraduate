<aside class="main-sidebar">

    <section class="sidebar">

        <!-- Sidebar user panel -->
        <div class="user-panel">
            <div class="pull-left image">
                <img src="<?= $directoryAsset ?>/img/user2-160x160.jpg" class="img-circle" alt="User Image"/>
            </div>
            <div class="pull-left info">
                <p><?php echo "欢迎"?><?php echo Yii::$app->user->identity->username ?></p>

                <a href="#"><i class="fa fa-circle text-success"></i> 在线</a>
            </div>
        </div>

        <!-- search form -->
        <form action="#" method="get" class="sidebar-form">
            <div class="input-group">
                <input type="text" name="q" class="form-control" placeholder="Search..."/>
              <span class="input-group-btn">
                <button type='submit' name='search' id='search-btn' class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
            </div>
        </form>
        <!-- /.search form -->

        <?= dmstr\widgets\Menu::widget(
            [
                'options' => ['class' => 'sidebar-menu tree', 'data-widget'=> 'tree'],
                'items' => [
                    ['label' => 'Menu Yii2', 'options' => ['class' => 'header']], 
                    
                    ['label' => 'Login', 'url' => ['site/login'], 'visible' => Yii::$app->user->isGuest],
                    ['label' => '前台留言管理', 'icon' => 'file-code-o', 'url' => ['/wish']], 
					['label' => '文章管理', 'icon' => 'file-code-o', 'url' => ['/article']],
                    ['label' => '疫情新闻管理', 'icon' => 'file-code-o', 'url' => ['/news']],
                    ['label' => '谣言管理', 'icon' => 'file-code-o', 'url' => ['/rumour']],
                    ['label' => '疫情知识管理', 'icon' => 'file-code-o', 'url' => ['/knowledge']], 
                    [
					'label' => '权限管理',
					'icon' => 'fa fa-circle-o',
					'url' => '#',	
					'items' => [
					['label' => '路由管理', 'icon' => 'fa fa-circle-o', 'url' => ['/admin/route'],],
					['label' => '权限管理', 'icon' => 'fa fa-circle-o', 'url' => ['/admin/permission'],],
					['label' => '角色管理', 'icon' => 'fa fa-circle-o', 'url' => ['/admin/role'],],
					['label' => '用户与角色', 'icon' => 'fa fa-circle-o', 'url' => ['/admin/assignment'],],
					['label' => '菜单管理', 'icon' => 'fa fa-circle-o', 'url' => ['/admin/menu'],],
					],
					],				
                ],
            ]
        ) ?>

        <?= dmstr\widgets\Menu::widget(
            [
                'options' => ['class' => 'sidebar-menu tree', 'data-widget'=> 'tree'],
                'items' => [
                    ['label' => '作业查看', 'options' => ['class' => 'header']],
                     [
                    'label' => '作业模块',
                    'icon' => 'dashboard',
                    'url' => '#',   
                    'items' => [
                    ['label' => '个人作业', 'icon' => 'fa fa-circle-o', 'url' => ['/homework/person'],],
                    ['label' => '团队作业', 'icon' => 'fa fa-circle-o', 'url' => ['/homework/team'],]
                    ],
                    ], 
                ],
            ]
                )?>
    </section>

</aside>
