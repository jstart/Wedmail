//
//  CLTIMportAddressesViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/3/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTImportAddressesViewController.h"
#import "CLTSendViewController.h"
#import <QBFlatButton/QBFlatButton.h>
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <SGNavigationProgress/UINavigationController+SGProgress.h>
#import <AFNetworking/AFNetworking.h>
#import <RHAddressBook/RHPerson.h>
#import "CLTPerson.h"
#import "CLTInviteViewController.h"

@import AddressBook;

@interface CLTImportAddressesViewController ()
@property (weak, nonatomic) IBOutlet QBFlatButton *importButton;

@end

@implementation CLTImportAddressesViewController

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

    self.title = @"Step 4: Import Addresses";
    
    // Do any additional setup after loading the view from its nib.
    [self.importButton setRadius:0.0];
    [self.importButton setDepth:2.0];
    [self.importButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.importButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.importButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController setSGProgressPercentage:5 * (100/6)];
    [self postable];
}

-(void)postable{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    [manager POST:@"https://www.postable.com/login" parameters:@{@"login": @"hana.nesbitt@gmail.com", @"password" : @"StormiePost20"} constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [manager POST:@"https://www.postable.com/contacts/export" parameters:@{@"export_format": @"vcard"} constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                NSString* string = [NSString stringWithUTF8String:[responseObject bytes]];

                NSError * error = nil;
                [string writeToFile:[@"~/Documents/postable.vcf" stringByExpandingTildeInPath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
                ABAddressBookRef book = ABAddressBookCreateWithOptions(nil, nil);
                ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
                CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, (__bridge CFDataRef)(responseObject));
                NSMutableArray * contacts = [NSMutableArray array];
                for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
                    ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
                    CLTPerson * contact = [[CLTPerson alloc] initWithABRecordRef:person];
                    [contacts addObject:contact];
                }
                CLTInviteViewController * inviteViewController = [[CLTInviteViewController alloc] init];
                inviteViewController.contacts = contacts;
//                [self presentViewController:inviteViewController animated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)importAddresses:(id)sender {
    CLTSendViewController * sendViewController = [[CLTSendViewController alloc] init];
    [self.navigationController pushViewController:sendViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
