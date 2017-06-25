//
//  DZHorizontalCollectionView.h
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DZHorizontalCollectionViewStyle) {
    DZHorizontalCollectionViewStyleDefault,// 普通样式
    DZHorizontalCollectionViewStyleCoverflow,//coverflow
};

@interface DZHorizontalCollectionView : UIView

@property (nonatomic,assign) DZHorizontalCollectionViewStyle style;

@property (nonatomic,assign,getter = isInfinite) BOOL infinite;

@property (nonatomic,assign) NSUInteger currentIndex; /**< 当前所在的index */

@property (nonatomic,assign) CGFloat    margin;     /**< 左右边缘大小 */
@property (nonatomic,assign) CGFloat    spacing;    /**< cell间隔大小 */
@property (nonatomic,assign) CGFloat    itemWidth;  /**< cell大小 */

- (instancetype)initWithFrame:(CGRect)frame customCell:(Class)cell;

- (void)reloadData:(NSArray *)data;

@end
