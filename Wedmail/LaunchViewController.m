//
//  LaunchViewController.m
//  Wedmail
//
//
//

#import "LaunchViewController.h"
#import "CLTDesignMenuViewController.h"

#import <UIColor-Utilities/UIColor+Expanded.h>

@interface LaunchViewController ()

@end

@implementation LaunchViewController

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
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.945 alpha:1.000]];
    [self.getStartedButton setRadius:0.0];
    [self.getStartedButton setDepth:2.0];
    [self.getStartedButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.getStartedButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.getStartedButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Medium" size:15]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

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
