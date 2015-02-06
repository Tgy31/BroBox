//
//  BBObject.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

@implementation BBObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
