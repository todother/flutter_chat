package com.example.jpushdemo;

import android.app.Notification;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.Toast;

import java.util.LinkedHashSet;
import java.util.Set;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.InstrumentedActivity;
import cn.jpush.android.api.JPushInterface;
 import  com.guojio.todother.R;
import cn.jpush.android.api.MultiActionsNotificationBuilder;
import cn.jpush.android.api.TagAliasCallback;

import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_ADD;
import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_CHECK;
import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_CLEAN;
import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_DELETE;
import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_GET;
import static com.example.jpushdemo.TagAliasOperatorHelper.ACTION_SET;
import static com.example.jpushdemo.TagAliasOperatorHelper.TagAliasBean;
import static com.example.jpushdemo.TagAliasOperatorHelper.sequence;


public class PushSetActivity extends InstrumentedActivity implements OnClickListener {
    private static final String TAG = "JIGUANG-Example";

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        setContentView(R.layout.push_set_dialog);
        initListener();
    }

    private void initListener() {
        //增加tag
        findViewById(R.id.bt_addtag).setOnClickListener(this);
        //设置tag
        findViewById(R.id.bt_settag).setOnClickListener(this);
        //删除tag
        findViewById(R.id.bt_deletetag).setOnClickListener(this);
        //获取所有tag
        findViewById(R.id.bt_getalltag).setOnClickListener(this);
        //清除所有tag
        findViewById(R.id.bt_cleantag).setOnClickListener(this);
        //查询tag绑定状态
        findViewById(R.id.bt_checktag).setOnClickListener(this);

        //设置alias
        findViewById(R.id.bt_setalias).setOnClickListener(this);
        //获取alias
        findViewById(R.id.bt_getalias).setOnClickListener(this);
        //删除alias
        findViewById(R.id.bt_deletealias).setOnClickListener(this);
        //设置手机号码
        findViewById(R.id.bt_setmobileNumber).setOnClickListener(this);
        //StyleAddActions
        findViewById(R.id.setStyle0).setOnClickListener(this);
        //StyleBasic
        findViewById(R.id.setStyle1).setOnClickListener(this);
        //StyleCustom
        findViewById(R.id.setStyle2).setOnClickListener(this);
        //SetPushTime
        findViewById(R.id.bu_setTime).setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.setStyle0:
                setAddActionsStyle();
                break;
            case R.id.setStyle1:
                setStyleBasic();
                break;
            case R.id.setStyle2:
                setStyleCustom();
                break;
            case R.id.bu_setTime:
                Intent intent = new Intent(PushSetActivity.this, SettingActivity.class);
                startActivity(intent);
                break;
            default:
                onTagAliasAction(view);
                break;
        }
    }

    TagAliasCallback tagAlias = new TagAliasCallback() {
        @Override
        public void gotResult(int responseCode, String alias, Set<String> tags) {
            Log.e(TAG,"responseCode:"+responseCode+",alias:"+alias+",tags:"+tags);
        }
    };


    /**
     * 设置通知提示方式 - 基础属性
     */
    private void setStyleBasic() {
        BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(PushSetActivity.this);
        builder.statusBarDrawable = R.drawable.ic_launcher;
        builder.notificationFlags = Notification.FLAG_AUTO_CANCEL;  //设置为点击后自动消失
        builder.notificationDefaults = Notification.DEFAULT_SOUND;  //设置为铃声（ Notification.DEFAULT_SOUND）或者震动（ Notification.DEFAULT_VIBRATE）
        JPushInterface.setPushNotificationBuilder(1, builder);
        Toast.makeText(PushSetActivity.this, "Basic Builder - 1", Toast.LENGTH_SHORT).show();
    }


    /**
     * 设置通知栏样式 - 定义通知栏Layout
     */
    private void setStyleCustom() {
        CustomPushNotificationBuilder builder = new CustomPushNotificationBuilder(PushSetActivity.this, R.layout.customer_notitfication_layout, R.id.icon, R.id.title, R.id.text);
        builder.layoutIconDrawable = R.drawable.ic_launcher;
        builder.developerArg0 = "developerArg2";
        JPushInterface.setPushNotificationBuilder(2, builder);
        Toast.makeText(PushSetActivity.this, "Custom Builder - 2", Toast.LENGTH_SHORT).show();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            finish();
        }
        return super.onKeyDown(keyCode, event);
    }

    private void setAddActionsStyle() {
        MultiActionsNotificationBuilder builder = new MultiActionsNotificationBuilder(PushSetActivity.this);
        builder.addJPushAction(R.drawable.jpush_ic_richpush_actionbar_back, "first", "my_extra1");
        builder.addJPushAction(R.drawable.jpush_ic_richpush_actionbar_back, "second", "my_extra2");
        builder.addJPushAction(R.drawable.jpush_ic_richpush_actionbar_back, "third", "my_extra3");
        JPushInterface.setPushNotificationBuilder(10, builder);

        Toast.makeText(PushSetActivity.this, "AddActions Builder - 10", Toast.LENGTH_SHORT).show();
    }


    /**===========================================================================**/
    /**=========================TAG/ALIAS 相关=====================================**/
    /**===========================================================================**/

    /**
     * 处理tag/alias相关操作的点击
     * */
    public void onTagAliasAction(View view) {
        Set<String> tags = null;
        String alias = null;
        int action = -1;
        boolean isAliasAction = false;
        switch (view.getId()){
            //设置手机号码:
            case R.id.bt_setmobileNumber:
                handleSetMobileNumber();
                return;
            //增加tag
            case R.id.bt_addtag:
                tags = getInPutTags();
                if(tags == null){
                    return;
                }
                action = ACTION_ADD;
                break;
            //设置tag
            case R.id.bt_settag:
                tags = getInPutTags();
                if(tags == null){
                    return;
                }
                action = ACTION_SET;
                break;
            //删除tag
            case R.id.bt_deletetag:
                tags = getInPutTags();
                if(tags == null){
                    return;
                }
                action = ACTION_DELETE;
                break;
            //获取所有tag
            case R.id.bt_getalltag:
                action = ACTION_GET;
                break;
            //清除所有tag
            case R.id.bt_cleantag:
                action = ACTION_CLEAN;
                break;
            case R.id.bt_checktag:
                tags = getInPutTags();
                if(tags == null){
                    return;
                }
                action = ACTION_CHECK;
                break;
            //设置alias
            case R.id.bt_setalias:
                alias = getInPutAlias();
                if(TextUtils.isEmpty(alias)){
                    return;
                }
                isAliasAction = true;
                action = ACTION_SET;
                break;
            //获取alias
            case R.id.bt_getalias:
                isAliasAction = true;
                action = ACTION_GET;
                break;
            //删除alias
            case R.id.bt_deletealias:
                isAliasAction = true;
                action = ACTION_DELETE;
                break;
            default:
                return;
        }
        TagAliasBean tagAliasBean = new TagAliasBean();
        tagAliasBean.action = action;
        sequence++;
        if(isAliasAction){
            tagAliasBean.alias = alias;
        }else{
            tagAliasBean.tags = tags;
        }
        tagAliasBean.isAliasAction = isAliasAction;
        TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(),sequence,tagAliasBean);
    }

    private void handleSetMobileNumber(){
        EditText mobileEdit = (EditText) findViewById(R.id.et_mobilenumber);
        String mobileNumber = mobileEdit.getText().toString().trim();
        if (TextUtils.isEmpty(mobileNumber)) {
            Toast.makeText(getApplicationContext(), R.string.mobilenumber_empty_guide, Toast.LENGTH_SHORT).show();
        }
        if (!ExampleUtil.isValidMobileNumber(mobileNumber)) {
            Toast.makeText(getApplicationContext(), R.string.error_tag_gs_empty, Toast.LENGTH_SHORT).show();
            return;
        }
        sequence++;
        TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(),sequence,mobileNumber);
    }
    /**
     * 获取输入的alias
     * */
    private String getInPutAlias(){
        EditText aliasEdit = (EditText) findViewById(R.id.et_alias);
        String alias = aliasEdit.getText().toString().trim();
        if (TextUtils.isEmpty(alias)) {
            Toast.makeText(getApplicationContext(), R.string.error_alias_empty, Toast.LENGTH_SHORT).show();
            return null;
        }
        if (!ExampleUtil.isValidTagAndAlias(alias)) {
            Toast.makeText(getApplicationContext(), R.string.error_tag_gs_empty, Toast.LENGTH_SHORT).show();
            return null;
        }
        return alias;
    }
    /**
     * 获取输入的tags
     * */
    private Set<String> getInPutTags(){
        EditText tagEdit = (EditText) findViewById(R.id.et_tag);
        String tag = tagEdit.getText().toString().trim();
        // 检查 tag 的有效性
        if (TextUtils.isEmpty(tag)) {
            Toast.makeText(getApplicationContext(), R.string.error_tag_empty, Toast.LENGTH_SHORT).show();
            return null;
        }

        // ","隔开的多个 转换成 Set
        String[] sArray = tag.split(",");
        Set<String> tagSet = new LinkedHashSet<String>();
        for (String sTagItme : sArray) {
            if (!ExampleUtil.isValidTagAndAlias(sTagItme)) {
                Toast.makeText(getApplicationContext(), R.string.error_tag_gs_empty, Toast.LENGTH_SHORT).show();
                return null;
            }
            tagSet.add(sTagItme);
        }
        if(tagSet.isEmpty()){
            Toast.makeText(getApplicationContext(), R.string.error_tag_empty, Toast.LENGTH_SHORT).show();
            return null;
        }
        return tagSet;
    }
}