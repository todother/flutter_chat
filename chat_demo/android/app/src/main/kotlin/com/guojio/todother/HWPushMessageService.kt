package com.guojio.todother

import android.content.Intent
import android.os.IBinder
import com.huawei.hms.push.HmsMessageService
import com.huawei.hms.push.RemoteMessage
import java.lang.Exception

class HWPushMessageService: HmsMessageService() {
    override fun onStartCommand(p0: Intent?, p1: Int, p2: Int): Int {
        return super.onStartCommand(p0, p1, p2)
    }

    override fun onMessageReceived(p0: RemoteMessage?) {
        super.onMessageReceived(p0)
    }

    override fun onBind(p0: Intent?): IBinder? {
        return super.onBind(p0)
    }

    override fun onMessageSent(p0: String?) {
        super.onMessageSent(p0)
    }

    override fun onDeletedMessages() {
        super.onDeletedMessages()
    }

    override fun onSendError(p0: String?, p1: Exception?) {
        super.onSendError(p0, p1)
    }

    override fun onNewToken(p0: String?) {
        super.onNewToken(p0)
    }

    override fun onDestroy() {
        super.onDestroy()
    }

}
