//
//  HelpViewController.m
//
//  Created by Jiva DeVoe on 5/10/09.
//  Copyright 2009 Random Ideas, LLC. All rights reserved.
//

#import "HelpViewController.h"
#import "UIView+Positioning.h"

@interface HelpViewController ()
@property (strong, nonatomic) NSURL *helpURL;
@end


@implementation HelpViewController

-(id)initWithHelpFileURL:(NSString *)inWebUrl;
{
    return [self initWithHelpURL:[NSURL URLWithString:inWebUrl]];
}

-(id)initWithHelpURL:(NSURL *)inWebUrl;
{
    if((self = [super initWithNibName:@"HelpView" bundle:nil]))
    {
        [self setHelpURL:inWebUrl];
    }
    return self;    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

-(IBAction)doneTouched:(id)sender;
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self dismissViewControllerAnimated:YES completion:nil];
#else
    [self dismissModalViewControllerAnimated:YES];
#endif
    [self.delegate viewControllerFinishedModalAction:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[self.navBar topItem] setTitle:@"Loading..."];
    [self.spinner startAnimating];
    [self.button setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.appTitle)
        [[self.navBar topItem] setTitle:self.appTitle];
    else
        [[self.navBar topItem] setTitle:@"Help"];
    
    [self.spinner stopAnimating];
    [self.button setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad 
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.helpURL]];
    [[self.navBar topItem] setTitle:@"Loading..."];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
            self.spinner.center = CGPointMake(512, 384);
        else
            self.spinner.center = [[UIApplication sharedApplication] keyWindow].center;
    }
    else
        self.spinner.center = [[UIApplication sharedApplication] keyWindow].center;
    
    [self.spinner startAnimating];
    [super viewDidLoad];
}

@end
