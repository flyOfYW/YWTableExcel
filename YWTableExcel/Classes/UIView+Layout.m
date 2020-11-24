//
//  UIView+Layout.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/13.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>


@implementation YWDrawLabel

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawStroke:rect
         strokeColor:self.borderColor
           fillColor:[UIColor clearColor]
           lineWidth:self.borderWidth];
}

@end

@implementation YWDrawButton
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawStroke:rect
         strokeColor:self.borderColor
           fillColor:[UIColor clearColor]
           lineWidth:self.borderWidth];
}

@end

@implementation UIView (Layout)

static char yw_columnMode_key;

- (YWColumnMode *)mode{
    return objc_getAssociatedObject(self, &yw_columnMode_key);
}
- (void)setMode:(YWColumnMode *)mode{
    objc_setAssociatedObject(self, &yw_columnMode_key, mode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to
                                                               attribute:attribute
                                                              multiplier:1.0 constant:offset]];
}
- (void)addLayoutConstraint:(NSLayoutConstraint *)constraint{
    [self.superview addConstraint:constraint];
}
- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to toAttribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to
                                                               attribute:toAttribute
                                                              multiplier:1.0 constant:offset]];
}
- (void)removeAllAutoLayout{
    for (NSLayoutConstraint *con in self.constraints)
    {
        [self removeConstraint:con];
    }
}

- (void)removeAutoLayout:(NSLayoutConstraint *)constraint{
    for (NSLayoutConstraint *con in self.superview.constraints) {
        if ([con isEqual:constraint]) {
            [self.superview removeConstraint:con];
        }
    }
}
- (NSLayoutConstraint *)getAutoLayoutByIdentifier:(NSString *)identifier{
    NSLayoutConstraint *lay = nil;
    for (NSLayoutConstraint *con in self.constraints)
    {
        if ([con.identifier isEqualToString:identifier]) {
            lay = con;
            break;
        }
    }
    return lay;
}
@end

@implementation UIView (YW_Draw)

static char kHssociatedParamsLayerKey;

- (void)setYw_Layer:(CALayer *)yw_Layer{
    objc_setAssociatedObject(self, &kHssociatedParamsLayerKey, yw_Layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CALayer *)yw_Layer{
    return objc_getAssociatedObject(self, &kHssociatedParamsLayerKey);
}
- (void)drawStroke:(CGRect)rect
       strokeColor:(UIColor *)strokeColor
         fillColor:(UIColor *)fillColor
         lineWidth:(CGFloat)lineWidth{
    if (!self.yw_Layer && strokeColor && lineWidth != 0) {
        
        CGSize viewSize = self.frame.size;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        shapeLayer.fillColor = fillColor.CGColor;
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.lineWidth = lineWidth;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height)
                                                              cornerRadius:0];
        shapeLayer.path = bezierPath.CGPath;
        
        [self.layer insertSublayer:shapeLayer atIndex:0];
        self.yw_Layer = shapeLayer;
    }
}

@end

@implementation NSIndexPath (Colunmn)

static char yw_indexPath_column_key;

- (NSInteger)colunmn{
    return [objc_getAssociatedObject(self, &yw_indexPath_column_key) integerValue];
}
- (void)setColunmn:(NSInteger)colunmn{
    objc_setAssociatedObject(self, &yw_indexPath_column_key, @(colunmn), OBJC_ASSOCIATION_ASSIGN);
}
@end
