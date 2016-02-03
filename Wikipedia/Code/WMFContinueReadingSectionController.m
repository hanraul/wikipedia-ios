
#import "WMFContinueReadingSectionController.h"
#import "WMFContinueReadingTableViewCell.h"
#import "UIView+WMFDefaultNib.h"
#import "MWKTitle.h"
#import "MWKDataStore.h"
#import "MWKArticle.h"
#import "NSString+WMFExtras.h"
#import "UITableViewCell+WMFLayout.h"
#import "MWKSection.h"
#import "MWKSectionList.h"
#import "WMFArticleBrowserViewController.h"

static NSString* const WMFContinueReadingSectionIdentifier = @"WMFContinueReadingSectionIdentifier";

@interface WMFContinueReadingSectionController ()

@property (nonatomic, strong, readwrite) MWKTitle* title;

@end

@implementation WMFContinueReadingSectionController

- (instancetype)initWithArticleTitle:(MWKTitle*)title
                           dataStore:(MWKDataStore*)dataStore {
    NSParameterAssert(title);
    self = [super initWithDataStore:dataStore items:@[title]];
    if (self) {
        self.title     = title;
    }
    return self;
}

#pragma mark - WMFBaseExploreSectionController

- (id)sectionIdentifier {
    return WMFContinueReadingSectionIdentifier;
}

- (UIImage*)headerIcon {
    return [UIImage imageNamed:@"home-continue-reading-mini"];
}

- (NSAttributedString*)headerText {
    return [[NSAttributedString alloc] initWithString:MWLocalizedString(@"home-continue-reading-heading", nil) attributes:@{NSForegroundColorAttributeName: [UIColor wmf_homeSectionHeaderTextColor]}];
}

- (NSString*)cellIdentifier {
    return [WMFContinueReadingTableViewCell wmf_nibName];
}

- (UINib*)cellNib {
    return [WMFContinueReadingTableViewCell wmf_classNib];
}

- (NSUInteger)numberOfPlaceholderCells {
    return 0;
}

- (void)configureCell:(WMFContinueReadingTableViewCell*)cell withItem:(MWKTitle*)item atIndexPath:(NSIndexPath*)indexPath {
    cell.title.text   = item.text;
    cell.summary.text = [self summaryForTitle:item];
    [cell wmf_layoutIfNeededIfOperatingSystemVersionLessThan9_0_0];
}

- (CGFloat)estimatedRowHeight {
    return [WMFContinueReadingTableViewCell estimatedRowHeight];
}

- (NSString*)analyticsName {
    return @"Continue Reading";
}

- (UIViewController*)detailViewControllerForItemAtIndexPath:(NSIndexPath*)indexPath {
    MWKTitle* title              = [self titleForItemAtIndexPath:indexPath];
    UINavigationController* vc = [WMFArticleBrowserViewController embeddedBrowserViewControllerWithDataStore:[self dataStore] articleTitle:title restoreScrollPosition:YES source:self];
    return vc;
}

#pragma mark - WMFTitleProviding

- (nullable MWKTitle*)titleForItemAtIndexPath:(NSIndexPath*)indexPath {
    return self.title;
}

#pragma mark - Utility

- (NSString*)summaryForTitle:(MWKTitle*)title {
    MWKArticle* cachedArticle = [self.dataStore existingArticleWithTitle:self.title];
    if (cachedArticle.entityDescription.length) {
        return [cachedArticle.entityDescription wmf_stringByCapitalizingFirstCharacter];
    } else {
        return [[cachedArticle.sections firstNonEmptySection] summary];
    }
}

@end
