//
//  CLTLaunchViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTLaunchViewController.h"
#import "CLTDesignMenuViewController.h"

#import <UIColor-Utilities/UIColor+Expanded.h>
#import <CardIO/CardIOPaymentViewController.h>
#import <AFNetworking.h>

@interface CLTLaunchViewController () //<CardIOPaymentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation CLTLaunchViewController

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
    self.title = @"";

    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.945 alpha:1.000]];
    [self.getStartedButton setRadius:0.0];
    [self.getStartedButton setDepth:2.0];
    [self.getStartedButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.getStartedButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.getStartedButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];

    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"frame.origin.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);

    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"frame.origin.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);

    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

    // Add both effects to your view
    [self.logoImageView addMotionEffect:group];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

//    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
//    scanViewController.appToken = @"5bf7ca908aa049f49fb1ae2c877bed87"; // get your app token from the card.io website
//    [self presentViewController:scanViewController animated:YES completion:nil];
}

//- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/// This method will be called when there is a successful scan (or manual entry). You MUST dismiss paymentViewController.
/// @param cardInfo The results of the scan.
/// @param paymentViewController The active CardIOPaymentViewController.
//- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)getStarted:(id)sender {
    CLTDesignMenuViewController * designMenuViewController = [[CLTDesignMenuViewController alloc] init];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setAlpha:0.1];
    [self.navigationController pushViewController:designMenuViewController animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
