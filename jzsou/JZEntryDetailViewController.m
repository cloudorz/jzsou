//
//  JZEntryDetailViewController.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZEntryDetailViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"

@interface JZEntryDetailViewController ()

-(BOOL)testCellPhoneNumber:(NSString *)num;

@end

@implementation JZEntryDetailViewController

@synthesize nameTitle=_nameTitle;
@synthesize worktime=_worktime;
@synthesize desc=_desc;
@synthesize address=_address;
@synthesize contact=_contact;
@synthesize phone=_phone;
@synthesize project=_project;
@synthesize area=_area;
@synthesize smsButton=_smsButton;
@synthesize callButton=_callButton;
@synthesize entry=_entry;

- (void)dealloc
{
    [_nameTitle release];
    [_worktime release];
    [_desc release];
    [_address release];
    [_contact release];
    [_phone release];
    [_project release];
    [_area release];
    [_callButton release];
    [_smsButton release];
    [_entry release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] 
                                             initBackBarButtonItemWithTarget:self 
                                             action:@selector(backAction:) 
                                             title:@"返回"] autorelease];
    self.navigationItem.title = @"详细";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    // init the contents
 
    self.nameTitle.text = [self.entry objectForKey:@"title"];
    self.address.text = [self.entry objectForKey:@"address"];
    self.project.text = [[self.entry objectForKey:@"serviceitems"] componentsJoinedByString:@" "];
    self.worktime.text = [self.entry objectForKey:@"worktime"];
    self.area.text = [[self.entry objectForKey:@"serviceareas"] componentsJoinedByString:@" "];
    self.desc.text = [self.entry objectForKey:@"desc"];
    self.contact.text = [self.entry objectForKey:@"linkman"];
    self.phone.text = [[self.entry objectForKey:@"contracts"] objectAtIndex:0];
    
    // init the buttons
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]){
        self.callButton.enabled = YES;
        if ([self testCellPhoneNumber:self.phone.text]) { 
            self.smsButton.enabled = YES;
        }
    } 
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)smsTrigger:(id)sender
{

    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            [Utils warningNotification:@"设备没有短信功能"];
        }
    } else {
        [Utils warningNotification:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

- (IBAction)callTrigger:(id)sender
{

    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phone.text]];
        
        [[UIApplication sharedApplication] openURL:callURL];
    } else {
        [Utils warningNotification:@"设备没有电话功能"];
    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)testCellPhoneNumber:(NSString *)num
{
#pragma todo
    NSString *decimalRegex = @"^(1(([35][0-9])|(47)|[8][0126789]))[0-9]{8}$";
    NSPredicate *decimalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    return [decimalTest evaluateWithObject:num];
}

#pragma mark - SMS

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObject:self.phone.text];
    picker.body=[NSString stringWithFormat:@"您好, 我在家政搜上看到你发布的信息\"%@\", ", [self.entry objectForKey:@"title"]];

    [self presentModalViewController:picker animated:YES];
    [picker release];
                 
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    switch (result){
            case MessageComposeResultCancelled:
                NSLog(@"Canceled SMS sending");
                break;
            case MessageComposeResultSent:
                NSLog(@"SMS sent it");
                break;
            case MessageComposeResultFailed:
                [Utils warningNotification:@"短信发送失败"];
                break;
            default:
                break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

@end
