package com.glennruysschaert.domain_verification_manager

import android.app.Activity
import android.content.Intent
import android.content.pm.verify.domain.DomainVerificationManager
import android.content.pm.verify.domain.DomainVerificationUserState
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/** DomainVerificationManagerPlugin */
class DomainVerificationManagerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private val activity get() = activityReference.get()
    private var activityReference = WeakReference<Activity>(null)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityReference.clear()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityReference.clear()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getIsSupported") {
            result.success(getIsSupported())
            return
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            result.error("WRONG_SDK_VERSION",
                    "The minimum SDK version is ${Build.VERSION_CODES.S} ",
                    null)
            return
        }
        when (call.method) {
            "getIsSupported" -> result.success(getIsSupported())
            "getDomainStateVerified" -> result.success(getDomainStateVerified())
            "getDomainStateSelected" -> result.success(getDomainStateSelected())
            "getDomainStateNone" -> result.success(getDomainStateNone())
            "domainRequest" -> {
                domainRequest()
                result.success(null)
            }
            else -> { // Note the block
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding:
                                    FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger,
                "domain_verification_manager")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ---------------------
    // PRIVATE
    // ---------------------

    /**
     * Check if the current platform and its version are supported.
     */
    private fun getIsSupported(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
    }

    /**
     * Returns the domain verification user state.
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun getUserState(): DomainVerificationUserState? {
        val manager = activity?.getSystemService(DomainVerificationManager::class.java)
        return manager?.getDomainVerificationUserState(activity?.packageName ?: "")
    }

    /**
     * Domains that have passed Android App Links verification.
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun getDomainStateVerified(): ArrayList<String>? {
        val result = getUserState()?.hostToStateMap
                ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_VERIFIED }?.keys
                ?: return null
        return ArrayList(result)
    }

    /**
     * Domains that haven't passed Android App Links verification but that the user
     * has associated with an app.
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun getDomainStateSelected(): ArrayList<String>? {
        val result = getUserState()?.hostToStateMap
                ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_SELECTED }?.keys
                ?: return null
        return ArrayList(result)
    }

    /**
     * All other domains.
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun getDomainStateNone(): ArrayList<String>? {
        val result = getUserState()?.hostToStateMap
                ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_NONE }?.keys
                ?: return null
        return ArrayList(result)
    }

    /**
     * Request permission from the user by opening the app settings.
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun domainRequest() {
        val intent = Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS,
                Uri.parse("package:${activity?.packageName}"))
        activity?.startActivity(intent)
    }
}
