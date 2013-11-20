//
//  CLTCustomizeCardViewController.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "CLTCustomizeCardViewController.h"
#import "CLTImportAddressesViewController.h"

#import <QBFlatButton/QBFlatButton.h>
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import <SGNavigationProgress/UINavigationController+SGProgress.h>
#import <vfrReader/ReaderViewController.h>
#import "UIImage+Width.h"
#import "UIView+Rasterize.h"
#import "UIImage+Rotate.h"
#import "UIImage+Resize.h"

@interface CLTCustomizeCardViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, ReaderViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coupleImageView;
@property (weak, nonatomic) IBOutlet QBFlatButton *backButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIToolbar *colorToolbar;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *greyButton;
@property (weak, nonatomic) IBOutlet UIButton *purpleButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) NSNumber * currentStep;

@property (weak, nonatomic) IBOutlet UIView *touchLayerView;

@property (strong, nonatomic) UIImage * fullScaleImage;

@end

@implementation CLTCustomizeCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Step 1: Choose a Picture";
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dateField.delegate = self;

    [self.backButton setRadius:0.0];
    [self.backButton setDepth:2.0];
    [self.backButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.backButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];

    [self.nextButton setRadius:0.0];
    [self.nextButton setDepth:2.0];
    [self.nextButton setFaceColor:[UIColor colorWithHexString:@"bcd756"]];
    [self.nextButton setSideColor:[UIColor colorWithHexString:@"8faa2b"]];
    [self.nextButton.titleLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];

    self.currentStep = @(1);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([self.currentStep integerValue] == 4) {
        self.currentStep = @(3);
        self.title = @"Step 3: Enter Date";
        [self.navigationController setSGProgressPercentage:[self.currentStep floatValue]*(100/6)];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setSGProgressPercentage:0];
}

- (IBAction)next:(id)sender {
    switch ([self.currentStep integerValue]) {
        case 1:
            [self changeImage:nil];
            break;
        case 2:
            [self crop];
            break;
        case 3:
            [self setDate];
            break;

        default:
            [self importAddresses];
            break;
    }
    [self.navigationController setSGProgressPercentage:[self.currentStep floatValue]*(100/6)];

    self.currentStep = [NSNumber numberWithInt:[self.currentStep intValue]+1];
}

-(void)crop{
    [self.nextButton setTitle:@"Set Date" forState:UIControlStateNormal];
    self.imageScrollView.userInteractionEnabled = NO;
    self.dateField.hidden = NO;
    self.dateField.enabled = YES;

    self.colorToolbar.hidden = NO;
    self.colorToolbar.userInteractionEnabled = YES;
    [self.dateField becomeFirstResponder];
    self.title = @"Step 3: Enter Date";
}

-(void)setDate{
    self.dateField.enabled = NO;
    self.title = @"Step 4: Add Guests";
    [self importAddresses];
}

-(void)importAddresses{
    CLTImportAddressesViewController * importViewController = [[CLTImportAddressesViewController alloc] init];
    [self.navigationController pushViewController:importViewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self importAddresses];
    return YES;
}

- (IBAction)back:(id)sender {
    self.backButton.hidden = [self.currentStep integerValue] > 1 ?  NO : YES;
    switch ([self.currentStep integerValue]) {
        case 2:{
            self.title = @"Step 1: Choose a Picture";
            [self.nextButton setTitle:@"Pick Image" forState:UIControlStateNormal];
            self.imageScrollView.userInteractionEnabled = NO;
        }
            break;
        case 3:{
            self.dateField.hidden = YES;
            self.title = @"Step 2: Crop the Image";
            [self.nextButton setTitle:@"Crop" forState:UIControlStateNormal];
            self.dateField.hidden = YES;
            self.dateField.enabled = NO;
            self.imageScrollView.userInteractionEnabled = YES;
            self.colorToolbar.hidden = YES;
            self.colorToolbar.userInteractionEnabled = NO;
            [self.dateField resignFirstResponder];
        }
            break;

        case 4:{
            self.title = @"Step 3: Enter Date";
            self.dateField.hidden = NO;
            self.dateField.enabled = YES;
            self.colorToolbar.hidden = NO;
            self.colorToolbar.userInteractionEnabled = YES;
            [self.dateField becomeFirstResponder];
        }
            break;
    }
    self.currentStep = @([self.currentStep integerValue] - 1);
    [self.navigationController setSGProgressPercentage:([self.currentStep floatValue] - 1.0)*(100/6)];
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
//    [self presentViewController:activityViewController animated:YES completion:nil];
    self.fullScaleImage = self.fullScaleImage ? self.fullScaleImage : image;
    if (self.fullScaleImage.size.width > self.fullScaleImage.size.height) {
        self.fullScaleImage = [self.fullScaleImage imageRotatedByDegrees:90];
    }
    self.fullScaleImage = [self.fullScaleImage imageScaledToWidth:288];

    //Create the pdf document reference
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(nil);

    //Create the pdf context
    CGRect pageRect = CGRectMake(0, 0, 288, 432);
    CFMutableDataRef mutableData = CFDataCreateMutable(NULL, 0);

    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData(mutableData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, &pageRect, NULL);


    CGPDFContextBeginPage(pdfContext, NULL);
    CGContextDrawImage(pdfContext, CGRectMake(0, 0, self.fullScaleImage.size.width, self.fullScaleImage.size.height), self.fullScaleImage.CGImage);
    CGPDFContextEndPage(pdfContext);

    CGContextRelease(pdfContext); //Release before writing data to disk.

    //Write to disk
    NSError * error = nil;
    [(__bridge NSData *)mutableData writeToFile:[@"~/Documents/Front.pdf" stringByExpandingTildeInPath] options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"%@", error);
    }

    //Clean up
    CGDataConsumerRelease(dataConsumer);
    CGPDFDocumentRelease(document);
    CFRelease(mutableData);

    ReaderDocument * readerDocument = [[ReaderDocument alloc] initWithFilePath:[@"~/Documents/Front.pdf" stringByExpandingTildeInPath] password:nil];
    ReaderViewController * readerViewController = [[ReaderViewController alloc] initWithReaderDocument:readerDocument];
    readerViewController.delegate = self;
    [self presentViewController:readerViewController animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
//    self.dateField.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    self.dateField.userInteractionEnabled = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.dateField.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    self.dateField.userInteractionEnabled = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.coupleImageView;
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
    self.title = @"Step 2: Crop the Image";
    [self dismissViewControllerAnimated:YES completion:nil];

    NSString * photoUrl = nil;

    BOOL isNewlyTaken = (info[UIImagePickerControllerReferenceURL] == nil);

    if (isNewlyTaken){
//        UIImage *image = info[UIImagePickerControllerOriginalImage];
    }
    [self.coupleImageView setImage:info[UIImagePickerControllerOriginalImage]];
    self.fullScaleImage = info[UIImagePickerControllerOriginalImage];
    photoUrl =  [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];

    self.imageScrollView.userInteractionEnabled = YES;
    self.backButton.hidden = [self.currentStep integerValue] > 1 ?  NO : YES;
    [self.nextButton setTitle:@"Crop" forState:UIControlStateNormal];
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
