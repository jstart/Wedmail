//
//  CLTCustomizeCardViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTCustomizeCardViewController.h"
#import "CLTImportAddressesViewController.h"

#import <QBFlatButton/QBFlatButton.h>
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import "UIImage+Width.h"
#import "UIView+Rasterize.h"

@interface CLTCustomizeCardViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coupleImageView;
@property (weak, nonatomic) IBOutlet QBFlatButton *saveButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIToolbar *colorToolbar;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *greyButton;
@property (weak, nonatomic) IBOutlet UIButton *purpleButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation CLTCustomizeCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Make it yours";
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(changeImage:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.saveButton setRadius:0.0];
    [self.saveButton setDepth:2.0];
    [self.saveButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.saveButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.saveButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];

    [self.nextButton setRadius:0.0];
    [self.nextButton setDepth:2.0];
    [self.nextButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.nextButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.nextButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)next:(id)sender {
    CLTImportAddressesViewController * importViewController = [[CLTImportAddressesViewController alloc] init];
    [self.navigationController pushViewController:importViewController animated:YES];
}

- (IBAction)save:(id)sender {
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:self.coupleImageView.frame];
    CGRect frame = self.dateField.frame;
    frame.origin.y = frame.origin.y - self.coupleImageView.frame.origin.y;
    frame.size.width = self.coupleImageView.frame.size.width;
    [dateLabel setFrame:frame];
    [dateLabel setText:self.dateField.text];
    [dateLabel setTextColor:self.dateField.textColor];
    [dateLabel setFont:self.dateField.font];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setContentMode:UIViewContentModeBottom];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:self.coupleImageView.image];
    [imageView addSubview:dateLabel];

    UIImage * image = [UIView rasterizeView:imageView];

    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)changeImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];

    NSString * photoUrl = nil;

    BOOL isNewlyTaken = (info[UIImagePickerControllerReferenceURL] == nil);

    if (isNewlyTaken){
//        UIImage *image = info[UIImagePickerControllerOriginalImage];
    }
    UIImage * scaledImage = [UIImage imageWithImage:info[UIImagePickerControllerOriginalImage] scaledToWidth:367];
    [self.coupleImageView setImage:scaledImage];
    photoUrl =  [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)deselectOtherButtons:(UIButton *)selectedButton{
    NSArray * array = @[self.blackButton, self.greyButton, self.whiteButton, self.purpleButton];
    for (UIButton * button in array) {
        if (button != selectedButton) {
            [button setSelected:NO];
        }
    }
}

- (IBAction)blackSelected:(id)sender {
    [self deselectOtherButtons:(UIButton *)sender];
    [(UIButton *)sender setSelected:YES];
    [self.dateField setTextColor:[UIColor blackColor]];
}

- (IBAction)greySelected:(id)sender {
    [self deselectOtherButtons:(UIButton *)sender];
    [(UIButton *)sender setSelected:YES];
    [self.dateField setTextColor:[UIColor grayColor]];
}

- (IBAction)purpleSelected:(id)sender {
    [self deselectOtherButtons:(UIButton *)sender];
    [(UIButton *)sender setSelected:YES];
    [self.dateField setTextColor:[UIColor purpleColor]];
}

- (IBAction)whiteSelected:(id)sender {
    [self deselectOtherButtons:(UIButton *)sender];
    [(UIButton *)sender setSelected:YES];
    [self.dateField setTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
