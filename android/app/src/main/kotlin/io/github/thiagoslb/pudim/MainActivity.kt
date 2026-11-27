package io.github.thiagoslb.pudim

import android.content.Intent
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import com.google.firebase.FirebaseApp
import com.google.firebase.messaging.FirebaseMessaging
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * AudioServiceActivity: background playback and Android Auto (audio_service).
 * Channel "pudim/token": encrypts the Jellyfin token with an AES-GCM key that
 * never leaves the Android Keystore.
 */
class MainActivity : AudioServiceActivity() {
    private var push: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Push: device token for the extras server, and the screen a tapped notification opens
        // (Firebase puts the message's data, e.g. "route", in the launch intent).
        push = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pudim/push").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "token" -> {
                        if (FirebaseApp.getApps(applicationContext).isEmpty()) {
                            result.success(null) // build without the Firebase ids
                        } else {
                            FirebaseMessaging.getInstance().token.addOnCompleteListener { t ->
                                result.success(if (t.isSuccessful) t.result else null)
                            }
                        }
                    }
                    "initialRoute" -> result.success(routeOf(intent).also { intent?.removeExtra("route") })
                    else -> result.notImplemented()
                }
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pudim/token")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "encrypt" -> result.success(encrypt(call.arguments as String))
                        "decrypt" -> result.success(decrypt(call.arguments as String))
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("crypto", e.message, null)
                }
            }
        // Home screen widget (PudimWidget): track, artist, playing state and cover.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pudim/widget")
            .setMethodCallHandler { call, result ->
                if (call.method == "update") {
                    PudimWidget.save(
                        applicationContext,
                        call.argument<String>("title") ?: "",
                        call.argument<String>("artist") ?: "",
                        call.argument<Boolean>("playing") ?: false,
                        call.argument<String>("cover"),
                    )
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        routeOf(intent)?.let { push?.invokeMethod("open", it) }
    }

    private fun routeOf(i: Intent?): String? =
        i?.getStringExtra("route")?.takeIf { it.startsWith("/") }

    private fun key(): SecretKey {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(ALIAS, null) as? SecretKey)?.let { return it }
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(
            KeyGenParameterSpec.Builder(
                ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .build()
        )
        return gen.generateKey()
    }

    private fun encrypt(plain: String): String {
        val c = Cipher.getInstance(TRANSFORM)
        c.init(Cipher.ENCRYPT_MODE, key())
        val out = c.iv + c.doFinal(plain.toByteArray(Charsets.UTF_8))
        return Base64.encodeToString(out, Base64.NO_WRAP)
    }

    private fun decrypt(data: String): String {
        val raw = Base64.decode(data, Base64.NO_WRAP)
        val c = Cipher.getInstance(TRANSFORM)
        c.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, raw, 0, IV_LEN))
        return String(c.doFinal(raw, IV_LEN, raw.size - IV_LEN), Charsets.UTF_8)
    }

    companion object {
        private const val ALIAS = "pudim_music_token"
        private const val TRANSFORM = "AES/GCM/NoPadding"
        private const val IV_LEN = 12
    }
}
