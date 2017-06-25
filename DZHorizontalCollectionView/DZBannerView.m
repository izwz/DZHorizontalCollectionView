//
//  DZBannerView.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/23.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZBannerView.h"
#import "DZBannerModel.h"

@interface DZBannerView ()

@property (nonatomic,strong) UILabel *lblTitle;

@property (nonatomic,strong) UILabel *lblDesc;

@end

@implementation DZBannerView

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lblTitle];
    }
    return self;
}

- (void)setModel:(id)model {
    if ([model isKindOfClass:[DZBannerModel class]]) {
        DZBannerModel *dzModel = (DZBannerModel *)model;
        _lblTitle.text = dzModel.name;
    }
}

#pragma mark - lazy load

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 40, 45, 80, 30)];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.backgroundColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:14];
        _lblTitle.textColor = [UIColor blackColor];
    }
    return _lblTitle;
}


@end
