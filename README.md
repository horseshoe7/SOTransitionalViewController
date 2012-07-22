# SOTransitionalViewController

A container view controller that can transition from one view controller to another.  Like a UINavigationController without a stack and more transition options that can be further extended if you want.

## Easy API

```objc
@interface SOTransitionalViewController : UIViewController

@property (nonatomic, readonly) UIViewController *currentViewController;

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

@end
```

## Transition Types

In the SOTransitionalViewController.h, the types are defined:

```objc
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
```

## Demo Project

When you run the demo project, tapping a view controller will transition to a new view controller.  The transitions will just cycle through the transitions above, so you can see them in action.

## Further Ideas

I use this class as the mainController in another project I made:

https://github.com/horseshoe7/SOSideMenusController

and these together form the basis of an application controller that ends up being remarkably flexible and powerful.

## Known Issues

 * Not heavily tested with autorotation, but I think it's fine.  ;-)

## Feedback

Is always welcome!  You can create a github issue if you like.

Hope you like it!

Stephen O'Connor
