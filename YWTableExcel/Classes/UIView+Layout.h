//
//  UIView+Layout.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/13.
//  Copyright © 2019 flyOfYW. All rights reserved.
//


#import <UIKit/UIKit.h>

@class YWColumnMode;


NS_ASSUME_NONNULL_BEGIN

@interface UIView (Layout)

@property (nonatomic, strong) YWColumnMode * mode;


- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(nullable UIView *)to offset:(CGFloat)offset;
- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(nullable UIView *)to toAttribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset;
@end


@interface NSIndexPath (Colunmn)
@property (nonatomic, assign) NSInteger colunmn;

@end
NS_ASSUME_NONNULL_END
