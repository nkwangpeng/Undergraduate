<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431,
 * This is the tendency controller
 */
namespace frontend\controllers;
use Yii;
use yii\helpers\Json;
use frontend\models\Current;
use frontend\models\Tendency;
use yii\filters\VerbFilter;

class TendencyController extends \yii\web\Controller
{
	public $layout = false;
    public $enableCsrfValidation = false;


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
    public function actionIndex()
    {
        return $this->render('index');
    }
      public function actionVisual()
    {
        try{
        $model=Current::findModel(1);
         // if(!$model->save())
         //   throw new  \Exception('保存失败')
        
      }catch(\Exception $e){
      }
        return $this->render('tendency',['model'=>$model]);
        
    }
     public function actionGive()
    {
        try{
         // if(!$model->save())
         //   throw new  \Exception('保存失败');
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $all= Tendency::find()->all();
      }catch(\Exception $e){
      }
        return $all;
        
    }


}
