

/** This is a simple delegate that I use sometimes when I want to tell another object when a view controller has finished it's work.
 */

@protocol ViewControllerDelegate <NSObject>

/// Required method. Called when the view controller has finished whatever work it's doing successfully.
-(void)viewControllerFinishedModalAction:(UIViewController *)inController;
@optional
/// Optional method. Called when the view controller has failed to do what it needed to do, or the user cancelled the operation.
-(void)viewControllerCancelledModalAction:(UIViewController *)inController;

@end
