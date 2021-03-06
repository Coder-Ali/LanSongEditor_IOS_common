//
//  LSOFullWidthSwitchsView.h
//  LanSongEditor_all
//
//  Created by sno on 2019/3/7.
//  Copyright © 2019 sno. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "LanSongUtils.h"

NS_ASSUME_NONNULL_BEGIN


@protocol LSOFullWidthSwitchsViewDelegate <NSObject>

- (void)LSOFullWidthSwitchsViewSelected:(int)index isOn:(BOOL)isOn;
@end

/**
 宽度等于view的宽度view
 */
@interface LSOFullWidthSwitchsView : UIScrollView

- (void)configureView:(NSArray *)array width:(CGFloat)width;

@property (nonatomic, weak) id <LSOFullWidthSwitchsViewDelegate> delegateObj;
@property (nonnull,readonly)NSMutableArray *uiswitchArray;


@end

NS_ASSUME_NONNULL_END
