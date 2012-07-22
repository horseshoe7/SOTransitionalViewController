//
//  TSNodalNavigationController.m
//  NodalNavigation
//
//  Created by Stephen O'Connor on 2/7/12.
//  Copyright (c) 2012 Stephen O'Connor. All rights reserved.
//

#import "SOTransitionalViewController.h"

@implementation UIViewController (SOTransitionalViewController)

- (SOTransitionalViewController*)transitionController
{
    SOTransitionalViewController *transitionController = nil;
    UIViewController *parent = [self parentViewController];
    while (parent != nil) {
        // check if it's a tableviewcell
        if ([parent isKindOfClass:[SOTransitionalViewController class]]) {
            transitionController = (SOTransitionalViewController*)parent;
            break;
        }
        // if not, set parent = [parent parentViewController];
        parent = [parent parentViewController];
    }
    
    return transitionController;    
}
@end



static int testTransition = 0;

@interface SOTransitionalViewController()
{
    
}


- (void)slideBothController:(UIViewController*)newController 
             withTransition:(SOViewTransition)transition 
            completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;

- (void)slideNewController:(UIViewController*)newController 
            withTransition:(SOViewTransition)transition 
           completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;

- (void)slideOldController:(UIViewController*)newController 
            withTransition:(SOViewTransition)transition 
           completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;

- (void)fadeController:(UIViewController*)newController 
       completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;

- (void)crossfadeController:(UIViewController*)newController 
            completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;



@end


@implementation SOTransitionalViewController

@synthesize currentViewController = _currentViewController;
@synthesize fadeTime = _fadeTime, transitionTime = _transitionTime;

+(SOViewTransition)testNextTransition
{
    testTransition ++;
    testTransition %= 16;
    NSLog(@"I wanna test transition num %i", testTransition);
    return testTransition;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentViewController = nil;
        
        _transitionTime = 0.5f;
        _fadeTime = 1.0f;
    }
    return self;
}

- (void)loadView
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(application.statusBarOrientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    
    CGRect newFrame;
    newFrame.origin = CGPointZero;
    newFrame.size = size;
    
    self.view = [[UIView alloc] initWithFrame: newFrame ];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.view.autoresizesSubviews = YES;
    
    UIView *tView = [[UIView alloc] initWithFrame:self.view.bounds];
    tView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    tView.autoresizesSubviews = YES;
    tView.backgroundColor = [UIColor clearColor];
    tView.tag = -100;
    [self.view addSubview:tView];
    _currentViewController = nil;
}

- (UIView*)transitionView { return [self.view viewWithTag: -100]; }

- (UIViewController*)currentViewController {return _currentViewController;}
- (void)setCurrentViewController:(UIViewController *)aViewController
{
    if (_currentViewController) {
        
        _currentViewController = nil;
    }
    
    _currentViewController = aViewController;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)changeToViewController:(UIViewController*)newController withTransition:(SOViewTransition)aTransition
{
    [self changeToViewController:newController withTransition:aTransition completionBlock:nil];
}

-(void)changeToViewController:(UIViewController*)newController withTransition:(SOViewTransition)aTransition completionBlock:(void (^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    [self changeToViewController:newController 
                  withTransition:aTransition 
                        duration:self.transitionTime 
                         options:UIViewAnimationCurveEaseIn 
                 completionBlock:completionBlock];
    
}
-(void)changeToViewController:(UIViewController *)newController 
               withTransition:(SOViewTransition)aTransition
                     duration:(NSTimeInterval)duration
                      options:(UIViewAnimationOptions)options
              completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    if (newController == nil)
        return;
    
    if (newController == self.currentViewController) {
        if (completionBlock) {
            [self fadeTransitionOfSameControllerWithCompletionBlock:completionBlock];
        }
        else
            [self fadeTransitionOfSameControllerWithCompletionBlock:nil];
        
    }

    
    if(aTransition == SOViewTransitionCustom) {
        NSLog(@"NavigationManager: <error> You tried to call an unimplemented custom transition!  Using None.");
        aTransition = SOViewTransitionNone;
    }
    
    if (aTransition == SOViewTransitionNone) {
        
        [self addChildViewController:newController];
        
        newController.view.frame = self.transitionView.bounds;  // i initially called transition view.bounds but if self.view is lazy loading, so transitionView was nil
        [self.transitionView addSubview:newController.view];
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        
        [self.currentViewController removeFromParentViewController];
                
        self.currentViewController = newController;
        [self.currentViewController didMoveToParentViewController:self];
        
        if (completionBlock) {
            completionBlock(self, newController);
        }
    }
    
    else if (aTransition == SOViewTransitionFade) {
        
        if (completionBlock)
            [self fadeController:newController completionBlock: completionBlock];
        else
            [self fadeController:newController completionBlock: nil ];
    }
    else if (aTransition == SOViewTransitionCrossfade)
    {
        if (completionBlock) 
            [self crossfadeController:newController completionBlock: completionBlock];
        else
            [self crossfadeController:newController completionBlock: nil];
    }
    else if (aTransition == SOViewTransitionSlideBothFromBottom ||
             aTransition == SOViewTransitionSlideBothFromLeft   ||
             aTransition == SOViewTransitionSlideBothFromRight  ||
             aTransition == SOViewTransitionSlideBothFromTop)
    {
        if (completionBlock) 
            [self slideBothController:newController withTransition:aTransition completionBlock: completionBlock];
        else
            [self slideBothController:newController withTransition:aTransition completionBlock: nil];
        
        
    }
    else if (aTransition == SOViewTransitionSlideNewFromBottom ||
             aTransition == SOViewTransitionSlideNewFromLeft ||
             aTransition == SOViewTransitionSlideNewFromRight ||
             aTransition == SOViewTransitionSlideNewFromTop)
    {
        if (completionBlock) 
            [self slideNewController:newController withTransition:aTransition completionBlock: completionBlock];
        else
            [self slideNewController:newController withTransition:aTransition completionBlock: nil];
        
        
    }
    else if (aTransition == SOViewTransitionSlideOldToBottom ||
             aTransition == SOViewTransitionSlideOldToLeft ||
             aTransition == SOViewTransitionSlideOldToRight ||
             aTransition == SOViewTransitionSlideOldToTop)
    {
        if (completionBlock) 
            [self slideOldController:newController withTransition:aTransition completionBlock: completionBlock];
        else
            [self slideOldController:newController withTransition:aTransition completionBlock: nil];
        
    }
    
}
- (void)fadeController:(UIViewController*)newController completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    
    
    newController.view.frame = self.transitionView.bounds;
    newController.view.alpha = 0.0;
    [self.currentViewController willMoveToParentViewController:nil];
    
    
    [UIView animateWithDuration:_fadeTime/2.0f
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // fade the current controller out
                         _currentViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         newController.view.alpha = 0.0;
                         
                         
                         [self.currentViewController.view removeFromSuperview];
                         [self.currentViewController removeFromParentViewController];
                         
                         [self addChildViewController:newController];
                         self.currentViewController = newController;
                         [self.transitionView addSubview:newController.view];
                         
                         [UIView animateWithDuration:_fadeTime/2.0f
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseOut                       
                                          animations:^{
                                              newController.view.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [self.currentViewController didMoveToParentViewController:self];
                                              
                                              if (completionBlock) {
                                                  completionBlock(self, newController);
                                              }
                                              
                                          }
                          ];
                     }
     ];
}

- (void)fadeTransitionOfSameControllerWithCompletionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    [UIView animateWithDuration:_fadeTime/2.0f
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // fade the current controller out
                         _currentViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.currentViewController.view.alpha = 0.0;
                         
                         if(completionBlock)
                             [self fadeSecondHalfOfTransitionWithController: self.currentViewController completionBlock: completionBlock];
                         else
                             [self fadeSecondHalfOfTransitionWithController: self.currentViewController completionBlock: nil];
                         
                     }
     ];
    
    
}

- (void)fadeSecondHalfOfTransitionWithController:(UIViewController*)aController completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    [UIView animateWithDuration:_fadeTime/2.0f
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut                       
                     animations:^{
                         aController.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                         if (completionBlock) {
                             completionBlock(self, aController);
                         }
                     }
     ];
}

- (void)crossfadeController:(UIViewController*)newController completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    newController.view.alpha = 0.0;  // set initial state for pre-animation of newController
    [self addChildViewController: newController];     
    newController.view.frame = self.transitionView.bounds;
    
    [self.currentViewController willMoveToParentViewController:nil];
    
    
    [self transitionFromViewController:self.currentViewController 
                      toViewController:newController 
                              duration:_fadeTime 
                               options:UIViewAnimationOptionCurveEaseInOut 
                            animations:^{
                                self.currentViewController.view.alpha = 0.0;
                                newController.view.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                [self.transitionView addSubview:newController.view];
                                [self.currentViewController.view removeFromSuperview];
                                
                                [newController didMoveToParentViewController:self];
                                [self.currentViewController removeFromParentViewController];
                                
                                if (completionBlock) {
                                    completionBlock(self, newController);
                                }
                                
                                self.currentViewController = newController;
                            }
     ];
    
}


- (void)slideBothController:(UIViewController*)newController withTransition:(SOViewTransition)aTransition completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    CGRect outFrameStart, outFrameEnd, inFrameStart, inFrameEnd;
    
    outFrameStart = self.transitionView.bounds;
    
    if (aTransition == SOViewTransitionSlideBothFromLeft)
    {
        
        inFrameStart = outFrameStart;
        inFrameStart.origin.x -= inFrameStart.size.width;
        
        inFrameEnd = outFrameStart;
        
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.x += outFrameEnd.size.width;
        
    }
    else if (aTransition == SOViewTransitionSlideBothFromRight)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.x += inFrameStart.size.width;
        
        inFrameEnd = outFrameStart;
        
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.x -= outFrameEnd.size.width;
        
        
    }
    else if (aTransition == SOViewTransitionSlideBothFromTop)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.y -= inFrameStart.size.height;
        
        inFrameEnd = outFrameStart;
        
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.y += outFrameEnd.size.height;
        
    }
    else if (aTransition == SOViewTransitionSlideBothFromBottom)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.y += inFrameStart.size.height;
        
        inFrameEnd = outFrameStart;
        
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.y -= outFrameEnd.size.height;
    }
    else
    {
        NSLog(@"TRANSITIONAL VIEW CONTROLLER HANDLING UNEXPECTED CASE!");
        // PASTING TRANSITION FROM RIGHT CODE SO THAT VALUES ARE INITIALIZED
        inFrameStart = outFrameStart;
        inFrameStart.origin.x += inFrameStart.size.width;
        
        inFrameEnd = outFrameStart;
        
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.x -= outFrameEnd.size.width;
    }
    
    
    [self addChildViewController:newController];  // newController will receive willMoveToParentViewController: 
    
    
    self.currentViewController.view.frame = outFrameStart;
    newController.view.frame = inFrameStart;
    [self.transitionView addSubview:newController.view];
    [self.currentViewController willMoveToParentViewController:nil];
    
    
    [UIView animateWithDuration:_transitionTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         newController.view.frame = inFrameEnd;
                         self.currentViewController.view.frame = outFrameEnd;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self.currentViewController.view removeFromSuperview];
                         [self.currentViewController removeFromParentViewController];
                         
                         self.currentViewController = newController;
                         [self.currentViewController didMoveToParentViewController:self];
                         
                         if (completionBlock) {
                             completionBlock(self, newController);
                         }
                         
                     }
     ];
    
}

- (void)slideNewController:(UIViewController*)newController withTransition:(SOViewTransition)transition completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    CGRect outFrameStart, outFrameEnd, inFrameStart, inFrameEnd;
    
    outFrameStart = self.transitionView.bounds;
    outFrameEnd = outFrameStart;
    
    if (transition == SOViewTransitionSlideNewFromLeft)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.x -= inFrameStart.size.width;
        inFrameEnd = outFrameStart;
    }
    else if (transition == SOViewTransitionSlideNewFromRight)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.x += inFrameStart.size.width;
        inFrameEnd = outFrameStart;
    }
    else if (transition == SOViewTransitionSlideNewFromTop)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.y -= inFrameStart.size.height;
        inFrameEnd = outFrameStart;        
    }
    else if (transition == SOViewTransitionSlideNewFromBottom)
    {
        inFrameStart = outFrameStart;
        inFrameStart.origin.y += inFrameStart.size.height;
        inFrameEnd = outFrameStart;
    }
    else
    {
        // doing this to make the analyzer happy.  pasting the slide new from right code
        inFrameStart = outFrameStart;
        inFrameStart.origin.x += inFrameStart.size.width;
        inFrameEnd = outFrameStart;
    }
    
    
    [self addChildViewController:newController];  // newController will receive willMoveToParentViewController: 
    
    self.currentViewController.view.frame = outFrameStart;
    newController.view.frame = inFrameStart;
    [self.transitionView addSubview:newController.view];
    [self.currentViewController willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:_transitionTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         newController.view.frame = inFrameEnd;
                         self.currentViewController.view.frame = outFrameEnd;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self.currentViewController.view removeFromSuperview];
                         [self.currentViewController removeFromParentViewController];
                         
                         self.currentViewController = newController;
                         [self.currentViewController didMoveToParentViewController:self];
                         
                         if (completionBlock) {
                             completionBlock(self, newController);
                         }
                         
                     }
     ];
    
}
- (void)slideOldController:(UIViewController*)newController withTransition:(SOViewTransition)transition completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock
{
    CGRect outFrameStart, outFrameEnd, inFrameStart, inFrameEnd;
    
    outFrameStart = self.transitionView.bounds;
    inFrameStart = outFrameStart;
    inFrameEnd = inFrameStart;
    
    if (transition == SOViewTransitionSlideOldToRight)
    {
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.x += outFrameEnd.size.width;
        
    }
    else if (transition == SOViewTransitionSlideOldToLeft)
    {
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.x -= outFrameEnd.size.width;
    }
    else if (transition == SOViewTransitionSlideOldToBottom)
    {
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.y += outFrameEnd.size.height;
        
    }
    else if (transition == SOViewTransitionSlideOldToTop)
    {
        outFrameEnd = outFrameStart;
        outFrameEnd.origin.y -= outFrameEnd.size.height;
    }
    
    
    [self addChildViewController:newController];  // newController will receive willMoveToParentViewController: 
    
    self.currentViewController.view.frame = outFrameStart;
    newController.view.frame = inFrameStart;
    
    [self.transitionView insertSubview:newController.view belowSubview:self.currentViewController.view];
    [self.currentViewController willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:_transitionTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         newController.view.frame = inFrameEnd;
                         self.currentViewController.view.frame = outFrameEnd;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self.currentViewController.view removeFromSuperview];
                         [self.currentViewController removeFromParentViewController];
                         
                         self.currentViewController = newController;
                         [self.currentViewController didMoveToParentViewController:self];
                         
                         if (completionBlock) {
                             completionBlock(self, newController);
                         }
                         
                     }
     ];
    
}




- (void)dealloc
{
    self.currentViewController = nil;
    
}

@end


