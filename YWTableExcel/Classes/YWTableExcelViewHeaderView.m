//
//  YWTableExcelViewHeaderView.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/12.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWTableExcelViewHeaderView.h"
#import "YWTableExcelViewMode.h"
#import "UIView+Layout.h"
#import "YWTableExcelCell.h"
#import "YWTableExcelViewColl.h"




@interface YWTableExcelViewHeaderView ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    YWExcelCellConfig *_config;
    NSArray *_slideColumn;
    NSArray *_fixedColumn;
    BOOL _isAllowedNotification;
    CGFloat _lastOffX;
}
@property (nonatomic, strong,readwrite) UICollectionView *collectionView;
@end


@implementation YWTableExcelViewHeaderView

- (void)reloadDataFixed:(NSArray<YWColumnMode *> *)fixedColumn slide:(NSArray<YWColumnMode *> *)slideColumn{
    _slideColumn = slideColumn;
    _fixedColumn = fixedColumn;
    [_collectionView reloadData];
    for (int i = 0 ; i < _fixedColumn.count; i ++) {
        YWColumnMode *columnModel = fixedColumn[i];
        if (_config.columnStyle == YWTableExcelViewColumnStyleText) {
            UILabel *label = [self viewWithTag:100 + i];
            label.text = columnModel.text;
        }else{
            UIButton *btn = [self viewWithTag:100 + i];
            [btn setTitle:columnModel.text forState:UIControlStateNormal];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _slideColumn.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWTableExcelViewColl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defalutHeadCell" forIndexPath:indexPath];
    if (indexPath.row < _slideColumn.count) {
        YWColumnMode *columnModel = _slideColumn[indexPath.row];
        cell.menuLabel.text = columnModel.text;

    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;//
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_isAllowedNotification) {//是自身才发通知去tableView以及其他的cell
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:_config.notifiKey object:self userInfo:@{YW_EXCEL_NOTIFI_KEY:@(scrollView.contentOffset.x)}];
    }
    _isAllowedNotification = NO;
}

- (void)setContentOffset:(CGPoint)point{
    [_collectionView setContentOffset:point animated:NO];
}

- (void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[YW_EXCEL_NOTIFI_KEY] floatValue];
    
    if (obj != self) {
        _isAllowedNotification = YES;
        if (_lastOffX != x) {
            [_collectionView setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        _lastOffX = x;
    }else{
        _isAllowedNotification = NO;
    }
    obj = nil;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                                  fixed:(NSArray <YWColumnMode *>*)fixedColumn
                                  slide:(NSArray <YWColumnMode *>*)slideColumn
                             cellConfig:(YWExcelCellConfig *)config{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _config = config;
        _slideColumn = slideColumn;
        _fixedColumn = fixedColumn;
        [self prepareInitFixed:fixedColumn slide:slideColumn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_config.notifiKey object:nil];
    }
    return self;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier cellConfig:(YWExcelCellConfig *)config{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _config = config;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_config.notifiKey object:nil];
    }
    return self;
}
- (void)setupViewWithFixed:(NSArray<YWColumnMode *> *)fixedColumn slide:(NSArray<YWColumnMode *> *)slideColumn{
    _slideColumn = slideColumn;
    _fixedColumn = fixedColumn;
    [self prepareInitFixed:fixedColumn slide:slideColumn];
}

- (void)prepareInitFixed:(NSArray <YWColumnMode *>*)fixedColumnList slide:(NSArray <YWColumnMode *>*)slideColumnList{
    
    UIView *currentLabel = nil;
    NSInteger index = 0;
    for (YWColumnMode *column in fixedColumnList) {
        UIView *titleLbl = nil;
        if (_config.columnStyle == YWTableExcelViewColumnStyleText) {
            UILabel *lbl = [UILabel new];
            lbl.text = column.text;
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.tag = 100 + index;
            titleLbl = lbl;
        }else{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            btn.mode = column;
            [btn setTitle:column.text forState:UIControlStateNormal];
            btn.tag = 100 + index;
            titleLbl = btn;
        }
        [self addSubview:titleLbl];
        if (currentLabel == nil) {
            [titleLbl addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
            [titleLbl addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
            [titleLbl addConstraint:NSLayoutAttributeWidth equalTo:nil offset:column.width];
            [titleLbl addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
        }else{
            [titleLbl addConstraint:NSLayoutAttributeLeft equalTo:currentLabel toAttribute:NSLayoutAttributeRight offset:0];
            [titleLbl addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
            [titleLbl addConstraint:NSLayoutAttributeWidth equalTo:nil offset:column.width];
            [titleLbl addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
        }
        currentLabel = titleLbl;
        index += 1;
    }
    if (slideColumnList.count > 0) {
        YWColumnMode *column = slideColumnList.firstObject;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(column.width, 40);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[YWTableExcelViewColl class] forCellWithReuseIdentifier:@"defalutHeadCell"];
        [self addSubview:_collectionView];
        if (currentLabel == nil) {
            [_collectionView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
        }else{
            [_collectionView addConstraint:NSLayoutAttributeLeft equalTo:currentLabel toAttribute:NSLayoutAttributeRight offset:0];
        }
        [_collectionView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
        [_collectionView addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
        [_collectionView addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_config.notifiKey object:nil];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
