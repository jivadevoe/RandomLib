//
//  CustomViewLoader.h
//
//  Created by Jiva DeVoe on 5/4/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomViewLoader : NSObject 
{
	IBOutlet UIView *view;
	NSString *nibName;
}
@property (strong, nonatomic) UIView * view;
@property (strong, nonatomic) NSString * nibName;

-(id)initWithNibName:(NSString *)inNibName;
-(void)reload;

@end
