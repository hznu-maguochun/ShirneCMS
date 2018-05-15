<extend name="public:base" />

<block name="body">

    <include file="public/bread" menu="product_category_index" title="规格管理" />

    <div id="page-wrapper">

        <div class="row list-header">
            <div class="col-6">
                <a href="javascript:" class="btn btn-outline-primary btn-sm btn-add"><i class="ion-md-add"></i> 规格</a>
            </div>
            <div class="col-6">
                &nbsp;
            </div>
        </div>
        <table class="table table-hover table-striped">
            <thead>
            <tr>
                <th width="50">编号</th>
                <th>名称</th>
                <th>规格值</th>
                <th width="200">操作</th>
            </tr>
            </thead>
            <tbody>
            <foreach name="lists" item="v">
                <tr>
                    <td>{$v.id}</td>
                    <td>{$v.title}</td>
                    <td>
                        <volist name="v['data']" id="val">
                            <span class="badge badge-info">{$val}</span>
                        </volist>
                    </td>
                    <td>
                        <a class="btn btn-outline-dark btn-sm btn-edit" href="javascript:" data-id="{$v.id}"><i class="ion-md-create"></i> 编辑</a>
                        <a class="btn btn-outline-dark btn-sm" href="{:url('oauth/delete',array('id'=>$v['id']))}" onclick="javascript:return del('您真的确定要删除吗？\n\n删除后将不能恢复!');"><i class="ion-md-trash"></i> 删除</a>
                    </td>
                </tr>
            </foreach>
            </tbody>
        </table>
    </div>
</block>
<block name="script">
    <script type="text/plain" id="editTpl">
        <form>
        <div class="form-group">
            <label for="title">规格名称</label>
            <input type="text" name="title" class="form-control" value="{@title}" >
        </div>
        <div class="form-group">
            <label for="data">规格值</label>
            <div class="form-control">
            <input type="text" class="taginput" value="{@data}" placeholder="填写多个值以,分割"  />
            </div>
        </div>
        <input type="hidden" name="id" value="{@id}"/>
        </form>
    </script>
    <script type="text/javascript">
        jQuery(function($){
            var tpl=$('#editTpl').html();
            $('.btn-add').click(function() {
                showDialog({title:'',data:'',id:0},'添加规格');
            });
            $('.btn-edit').click(function() {
                var id=$(this).data('id');
                var title=$(this).parents('tr').find('td').eq(1).text();
                var data=[];
                var labels=$(this).parents('tr').find('td').eq(2).find('.badge');
                labels.each(function() {
                    data.push($(this).text());
                });
                showDialog({id:id,title:title,data:data.join(',')},'编辑规格');
            });
            function showDialog(data,title){
                var issending=false;
                var  dlg=new Dialog({
                    onshow:function(body){
                        body.find('.taginput').tags('data[]');
                    },
                    onsure:function(body){
                        issending=true;
                        $.ajax({
                            url:'',
                            type:'POST',
                            dataType:'JSON',
                            data:body.find('form').serialize(),
                            success:function(json){
                                if(json.code==1){
                                    toastr.success(json.msg);
                                    setTimeout(function(){dlg.hide();location.reload();},500);
                                }else{
                                    issending=false;
                                    toastr.warning(json.msg);
                                }
                            }
                        })
                        return false;
                    }
                }).show(tpl.compile(data),title);
            }
        })
    </script>
</block>