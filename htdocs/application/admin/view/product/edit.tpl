<extend name="public:base" />

<block name="body">
<include file="public/bread" menu="product_index" title="商品详情" />
<div id="page-wrapper">
    <div class="page-header">{$id>0?'编辑':'添加'}商品</div>
    <div id="page-content">
    <form method="post" action="" class="page-form" enctype="multipart/form-data">
        <div class="form-row">
            <div class="col">
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text">商品名称</span> </div>
                        <input type="text" name="title" class="form-control" value="{$product.title}" id="product-title" placeholder="输入商品名称">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text">商品特性</span> </div>
                        <input type="text" name="vice_title" class="form-control" value="{$product.vice_title}" id="product-vice_title" placeholder="简要概括文字">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text">商品货号</span> </div>
                        <input type="text" name="goods_no" class="form-control" value="{$product.goods_no}" id="product-goods_no" placeholder="输入商品货号">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text">商品分类</span> </div>
                        <select name="cate_id" id="product-cate" class="form-control">
                            <foreach name="category" item="v">
                                <option value="{$v.id}" data-props="{$v['props']}" data-specs="{$v['specs']}" {$product['cate_id'] == $v['id']?'selected="selected"':""}>{$v.html} {$v.title}</option>
                            </foreach>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">商品主图</span>
                        </div>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" name="upload_image"/>
                            <label class="custom-file-label" for="upload_image">选择文件</label>
                        </div>
                    </div>
                    <if condition="$product['image']">
                        <figure class="figure">
                            <img src="{$product.image}" class="figure-img img-fluid rounded" alt="image">
                            <figcaption class="figure-caption text-center">{$product.image}</figcaption>
                        </figure>
                        <input type="hidden" name="delete_image" value="{$product.image}"/>
                    </if>
                </div>
            </div>
            <div class="col-4">
                <div class="card form-group">
                    <div class="card-header">商品属性</div>
                    <div class="card-body">
                        <div class="form-row">
                            <label class="col-3">是否发布</label>
                            <div class="form-group col">
                                <div class="btn-group btn-group-toggle btn-group-sm" data-toggle="buttons">
                                    <label class="btn btn-outline-secondary{$product['status']=='1'?' active':''}">
                                        <input type="radio" name="status" value="1" autocomplete="off" {$product['type']=='1'?'checked':''}>是
                                    </label>
                                    <label class="btn btn-outline-secondary{$product['status']=='0'?' active':''}">
                                        <input type="radio" name="status" value="0" autocomplete="off" {$product['type']=='0'?'checked':''}>否
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <label class="col-3">商品类型</label>
                            <div class="form-group col">
                                <div class="btn-group btn-group-toggle btn-group-sm" data-toggle="buttons">
                                    <volist name="types" id="type" key="k">
                                        <label class="btn btn-outline-secondary{$k==$product['type']?' active':''}">
                                            <input type="radio" name="type" value="{$k}" autocomplete="off" {$k==$product['type']?'checked':''}>{$type}
                                        </label>
                                    </volist>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <label class="col-3">支持折扣</label>
                            <div class="form-group col">
                                <div class="btn-group btn-group-toggle btn-group-sm" data-toggle="buttons">
                                    <label class="btn btn-outline-secondary{$product['is_discount']==1?' active':''}">
                                        <input type="radio" name="is_discount" value="1" autocomplete="off" {$product['is_discount']==1?'checked':''}>支持
                                    </label>
                                    <label class="btn btn-outline-secondary{$product['is_discount']==0?' active':''}">
                                        <input type="radio" name="is_discount" value="0" autocomplete="off" {$product['is_discount']==0?'checked':''}>不支持
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <label class="col-3">支持分佣</label>
                            <div class="form-group col">
                                <div class="btn-group btn-group-toggle btn-group-sm" data-toggle="buttons">
                                    <label class="btn btn-outline-secondary{$product['is_commission']==1?' active':''}">
                                        <input type="radio" name="is_commission" value="1" autocomplete="off" {$product['is_commission']==1?'checked':''}>支持
                                    </label>
                                    <label class="btn btn-outline-secondary{$product['is_commission']==0?' active':''}">
                                        <input type="radio" name="is_commission" value="0" autocomplete="off" {$product['is_commission']==0?'checked':''}>不支持
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <label class="col-3">限制购买</label>
                            <div class="form-group col">
                                <div class="btn-group btn-group-toggle btn-group-sm" data-toggle="buttons">
                                    <volist name="levels" id="lv" key="k">
                                        <label class="btn btn-outline-secondary{:fix_in_array($k,$product['levels'])?' active':''}">
                                            <input type="checkbox" name="levels[]" value="{$k}" autocomplete="off" {:fix_in_array($k,$product['levels'])?'checked':''}>{$lv.level_name}
                                        </label>
                                    </volist>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-row">
            <label class="col-2" style="max-width: 80px;">自定义属性</label>
            <div class="form-group col">
                <div class="prop-groups">
                    <foreach name="product['prop_data']" item="prop" key="k">
                        <div class="input-group mb-2" >
                            <input type="text" class="form-control" style="max-width:120px;" name="prop_data[keys][]" value="{$k}"/>
                            <input type="text" class="form-control" name="prop_data[values][]" value="{$prop}"/>
                            <div class="input-group-append delete"><a href="javascript:" class="btn btn-outline-secondary"><i class="ion-md-trash"></i> </a> </div>
                        </div>
                    </foreach>
                </div>
                <a href="javascript:" class="btn btn-outline-dark btn-sm addpropbtn"><i class="ion-md-add"></i> 添加属性</a>
            </div>
        </div>
        <div class="form-row">
            <label class="col-2" style="max-width: 80px;">商品规格</label>
            <div class="form-group col">
                <div class="spec-groups">
                    <foreach name="product['spec_data']" item="spec" key="k">
                    <div class="d-flex spec-row spec-{$k}" data-specid="{$k}">
                        <input type="hidden" name="spec_data[{$k}][title]" value="{$spec['title']}"/>
                        <label>{$spec.title}</label>
                        <div class="form-control col"><input type="text" class="taginput" data-spec_id="{$k}" value="{:implode(',',$spec['data'])}" ></div>
                        <div class="delete"><a href="javascript:" class="btn btn-outline-secondary"><i class="ion-md-trash"></i> </a> </div>
                    </div>
                    </foreach>
                </div>
                <a href="javascript:" class="btn btn-outline-dark btn-sm addspecbtn"><i class="ion-md-add"></i> 添加规格</a>
            </div>
        </div>
        <div class="form-group">
            <table class="table table-hover spec-table">
                <thead>
                <tr>
                    <foreach name="product['spec_data']" item="spec" key="k">
                        <th class="specth">{$spec['title']}</th>
                    </foreach>
                    <th class="first" scope="col">规格货号&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="goods_no"><i class="ion-md-create"></i> </a> </th>
                    <th scope="col">规格图片</th>
                    <th scope="col">重量(克)&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="weight"><i class="ion-md-create"></i> </a> </th>
                    <th scope="col">销售价&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="price"><i class="ion-md-create"></i> </a></th>
                    <th scope="col">市场价&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="market_price"><i class="ion-md-create"></i> </a></th>
                    <th scope="col">成本价&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="cost_price"><i class="ion-md-create"></i> </a></th>
                    <th scope="col">库存&nbsp;<a class="batch-set" title="批量设置" href="javascript:" data-field="storage"><i class="ion-md-create"></i> </a></th>
                    <th scope="col">操作</th>
                </tr>
                </thead>
                <tbody>
                    <foreach name="skus" item="sku" key="k">
                    <tr data-idx="{$k}">
                        <foreach name="sku['specs']" item="spec" key="sk">
                            <td><input type="hidden" class="spec-val" data-specid="{$sk}" name="skus[{$k}][specs][{$sk}]" value="{$spec}" />{$spec}</td>
                        </foreach>
                        <td>
                            <input type="hidden" class="field-sku_id" name="skus[{$k}][sku_id]" value="{$sku.sku_id}"/>
                            <input type="text" class="form-control field-goods_no" name="skus[{$k}][goods_no]" value="{$sku.goods_no}">
                        </td>
                        <td><input type="hidden" class="field-sku_id" name="skus[{$k}][image]" value="{$sku.image}"/><img class="imgupload" src="{$sku.image|default='/static/images/noimage.png'}" /> </td>
                        <td><input type="text" class="form-control field-weight" name="skus[{$k}][weight]" value="{$sku.weight}"> </td>
                        <td><input type="text" class="form-control field-price" name="skus[{$k}][price]" value="{$sku.price}"> </td>
                        <td><input type="text" class="form-control field-market_price" name="skus[{$k}][market_price]" value="{$sku.market_price}"> </td>
                        <td><input type="text" class="form-control field-cost_price" name="skus[{$k}][cost_price]" value="{$sku.cost_price}"> </td>
                        <td><input type="text" class="form-control field-storage" name="skus[{$k}][storage]" value="{$sku.storage}"> </td>
                        <td><a href="javascript:" class="btn btn-outline-secondary delete-btn"><i class="ion-md-trash"></i> </a> </td>
                    </tr>
                    </foreach>
                </tbody>
            </table>
        </div>

        <div class="form-group">
            <label for="product-content">商品介绍</label>
            <script id="product-content" name="content" type="text/plain">{$product.content|raw}</script>
        </div>
        <div class="form-group submit-btn">
            <input type="hidden" name="id" value="{$product.id}">
            <button type="submit" class="btn btn-primary">{$id>0?'保存':'添加'}</button>
        </div>
    </form>
        </div>
</div>
    </block>
<block name="script">
<!-- 配置文件 -->
<script type="text/javascript" src="__STATIC__/ueditor/ueditor.config.js"></script>
<!-- 编辑器源码文件 -->
<script type="text/javascript" src="__STATIC__/ueditor/ueditor.all.min.js"></script>
<!-- 实例化编辑器 -->
<script type="text/javascript">
    var ue = UE.getEditor('product-content',{
        toolbars: Toolbars.normal,
        initialFrameHeight:500,
        zIndex:100
    });
    jQuery(function ($) {
        var usespecs=[];
        var rows=null;
        var isready=false;
        var goods_no=$('[name=goods_no]').val();
        var skus=JSON.parse('{$skus|json_encode|raw}');

        function setSpecs(specids) {
            if(specids && specids.length) {
                $.ajax({
                    url: "{:url('get_specs')}",
                    dataType: 'JSON',
                    data: {
                        ids: specids.join(',')
                    },
                    type: 'POST',
                    success: function (json) {
                        $('.spec-groups').html('');
                        if (json.code === 1 && json.data) {
                            addSpec(json.data);
                        }
                        resetSkus();
                    }
                })
            }else{
                $('.spec-groups').html('');
                resetSkus();
            }
        }
        function changeCategory(select,force) {
            var option=$(select).find('option:selected');
            var curProps=[];
            var props=$(option).data('props') || [];
            $('.prop-groups .input-group').each(function () {
                var input=$(this).find('input');
                var prop=input.val().trim();
                if(input.eq(1).val().trim()===''){
                    if(props.indexOf(prop)<0){
                        $(this).remove();
                    }else{
                        curProps.push(prop);
                    }
                }else {
                    curProps.push(prop);
                }
            });
            for(var i=0;i<props.length;i++){
                if(curProps.indexOf(props[i])<0){
                    addProp(props[i]);
                }
            }
            var newspecs = $(option).data('specs');
            if(!newspecs)newspecs=[];
            if(force===true){
                setSpecs(newspecs);
            }else {
                usespecs = usespecs.sort(function (a, b){return a<b?-1:1});
                newspecs = newspecs.sort(function (a, b){return a<b?-1:1});
                if (usespecs.join(',') !== newspecs.join(',')) {
                    dialog.confirm('是否重置规格?', function () {
                        setSpecs(newspecs);
                    })
                }
            }
        }
        $('#product-cate').change(function (e) {
            changeCategory(this);
        });
        if('add'==="{$product['id']?'':'add'}"){
            changeCategory($('#product-cate'),true);
        }

        window.checkUsed=function(id) {
            if(usespecs.indexOf(id)>-1){
                return ' disabled';
            }
            return '';
        };
        window.joinTags=function (data) {
            return data?('<span class="badge badge-secondary badge-pill">'+
                data.join('</span><span class="badge badge-secondary badge-pill">')+
                '</span>'):'';
        };
        function updateSkus(){
            skus=[];
            var skurows=$('.spec-table tbody tr');
            skurows.each(function () {
                var sku={
                    sku_id: '',
                    goods_no: '',
                    weight: '',
                    price: '',
                    market_price: '',
                    cost_price: '',
                    storage: ''
                };
                for(var i in sku){
                    sku[i]=$(this).find('.field-'+i).val();
                }
                sku.specs={};
                var speccells=$(this).find('.spec-val');
                speccells.each(function () {
                    sku.specs[$(this).data('specid')]=$(this).val();
                });
                skus.push(sku);
            });
        }
        function resetSkus(){
            if(!isready)return;
            var nrows=[],specrows=$('.spec-groups .spec-row');
            usespecs=[];
            var spec_datas=[];
            for(var i=0;i<specrows.length;i++){
                nrows.push(specrows.eq(i).find('label').text());
                var specid=specrows.eq(i).data('specid');
                usespecs.push(specid);

                var datas=[],labels=specrows.eq(i).find('.badge input[type=hidden]');
                for(var k=0;k<labels.length;k++){
                    datas.push(labels.eq(k).val());
                }
                spec_datas.push(datas);
            }

            var rowhtml='<tr data-idx="{@i}">\n' +
                '   {@specs}\n' +
                '   <td>\n' +
                '       <input type="hidden" class="field-sku_id" name="skus[{@i}][sku_id]" value="{@sku_id}"/>\n'+
                '       <input type="text" class="form-control field-goods_no" name="skus[{@i}][goods_no]" value="{@goods_no}">\n' +
                '   </td>\n' +
                '   <td><input type="hidden" class="field-image" name="skus[{@i}][image]" value="{@image}"/><img class="imgupload" src="{@image|default=/static/images/noimage.png}" /></td>\n' +
                '   <td><input type="text" class="form-control field-weight" name="skus[{@i}][weight]" value="{@weight}"> </td>\n' +
                '   <td><input type="text" class="form-control field-price" name="skus[{@i}][price]" value="{@price}"> </td>\n' +
                '   <td><input type="text" class="form-control field-market_price" name="skus[{@i}][market_price]" value="{@market_price}"> </td>\n' +
                '   <td><input type="text" class="form-control field-cost_price" name="skus[{@i}][cost_price]" value="{@cost_price}"> </td>\n' +
                '   <td><input type="text" class="form-control field-storage" name="skus[{@i}][storage]" value="{@storage}"> </td>\n' +
                '   <td><a href="javascript:" class="btn btn-outline-secondary delete-btn"><i class="ion-md-trash"></i> </a> </td>\n'+
                '</tr>';
            if(!rows || nrows.join("\n")!==rows.join("\n")){
                $('.spec-table thead th.specth').remove();
                for(i=0;i<nrows.length;i++){
                    $('.spec-table thead th.first').before('<th class="specth">'+nrows[i]+'</th>');
                }
                rows=nrows;
            }

            var allhtml=[];
            var mixed_specs=[[]];
            if(spec_datas.length>0) {
                mixed_specs = specs_mix(spec_datas);
            }
            for (i = 0; i < mixed_specs.length; i++) {
                var data = findSku(mixed_specs[i]);
                data.specs=spec_cell(mixed_specs[i],i);
                data.i= i;
                if(goods_no)data.goods_no=goods_no+'_'+i;
                allhtml.push(rowhtml.compile(data));
            }

            $('.spec-table tbody').html(allhtml.join('\n'));
            updateSkus();
        }
        function findSku(specs) {
            var spec_obj=array_combine(usespecs,specs);
            for(var i=0;i<skus.length;i++){
                if(isObjectValueEqual(spec_obj, skus[i].specs)){
                    return {
                        sku_id:skus[i].sku_id,
                        goods_no: skus[i].goods_no,
                        image: skus[i].image,
                        weight: skus[i].weight,
                        price: skus[i].price,
                        market_price: skus[i].market_price,
                        cost_price: skus[i].cost_price,
                        storage: skus[i].storage
                    };
                }
            }
            return {
                sku_id:'',
                image:'',
                goods_no: '',
                weight: '',
                price: '',
                market_price: '',
                cost_price: '',
                storage: ''
            };
        }
        function spec_cell(arr,idx) {
            var specs=[];
            for(var i=0;i<arr.length;i++){
                specs.push('<td><input type="hidden" class="spec-val" data-specid="'+usespecs[i]+'" name="skus['+idx+'][specs]['+usespecs[i]+']" value="'+arr[i]+'" />'+arr[i]+'</td>')
            }
            return specs.join('\n');
        }
        function specs_mix(arr, idx, base){
            if(!idx)idx=0;
            if(!base)base=[];
            var mixed=[];
            var l=arr.length;
            for(var i=0;i<arr[idx].length;i++){
                var narr=copy_obj(base);
                narr.push(arr[idx][i]);
                if(idx+1>=l){
                    mixed.push(narr);
                }else {
                    mixed = mixed.concat(specs_mix(arr, idx+1, narr));
                }
            }
            return mixed;
        }
        function addProp(key,value) {
            $('.prop-groups').append('<div class="input-group mb-2" >\n' +
                '                            <input type="text" class="form-control" style="max-width:120px;" name="prop_data[keys][]" value="'+(key?key:'')+'" />\n' +
                '                            <input type="text" class="form-control" name="prop_data[values][]" value="'+(value?value:'')+'" />\n' +
                '                            <div class="input-group-append delete"><a href="javascript:" class="btn btn-outline-secondary"><i class="ion-md-trash"></i> </a> </div>\n' +
                '                        </div>');
        }
        $('.addpropbtn').click(function (e) {
            addProp();
        });
        function addSpec(spec,update) {
            if(spec instanceof Array){
                for(var i=0;i<spec.length;i++){
                    addSpec(spec[i],false);
                }
                if(update!==false)resetSkus();
            }else {
                $('.spec-groups').append(('<div class="spec-row d-flex spec-{@id}" data-specid="{@id}">\n' +
                    '   <input type="hidden" name="spec_data[{@id}][title]" value="{@title}"/>\n' +
                    '   <label>{@title}</label>\n' +
                    '   <div class="form-control col"><input type="text" class="taginput" value="{@data}" ></div>\n' +
                    '   <div class="delete"><a href="javascript:" class="btn btn-outline-secondary"><i class="ion-md-trash"></i> </a> </div>\n' +
                    '</div>').compile(spec));
                var lastrow = $('.spec-groups .spec-row').eq(-1);
                var firstInit=update;
                lastrow.find('.taginput').tags('spec_data[' + spec.id + '][data][]',function () {
                    if(firstInit!==false)resetSkus();
                    else firstInit=true;
                });

                if(update!==false)resetSkus();
            }
        }
        $('.addspecbtn').click(function (e) {
            dialog.pickList({
                'url':'{:url("get_specs")}',
                'name':'规格',
                'rowTemplate':'<a class="list-group-item list-group-item-action{@id|checkUsed} d-flex justify-content-between"  data-id="{@id}" ><span class="title">{@title}</span><div>{@data|joinTags}</div></a>'
            },function (spec) {
                if(!spec){
                    dialog.info('请选择规格');
                    return false;
                }
                if(checkUsed(spec.id)){
                    dialog.info('该规格已使用');
                    return false;
                }
                addSpec(spec);
            });
        });

        $('.taginput').each(function () {
            $(this).tags('spec_data['+$(this).data('spec_id')+'][data][]',resetSkus);
        });
        $('.prop-groups').on('click','.delete .btn',function (e) {
            var self=$(this);
            dialog.confirm('确定删除该属性？',function () {
                self.parents('.input-group').remove();
            })
        });
        $('.spec-groups').on('click','.delete .btn',function (e) {
            var self=$(this);
            dialog.confirm('确定删除该规格？',function () {
                self.parents('.spec-row').remove();
                resetSkus();
            })
        });
        $('.batch-set').click(function (e) {
            var field=$(this).data('field');
            dialog.prompt('请输入要设置的数据',function(val) {
                if(field==='goods_no'){
                    if(!val){
                        dialog.warning('请填写货号');
                        return false;
                    }
                    if(!goods_no){
                        goods_no=val;
                        $('[name=goods_no]').val(val);
                    }
                    $('.spec-table tbody .field-' + field).each(function () {
                        //console.log(this)
                        var row=$(this).parents('tr');
                        $(this).val(val+'_'+row.data('idx'));
                    })
                }else {
                    val=parseFloat(val);
                    if(isNaN(val)){
                        dialog.warning('请填写数值');
                        return false;
                    }
                    $('.spec-table tbody .field-' + field).val(val);
                }
                updateSkus();
                return true;
            });
        });
        $('.spec-table').on('click','.delete-btn',function (e) {
            var row=$(this).parents('tr').eq(0);
            row.remove();
        });

        var currentUpload=null;
        $(document.body).append('<div class="d-none uploadfield"><input type="file" /></div>').on('click','.imgupload',function (e) {
            currentUpload=$(this);
            $('.uploadfield input').trigger('click');
        });
        $('.uploadfield input').on('change',function (e) {
            if(this.value){
                var file=this.files[0];
                currentUpload.attr('src',window.URL.createObjectURL(file));
                (function (img) {
                    var formData=new FormData();
                    formData.append('file',file);
                    $.ajax({
                        url:"{:url('index/uploads',['folder'=>'productsku'])}",
                        data:formData,
                        cache:false,
                        processData: false,
                        contentType: false,
                        dataType:'json',
                        type:'POST',
                        success:function (json) {
                            if(json.code==1) {
                                dialog.success(json.msg);
                                img.attr('src',json.data.url);
                                img.parent().find('input[type=hidden]').val(json.data.url)
                            }else{
                                dialog.error(json.msg);
                            }
                        }
                    })
                })(currentUpload)
            }
        });
        isready=true;
    });
</script>
</block>