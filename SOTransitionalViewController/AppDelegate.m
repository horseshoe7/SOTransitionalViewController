//
//  AppDelegate.m
//  SOTransitionalViewController
//
//  Created by Stephen O'Connor on 7/22/12.
//  Copyright (c) 2012 Stephen O'Connor. All rights reserved.
//

#import "AppDelegate.h"
#import "SOTransitionalViewController.h"
#import "ControllerA.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize infoLabel = _infoLabel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    SOTransitionalViewController *transController = [[SOTransitionalViewController alloc] init];
    
    self.window.rootViewController = transController;
    
    // prints test info
    CGRect labelRect = transController.view.bounds;
    labelRect.size.height /= 2.0f;
    labelRect.origin.y = labelRect.size.height;
    labelRect = CGRectInset(labelRect, 10, 0);
    
    _infoLabel = [[UILabel alloc] initWithFrame: labelRect];
    _infoLabel.numberOfLines = 3;
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.shadowColor = [UIColor darkGrayColor];
    _infoLabel.shadowOffset = CGSizeMake(0, 1);
    [transController.view addSubview: _infoLabel];    
    
    
    // don't have to always call navigateToNode: , you can directly call the method from the superclass which navigateToNode ultimately manages.
    [transController changeToViewController: [[ControllerA alloc] init]
                             withTransition:SOViewTransitionNone 
                            completionBlock:^(SOTransitionalViewController *transitionalController, 
                                              UIViewController *toController) {
                                
                             _infoLabel.text = [NSString stringWithFormat:@"Changed to view controller of type:\n%@", [toController class]];

                            }];

    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
