//
//  AppDelegate.h
//  PubNubTest
//
//  Created by Assure Developer on 3/17/15.
//  Copyright (c) 2015 AssureDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PNDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) PNChannel *myChannel;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;


@end

