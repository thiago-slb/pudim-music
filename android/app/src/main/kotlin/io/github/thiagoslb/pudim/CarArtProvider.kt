package io.github.thiagoslb.pudim

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest

/**
 * Covers for the Android Auto folders. The car only loads content:// images, so the app hands it
 * content://<app id>.carart/img?u=<cover url> and this provider downloads the cover (once, kept in
 * the cache folder) and serves the file. Only addresses on the app's own server are fetched: the
 * app writes that address to its preferences ("carArtBase") before listing folders.
 */
class CarArtProvider : ContentProvider() {
    override fun onCreate() = true

    override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor? {
        val ctx = context ?: return null
        // Cover saved with a download: only files inside the app's own folder.
        uri.getQueryParameter("f")?.let { path ->
            val f = File(path).canonicalFile
            val home = File(ctx.applicationInfo.dataDir).canonicalFile
            if (!f.path.startsWith(home.path + File.separator) || !f.isFile) return null
            return ParcelFileDescriptor.open(f, ParcelFileDescriptor.MODE_READ_ONLY)
        }
        val url = uri.getQueryParameter("u") ?: return null
        val base = ctx.getSharedPreferences("FlutterSharedPreferences", 0)
            .getString("flutter.carArtBase", null) ?: return null
        if (base.isEmpty() || !url.startsWith("$base/")) return null
        val dir = File(ctx.cacheDir, "car-art").apply { mkdirs() }
        val name = MessageDigest.getInstance("SHA-1").digest(url.toByteArray())
            .joinToString("") { "%02x".format(it) }
        val file = File(dir, name)
        if (!file.exists() || file.length() == 0L) {
            val tmp = File(dir, "$name.tmp")
            val conn = URL(url).openConnection() as HttpURLConnection
            conn.connectTimeout = 8000
            conn.readTimeout = 15000
            try {
                if (conn.responseCode != 200) return null
                conn.inputStream.use { input -> tmp.outputStream().use { input.copyTo(it) } }
            } finally {
                conn.disconnect()
            }
            if (!tmp.renameTo(file)) return null
            // Keeps the folder small: the oldest covers go once there are more than 300.
            dir.listFiles()?.sortedBy { it.lastModified() }?.dropLast(300)?.forEach { it.delete() }
        }
        return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
    }

    override fun getType(uri: Uri) = "image/jpeg"
    override fun query(u: Uri, p: Array<String>?, s: String?, a: Array<String>?, o: String?): Cursor? = null
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, s: String?, a: Array<String>?) = 0
    override fun update(uri: Uri, v: ContentValues?, s: String?, a: Array<String>?) = 0
}
