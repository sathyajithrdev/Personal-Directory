package com.saj.android.personal_dictionary;


import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import be.tramckrijte.workmanager.WorkmanagerPlugin;

public class PersonalDictionaryApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        WorkmanagerPlugin.setPluginRegistrantCallback(this);

    }

    @Override
    public void registerWith(PluginRegistry registry) {
        // GeneratedPluginRegistrant.registerWith(registry);

        //add AndroidAlarmManagerPlugin plugin register  if you work with arlarm
        AndroidAlarmManagerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));

       //add SharedPreferencesPlugin plugin register  if you work with share preferences
        SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));

        // something else...

        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));

        CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));

        WorkmanagerPlugin.registerWith(registry.registrarFor("be.tramckrijte.workmanager.WorkmanagerPlugin"));
    }
}