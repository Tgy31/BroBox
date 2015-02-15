//
//  BBTableViewCell.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBTableViewCell.h"

@implementation BBTableViewCell

+ (NSString *)reusableIdentifier {
    return nil;
}

+ (void)registerToTableView:(UITableView *)tableView {
}

+ (CGFloat)preferedHeight {
    return 44.0;
}

@end
