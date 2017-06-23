//
//  DZAdViewCell.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/23.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZAdViewCell.h"
#import "DZAdModel.h"

@interface DZAdViewCell ()

@property (nonatomic,strong) UILabel *lblTitle;

@property (nonatomic,strong) UILabel *lblDesc;

@end


@implementation DZAdViewCell

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblDesc];
    }
    return self;
}

- (void)setModel:(id)model {
    if ([model isKindOfClass:[DZAdModel class]]) {
        [super setModel:model];
        DZAdModel *dzModel = (DZAdModel *)model;
        _lblTitle.text = dzModel.carName;
//        _lblDesc.text = [NSString stringWithFormat:@"%ld",(long)dzModel.age];
    }
}

#pragma mark - lazy load

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 50, 50, 100, 30)];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.backgroundColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:14];
        _lblTitle.textColor = [UIColor blackColor];
    }
    return _lblTitle;
}

- (UILabel *)lblDesc {
    if (!_lblDesc) {
        _lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 50, 100, 100, 30)];
        _lblDesc.textAlignment = NSTextAlignmentCenter;
        _lblDesc.backgroundColor = [UIColor whiteColor];
        _lblDesc.font = [UIFont systemFontOfSize:12];
        _lblDesc.textColor = [UIColor blackColor];
    }
    return _lblDesc;
}

@end
