//
//  CLTInviteViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTInviteViewController.h"
#import "CLTAddressCell.h"

#import <RHAddressBook/AddressBook.h>
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <MessageUI/MessageUI.h>
#import <SAMHUDView/SAMHUDView.h>

@interface CLTInviteViewController () <UITableViewDataSource, UITableViewDelegate>{
    BOOL alreadyLoaded;
}

@property (nonatomic, strong) NSMutableArray * currentContacts;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactSegmentedControl;
@property (nonatomic, strong) NSMutableArray *selectedContacts;

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

        UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"Unselect All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAll)];
        //        UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
//
        self.navigationItem.rightBarButtonItems = @[addButton];

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (self.contacts) {
        self.selectedContacts = [self.contacts mutableCopy];
        [self.tableView reloadData];
        alreadyLoaded = YES;
    }
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
        NSPredicate * addressFilterPredicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary * bindings){
            RHPerson * person = evaluatedObject;
            if ([person isOrganization]) {
                return NO;
            }

            if (person.addresses.count > 0) {
                NSString * street = [person.addresses valueAtIndex:0][@"Street"];
                NSString * name = [person compositeName];
                if (street && name) {
                    return YES;
                }
            }else{
                return NO;
            }
            return NO;
        }];

        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
            self.addressBook = self.addressBook ? self.addressBook : [[RHAddressBook alloc] init];
            [_addressBook requestAuthorizationWithCompletion:^(bool granted, NSError * error){
                if (granted) {
                    self.contacts = [[[_addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:addressFilterPredicate] copy];
                    self.selectedContacts = [self.contacts mutableCopy];
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
            self.addressBook = self.addressBook ? self.addressBook : [[RHAddressBook alloc] init];
            self.contacts = [[[_addressBook peopleOrderedByFirstName] filteredArrayUsingPredicate:addressFilterPredicate] copy];
            self.selectedContacts = [self.contacts mutableCopy];
            alreadyLoaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hudView completeAndDismissWithTitle:@"Loaded Contacts"];
                [self.tableView reloadData];
            });
        }
    });
}

-(void)selectAll{
    if (self.contacts.count == self.selectedContacts.count) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Select All"];
        self.selectedContacts = [NSMutableArray array];
        [[self tableView] reloadData];
    }else{
        self.selectedContacts = [self.contacts mutableCopy];
        [self.navigationItem.rightBarButtonItem setTitle:@"Unselect All"];
        [[self tableView] reloadData];
    }
}

-(void)add{

}

-(void)search{

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContactCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"CLTAddressCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
    CLTAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[CLTAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RHPerson * person = ((RHPerson *)[self.contacts objectAtIndex:indexPath.row]);
    [cell configureWithPerson:person];
    
    if ([self.selectedContacts containsObject:[self.contacts objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    RHPerson *contact = [self.contacts objectAtIndex:indexPath.row];
    
    if ([self.selectedContacts containsObject:contact]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedContacts removeObject:contact];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedContacts addObject:contact];
    }

    if (self.contacts.count == self.selectedContacts.count) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Unselect All"];
    }else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Select All"];
    }

    [self sendInvitesToContacts:@[contact]];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

@end
