package com.upcwangying.apps.flutter.boilerplate

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class FlutterBoilerplateHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.flutter_boilerplate_widget_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Swap Title Text by calling Dart Code in the Background
                setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                        ?: "No Title Set")
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("flutterBoilerplateHomeWidget://titleClicked")
                )
                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

                val message = widgetData.getString("message", null)
                setTextViewText(R.id.widget_message, message
                        ?: "No Message Set")
                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("flutterBoilerplateHomeWidget://message?message=$message"))
                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
