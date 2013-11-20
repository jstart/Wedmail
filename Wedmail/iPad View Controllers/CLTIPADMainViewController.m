//
//  CLTIPADMainViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/18/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTIPADMainViewController.h"
#import "CLTDesignMenuViewController.h"
#import "CLTCustomizeCardViewController.h"

@interface CLTIPADMainViewController ()

@end

@implementation CLTIPADMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CLTDesignMenuViewController * left = [[CLTDesignMenuViewController alloc] init];
        CLTCustomizeCardViewController * right = [[CLTCustomizeCardViewController alloc] init];
        [self setViewControllers:@[left, right]];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
