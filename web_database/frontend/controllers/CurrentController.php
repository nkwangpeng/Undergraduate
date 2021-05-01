<?php
/**
 * Team:NKtoString
 * Coding by wangpeng 1811431,
 * This is the current controller
 */
namespace frontend\controllers;

use Yii;
use frontend\models\Current;
use frontend\models\CurrentSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\helpers\Json;
use frontend\models\Tendency;

/**
 * CurrentController implements the CRUD actions for Current model.
 */
class CurrentController extends Controller
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
     * Lists all Current models.
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new CurrentSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Current model.
     * @param integer $id
     * @return mixed
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionView($id)
    {
        return $this->render('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new Current model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new Current();

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->id]);
        }

        return $this->render('create', [
            'model' => $model,
        ]);
    }

    /**
     * Updates an existing Current model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->id]);
        }

        return $this->render('update', [
            'model' => $model,
        ]);
    }

    /**
     * Deletes an existing Current model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionDelete($id)
    {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the Current model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Current the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    
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
}
