//
//  CLTInviteViewController.h
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

@class RHAddressBook;
@interface CLTInviteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RHAddressBook * addressBook;
@property (nonatomic, strong) NSArray *contacts;

@end
