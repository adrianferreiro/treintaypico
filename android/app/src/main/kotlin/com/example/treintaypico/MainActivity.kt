package com.example.treintaypico

import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "walkprint.intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "open" -> {
                        try {
                            val bytes = call.argument<ByteArray>("bytes")
                            val mime = call.argument<String>("mime") ?: "image/png"
                            val filename = call.argument<String>("filename") ?: "ticket.png"
                            val targetPackage = call.argument<String>("package") // opcional

                            if (bytes == null) {
                                result.error("ARG", "bytes requeridos", null)
                                return@setMethodCallHandler
                            }

                            val dir = File(cacheDir, "walkprint")
                            if (!dir.exists()) dir.mkdirs()
                            val outFile = File(dir, filename)
                            outFile.outputStream().use { it.write(bytes) }

                            val uri: Uri = FileProvider.getUriForFile(
                                this,
                                "${applicationContext.packageName}.fileprovider",
                                outFile
                            )

                            val send = Intent(Intent.ACTION_SEND).apply {
                                type = mime // "image/png" o "image/*"
                                putExtra(Intent.EXTRA_STREAM, uri)
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                if (!targetPackage.isNullOrBlank()) {
                                    `package` = targetPackage
                                }
                            }

                            if (canHandle(send)) {
                                try {
                                    startActivity(send)
                                    result.success(true)
                                    return@setMethodCallHandler
                                } catch (_: ActivityNotFoundException) {}
                            }

                            val chooser = Intent.createChooser(send, "Elegí app para imprimir")
                            startActivity(chooser)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("INTENT", "No se pudo abrir app: ${e.message}", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun canHandle(intent: Intent): Boolean {
        val res = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
        return res.isNotEmpty()
    }
}
