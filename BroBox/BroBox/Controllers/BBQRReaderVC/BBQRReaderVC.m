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

@end

@implementation BBQRReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = NSLocalizedString(@"Scan QR code", @"");
    [self.scanButton setTitle:title forState:UIControlStateNormal];
    
    self.textLabel.text = nil;
}

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
