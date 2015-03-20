//
//  ViewController.m
//  PubNubTest
//
//  Created by Assure Developer on 3/17/15.
//  Copyright (c) 2015 AssureDev. All rights reserved.
//

#import "ViewController.h"
#import <Pubnub.h>
#import "AppDelegate.h"

@interface ViewController (){
    PNChannel *myChannel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myChannel = [(AppDelegate*)[UIApplication sharedApplication].delegate myChannel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User interaction
- (IBAction)clickOnSendMessageBtn:(id)sender{
    
    [PubNub sendMessage:@"Test Message from iOS!" toChannel:myChannel];
}

@end
