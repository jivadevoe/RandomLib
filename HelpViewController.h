//
//  HelpViewController.h
//
//  Created by Jiva DeVoe on 5/10/09.
//  Copyright 2009 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDelegate.h"

@interface HelpViewController : UIViewController 
@property (weak, nonatomic)  id<ViewControllerDelegate> delegate;
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
@property (strong, nonatomic) UINavigationBar * navBar;
@property (strong, nonatomic) UIButton * button;
@property (nonatomic, strong) NSString * appTitle;

-(id)initWithHelpFileURL:(NSString *)inWebUrl __attribute__((deprecated));;
-(id)initWithHelpURL:(NSURL *)inWebUrl;
-(IBAction)doneTouched:(id)sender;

@end
