## FlutterPluginSort
### About
- This is the script help to sort the `GeneratedPluginRegistrant.m` generated by Flutter.
- This script also provide a function to automatically move specified plugin to the last, if the plugin should be run as the last one.

```objc
// Flutter initially generated `GeneratedPluginRegistrant.m`, plugins register order is random
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [SomeDeeplinkPlugin registerWithRegistrar:[registry registrarForPlugin:@"SomeDeeplinkPlugin"]];
  [BPlugin registerWithRegistrar:[registry registrarForPlugin:@"BPlugin"]];
  [CPlugin registerWithRegistrar:[registry registrarForPlugin:@"CPlugin"]];
  [APlugin registerWithRegistrar:[registry registrarForPlugin:@"APlugin"]];  
}

// Sorted result, and the deeplink plugin should be loaded as the last one
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [APlugin registerWithRegistrar:[registry registrarForPlugin:@"APlugin"]];
  [BPlugin registerWithRegistrar:[registry registrarForPlugin:@"BPlugin"]];
  [CPlugin registerWithRegistrar:[registry registrarForPlugin:@"CPlugin"]];
  [SomeDeeplinkPlugin registerWithRegistrar:[registry registrarForPlugin:@"SomeDeeplinkPlugin"]];
}
```

### The reason why to use this script
- The plugin register order in `GeneratedPluginRegistrant.m`'s `registerWithRegistry:` is randomly generated by Flutter, which in some cases will cause some issues. 
- Due to this uncertainty, the 3rd-party login deeplink back to App might sometimes be failed. 
The reason is that, for example, after allow login at Facebook App, Facebook App will try to launch the original App by deeplink, and bring back auth token along with it. But this deeplink, might be intercept by other flutter plugins, so Facebook SDK will never receive that deeplink, and the login action will be failed.
- Also the FirebaseDynamicLinks deeplink/universal link might also be incercepted by other plugin, and the deferred deep link will therefore be failed.

### Usage
- Sort the plugins: `perl FlutterPluginSortObjC.pl`
- Move plugin to the last: `perl FlutterPluginSortObjC.pl -last [plugin_name]`
- Although the generated file says `Do not edit`, it is recommanded to sort it, and add it into `git` system, to make sure every build has the same code execution order.


### XCode Integration
- At Xcode `Build Phases`, click the `Add New Run Script Phase`
- Drag the run script before `Compile Sources`
- Type the command `perl FlutterPluginSortObjC.pl`
<image src=https://github.com/eJamesLin/FlutterPluginSort/blob/master/img/xcode-integration.png>
