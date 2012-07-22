//
//  TSNodalNavigationController.h
//  NodalNavigation
//
//  Created by Stephen O'Connor on 2/7/12.
//  Copyright (c) 2012 Stephen O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SOTransitionalViewController;

@interface UIViewController (SOTransitionalViewController)

- (SOTransitionalViewController*)transitionController;

@end


typedef enum {
    SOViewTransitionCustom = 0,  /* currently no real implementation for this type.  More of a stub right now */
    SOViewTransitionNone,
    SOViewTransitionFade,
    SOViewTransitionCrossfade,
    SOViewTransitionSlideBothFromRight,
    SOViewTransitionSlideBothFromLeft,
    SOViewTransitionSlideBothFromTop,
    SOViewTransitionSlideBothFromBottom,
    SOViewTransitionSlideNewFromRight,
    SOViewTransitionSlideNewFromLeft,
    SOViewTransitionSlideNewFromTop,
    SOViewTransitionSlideNewFromBottom,
    SOViewTransitionSlideOldToRight,
    SOViewTransitionSlideOldToLeft,
    SOViewTransitionSlideOldToTop,
    SOViewTransitionSlideOldToBottom
    
}SOViewTransition;


@protocol SOViewTransitionDelegate;

#pragma mark -

@interface SOTransitionalViewController : UIViewController
{
    UIViewController *_currentViewController;
    NSTimeInterval _fadeTime, _transitionTime;
}
@property (nonatomic, strong) UIViewController *currentViewController;
@property (readonly) UIView *transitionView;  // the view which holds the controllers being transitioned.  usually same size as window bounds, but you can customize.

@property NSTimeInterval fadeTime;  // time in seconds for fade transitions
@property NSTimeInterval transitionTime;  // time in seconds for slide transitions

// if you provide the same controller, it will default to a fade transition and call the methods below.
-(void)changeToViewController:(UIViewController*)controller 
               withTransition:(SOViewTransition)aTransition;

-(void)changeToViewController:(UIViewController *)controller 
               withTransition:(SOViewTransition)aTransition 
              completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;

-(void)changeToViewController:(UIViewController *)controller 
               withTransition:(SOViewTransition)aTransition
                     duration:(NSTimeInterval)duration
                      options:(UIViewAnimationOptions)options
              completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;


// "Special Methods"
- (void)fadeTransitionOfSameControllerWithCompletionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;
;  // will be 
- (void)fadeSecondHalfOfTransitionWithController:(UIViewController*)aController completionBlock:(void(^)(SOTransitionalViewController *transitionalController, UIViewController *toController))completionBlock;
;  // you can override this, but don't forget to call [super fadeSecond... at end

/* NOTES on the 2 Methods above:
 You may have a situation where you have the same content controller, but your data model or source changes.  Without deallocating and reallocating a view controller, you can transition out of the old one, override the fadeSecondHalfOfTransitionWithController: method to change your data source and update your view, then call [super fadeSecondHalfOfTransitionWithController: aController]; to finish the animation
 
 */


+(SOViewTransition)testNextTransition;

@end



