//
//  CLTConfirmationViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/3/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTConfirmationViewController.h"
#import <QBFlatButton/QBFlatButton.h>
#import <UIColor-Utilities/UIColor+Expanded.h>

@interface CLTConfirmationViewController ()

@end

@implementation CLTConfirmationViewController

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
