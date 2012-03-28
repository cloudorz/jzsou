//
//  JZEntryDetailViewController.h
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface JZEntryDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *address, *worktime, *contact, *phone, *nameTitle;
@property (strong, nonatomic) IBOutlet UITextView *project, *area, *desc;
@property (strong, nonatomic) IBOutlet UIButton *smsButton, *callButton;
@property (strong, nonatomic) NSMutableDictionary *entry;

@end
