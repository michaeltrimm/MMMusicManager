MMMusicManager
==============

MMMusicManager is an iOS implementation of a music manager that includes purchaseable in-app songs, custom playlist, and custom sinatra rails application API


Basics
======

MMMusicManager is currently in development. It isn't even at a buildable state. So, hang in there or fork and start developing some of the code and push your changes back up for approval.

What It Does
============

Correction - what it is going to do. I was looking for something like this and haven't been able to find it yet. I want to be able to have a custom iPod like store to buy and sell music files that I create. Similar to ambiance applications however this one would have a playlist functionality similar to the iPod. 

* MMMusicManager will function like the iPod app with the iTunes store built in
* MKStoreKit will handle all in-app purchases of music content
* MMMusicManager will keep track of music files and download all purchases
* MMMusicManager will handle the playlist and available pool of songs. The user will get to seletc the songs they want to have on their playlist and choose: 
  * Normal Play
  * Loop Single Song
  * Loop Playlist
  * Suffle Playlist
* MMMusicManager will give control functionality to iOS 6 multitasking
* MMMusicManager will have custom access point from a UIBarButtonItem or UIButton

Overview Of Classes
===================

* MMUser 
  * This is the user class and it contains the emailAddress and BSON_ID of the Sinatra/Mongoid ID of the User model
  * This instance gets populated when [MMNetworkManager authenticateWithEmailAddress:andPassword:] or [MMNetworkManager createAccount:withPassword] is called
  * This class is singleton by design
* MMNetworkManager
  * This class is also singleton
  * This class specifically interfaces with the Sinatra/Mongoid web server API
  * This class will handle all network related prepration for the API using MKNetworkKit
* MMMusicManager
  * This class is also a singleton
  * This class will manage the iOS 6 core audio, audio toolbox, avfoundation, and openal implementations
  * This class will handle all user interactions with the purpose of this application
* MMMusicViewController 
  * This class is a UIViewController subclass
  * This class contains all user-action items that the class will work with
  * To integrate MMMusicManager into your application via a UIBarButtonItem or UIButton
