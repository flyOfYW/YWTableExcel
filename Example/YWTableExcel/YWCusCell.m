//
//  YWCusCell.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2020/11/23.
//  Copyright © 2020 flyOfYW. All rights reserved.
//

#import "YWCusCell.h"

@implementation YWCusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier fixed:(NSArray<YWColumnMode *> *)fixedColumn slide:(NSArray<YWColumnMode *> *)slideColumn cellConfig:(YWExcelCellConfig *)config{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier fixed:fixedColumn slide:slideColumn cellConfig:config];
    if (self) {
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    }
    return self;
}
@end
