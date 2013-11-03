//
//  CLTInviteViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTInviteViewController.h"


#import "AddressBook.h"
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <MessageUI/MessageUI.h>
#import <SAMHUDView/SAMHUDView.h>

@interface CLTInviteViewController () <MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>{

    RHAddressBook * addressBook;
    BOOL alreadyLoaded;
}
@property (nonatomic, strong) NSMutableArray * currentContacts;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactSegmentedControl;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;

@end

@implementation CLTInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Invite Friends";
        
//        UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem;

//        UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
//        UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
//
//        self.navigationItem.rightBarButtonItems = @[addButton, searchButton];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
//    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
//    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
//    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    if (alreadyLoaded) {
        [self.tableView reloadData];
        return;
    }
    SAMHUDView * hudView = [[SAMHUDView alloc] initWithTitle:@"Loading Contacts" loading:YES];
    [hudView show];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSPredicate * phoneFilterPredicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary * bindings){
            RHPerson * person = evaluatedObject;
            if (person.phoneNumbers.count > 0) {
                return YES;
            }else{
                return NO;
            }
        }];

        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
            addressBook = [[RHAddressBook alloc] init];
            [addressBook requestAuthorizationWithCompletion:^(bool granted, NSError * error){
                if (granted) {
                    self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:phoneFilterPredicate] mutableCopy];
                    self.selectedContacts = [NSMutableArray array];
                    self.filteredContacts = self.contacts;
                    alreadyLoaded = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                        [self.tableView reloadData];
                    });
                } else {
                    [hudView failAndDismissWithTitle:@"Can't Access Contacts"];
                }
            }];
        }else{
            addressBook = [[RHAddressBook alloc] init];
            self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:phoneFilterPredicate] mutableCopy];
            self.selectedContacts = [NSMutableArray array];
            self.filteredContacts = self.contacts;
            alreadyLoaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                [self.tableView reloadData];
            });
        }
    });

}

-(void)add{

}

-(void)search{

}

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl * segmentedControl = sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        SAMHUDView * hudView = [[SAMHUDView alloc] initWithTitle:@"Loading Contacts" loading:YES];
        [hudView show];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate * phoneFilterPredicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary * bindings){
                RHPerson * person = evaluatedObject;
                if (person.phoneNumbers.count > 0) {
                    return YES;
                }else{
                    return NO;
                }
            }];

            if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
                addressBook = [[RHAddressBook alloc] init];
                [addressBook requestAuthorizationWithCompletion:^(bool granted, NSError * error){
                    if (granted) {
                        self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:phoneFilterPredicate] mutableCopy];
                        self.selectedContacts = [NSMutableArray array];
                        self.filteredContacts = self.contacts;
                        alreadyLoaded = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                            [self.tableView reloadData];
                        });
                    } else {
                        [hudView failAndDismissWithTitle:@"Can't Access Contacts"];
                    }
                }];
            }else{
                self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:phoneFilterPredicate] mutableCopy];
                self.selectedContacts = [NSMutableArray array];
                self.filteredContacts = self.contacts;
                alreadyLoaded = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                    [self.tableView reloadData];
                });
            }
        });

    }else{
        SAMHUDView * hudView = [[SAMHUDView alloc] initWithTitle:@"Loading Contacts" loading:YES];
        [hudView show];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate * emailFilterPredicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary * bindings){
                RHPerson * person = evaluatedObject;
                if (person.emails.count > 0) {
                    return YES;
                }else{
                    return NO;
                }
            }];

            if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
                addressBook = [[RHAddressBook alloc] init];
                [addressBook requestAuthorizationWithCompletion:^(bool granted, NSError * error){
                    if (granted) {
                        self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:emailFilterPredicate] mutableCopy];
                        self.selectedContacts = [NSMutableArray array];
                        self.filteredContacts = self.contacts;
                        alreadyLoaded = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                            [self.tableView reloadData];
                        });
                    } else {
                        [hudView failAndDismissWithTitle:@"Can't Access Contacts"];
                    }
                }];
            }else{
                self.contacts = [[[addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:emailFilterPredicate] mutableCopy];
                self.selectedContacts = [NSMutableArray array];
                self.filteredContacts = self.contacts;
                alreadyLoaded = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                    [self.tableView reloadData];
                });
            }
        });

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RHPerson * contact = ((RHPerson *)[self.filteredContacts objectAtIndex:indexPath.row]);
    cell.textLabel.text = contact.compositeName;
    
    if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    RHPerson *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    if ([self.selectedContacts containsObject:contact]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedContacts removeObject:contact];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedContacts addObject:contact];
    }

        [self sendInvitesToContacts:@[contact]];
        self.filteredContacts = self.contacts;
        [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClose{
    if (self.currentContacts) {
        [self sendInvitesToContacts:self.currentContacts];
    }else{
        [self done];
    }
}

-(void)cancel{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendInvitesToContacts:(NSArray*)contacts{
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        [self.selectedContacts removeObject:[self.selectedContacts lastObject]];
        [self.tableView reloadData];
    }else if(result == MessageComposeResultSent) {
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

@end
