//
//  CLTSendViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/3/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTSendViewController.h"
#import "CLTInviteViewController.h"
#import "CLTConfirmationViewController.h"
#import <QBFlatButton/QBFlatButton.h>
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <RHAddressBook/RHAddressBook.h>
#import <RHAddressBook/RHPerson.h>

@interface CLTSendViewController ()
@property (weak, nonatomic) IBOutlet QBFlatButton *reviewButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *orderButton;
@property (nonatomic, strong) RHAddressBook * addressBook;
@property (nonatomic, strong) NSMutableArray * contacts;
@property (nonatomic, strong) NSMutableArray * selectedContacts;
@property (nonatomic, strong) NSMutableArray * filteredContacts;
@property (weak, nonatomic) IBOutlet UILabel *addressCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestsLabel;

@end

@implementation CLTSendViewController

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

    self.title = @"Send Them on Their Way";

    // Do any additional setup after loading the view from its nib.
    [self.reviewButton setRadius:0.0];
    [self.reviewButton setDepth:2.0];
    [self.reviewButton setFaceColor:[UIColor colorWithHexString:@"f38e58"]];
    [self.reviewButton setSideColor:[UIColor colorWithHexString:@"cf6933"]];
    [self.reviewButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];

    [self.orderButton setRadius:0.0];
    [self.orderButton setDepth:2.0];
    [self.orderButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.orderButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.orderButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];

    [self.topTextLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
    [self.guestsLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
    [self.addressCountLabel setFont:[UIFont fontWithName:@"Gotham" size:24]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
            self.addressBook = [[RHAddressBook alloc] init];
            [self.addressBook requestAuthorizationWithCompletion:^(bool granted, NSError * error){
                if (granted) {
                    self.contacts = [[self.addressBook peopleOrderedByFirstName]  mutableCopy];
                    self.selectedContacts = [NSMutableArray array];
                    self.filteredContacts = self.contacts;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.addressCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.contacts.count]];
                    });
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't access contacts" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }else{
            self.addressBook = [[RHAddressBook alloc] init];
            self.contacts = [[self.addressBook peopleOrderedByFirstName] mutableCopy];
            self.selectedContacts = [NSMutableArray array];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.addressCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.contacts.count]];
            });
        }
    });
}

- (IBAction)reviewAddresses:(id)sender {
    CLTInviteViewController * inviteViewController = [[CLTInviteViewController alloc] init];
    [self.navigationController pushViewController:inviteViewController animated:YES];
}

- (IBAction)order:(id)sender {
    CLTConfirmationViewController * confirmViewController = [[CLTConfirmationViewController alloc] init];
    [self.navigationController pushViewController:confirmViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
