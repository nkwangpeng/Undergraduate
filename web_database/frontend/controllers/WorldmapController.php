<?php


/**
 * Team:NKtoString
 * Coding by huanglinlan 1811364, 20200524
 * This is the worlpmap controller
 */


namespace frontend\controllers;

use Yii;
use app\models\Worldmap;
use frontend\models\WorldmapSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * WorldmapController implements the CRUD actions for Worldmap model.
 */
class WorldmapController extends Controller
{
    public $layout = false;
    public $enableCsrfValidation = false;
    /**
     * {@inheritdoc}
     */

    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['POST'],
                ],
            ],
        ];
    }

    /**
     * Lists all Worldmap models.
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->render('index');
    }
    public function actionPage()
    {
        return $this->render('page');
    }
    


    public function actionData(){
        try{
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $all= Worldmap::find()->all();
        }catch(\Exception $e){}
        return $all;
    }
}
