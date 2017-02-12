

#import <UIKit/UIKit.h>


typedef enum {
    ZBTopicTypeAll = 1,
    ZBTopicTypePicture = 10,
    ZBTopicTypeWord = 29,
    ZBTopicTypeVoice = 31,
    ZBTopicTypeVideo = 41
} ZBTopicType;

/** 精华—顶部标题的高度*/
UIKIT_EXTERN CGFloat const ZBTitlesViewX;
/** 精华—顶部标题的Y*/
UIKIT_EXTERN CGFloat const ZBTitlesViewY;

/** 精华—cell的间距*/
UIKIT_EXTERN CGFloat const ZBTopicCellMargin;
/** 精华—cell文字内容的Y*/
UIKIT_EXTERN CGFloat const ZBTopicCellTextY;
/** 精华—cell底部工具条的高度*/
UIKIT_EXTERN CGFloat const ZBTopicCellBottomBarH;

/** 精华—cell图片帖子的最大高度*/
UIKIT_EXTERN CGFloat const ZBTopicCellPictureMaxH;
/** 精华—cell图片帖子一旦超过最大高度,就是用Break*/
UIKIT_EXTERN CGFloat const ZBTopicCellPictureBreakH;

/** ZBUser模型-性别属性值 */
UIKIT_EXTERN NSString * const ZBUserSexMale;
UIKIT_EXTERN NSString * const ZBUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const ZBTopicCellTopCmtTitleH;

/** tabbar被选中的通知的名字 */
UIKIT_EXTERN NSString * const ZBTabBarDidSelectNOtification;
/** tabbar被选中的通知 -  被选中的控制器的index key*/
UIKIT_EXTERN NSString * const ZBSelectedControllerIndexKey;
/** tabbar被选中的通知 -  被选中的控制器的key*/
UIKIT_EXTERN NSString * const ZBSelectedControllerKey;


/** 标签间距 */
UIKIT_EXTERN CGFloat const ZBTagMargin;
/** 标签高度*/
UIKIT_EXTERN CGFloat const ZBTagH;


