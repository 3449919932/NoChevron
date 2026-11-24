// NoChevron — 独立插件：隐藏控制中心顶部的「拉手」(chevron)
// 目标：SpringBoard 的私有视图 CCUIHeaderPocketView 的子视图 _headerChevronView
// 与 ControlCenter18 无耦合：CC18 只负责把它摆到 y=23 露出来，本插件负责把它隐藏

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// SpringBoard 私有类声明（没有头文件，按逆向结论声明即可）
@interface CCUIHeaderPocketView : UIView
@end

static void NoChevronHide(UIView *pocket) {
    if (![pocket isKindOfClass:[UIView class]]) return;

    UIView *chev = nil;
    @try {
        chev = [pocket valueForKey:@"_headerChevronView"];
    } @catch (__unused NSException *e) {
        chev = nil;
    }

    // 兜底：万一 KVC 拿不到，就按类名在子视图里找
    if (![chev isKindOfClass:[UIView class]]) {
        for (UIView *v in pocket.subviews) {
            if ([NSStringFromClass([v class]).lowercaseString containsString:@"chevron"]) {
                chev = v;
                break;
            }
        }
    }

    if ([chev isKindOfClass:[UIView class]]) {
        chev.hidden = YES;
        chev.alpha = 0.0f;
    }
}

%hook CCUIHeaderPocketView

- (void)layoutSubviews {
    %orig;
    // CC18 的 hook 也在这个方法里（它把 chevron 挪到 y=23）；
    // 我们的 %orig 返回后代表整条 hook 链都跑完了，此时隐藏最稳。
    NoChevronHide(self);
}

- (void)didMoveToWindow {
    %orig;
    NoChevronHide(self);
}

%end
