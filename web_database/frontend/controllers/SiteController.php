<?php

/**
 * Team:NKtoString
 * Coding by wangpeng,1811431
 * This is the main controller
 */

namespace frontend\controllers;

use Yii;
use frontend\models\LoginForm;
use frontend\models\PasswordResetRequestForm;
use frontend\models\ResetPasswordForm;
use frontend\models\SignupForm;
use frontend\models\ContactForm;
use yii\base\InvalidParamException;
use yii\web\BadRequestHttpException;
use yii\web\Controller;
use yii\filters\VerbFilter;
use yii\filters\AccessControl;
use frontend\models\EntryForm;
use frontend\models\WishForm;
use yii\helpers\Json;
use frontend\models\Current;
use frontend\models\Tendency;

/**
 * Site controller
 */
class SiteController extends Controller
{
    public $layout = false;
    public $enableCsrfValidation = false;

    /**
     * @inheritdoc
     */

    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['logout', 'signup'],
                'rules' => [
                    [
                        'actions' => ['signup'],
                        'allow' => true,
                        'roles' => ['?'],
                    ],
                    [
                        'actions' => ['logout'],
                        'allow' => true,
                        'roles' => ['@'],
                    ],
                ],
            ],
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'logout' => ['post'],
                ],
            ],
        ];
    }

    /**
     * @inheritdoc
     */
    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }

    /**
     * Displays homepage.
     *
     * @return mixed
     */
    public function actionIndex()
    {

        //$this->layout = "main_layout";
        \YII::beginProfile('profile0');
        //echo 'hello';
        \Yii::Warning('Hello, I am a test log message');
        \YII::endProfile('profile0');

        return $this->render('index');
    }

    /**
     * Logs in a user.
     *
     * @return mixed
     */
    public function actionLogin()
    {
        $this->layout="main-login";
        if (!\Yii::$app->user->isGuest) {
            return $this->goHome();
        }

        $model = new LoginForm();
        if ($model->load(Yii::$app->request->post()) && $model->login()) {
            return $this->goBack();
        } else {
            return $this->render('login', [
                'model' => $model,
            ]);
        }
    }


    /**
     * Logs out the current user.
     *
     * @return mixed
     */
    public function actionLogout()
    {
        if(Yii::$app->request->isPost){
        Yii::$app->user->logout();
        return $this->goHome();
}
else{

    $csrfToken = Yii::$app->request->csrfToken;
    return $this->render('index',['csrfToken'=>$csrfToken]);
}
    }

    /**
     * Displays contact page.
     *
     * @return mixed
     */
    public function actionContact()
    {
        $model = new ContactForm();
        if ($model->load(Yii::$app->request->post()) && $model->validate()) {
            if ($model->sendEmail(Yii::$app->params['adminEmail'])) {
                Yii::$app->session->setFlash('success', 'Thank you for contacting us. We will respond to you as soon as possible.');
            } else {
                Yii::$app->session->setFlash('error', 'There was an error sending email.');
            }

            return $this->refresh();
        } else {
            return $this->render('contact', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Displays about page.
     *
     * @return mixed
     */
    public function actionAbout()
    {
        //$this->layout = "main2";
        return $this->render('about');
    }


    /** 
     * Displays teamwork page.
     */
    public function actionTeamwork()
    {
        return $this->render('teamwork');
    }

     /** 
     * Displays personal page.
     */
    public function actionPersonalwork1()
    {
        return $this->render('personalwork1');
    }


    /**
     * Signs user up.
     *
     * @return mixed
     */
    public function actionSignup()
    {
        $this->layout="main-login";
        $model = new SignupForm();
        if ($model->load(Yii::$app->request->post())) {
            if ($user = $model->signup()) {
               
                    return $this->goHome();
                
            }
        }

        return $this->render('signup', [
            'model' => $model,
        ]);
    }
    /**
     * Requests password reset.
     *
     * @return mixed
     */
    public function actionRequestPasswordReset()
    {
        $model = new PasswordResetRequestForm();
        if ($model->load(Yii::$app->request->post()) && $model->validate()) {
            if ($model->sendEmail()) {
                Yii::$app->session->setFlash('success', 'Check your email for further instructions.');

                return $this->goHome();
            } else {
                Yii::$app->session->setFlash('error', 'Sorry, we are unable to reset password for email provided.');
            }
        }

        return $this->render('requestPasswordResetToken', [
            'model' => $model,
        ]);
    }

    /**
     * Resets password.
     *
     * @param string $token
     * @return mixed
     * @throws BadRequestHttpException
     */
    public function actionResetPassword($token)
    {
        try {
            $model = new ResetPasswordForm($token);
        } catch (InvalidParamException $e) {
            throw new BadRequestHttpException($e->getMessage());
        }

        if ($model->load(Yii::$app->request->post()) && $model->validate() && $model->resetPassword()) {
            Yii::$app->session->setFlash('success', 'New password was saved.');

            return $this->goHome();
        }

        return $this->render('resetPassword', [
            'model' => $model,
        ]);
    }
    public function actionEntry(){
        $this->layout = "main";
        $model =new EntryForm();

    if ($model->load(Yii::$app->request->post()) && $model->validate()) {
        return $this->render('entry-form',['model'=>$model]);
    }

    else{
        return $this->render('entry', [
        'model' => $model]);
        }
}
public function actionAddWish()
    {
        $model=new WishForm();
        $model->content=Yii::$app->request->post('content');
        if ($model->validate()){
            if ($model->create()){
                return json_encode(['status'=>true]);
            }
        }
     
        return json_encode(['status'=>false,'msg'=>'登录之后才可以留言噢']);
    }
  
   
    public function actionUpdateCurrent()
    {
        try{
        $model=Current::findModel(1);
        $model->confirmedCount=Yii::$app->request->post("confirmedCount");
        $model->deadCount=Yii::$app->request->post("deadCount");
        $model->curedCount=Yii::$app->request->post("curedCount");
        $model->currentConfirmedCount=Yii::$app->request->post("currentConfirmedCount");
        $model->seriousCount=Yii::$app->request->post("seriousCount");
        $model->suspectedCount=Yii::$app->request->post("suspectedCount");

         if(!$model->save()){
            echo json_encode($model->errors);
       }
      }catch(\Exception $e){
      }
        // return $this->render('tendency',['model'=>$model]);
    }

    public function actionPage1()
    {
        return $this->render('page1');

    }
     public function actionPage2()
    {
        return $this->render('page2');

    }
     public function actionPage3()
    {
        return $this->render('page3');

    }
     public function actionPage4()
    {
        return $this->render('page4');

    }
     public function actionPage5()
    {
        return $this->render('page5');

    }

}