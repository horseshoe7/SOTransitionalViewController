//
//  ControllerB.m
//  TSNodalNavigationController
//
//  Created by Stephen O'Connor on 11/23/11.
//  Copyright (c) 2011 Stephen O'Connor. All rights reserved.
//

#import "ControllerB.h"
#import "ControllerA.h"
#import "AppDelegate.h"
#import "SOTransitionalViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControllerB

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blueColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: self.view.bounds];
    
    // taken from here http://www.flickr.com/photos/zingyyellow/2956427484/  (CC License of attribution)
    imgView.image = [UIImage imageNamed:@"fuzzy_tree.jpeg"];
    imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view insertSubview:imgView atIndex:0];
}

- (void)changeView
{
    [self.transitionController changeToViewController:[[ControllerA alloc] init]
                                       withTransition: [SOTransitionalViewController testNextTransition] 
                                      completionBlock:^(SOTransitionalViewController *transitionalController, UIViewController *toController) {
                                          
                                          AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                          
                                          appdelegate.infoLabel.text = [NSString stringWithFormat:@"Changed to view controller of type:\n%@", [toController class]];                                                                     }
     ];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc
{
    NSLog(@"Dealloc'd ControllerB");

}

@end
