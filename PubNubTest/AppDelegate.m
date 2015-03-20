//
//  AppDelegate.m
//  PubNubTest
//
//  Created by Assure Developer on 3/17/15.
//  Copyright (c) 2015 AssureDev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (){
    NSString *uuid;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    PNConfiguration *configuration = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com" publishKey:@"pub-c-92cb92a3-e50e-45fa-abbd-4d01c01f15c0" subscribeKey:@"sub-c-ff2b2974-ccf2-11e4-bf07-0619f8945a4f" secretKey:@"sec-c-ZjFlOWYxM2UtN2RkNC00YTYyLWFiNmMtOGEzNTdiYjJjZjhk"];
    
    uuid = [NSString stringWithFormat:@"matindimitrov"];
    [PubNub setClientIdentifier:uuid];
    
    [PubNub setupWithConfiguration:configuration
                       andDelegate:self];
    
    [PubNub connect];
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
    }];
    
    //Define a channel
    self.myChannel = [PNChannel channelWithName:@"testChannel"
                          shouldObservePresence:YES];
    
    //Subscribe to the channel
    [PubNub subscribeOn:@[self.myChannel]
        withClientState:@{self.myChannel.name:@{@"appstate":@"Online"}}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [PubNub updateClientState:uuid state:@{@"appstate": @"Offline"} forObject:self.myChannel];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (self.backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
        NSLog(@"Task invalidated");
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [PubNub unsubscribeFrom:@[self.myChannel]];
}

#pragma mark - PubNub Delegate

//------- Subscriptino of Channel ---------
- (void)pubnubClient:(PubNub *)client didSubscribeOn:(NSArray *)channelObjects {
    
    NSLog(@"PubNub client successfully subscribed on channels: %@", channelObjects);
}

//------- Restoration ---------
-(NSNumber *)shouldReconnectPubNubClient:(PubNub *)client{
    return @(YES);
}

-(NSNumber *)shouldResubscribeOnConnectionRestore{
    return @(YES);
}

- (void)pubnubClient:(PubNub *)client willRestoreSubscriptionOn:(NSArray *)channelObjects {
    
    NSLog(@"PubNub client resuming subscription on: %@", channelObjects);
}

- (void)pubnubClient:(PubNub *)client didRestoreSubscriptionOn:(NSArray *)channelObjects {
    
    NSLog(@"PubNub client successfully restored subscription on channels: %@", channelObjects);
    
    [PubNub updateClientState:uuid state:@{@"appstate": @"Online"} forObject:self.myChannel];
}

- (void)pubnubClient:(PubNub *)client subscriptionDidFailWithError:(NSError *)error {
    
    NSLog(@"PubNub client failed to subscribe because of error: %@", error);
}

//------- Messaging ---------
- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog( @"%@", [NSString stringWithFormat:@"received: %@", message.message] );
}


//-------Client State ---------
- (void)pubnubClient:(PubNub *)client didUpdateClientState:(PNClient *)remoteClient {
    
    NSLog(@"PubNub client successfully updated state for client %@ at channel %@: %@ ",
          remoteClient.identifier, remoteClient.channel, [remoteClient stateForChannel:remoteClient.channel]);
}

- (void)pubnubClient:(PubNub *)client didReceiveClientState:(PNClient *)remoteClient {
    
    NSLog(@"PubNub client successfully received state for client %@ on channel %@: %@ ",
          remoteClient.identifier, remoteClient.channel, [remoteClient stateForChannel:remoteClient.channel]);
}

@end
