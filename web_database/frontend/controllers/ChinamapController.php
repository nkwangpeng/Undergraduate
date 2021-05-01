<?php

/**
 * Team:NKtoString
 * Coding by wangrunze,1811432
 * This is the chinamap controller
 */
namespace frontend\controllers;

use Yii;
use frontend\models\China;
use frontend\models\ChinaQuery;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\helpers\Json;


class ChinamapController extends Controller
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
        $all=China::find()->all();
        }catch(\Exception $e){}
        return $all;
    }
}
