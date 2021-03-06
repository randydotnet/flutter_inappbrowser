/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

import 'dart:async';

import 'package:flutter/services.dart';

///Main class of the plugin.
class InAppBrowser {
  static const MethodChannel _channel = const MethodChannel('com.pichillilorenzo/flutter_inappbrowser');

  ///
  InAppBrowser () {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {
      case "onLoadStart":
        String url = call.arguments["url"];
        onLoadStart(url);
        break;
      case "onLoadStop":
        String url = call.arguments["url"];
        onLoadStop(url);
        break;
      case "onLoadError":
        String url = call.arguments["url"];
        int code = call.arguments["code"];
        String message = call.arguments["message"];
        onLoadError(url, code, message);
        break;
      case "onExit":
        onExit();
        break;
      case "shouldOverrideUrlLoading":
        String url = call.arguments["url"];
        shouldOverrideUrlLoading(url);
        break;
    }
    return new Future.value("");
  }

  ///Opens an [url] in a new [InAppBrowser] instance or the system browser.
  ///
  ///- [url]: The [url] to load. Call [encodeUriComponent()] on this if the [url] contains Unicode characters.
  ///
  ///- [headers]: The additional headers to be used in the HTTP request for this URL, specified as a map from name to value.
  ///
  ///- [target]: The target in which to load the [url], an optional parameter that defaults to `_self`.
  ///
  ///  - `_self`: Opens in the [InAppBrowser].
  ///  - `_blank`: Opens in the [InAppBrowser].
  ///  - `_system`: Opens in the system's web browser.
  ///
  ///- [options]: Options for the [InAppBrowser].
  ///
  ///  All platforms support:
  ///  - __useShouldOverrideUrlLoading__: Set to `true` to be able to listen at the [shouldOverrideUrlLoading()] event. The default value is `false`.
  ///  - __clearCache__: Set to `true` to have all the browser's cache cleared before the new window is opened. The default value is `false`.
  ///  - __userAgent___: Set the custom WebView's user-agent.
  ///  - __javaScriptEnabled__: Set to `true` to enable JavaScript. The default value is `true`.
  ///  - __javaScriptCanOpenWindowsAutomatically__: Set to `true` to allow JavaScript open windows without user interaction. The default value is `false`.
  ///  - __hidden__: Set to `true` to create the browser and load the page, but not show it. The `onLoadStop` event fires when loading is complete. Omit or set to `false` (default) to have the browser open and load normally.
  ///  - __toolbarTop__: Set to `false` to hide the toolbar at the top of the WebView. The default value is `true`.
  ///  - __toolbarTopBackgroundColor__: Set the custom background color of the toolbat at the top.
  ///  - __hideUrlBar__: Set to `true` to hide the url bar on the toolbar at the top. The default value is `false`.
  ///  - __mediaPlaybackRequiresUserGesture__: Set to `true` to prevent HTML5 audio or video from autoplaying. The default value is `true`.
  ///
  ///  **Android** supports these additional options:
  ///
  ///  - __hideTitleBar__: Set to `true` if you want the title should be displayed. The default value is `false`.
  ///  - __closeOnCannotGoBack__: Set to `false` to not close the InAppBrowser when the user click on the back button and the WebView cannot go back to the history. The default value is `true`.
  ///  - __clearSessionCache__: Set to `true` to have the session cookie cache cleared before the new window is opened.
  ///  - __builtInZoomControls__: Set to `true` if the WebView should use its built-in zoom mechanisms. The default value is `false`.
  ///  - __supportZoom__: Set to `false` if the WebView should not support zooming using its on-screen zoom controls and gestures. The default value is `true`.
  ///  - __databaseEnabled__: Set to `true` if you want the database storage API is enabled. The default value is `false`.
  ///  - __domStorageEnabled__: Set to `true` if you want the DOM storage API is enabled. The default value is `false`.
  ///  - __useWideViewPort__: Set to `true` if the WebView should enable support for the "viewport" HTML meta tag or should use a wide viewport. When the value of the setting is false, the layout width is always set to the width of the WebView control in device-independent (CSS) pixels. When the value is true and the page contains the viewport meta tag, the value of the width specified in the tag is used. If the page does not contain the tag or does not provide a width, then a wide viewport will be used. The default value is `true`.
  ///  - __safeBrowsingEnabled__: Set to `true` if you want the Safe Browsing is enabled. Safe Browsing allows WebView to protect against malware and phishing attacks by verifying the links. The default value is `true`.
  ///  - __progressBar__: Set to `false` to hide the progress bar at the bottom of the toolbar at the top. The default value is `true`.
  ///
  ///  **iOS** supports these additional options:
  ///
  ///  - __disallowOverScroll__: Set to `true` to disable the bouncing of the WebView when the scrolling has reached an edge of the content. The default value is `false`.
  ///  - __toolbarBottom__: Set to `false` to hide the toolbar at the bottom of the WebView. The default value is `true`.
  ///  - __toolbarBottomBackgroundColor__: Set the custom background color of the toolbat at the bottom.
  ///  - __toolbarBottomTranslucent__: Set to `true` to set the toolbar at the bottom translucent. The default value is `true`.
  ///  - __closeButtonCaption__: Set the custom text for the close button.
  ///  - __closeButtonColor__: Set the custom color for the close button.
  ///  - __presentationStyle__: Set the custom modal presentation style when presenting the WebView. The default value is `0 //fullscreen`. See [UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle) for all the available styles.
  ///  - __transitionStyle__: Set to the custom transition style when presenting the WebView. The default value is `0 //crossDissolve`. See [UIModalTransitionStyle](https://developer.apple.com/documentation/uikit/uimodaltransitionStyle) for all the available styles.
  ///  - __enableViewportScale__: Set to `true` to allow a viewport meta tag to either disable or restrict the range of user scaling. The default value is `false`.
  ///  - __keyboardDisplayRequiresUserAction__: Set to `true` if you want the user must explicitly tap the elements in the WebView to display the keyboard (or other relevant input view) for that element. When set to `false`, a focus event on an element causes the input view to be displayed and associated with that element automatically. The default value is `true`.
  ///  - __suppressesIncrementalRendering__: Set to `true` if you want the WebView suppresses content rendering until it is fully loaded into memory.. The default value is `false`.
  ///  - __allowsAirPlayForMediaPlayback__: Set to `true` to allow AirPlay. The default value is `true`.
  ///  - __allowsBackForwardNavigationGestures__: Set to `true` to allow the horizontal swipe gestures trigger back-forward list navigations. The default value is `true`.
  ///  - __allowsLinkPreview__: Set to `true` to allow that pressing on a link displays a preview of the destination for the link. The default value is `true`.
  ///  - __ignoresViewportScaleLimits__: Set to `true` if you want that the WebView should always allow scaling of the webpage, regardless of the author's intent. The ignoresViewportScaleLimits property overrides the `user-scalable` HTML property in a webpage. The default value is `false`.
  ///  - __allowsInlineMediaPlayback__: Set to `true` to allow HTML5 media playback to appear inline within the screen layout, using browser-supplied controls rather than native controls. For this to work, add the `webkit-playsinline` attribute to any `<video>` elements. The default value is `false`.
  ///  - __allowsPictureInPictureMediaPlayback__: Set to `true` to allow HTML5 videos play picture-in-picture. The default value is `true`.
  ///  - __spinner__: Set to `false` to hide the spinner when the WebView is loading a page. The default value is `true`.
  Future<void> open(String url, {Map<String, String> headers = const {}, String target = "_self", Map<String, dynamic> options = const {}}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('url', () => url);
    args.putIfAbsent('headers', () => headers);
    args.putIfAbsent('target', () => target);
    args.putIfAbsent('options', () => options);
    return await _channel.invokeMethod('open', args);
  }

  ///Loads the given [url] with optional [headers] specified as a map from name to value.
  Future<void> loadUrl(String url, {Map<String, String> headers = const {}}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('url', () => url);
    args.putIfAbsent('headers', () => headers);
    return await _channel.invokeMethod('loadUrl', args);
  }

  ///Displays an [InAppBrowser] window that was opened hidden. Calling this has no effect if the [InAppBrowser] was already visible.
  Future<void> show() async {
    return await _channel.invokeMethod('show');
  }

  ///Hides the [InAppBrowser] window. Calling this has no effect if the [InAppBrowser] was already hidden.
  Future<void> hide() async {
    return await _channel.invokeMethod('hide');
  }

  ///Closes the [InAppBrowser] window.
  Future<void> close() async {
    return await _channel.invokeMethod('close');
  }

  ///Reloads the [InAppBrowser] window.
  Future<void> reload() async {
    return await _channel.invokeMethod('reload');
  }

  ///Goes back in the history of the [InAppBrowser] window.
  Future<void> goBack() async {
    return await _channel.invokeMethod('goBack');
  }

  ///Goes forward in the history of the [InAppBrowser] window.
  Future<void> goForward() async {
    return await _channel.invokeMethod('goForward');
  }

  ///Check if the Web View of the [InAppBrowser] instance is in a loading state.
  Future<bool> isLoading() async {
    return await _channel.invokeMethod('isLoading');
  }

  ///Stops the Web View of the [InAppBrowser] instance from loading.
  Future<void> stopLoading() async {
    return await _channel.invokeMethod('stopLoading');
  }

  ///Check if the Web View of the [InAppBrowser] instance is hidden.
  Future<bool> isHidden() async {
    return await _channel.invokeMethod('isHidden');
  }

  ///Injects JavaScript code into the [InAppBrowser] window and returns the result of the evaluation. (Only available when the target is set to `_blank` or to `_self`)
  Future<String> injectScriptCode(String source) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    return await _channel.invokeMethod('injectScriptCode', args);
  }

  ///Injects a JavaScript file into the [InAppBrowser] window. (Only available when the target is set to `_blank` or to `_self`)
  Future<void> injectScriptFile(String urlFile) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile);
    return await _channel.invokeMethod('injectScriptFile', args);
  }

  ///Injects CSS into the [InAppBrowser] window. (Only available when the target is set to `_blank` or to `_self`)
  Future<void> injectStyleCode(String source) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    return await _channel.invokeMethod('injectStyleCode', args);
  }

  ///Injects a CSS file into the [InAppBrowser] window. (Only available when the target is set to `_blank` or to `_self`)
  Future<void> injectStyleFile(String urlFile) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile);
    return await _channel.invokeMethod('injectStyleFile', args);
  }

  ///Event fires when the [InAppBrowser] starts to load an [url].
  void onLoadStart(String url) {

  }

  ///Event fires when the [InAppBrowser] finishes loading an [url].
  void onLoadStop(String url) {

  }

  ///Event fires when the [InAppBrowser] encounters an error loading an [url].
  void onLoadError(String url, int code, String message) {

  }

  ///Event fires when the [InAppBrowser] window is closed.
  void onExit() {

  }

  ///Give the host application a chance to take control when a URL is about to be loaded in the current WebView.
  void shouldOverrideUrlLoading(String url) {

  }

}
