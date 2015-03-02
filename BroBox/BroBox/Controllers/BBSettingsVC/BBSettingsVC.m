//
//  BBSettingsVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBSettingsVC.h"

// Managers
#import "AppDelegate.h"
#import "BBPaypalManager.h"
#import "BBLoginManager.h"

typedef NS_ENUM(NSInteger, BBSettingsSection) {
    BBSettingsSectionPayPal,
    BBSettingsSectionDisconnect
};

@interface BBSettingsVC () <UITableViewDataSource, UITableViewDelegate, BBPayPalManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBSettingsVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"");
    
    [self initializeTableView];
}

#pragma mark - Initialization

- (void)initializeTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBSettingsSectionDisconnect + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case BBSettingsSectionPayPal:
            return 1;
            
        case BBSettingsSectionDisconnect:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BBSettingsSectionPayPal:
            return [self tableView:tableView paypalCellForRowAtIndexPath:indexPath];
            
        case BBSettingsSectionDisconnect:
            return [self tableView:tableView disconnectCellForRowAtIndexPath:indexPath];
            
        default:
            return nil;
    }
}

#define PAYPAL_CELL_IDENTIFIER @"paypalCell"

- (UITableViewCell *)tableView:(UITableView *)tableView paypalCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYPAL_CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PAYPAL_CELL_IDENTIFIER];
    }
    
    if ([BBPaypalManager hasConsentForFuturePayement]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@@brobox.com", [BBParseUser currentUser].firstName.lowercaseString];
        cell.textLabel.textColor = [UIColor colorWithRed:0.00f green:0.18f blue:0.53f alpha:1.00f];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Connect PayPal account...", @"");
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"paypal.png"];
    
    return cell;
}

#define DISCONNECT_CELL_IDENTIFIER @"disconnectCell"

- (UITableViewCell *)tableView:(UITableView *)tableView disconnectCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCONNECT_CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DISCONNECT_CELL_IDENTIFIER];
    }
    
    cell.textLabel.text = NSLocalizedString(@"Disconnect", @"");
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case BBSettingsSectionPayPal:
            return NSLocalizedString(@"PayPal", @"");
            
        case BBSettingsSectionDisconnect:
            return NSLocalizedString(@"BroBox account", @"");
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            
        default:
            return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case BBSettingsSectionPayPal: {
            if (![BBPaypalManager hasConsentForFuturePayement]) {
                [BBPaypalManager obtainConsentFromViewController:self];
            }
            break;
        }
            
        case BBSettingsSectionDisconnect: {
            [BBLoginManager logout];
            [AppDelegate presentLoginScreen];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - BBPayPalManagerDelegate

- (void)futurePaymentAuthorizationDidCancel {
    
}

- (void)futurePaymentAuthorizationDidSucced:(NSDictionary *)futurePaymentAuthorization {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:BBSettingsSectionPayPal];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

@end
