//
//  JZEntryCell.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZEntryCell.h"

@implementation JZEntryCell

@synthesize title=_title;
@synthesize subTitle=_subTitle;

- (void)dealloc
{
    [_title release];
    [_subTitle release];
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
        
        self.title = [[[UILabel alloc] initWithFrame:CGRectMake(12, 12, 250, 14)] autorelease];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        [self.contentView addSubview:self.title];
        
        self.subTitle = [[[UILabel alloc] initWithFrame:CGRectMake(12, 30, 250, 12)] autorelease];
        self.subTitle.backgroundColor = [UIColor clearColor];
        self.subTitle.font = [UIFont systemFontOfSize:12.0f];
        self.subTitle.textColor = [UIColor colorWithRed:153/255.0 
                                                  green:153/255.0 
                                                   blue:153/255.0 
                                                  alpha:1.0];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        
        [self.contentView addSubview:self.subTitle];
        
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
