//
//  JZListCateCell.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZListCateCell.h"

@implementation JZListCateCell

@synthesize name=_name;
@synthesize logo=_logo;

- (void)dealloc
{
    [_name release];
    [_logo release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *sbv = [[UIView alloc] init];
        sbv.backgroundColor = [UIColor colorWithRed:245/255.0 
                                              green:243/255.0 
                                               blue:241/255.0 
                                              alpha:1.0];
        sbv.opaque = YES;
        self.selectedBackgroundView = sbv;
        [sbv release];
        
        self.logo = [[[UIImageView alloc] initWithFrame:CGRectMake(14, 16, 18, 18)] autorelease];
        self.logo.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.logo];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(46, 18, 100, 14)] autorelease];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.font = [UIFont boldSystemFontOfSize:14.0f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        [self.contentView addSubview:self.name];
        
        UIImageView *tri = [[[UIImageView alloc] initWithFrame:CGRectMake(299, 18, 9, 13)] autorelease];
        tri.backgroundColor = [UIColor clearColor];
        tri.image = [UIImage imageNamed:@"graytri.png"];
        
        [self.contentView addSubview:tri];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
