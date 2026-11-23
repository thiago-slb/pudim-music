package io.github.thiagoslb.pudim

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.view.KeyEvent
import android.widget.RemoteViews
import java.io.File

/**
 * Widget da tela inicial: o app manda (canal "pudim/widget") música, artista, se está tocando e a capa
 * já salva num arquivo. Os botões mandam teclas de mídia para o MediaButtonReceiver do audio_service,
 * igual aos botões de um fone bluetooth.
 */
class PudimWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        render(context, manager, ids)
    }

    companion object {
        private const val PREFS = "pudim_widget"

        fun save(context: Context, title: String, artist: String, playing: Boolean, cover: String?) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putString("title", title)
                .putString("artist", artist)
                .putBoolean("playing", playing)
                .putString("cover", cover ?: "")
                .apply()
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, PudimWidget::class.java))
            if (ids.isNotEmpty()) render(context, manager, ids)
        }

        private fun media(context: Context, code: Int, key: Int): PendingIntent {
            val i = Intent(Intent.ACTION_MEDIA_BUTTON)
                .setComponent(ComponentName(context, "com.ryanheise.audioservice.MediaButtonReceiver"))
                .putExtra(Intent.EXTRA_KEY_EVENT, KeyEvent(KeyEvent.ACTION_DOWN, key))
            return PendingIntent.getBroadcast(
                context, code, i, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val p = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val v = RemoteViews(context.packageName, R.layout.pudim_widget)
            v.setTextViewText(R.id.widget_title, p.getString("title", null)?.ifEmpty { null } ?: "Pudim")
            v.setTextViewText(R.id.widget_artist, p.getString("artist", null)?.ifEmpty { null } ?: "Toque para abrir")
            v.setImageViewResource(
                R.id.widget_play,
                if (p.getBoolean("playing", false)) R.drawable.ic_w_pause else R.drawable.ic_w_play
            )
            val cover = p.getString("cover", "") ?: ""
            val bmp = if (cover.isNotEmpty() && File(cover).exists()) {
                try {
                    val opts = BitmapFactory.Options().apply { inSampleSize = 2 }
                    BitmapFactory.decodeFile(cover, opts)
                } catch (e: Exception) {
                    null
                }
            } else null
            if (bmp != null) v.setImageViewBitmap(R.id.widget_cover, bmp)
            else v.setImageViewResource(R.id.widget_cover, R.mipmap.ic_launcher)

            val open = PendingIntent.getActivity(
                context, 0,
                Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            v.setOnClickPendingIntent(R.id.widget_root, open)
            v.setOnClickPendingIntent(R.id.widget_prev, media(context, 1, KeyEvent.KEYCODE_MEDIA_PREVIOUS))
            v.setOnClickPendingIntent(R.id.widget_play, media(context, 2, KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE))
            v.setOnClickPendingIntent(R.id.widget_next, media(context, 3, KeyEvent.KEYCODE_MEDIA_NEXT))
            manager.updateAppWidget(ids, v)
        }
    }
}
