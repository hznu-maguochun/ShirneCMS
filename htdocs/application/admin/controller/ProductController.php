<?php
/**
 * 商品管理
 * User: shirne
 * Date: 2018/5/11
 * Time: 17:47
 */

namespace app\admin\controller;


use app\admin\model\SpecificationsModel;
use app\common\model\ProductModel;
use app\common\model\ProductSkuModel;
use app\admin\validate\ProductSkuValidate;
use app\admin\validate\ProductValidate;
use app\admin\validate\ImagesValidate;
use app\common\facade\ProductCategoryFacade;
use think\Db;

class ProductController extends BaseController
{
    public function index($key='',$cate_id=0){
        $model = Db::view('product','*')
            ->view('productCategory',['name'=>'category_name','title'=>'category_title'],'product.cate_id=productCategory.id','LEFT');
        $where=array();
        if(!empty($key)){
            $where[]=['product.title|productCategory.title','like',"%$key%"];
        }
        if($cate_id>0){
            $where[]=['product.cate_id','in',ProductCategoryFacade::getSubCateIds($cate_id)];
        }

        $lists=$model->where($where)->paginate(10);

        $this->assign('lists',$lists);
        $this->assign('page',$lists->render());
        $this->assign('types',getProductTypes());
        $this->assign('keyword',$key);
        $this->assign('cate_id',$cate_id);
        $this->assign("category",ProductCategoryFacade::getCategories());

        return $this->fetch();
    }

    public function add($cid=0){
        if ($this->request->isPost()) {
            $data = $this->request->post();
            $validate = new ProductValidate();
            $validate->setId();
            $skuValidate=new ProductSkuValidate();
            $skuValidate->setId(0);
            $validate->rule([
                'skus'=>function($value) use ($skuValidate){
                    if(!is_array($value) || count($value)<1){
                        return '请填写商品规格信息';
                    }
                    foreach ($value as $sku){
                        if(!$skuValidate->check($sku)){
                            return $skuValidate->getError();
                        }
                    }
                    return true;
                }
            ]);
            if (!$validate->check($data)) {
                $this->error($validate->getError());
            } else {
                $delete_images=[];
                $uploaded = $this->upload('product', 'upload_image');
                if (!empty($uploaded)) {
                    $data['image'] = $uploaded['url'];
                    $delete_images[]=$data['delete_image'];
                }
                unset($data['delete_image']);
                $data['user_id'] = $this->mid;
                $skus=$data['skus'];
                $data['max_price']=array_max($skus,'price');
                $data['min_price']=array_min($skus,'price');
                $data['storage']=array_sum(array_column($skus,'storage'));
                if(!empty($data['prop_data'])){
                    $data['prop_data']=array_combine($data['prop_data']['keys'],$data['prop_data']['values']);
                }else{
                    $data['prop_data']=[];
                }
                unset($data['skus']);
                $model=ProductModel::create($data);
                if ($model['id']) {
                    delete_image($delete_images);
                    foreach ($skus as $sku){
                        $sku['product_id']=$model['id'];
                        ProductSkuModel::create($sku);
                    }
                    user_log($this->mid,'addproduct',1,'添加商品 '.$model->id ,'manager');
                    $this->success("添加成功", url('Product/index'));
                } else {
                    delete_image($data['image']);
                    $this->error("添加失败");
                }
            }
        }
        $model=array('type'=>1,'cate_id'=>$cid,'is_discount'=>1,'is_commission'=>1);
        $this->assign("category",ProductCategoryFacade::getCategories());
        $this->assign('product',$model);
        $this->assign('skus',[[]]);
        $this->assign('levels',getMemberLevels());
        $this->assign('types',getProductTypes());
        $this->assign('id',0);
        return $this->fetch('edit');
    }

    /**
     * 更新商品信息
     */
    public function edit($id)
    {
        $id = intval($id);

        if ($this->request->isPost()) {
            $data=$this->request->post();
            $validate=new ProductValidate();
            $validate->setId($id);
            $skuValidate=new ProductSkuValidate();
            $validate->rule([
                'skus'=>function($value) use ($skuValidate){
                    if(!is_array($value) || count($value)<1){
                        return '请填写商品规格信息';
                    }
                    foreach ($value as $sku){
                        $skuValidate->setId($sku['sku_id']);
                        if(!$skuValidate->check($sku)){
                            return $skuValidate->getError();
                        }
                    }
                    return true;
                }
            ]);
            if (!$validate->check($data)) {
                $this->error($validate->getError());
            }else{
                $delete_images=[];
                $uploaded=$this->upload('product','upload_image');
                if(!empty($uploaded)){
                    $data['image']=$uploaded['url'];
                    $delete_images[]=$data['delete_image'];
                }
                $model=ProductModel::get($id);
                $skus=$data['skus'];
                if(!empty($data['prop_data'])){
                    $data['prop_data']=array_combine($data['prop_data']['keys'],$data['prop_data']['values']);
                }else{
                    $data['prop_data']=[];
                }
                $data['max_price']=array_max($skus,'price');
                $data['min_price']=array_min($skus,'price');
                $data['storage']=array_sum(array_column($skus,'storage'));
                if ($model->allowField(true)->save($data)) {
                    delete_image($delete_images);
                    $existsIds=[];
                    foreach ($skus as $sku){
                        if($sku['sku_id']) {
                            ProductSkuModel::update($sku);
                            $existsIds[]=$sku['sku_id'];
                        }else{
                            $sku['product_id']=$id;
                            $skuModel=ProductSkuModel::create($sku);
                            $existsIds[]=$skuModel['sku_id'];
                        }
                    }
                    Db::name('productSku')->where('product_id',$id)->whereNotIn('sku_id',$existsIds)->delete();
                    user_log($this->mid, 'updateproduct', 1, '修改商品 ' . $id, 'manager');
                    $this->success("编辑成功", url('product/index'));
                } else {
                    delete_image($data['image']);
                    $this->error("编辑失败");
                }
            }
        }else{

            $model = ProductModel::get($id);
            if(empty($model)){
                $this->error('商品不存在');
            }
            $skuModel=new ProductSkuModel();
            $skus=$skuModel->where('product_id',$id)->select();
            $this->assign("category",ProductCategoryFacade::getCategories());
            $this->assign('levels',getMemberLevels());
            $this->assign('product',$model);
            $this->assign('skus',$skus->isEmpty()?[[]]:$skus);
            $this->assign('types',getProductTypes());
            $this->assign('id',$id);
            return $this->fetch();
        }
    }

    public function get_specs(){
        $model = new SpecificationsModel();
        $lists=$model->order('ID ASC')->select();
        return json(['lists'=>$lists]);
    }

    /**
     * 删除商品
     */
    public function delete($id)
    {
        $model = Db::name('product');
        $result = $model->where('id','in',idArr($id))->delete();
        if($result){
            Db::name('productSku')->where('product_id','in',idArr($id))->delete();
            Db::name('productImages')->where('product_id','in',idArr($id))->delete();
            Db::name('productComment')->where('product_id','in',idArr($id))->delete();
            user_log($this->mid,'deleteproduct',1,'删除商品 '.$id ,'manager');
            $this->success("删除成功", url('Product/index'));
        }else{
            $this->error("删除失败");
        }
    }
    public function push($id,$type=0)
    {
        $data['status'] = $type==1?1:0;

        $result = Db::name('product')->where('id','in',idArr($id))->update($data);
        if ($result && $data['status'] === 1) {
            user_log($this->mid,'pushproduct',1,'上架商品 '.$id ,'manager');
            $this -> success("上架成功", url('Product/index'));
        } elseif ($result && $data['status'] === 0) {
            user_log($this->mid,'cancelproduct',1,'下架商品 '.$id ,'manager');
            $this -> success("下架成功", url('Product/index'));
        } else {
            $this -> error("操作失败");
        }
    }

    /**
     * 图集
     * @param $aid
     * @return mixed
     */
    public function imagelist($aid){
        $model = Db::name('ProductImages');
        $product=Db::name('Product')->find($aid);
        if(empty($product)){
            $this->error('产品不存在');
        }
        $model->where('product_id',$aid);
        if(!empty($key)){
            $model->where('title','like',"%$key%");
        }
        $lists=$model->order('sort ASC,id DESC')->paginate(15);
        $this->assign('product',$product);
        $this->assign('lists',$lists);
        $this->assign('page',$lists->render());
        $this->assign('aid',$aid);
        return $this->fetch();
    }

    public function imageadd($aid){
        if ($this->request->isPost()) {
            $data=$this->request->post();
            $validate=new ImagesValidate();

            if (!$validate->check($data)) {
                $this->error($validate->getError());
            }else{
                $uploaded=$this->upload('product','upload_image');
                if(!empty($uploaded)){
                    $data['image']=$uploaded['url'];
                }
                $model = Db::name("ProductImages");
                $url=url('product/imagelist',array('aid'=>$aid));
                if ($model->insert($data)) {
                    $this->success("添加成功",$url);
                } else {
                    delete_image($data['image']);
                    $this->error("添加失败");
                }
            }
        }
        $model=array('status'=>1,'product_id'=>$aid);
        $this->assign('model',$model);
        $this->assign('aid',$aid);
        $this->assign('id',0);
        return $this->fetch('imageupdate');
    }

    /**
     * 添加/修改
     */
    public function imageupdate($id)
    {
        $id = intval($id);

        if ($this->request->isPost()) {
            $data=$this->request->post();
            $validate=new ImagesValidate();

            if (!$validate->check($data)) {
                $this->error($validate->getError());
            }else{
                $model = Db::name("ProductImages");
                $url=url('product/imagelist',array('aid'=>$data['product_id']));
                $delete_images=[];
                $uploaded=$this->upload('product','upload_image');
                if(!empty($uploaded)){
                    $data['image']=$uploaded['url'];
                    $delete_images[]=$data['delete_image'];
                }
                unset($data['delete_image']);
                $data['id']=$id;
                if ($model->update($data)) {
                    delete_image($delete_images);
                    $this->success("更新成功", $url);
                } else {
                    delete_image($data['image']);
                    $this->error("更新失败");
                }
            }
        }else{
            $model = Db::name('ProductImages')->where('id', $id)->find();
            if(empty($model)){
                $this->error('图片不存在');
            }

            $this->assign('model',$model);
            $this->assign('aid',$model['product_id']);
            $this->assign('id',$id);
            return $this->fetch();
        }
    }
    /**
     * 删除图片
     */
    public function imagedelete($aid,$id)
    {
        $id = intval($id);
        $model = Db::name('ProductImages');
        $result = $model->delete($id);
        if($result){
            $this->success("删除成功", url('product/imagelist',array('aid'=>$aid)));
        }else{
            $this->error("删除失败");
        }
    }

    /**
     * 商品评论
     * @param int $id
     * @return \think\Response
     */
    public function comments($id=0,$key=''){
        $model = Db::view('productComment','*')
            ->view('member',['username','level_id','avatar'],'member.id=productComment.member_id','LEFT')
            ->view('product',['title'=>'product_title','cate_id','cover'],'product.id=productComment.product_id','LEFT')
            ->view('productCategory',['name'=>'category_name','title'=>'category_title'],'product.cate_id=productCategory.id','LEFT');
        $where=array();
        if($id>0){
            $where[]=['product_id',$id];
        }
        if(!empty($key)){
            $where[]=['product.title|productCategory.title','like',"%$key%"];
        }

        $lists=$model->where($where)->paginate(10);

        $this->assign('lists',$lists);
        $this->assign('page',$lists->render());
        $this->assign('keyword',$key);
        $this->assign('product_id',$id);
        $this->assign("category",ProductCategoryFacade::getCategories());

        return $this->fetch();
    }

    public function commentview($id){
        $model=Db::name('productComment')->find($id);
        if(empty($model)){
            $this->error('评论不存在');
        }
        if($this->request->isPost()){
            $data=$this->request->post();
            $data['reply_time']=$id;
            $data['reply_user_id']=$this->mid;
            Db::name('productComment')->where('id',$id)->update($data);
            $this->success('回复成功');

        }
        $product=Db::name('product')->find($model['product_id']);
        $category=Db::name('productCategory')->find($product['cate_id']);
        $member=Db::name('member')->find($model['member_id']);

        $this->assign('model',$model);
        $this->assign('product',$product);
        $this->assign('category',$category);
        $this->assign('member',$member);
        return $this->fetch();
    }

    public function commentstatus($id,$type=1)
    {
        $data['status'] = $type==1?1:2;

        $result = Db::name('productComment')->where('id','in',idArr($id))->update($data);
        if ($result && $data['status'] === 1) {
            user_log($this->mid,'auditproductcomment',1,'审核评论 '.$id ,'manager');
            $this -> success("审核成功", url('Product/comments'));
        } elseif ($result && $data['status'] === 2) {
            user_log($this->mid,'hideproductcomment',1,'隐藏评论 '.$id ,'manager');
            $this -> success("评论已隐藏", url('Product/comments'));
        } else {
            $this -> error("操作失败");
        }
    }
    public function commentdelete($id)
    {
        $model = Db::name('productComment');
        $result = $model->where('id','in',idArr($id))->delete();
        if($result){
            user_log($this->mid,'deleteproductcomment',1,'删除评论 '.$id ,'manager');
            $this->success("删除成功", url('Product/comments'));
        }else{
            $this->error("删除失败");
        }
    }
}