package io.github.thiagoslb.pudim

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * AudioServiceActivity: reprodução em segundo plano e Android Auto (audio_service).
 * Canal "pudim/token": cifra o token do Jellyfin com uma chave AES-GCM que
 * nunca sai do Android Keystore.
 */
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
        // Widget da tela inicial (PudimWidget): música, artista, tocando e capa.
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
