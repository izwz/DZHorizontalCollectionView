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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapped{
    NSLog(@"%@",self.model.name);
}

- (void)setModel:(DZBannerModel *)model {
    if ([model isKindOfClass:[DZBannerModel class]]) {
        _model = model;
        _lblTitle.text = model.name;
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
