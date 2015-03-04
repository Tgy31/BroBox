//
//  BBQRReaderVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBQRReaderVC.h"

// Frameworks
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BBQRReaderVC () <QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation BBQRReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = NSLocalizedString(@"Scan QR code", @"");
    [self.scanButton setTitle:title forState:UIControlStateNormal];
    
    self.commentLabel.text = NSLocalizedString(@"Click on the button below to scan the QR code on your carrier watch", @"");
    
    self.profilePictureView.hidden = YES;
    
    self.profileLabel.hidden = YES;
    self.profileLabel.textColor = [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f];
}

- (void)viewWillLayoutSubviews {
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width/2.0;
}

#pragma mark - Getters & Setters

#pragma mark - Appearance

- (void)setUpAppearance {
    self.scanButton.backgroundColor = [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f];
    [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.scanButton.layer.cornerRadius = 5.0;
}

#pragma mark - Handlers

- (void)presentQRReader {
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle      = UIModalPresentationFormSheet;
    
    // Using delegate methods
    reader.delegate                    = self;
    
    [self presentViewController:reader animated:YES completion:NULL];
}

- (IBAction)scanButtonHandler:(id)sender {
    [self presentQRReader];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    if ([result isEqualToString:self.mission.pebbleAuthToken]) {
        [self handleSuccess];
    } else {
        [self handleFail];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handleSuccess {
    self.imageView.hidden = YES;
    self.scanButton.hidden = YES;
    self.commentLabel.text = NSLocalizedString(@"Carrier certified", @"");
    
    self.profilePictureView.hidden = NO;
    self.profilePictureView.profileID = self.mission.carrier.facebookID;
    
    self.profileLabel.hidden = NO;
    self.profileLabel.text = [self.mission.carrier fullName];
}

- (void)handleFail {
    self.imageView.image = [UIImage imageNamed:@"error.png"];
    self.commentLabel.text = NSLocalizedString(@"Failed to identify your carrier code", @"");
}

@end
