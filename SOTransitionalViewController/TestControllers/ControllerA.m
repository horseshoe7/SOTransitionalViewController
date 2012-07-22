//
//  ControllerA.m
//  TSNodalNavigationController
//
//  Created by Stephen O'Connor on 11/23/11.
//  Copyright (c) 2011 Stephen O'Connor. All rights reserved.
//

#import "ControllerA.h"
#import "ControllerB.h"
#import "AppDelegate.h"
#import "SOTransitionalViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControllerA

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
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: self.view.bounds] ;
    imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    // image taken from http://www.flickr.com/photos/marktee/5471807934/  (CC license of attribution)
    imgView.image = [UIImage imageNamed:@"tree_no_panties.jpeg"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view insertSubview:imgView atIndex:0];
    
}

- (void)changeView
{    
    [self.transitionController changeToViewController:[[ControllerB alloc] init]
                                       withTransition: [SOTransitionalViewController testNextTransition] 
                                      completionBlock:^(SOTransitionalViewController *transitionalController, UIViewController *toController) {
                                   
                                             AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                             
                                             appdelegate.infoLabel.text = [NSString stringWithFormat:@"Changed to view controller of type:\n%@", [toController class]];                                                                     }
     ];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc
{
    NSLog(@"Dealloc'd ControllerA");

}

@end
