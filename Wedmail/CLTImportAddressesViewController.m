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

    self.title = @"Import Addresses";
    
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
