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

@interface BBQRReaderVC () <QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation BBQRReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = NSLocalizedString(@"Scan QR code", @"");
    [self.scanButton setTitle:title forState:UIControlStateNormal];
    
    self.commentLabel.text = NSLocalizedString(@"Click on the button below to scan the QR code on your carrier watch", @"");
    
    self.textLabel.text = nil;
}

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
    self.textLabel.text = result;
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
