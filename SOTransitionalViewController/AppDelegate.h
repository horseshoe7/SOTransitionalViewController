//
//  AppDelegate.h
//  SOTransitionalViewController
//
//  Created by Stephen O'Connor on 7/22/12.
//  Copyright (c) 2012 Stephen O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UILabel *_infoLabel;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) UILabel *infoLabel;

@end
