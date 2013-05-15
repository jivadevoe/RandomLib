//
//  CustomViewLoader.m
//
//  Created by Jiva DeVoe on 5/4/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "CustomViewLoader.h"


@implementation CustomViewLoader
@synthesize view;
@synthesize nibName;


-(id)initWithNibName:(NSString *)inNibName;
{
	if((self = [super init]))
    {
		[self setNibName:inNibName];
		[self reload];
    }
    return self;

}

-(void)reload;
{
	[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];			
}

@end
