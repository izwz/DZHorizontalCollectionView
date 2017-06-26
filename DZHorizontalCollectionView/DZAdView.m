//
//  DZAdView.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/23.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZAdView.h"
#import "DZAdModel.h"

@interface DZAdView ()

@property (nonatomic,strong) UILabel *lblTitle;

@end


@implementation DZAdView

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lblTitle];
    }
    return self;
}

- (void)setModel:(DZAdModel *)model {
    if ([model isKindOfClass:[DZAdModel class]]) {
        _model = model;
        _lblTitle.text = model.carName;
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
