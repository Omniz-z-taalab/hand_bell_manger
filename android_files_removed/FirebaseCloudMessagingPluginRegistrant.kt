package com.egyapp.hand_bill_manger
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin

object FirebaseCloudMessagingPluginRegistrant {
    fun registerWith(registry: PluginRegistry?) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry?): Boolean {
        val key: String? = FirebaseCloudMessagingPluginRegistrant::class.java.canonicalName
        if (registry?.hasPlugin(key)!!) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}