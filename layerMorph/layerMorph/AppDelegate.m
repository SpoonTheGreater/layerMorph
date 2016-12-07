//
//  AppDelegate.m
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <OneSignal/OneSignal.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    [OneSignal initWithLaunchOptions:launchOptions appId:@"d426145b-9b95-4661-b889-c5fce3fd5ca9" handleNotificationAction:^(OSNotificationOpenedResult *result) {
        
        // This block gets called when the user reacts to a notification received
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
        if (payload.additionalData) {
            if(payload.title)
                messageTitle = payload.title;
            
            NSDictionary* additionalData = payload.additionalData;
            
            if (additionalData[@"actionSelected"])
                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
        }
        
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:messageTitle message:fullMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        
        [alertView addAction:closeAction];
//        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertView animated:YES completion:^{
//            
//        }];
        
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDictionary *payload = userInfo[@"custom"][@"a"];
    if( payload[@"action"] && [payload[@"action"] isEqualToString:@"NEXT"] )
    {
        if( [[[UIApplication sharedApplication] keyWindow].rootViewController respondsToSelector:@selector(changeShape)] )
        [[[UIApplication sharedApplication] keyWindow].rootViewController performSelectorOnMainThread:@selector(changeShape) withObject:nil waitUntilDone:YES];
    }
}
//application:didReceiveRemoteNotification:fetchCompletionHandler

@end
