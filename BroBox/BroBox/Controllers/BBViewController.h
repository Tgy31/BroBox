//
//  BBViewController.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBViewController : UIViewController

@property (nonatomic) BOOL navigationBarShouldCoverViewController;


- (void)startLoading;
- (void)stopLoading;
- (void)showPlaceHolderWithtitle:(NSString *)title
                        subtitle:(NSString *)subtitle;
- (void)hidePlaceHolder;

- (BOOL)shouldShowDebugBarbutton;
- (void)debugButtonHandler;

- (void)setUpAppearance;

@end
