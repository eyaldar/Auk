//
// An image slideshow for iOS written in Swift.
//
// https://github.com/evgenyneu/Auk
//
// This file was automatically generated by combining multiple Swift source files.
//


// ----------------------------
//
// Auk.swift
//
// ----------------------------

import UIKit

/**

Shows images in the scroll view with page indicator.
Auk extends UIScrollView class by creating the auk property that you can use for showing images.

Usage:

    // Show remote image
    scrollView.auk.show(url: "http://site.com/bird.jpg")

    // Show local image
    if let image = UIImage(named: "bird.jpg") {
      scrollView.auk.show(image: image)
    }

*/
public class Auk {
  
  // ---------------------------------
  //
  // MARK: - Public interface
  //
  // ---------------------------------
  
  /**
  
  Settings that control appearance of the images and page indicator.
  
  */
  public var settings = AukSettings()
  
  /**
  
  Shows a local image in the scroll view.
  
  :param: image: Image to be shown in the scroll view.
  
  */
  public func show(#image: UIImage) {
    setup()
    let page = createPage()
    page.show(image: image, settings: settings)
  }
  
  /**
  
  Downloads a remote image and adds it to the scroll view. Use `Moa.settings.cache` property to configure image caching.
  
  :param: url: Url of the image to be shown.
  
  */
  public func show(#url: String) {
    setup()
    let page = createPage()
    page.show(url: url, settings: settings)
    
    if let scrollView = scrollView {
      AukPageVisibility.tellPagesAboutTheirVisibility(scrollView, settings: settings)
    }
  }
  
  /**
  
  Changes the current page.
  
  :param: pageIndex: Index of the page to show.
  :param: animated: The page change will be animated when `true`.
  
  */
  public func scrollTo(pageIndex: Int, animated: Bool) {
    if let scrollView = scrollView {
      AukScrollTo.scrollTo(scrollView, pageIndex: pageIndex, animated: animated,
        numberOfPages: numberOfPages)
    }
  }
  
  /**
  
  Changes both the current page and the page width.
  
  This function can be used for animating the scroll view content during orientation change. It is called in viewWillTransitionToSize and inside animateAlongsideTransition animation block.
  
      override func viewWillTransitionToSize(size: CGSize,
      withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
          let pageIndex = scrollView.auk.pageIndex
          
          coordinator.animateAlongsideTransition({ [weak self] _ in
          self?.scrollView.auk.changePage(pageIndex, pageWidth: size.width, animated: false)
        }, completion: nil)
      }
  
  More information: https://github.com/evgenyneu/Auk/wiki/Size-animation
  
  :param: toPageIndex: Index of the page that will be made a current page.
  :param: pageWidth: The new page width.
  :param: animated: The page change will be animated when `true`.
  
  */
  public func scrollTo(pageIndex: Int, pageWidth: CGFloat, animated: Bool) {
    if let scrollView = scrollView {
      AukScrollTo.scrollTo(scrollView, pageIndex: pageIndex, pageWidth: pageWidth,
        animated: animated, numberOfPages: numberOfPages)
    }
  }
  
  /**
  
  Scrolls to the next page.
  
  */
  public func scrollToNextPage() {
    scrollToNextPage(cycle: true, animated: true)
  }
  
  /**
  
  Scrolls to the next page.
  
  :param: cycle: If `true` it scrolls to the first page from the last one. If `false` the scrolling stops at the last page.
  :param: animated: The page change will be animated when `true`.
  
  */
  public func scrollToNextPage(#cycle: Bool, animated: Bool) {
    if let scrollView = scrollView {
      AukScrollTo.scrollToNextPage(scrollView, cycle: cycle, animated: animated,
        currentPageIndex: currentPageIndex, numberOfPages: numberOfPages)
    }
  }
  
  /**
  
  Scrolls to the previous page.
  
  */
  public func scrollToPreviousPage() {
    scrollToPreviousPage(cycle: true, animated: true)
  }
  
  /**
  
  Scrolls to the previous page.
  
  :param: cycle: If true it scrolls to the last page from the first one. If false the scrolling stops at the first page.
  :param: animated: The page change will be animated when `true`.
  
  */
  public func scrollToPreviousPage(#cycle: Bool, animated: Bool) {
    if let scrollView = scrollView {
      AukScrollTo.scrollToPreviousPage(scrollView, cycle: cycle, animated: animated,
        currentPageIndex: currentPageIndex, numberOfPages: numberOfPages)
    }
  }
  
  /**
  
  Removes all images from the scroll view.
  
  */
  public func removeAll() {
    if let scrollView = scrollView {
      let pages = AukScrollViewContent.aukPages(scrollView)
      
      for page in pages {
        page.removeFromSuperview()
      }
    }
    
    pageIndicatorContainer?.updateNumberOfPages(numberOfPages)
    pageIndicatorContainer?.updateCurrentPage(currentPageIndex)
  }
  
  /// Returns the current number of pages.
  public var numberOfPages: Int {
    if let scrollView = scrollView {
      return AukScrollViewContent.aukPages(scrollView).count
    }
    
    return 0
  }
  
  /**
  
  Returns the current page index. If pages are being scrolled and there are two of them on screen the page index will indicate the page that occupies bigger portion of the screen at the moment.
  
  */
  public var currentPageIndex: Int {
    if let scrollView = scrollView {
      let width = Double(scrollView.bounds.size.width)
      let offset = Double(scrollView.contentOffset.x)
      
      return Int(round(offset / width))
    }
    
    return 0
  }
  
  /**
  
  Starts auto scrolling of the pages with the given delay in seconds.
  
  :param: delaySeconds: Amount of time in second each page is visible before scrolling to the next.
  
  */
  public func startAutoScroll(#delaySeconds: Double) {
    startAutoScroll(delaySeconds: delaySeconds, forward: true,
      cycle: true, animated: true)
  }
  
  /**
  
  Starts auto scrolling of the pages with the given delay in seconds.
  
  :param: delaySeconds: Amount of time in second each page is visible before scrolling to the next.
  :param: forward: When true the scrolling is done from left to right direction.
  :param: cycle: If true it scrolls to the first page from the last one. If false the scrolling stops at the last page.
  :param: animated: The page change will be animated when `true`.
  
  */
  public func startAutoScroll(#delaySeconds: Double, forward: Bool,
    cycle: Bool, animated: Bool) {
      
    if let scrollView = scrollView {
      autoscroll.startAutoScroll(scrollView, delaySeconds: delaySeconds,
        forward: forward, cycle: cycle, animated: animated, auk: self)
    }
  }
  
  /**
  
  Stops auto scrolling of the pages.
  
  */
  public func stopAutoScroll() {
    autoscroll.stopAutoScroll()
  }
  
  // ---------------------------------
  //
  // MARK: - Internal functionality
  //
  // ---------------------------------
  
  var scrollViewDelegate = AukScrollViewDelegate()
  var pageIndicatorContainer: AukPageIndicatorContainer?
  var autoscroll = AukAutoscroll()
  private weak var scrollView: UIScrollView?
  
  init(scrollView: UIScrollView) {
    self.scrollView = scrollView
    
    scrollViewDelegate.onScroll = { [weak self] in
      self?.onScroll()
    }
    
    scrollViewDelegate.onScrollByUser = { [weak self] in
      self?.stopAutoScroll()
    }
    
    scrollViewDelegate.delegate = scrollView.delegate
    scrollView.delegate = scrollViewDelegate
  }
  
  func setup() {
    createPageIdicator()
    scrollView?.showsHorizontalScrollIndicator = settings.showsHorizontalScrollIndicator
    scrollView?.pagingEnabled = settings.pagingEnabled
  }
  
  /// Create a page, add it to the scroll view content and layout.
  private func createPage() -> AukPage {
    let page = AukPage()
    
    if let scrollView = scrollView {
      scrollView.addSubview(page)
      AukScrollViewContent.layout(scrollView)
    }
    
    pageIndicatorContainer?.updateNumberOfPages(numberOfPages)
    
    return page
  }
  
  func onScroll() {
    if let scrollView = scrollView {
      AukPageVisibility.tellPagesAboutTheirVisibility(scrollView, settings: settings)
      pageIndicatorContainer?.updateCurrentPage(currentPageIndex)
    }
  }
  
  private func createPageIdicator() {
    if !settings.pageControl.visible { return }
    if pageIndicatorContainer != nil { return } // Already created a page indicator container 
    
    if let scrollView = scrollView,
      superview = scrollView.superview {
        
      let container = AukPageIndicatorContainer()
      superview.addSubview(container)
      pageIndicatorContainer = container
      container.setup(settings, scrollView: scrollView)
    }
  }
}


// ----------------------------
//
// AukAutoscroll.swift
//
// ----------------------------

import UIKit

/**

Starts and cancels the auto scrolling.

*/
struct AukAutoscroll {
  var autoscrollTimer: AutoCancellingTimer?
  
  mutating func startAutoScroll(scrollView: UIScrollView, delaySeconds: Double,
    forward: Bool, cycle: Bool, animated: Bool, auk: Auk) {
      
    // Assign the new instance of AutoCancellingTimer to autoscrollTimer
    // The previous instance deinitializes and cancels its timer.
      
    autoscrollTimer = AutoCancellingTimer(interval: delaySeconds, repeats: true) {
      if forward {
        AukScrollTo.scrollToNextPage(scrollView, cycle: cycle,
          animated: animated, currentPageIndex: auk.currentPageIndex,
          numberOfPages: auk.numberOfPages)
      } else {
        AukScrollTo.scrollToPreviousPage(scrollView, cycle: cycle,
          animated: animated, currentPageIndex: auk.currentPageIndex,
          numberOfPages: auk.numberOfPages)
      }
    }
  }
  
  mutating func stopAutoScroll() {
    autoscrollTimer = nil // Cancels the timer on deinit
  }
}


// ----------------------------
//
// AukPage.swift
//
// ----------------------------

import UIKit

/// The view for an individual page of the scroll view containing an image.
final class AukPage: UIView {
  
  // Image view for showing local image or a placeholder image
  weak var imageView: UIImageView?
  
  // Image view for showing the remote image
  weak var remoteImageView: UIImageView?
  
  // Contains a URL for the remote image, if any.
  var remoteImage: AukRemoteImage?
  
  /**
  
  Shows an image.
  
  :param: image: The image to be shown
  :param: settings: Auk settings.
  
  */
  func show(#image: UIImage, settings: AukSettings) {
    createAndLayoutImageView(settings)
    
    imageView?.image = image
  }
  
  /**
  
  Shows a remote image. The image download stars if/when the page becomes visible to the user.
  
  :param: url: The URL to the image to be displayed.
  :param: settings: Auk settings.
  
  */
  func show(#url: String, settings: AukSettings) {
    createAndLayoutImageView(settings)
    createAndLayoutRemoteImageView(settings)
    
    if let remoteImageView = remoteImageView {
      remoteImage = AukRemoteImage()
      remoteImage?.setup(url, imageView: remoteImageView, settings: settings)
    }
  }
  
  
  /**

  Called when the page is currently visible to user which triggers the image download. The function is called frequently each time scroll view's content offset is changed.
  
  */
  func visibleNow(settings: AukSettings) {
    remoteImage?.downloadImage(settings)
  }
  
  /**
  
  Called when the page is currently not visible to user which cancels the image download. The method called frequently each time scroll view's content offset is changed and the page is out of sight.
  
  */
  func outOfSightNow() {
    remoteImage?.cancelDownload()
  }
  
  /**
  
  Create and layout an image view.
  
  :param: settings: Auk settings.
  
  */
  func createAndLayoutImageView(settings: AukSettings) {
    if imageView != nil { return }
    
    clipsToBounds = true // Hide image if it is out of page bounds
    
    let newImageView = AukPage.createImageView(settings)
    addSubview(newImageView)
    imageView = newImageView
    
    AukPage.layoutImageView(newImageView, superview: self)
  }
  
  /**
  
  Create and layout the remote image view.
  
  :param: settings: Auk settings.
  
  */
  func createAndLayoutRemoteImageView(settings: AukSettings) {
    if remoteImageView != nil { return }
    
    let newImageView = AukPage.createImageView(settings)
    addSubview(newImageView)
    remoteImageView = newImageView
    
    AukPage.layoutImageView(newImageView, superview: self)
  }
  
  private static func createImageView(settings: AukSettings) -> UIImageView {
    let newImageView = UIImageView()
    newImageView.contentMode = settings.contentMode
    return newImageView
  }
  
  /**
  
  Creates Auto Layout constrains for the image view.
  
  :param: imageView: Image view that is used to create Auto Layout constraints.
  
  */
  private static func layoutImageView(imageView: UIImageView, superview: UIView) {
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    iiAutolayoutConstraints.fillParent(imageView, parentView: superview, margin: 0, vertically: false)
    iiAutolayoutConstraints.fillParent(imageView, parentView: superview, margin: 0, vertically: true)
  }
}


// ----------------------------
//
// AukPageIndicatorContainer.swift
//
// ----------------------------

import UIKit

/// View containing a UIPageControl object that shows the dots for present pages.
final class AukPageIndicatorContainer: UIView {
  var pageControl: UIPageControl? {
    get {
      if subviews.count == 0 { return nil }
      return subviews[0] as? UIPageControl
    }
  }
  
  // Layouts the view, creates and layouts the page control
  func setup(settings: AukSettings, scrollView: UIScrollView) {    
    styleContainer(settings)
    AukPageIndicatorContainer.layoutContainer(self, settings: settings, scrollView: scrollView)
    
    let pageControl = createPageControl(settings)
    AukPageIndicatorContainer.layoutPageControl(pageControl, superview: self, settings: settings)
    
    updateVisibility()
  }
  
  // Update the number of pages showing in the page control
  func updateNumberOfPages(numberOfPages: Int) {
    pageControl?.numberOfPages = numberOfPages
    updateVisibility()
  }
  
  // Update the current page in the page control
  func updateCurrentPage(currentPageIndex: Int) {
    pageControl?.currentPage = currentPageIndex
  }
  
  private func styleContainer(settings: AukSettings) {
    backgroundColor = settings.pageControl.backgroundColor
    layer.cornerRadius = CGFloat(settings.pageControl.cornerRadius)
  }
  
  private static func layoutContainer(pageIndicatorContainer: AukPageIndicatorContainer,
    settings: AukSettings, scrollView: UIScrollView) {
      
    if let superview = pageIndicatorContainer.superview {
      pageIndicatorContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        
      // Align bottom of the page view indicator with the bottom of the scroll view
      iiAutolayoutConstraints.alignSameAttributes(pageIndicatorContainer, toItem: scrollView,
        constraintContainer: superview, attribute: NSLayoutAttribute.Bottom,
        margin: CGFloat(-settings.pageControl.marginToScrollViewBottom))
      
      // Center the page view indicator horizontally in relation to the scroll view
      iiAutolayoutConstraints.alignSameAttributes(pageIndicatorContainer, toItem: scrollView,
        constraintContainer: superview, attribute: NSLayoutAttribute.CenterX, margin: 0)
    }
  }
  
  private func createPageControl(settings: AukSettings) -> UIPageControl {
    let pageControl = UIPageControl()
    
    pageControl.pageIndicatorTintColor = settings.pageControl.pageIndicatorTintColor
    pageControl.currentPageIndicatorTintColor = settings.pageControl.currentPageIndicatorTintColor

    addSubview(pageControl)
    return pageControl
  }
  
  private static func layoutPageControl(pageControl: UIPageControl, superview: UIView,
    settings: AukSettings) {
      
    pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    iiAutolayoutConstraints.fillParent(pageControl, parentView: superview,
      margin: settings.pageControl.innerPadding.width, vertically: false)
    
    iiAutolayoutConstraints.fillParent(pageControl, parentView: superview,
      margin: settings.pageControl.innerPadding.height, vertically: true)
  }
  
  private func updateVisibility() {
    self.hidden = pageControl?.numberOfPages < 2
  }
}


// ----------------------------
//
// AukPageVisibility.swift
//
// ----------------------------

import UIKit

/**

Helper functions that tell if the scroll view page is currently visible to the user.

*/
struct AukPageVisibility {
  /**
  
  Check if the given page is currently visible to user.
  
  :param: scrollView: Scroll view containing the page.
  :param: page: A scroll view page which visibility will be checked.
  
  :returns: True if the page is visible to the user.
  
  */
  static func isVisible(scrollView: UIScrollView, page: AukPage) -> Bool {
    return CGRectIntersectsRect(scrollView.bounds, page.frame)
  }
  
  /**
  
  Tells if the page is way out of sight. This is done to prevent cancelling download of the image for the page that is not very far out of sight.
  
  :param: scrollView: Scroll view containing the page.
  :param: page: A scroll view page which visibility will be checked.
  
  :returns: True if the page is visible to the user.
  
  */
  static func isFarOutOfSight(scrollView: UIScrollView, page: AukPage) -> Bool {
    let parentRectWithIncreasedHorizontalBounds = CGRectInset(scrollView.bounds, -50, 0)
    return !CGRectIntersectsRect(parentRectWithIncreasedHorizontalBounds, page.frame)
  }
  
  /**
  
  Goes through all the scroll view pages and tell them if they are visible or out of sight. The pages, in turn, if they are visible start the download of the image or cancel the download if they are out of sight.
  
  :param: scrollView: Scroll view with the pages.

  */
  static func tellPagesAboutTheirVisibility(scrollView: UIScrollView, settings: AukSettings) {
    let pages = AukScrollViewContent.aukPages(scrollView)

    for page in pages {
      if isVisible(scrollView, page: page) {
        page.visibleNow(settings)
      } else {
        /*
        
        Now, this is a bit nuanced so let me explain. When we scroll into a new page we sometimes see a little bit of the next page. The scroll view animation overshoots a little bit to show the next page and then slides back to the current page. This is probably done on purpose for more natural spring bouncing effect.
        
        When the scroll view overshoots and shows the next page, we call `isVisible` on it and it starts downloading its image. But because scroll view bounces back in a moment that page becomes invisible very soon. If we just call `outOfSightNow()` the next page download will be canceled even though it has just been started. That is probably not very efficient use of network, so we call `isFarOutOfSight` function to check if the next page is way out of sight (and not just a little bit). If the page is out of sight but just by a little margin we still let it download the image.
        
        */
        if isFarOutOfSight(scrollView, page: page) {
          page.outOfSightNow()
        }
      }
    }
  }
}


// ----------------------------
//
// AukRemoteImage.swift
//
// ----------------------------

import UIKit

/**

Downloads and shows a single remote image.

*/
class AukRemoteImage {
  var url: String?
  weak var imageView: UIImageView?
  
  init() { }
  
  /// True when image has been successfully downloaded
  var didFinishDownload = false
  
  func setup(url: String, imageView: UIImageView, settings: AukSettings) {
      
    self.url = url
    self.imageView = imageView
    
    setPlaceholderImage(settings)
  }
  
  /// Sends image download HTTP request.
  func downloadImage(settings: AukSettings) {
    if imageView?.moa.url != nil { return } // Download has already started
    if didFinishDownload { return } // Image has already been downloaded
    
    imageView?.moa.onSuccessAsync = { [weak self] image in
      self?.didReceiveImageAsync(image, settings: settings)
      return image
    }
    
    imageView?.moa.onErrorAsync = { [weak self] _, _ in
      self?.onDownloadErrorAsync(settings)
    }
    
    imageView?.moa.url = url
  }
  
  private func onDownloadErrorAsync(settings: AukSettings) {
    if let errorImage = settings.errorImage {
      iiQ.main { [weak self] in
        imageView?.image = errorImage
      }
      
      didReceiveImageAsync(errorImage, settings: settings)
    }
  }
  
  /// Cancel current image download HTTP request.
  func cancelDownload() {
    // Cancel current download by setting url to nil
    imageView?.moa.url = nil
  }
  
  func didReceiveImageAsync(image: UIImage, settings: AukSettings) {
    didFinishDownload = true
    
    iiQ.main { [weak self] in
      if let imageView = self?.imageView {
        AukRemoteImage.animateImageView(imageView, settings: settings)
      }
    }
  }
  
  private func setPlaceholderImage(settings: AukSettings) {
    if let placeholderImage = settings.placeholderImage,
      imageView = imageView {
        
      imageView.image = placeholderImage
      AukRemoteImage.animateImageView(imageView, settings: settings)
    }
  }
  
  private static func animateImageView(imageView: UIImageView, settings: AukSettings) {
    imageView.alpha = 0
    let interval = NSTimeInterval(settings.remoteImageAnimationIntervalSeconds)
    
    UIView.animateWithDuration(interval, animations: {
      imageView.alpha = 1
    })
  }
}


// ----------------------------
//
// AukScrollTo.swift
//
// ----------------------------

import UIKit

/**

Scrolling code.

*/
struct AukScrollTo {
  static func scrollTo(scrollView: UIScrollView, pageIndex: Int, animated: Bool,
    numberOfPages: Int) {
      
    let pageWidth = scrollView.bounds.size.width
    scrollTo(scrollView, pageIndex: pageIndex, pageWidth: pageWidth, animated: animated,
      numberOfPages: numberOfPages)
  }
  
  static func scrollTo(scrollView: UIScrollView, pageIndex: Int, pageWidth: CGFloat,
    animated: Bool, numberOfPages: Int) {
      
    let offsetX = CGFloat(pageIndex) * pageWidth
    var offset = CGPoint(x: offsetX, y: 0)
      
    let maxOffset = CGFloat(numberOfPages - 1) * pageWidth
      
    // Prevent overscrolling to the right
    if offset.x > maxOffset { offset.x = maxOffset }
      
    // Prevent overscrolling to the left
    if offset.x < 0 { offset.x = 0 }

    scrollView.setContentOffset(offset, animated: animated)
  }
  
  static func scrollToNextPage(scrollView: UIScrollView, cycle: Bool, animated: Bool,
    currentPageIndex: Int, numberOfPages: Int) {
      
    var pageIndex = currentPageIndex + 1
      
    if pageIndex >= numberOfPages {
      if cycle {
        pageIndex = 0
      } else {
        return
      }
    }
    
    scrollTo(scrollView, pageIndex: pageIndex, animated: animated, numberOfPages: numberOfPages)
  }
  
  static func scrollToPreviousPage(scrollView: UIScrollView, cycle: Bool, animated: Bool,
    currentPageIndex: Int, numberOfPages: Int) {
    
    var pageIndex = currentPageIndex - 1
      
    if pageIndex < 0 {
      if cycle {
        pageIndex = numberOfPages - 1
      } else {
        return
      }
    }
    
    scrollTo(scrollView, pageIndex: pageIndex, animated: animated, numberOfPages: numberOfPages)
  }
}


// ----------------------------
//
// AukScrollViewContent.swift
//
// ----------------------------

import UIKit

/**

Collection of static functions that help managing the scroll view content.

*/
struct AukScrollViewContent {
  
  /**

  :returns: Array of scroll view pages.
  
  */
  static func aukPages(scrollView: UIScrollView) -> [AukPage] {
    return scrollView.subviews.filter { $0 is AukPage }.map { $0 as! AukPage }
  }
  
  /**
  
  Creates Auto Layout constraints for positioning the page view inside the scroll view.
  
  */
  static func layout(scrollView: UIScrollView) {
    let pages = aukPages(scrollView)

    for (index, page) in enumerate(pages) {
      
      // Delete current constraints by removing the view and adding it back to its superview
      page.removeFromSuperview()
      scrollView.addSubview(page)
      
      page.setTranslatesAutoresizingMaskIntoConstraints(false)
      
      // Make page size equal to the scroll view size
      iiAutolayoutConstraints.equalSize(page, viewTwo: scrollView, constraintContainer: scrollView)
      
      // Stretch the page vertically to fill the height of the scroll view
      iiAutolayoutConstraints.fillParent(page, parentView: scrollView, margin: 0, vertically: true)
      
      if index == 0 {
        // Align the left edge of the first page to the left edge of the scroll view.
        iiAutolayoutConstraints.alignSameAttributes(page, toItem: scrollView,
          constraintContainer: scrollView, attribute: NSLayoutAttribute.Left, margin: 0)
      }
      
      if index == pages.count - 1 {
        // Align the right edge of the last page to the right edge of the scroll view.
        iiAutolayoutConstraints.alignSameAttributes(page, toItem: scrollView,
          constraintContainer: scrollView, attribute: NSLayoutAttribute.Right, margin: 0)
      }
    }
    
    // Align page next to each other
    iiAutolayoutConstraints.viewsNextToEachOther(pages, constraintContainer: scrollView,
      margin: 0, vertically: false)
    
    scrollView.layoutIfNeeded()
  }
}


// ----------------------------
//
// AukScrollViewDelegate.swift
//
// ----------------------------

import UIKit

/**

This delegate detects the scrolling event which is used for loading remote images when their superview becomes visible on screen.

*/
final class AukScrollViewDelegate: NSObject, UIScrollViewDelegate {
  /**
  
  If scroll view already has delegate it is preserved in this property and all the delegate calls are forwarded to it.
  
  */
  weak var delegate: UIScrollViewDelegate?
  
  var onScroll: (()->())?
  var onScrollByUser: (()->())?
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    onScroll?()
    delegate?.scrollViewDidScroll?(scrollView)
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView) {
    delegate?.scrollViewDidZoom?(scrollView)
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    delegate?.scrollViewWillBeginDragging?(scrollView)
    onScrollByUser?()
  }
  
  func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
  }
  
  func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    delegate?.scrollViewWillBeginDecelerating?(scrollView)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    delegate?.scrollViewDidEndDecelerating?(scrollView)
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return delegate?.viewForZoomingInScrollView?(scrollView)
  }
  
  func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
    delegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
  }
  
  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
    delegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
  }
  
  func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
    return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
  }
  
  func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    delegate?.scrollViewDidScrollToTop?(scrollView)
  }
}


// ----------------------------
//
// AukSettings.swift
//
// ----------------------------

import UIKit

/**

Appearance and behavior of the scroll view.

*/
public struct AukSettings {
  
  /// Determines the stretching and scaling of the image when its proportion are not the same as its  container.
  public var contentMode = UIViewContentMode.ScaleAspectFit
  
  /// Image to be displayed when remote image download fails.
  public var errorImage: UIImage?
  
  /// Settings for styling the scroll view page indicator.
  public var pageControl = PageControlSettings()
  
  /// Enable paging for the scroll view. When true the view automatically scrolls to show the whole image.
  public var pagingEnabled = true
  
  /// Image to be displayed while the remote image is being downloaded.
  public var placeholderImage: UIImage?
  
  /// The duration of the animation that is used to show the remote images.
  public var remoteImageAnimationIntervalSeconds: Double = 0.3
  
  /// Show horizontal scroll indicator.
  public var showsHorizontalScrollIndicator = false
}

/**

Settings for page indicator.

*/
public struct PageControlSettings {
  /// Background color of the page control container view.
  public var backgroundColor = UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 0.4)
  
  /// Corner radius of page control container view.
  public var cornerRadius: Double = 13
  
  /// Color of the dot representing for the current page.
  public var currentPageIndicatorTintColor: UIColor? = nil
  
  /// Padding between page indicator and its container
  public var innerPadding = CGSize(width: 10, height: -5)
  
  /// Distance between the bottom of the page control view and the bottom of the scroll view.
  public var marginToScrollViewBottom: Double = 8
  
  /// Color of the page indicator dot.
  public var pageIndicatorTintColor: UIColor? = nil
  
  /// When true the page control is visible on screen.
  public var visible = true
}


// ----------------------------
//
// UIScrollView+Auk.swift
//
// ----------------------------

import UIKit

private var xoAukAssociationKey: UInt8 = 0

/**

Scroll view extension for showing series of images with page indicator.


Usage:

    // Show remote image
    scrollView.auk.show(url: "http://site.com/bird.jpg")

    // Show local image
    if let image = UIImage(named: "bird.jpg") {
      scrollView.auk.show(image: image)
    }

*/
public extension UIScrollView {
  /**
  
  Scroll view extension for showing series of images with page indicator.
  
  Usage:
  
      // Show remote image
      scrollView.auk.show(url: "http://site.com/bird.jpg")
      
      // Show local image
      if let image = UIImage(named: "bird.jpg") {
        scrollView.auk.show(image: image)
      }
  
  */
  public var auk: Auk {
    get {
      if let value = objc_getAssociatedObject(self, &xoAukAssociationKey) as? Auk {
        return value
      } else {
        let auk = Auk(scrollView: self)
        
        objc_setAssociatedObject(self, &xoAukAssociationKey, auk,
          objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        
        return auk
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoAukAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
  }
}


// ----------------------------
//
// AutoCancellingTimer.swift
//
// ----------------------------

//
// Creates a timer that executes code after delay. The timer lives in an instance of `AutoCancellingTimer` class and is automatically canceled when this instance is deallocated.
// This is an auto-canceling alternative to timer created with `dispatch_after` function.
//
// Source: https://gist.github.com/evgenyneu/516f7dcdb5f2f73d
//
// Usage
// -----
//     
//     class MyClass {
//         var timer: AutoCancellingTimer? // Timer will be cancelled with MyCall is deallocated
//
//         func runTimer() {
//             timer = AutoCancellingTimer(interval: delaySeconds, repeats: true) {
//                ... code to run
//             }
//         }
//     }
//
//
//  Cancel the timer
//  --------------------
//
//  Timer is canceled automatically when it is deallocated. You can also cancel it manually:
//
//     timer.cancel()
//

import UIKit

final class AutoCancellingTimer {
  private var timer: AutoCancellingTimerInstance?
  
  init(interval: NSTimeInterval, repeats: Bool = false, callback: ()->()) {
    timer = AutoCancellingTimerInstance(interval: interval, repeats: repeats, callback: callback)
  }
  
  deinit {
    timer?.cancel()
  }
  
  func cancel() {
    timer?.cancel()
  }
}

final class AutoCancellingTimerInstance: NSObject {
  private let repeats: Bool
  private var timer: NSTimer?
  private var callback: ()->()
  
  init(interval: NSTimeInterval, repeats: Bool = false, callback: ()->()) {
    self.repeats = repeats
    self.callback = callback
    
    super.init()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
      selector: "timerFired:", userInfo: nil, repeats: repeats)
  }
  
  func cancel() {
    timer?.invalidate()
  }
  
  func timerFired(timer: NSTimer) {
    self.callback()
    if !repeats { cancel() }
  }
}


// ----------------------------
//
// iiAutolayoutConstraints.swift
//
// ----------------------------

//
//  Collection of shortcuts to create autolayout constraints.
//

import UIKit

class iiAutolayoutConstraints {
  class func fillParent(view: UIView, parentView: UIView, margin: CGFloat = 0, vertically: Bool = false) {
    var marginFormat = ""

    if margin != 0 {
      marginFormat = "-(\(margin))-"
    }

    var format = "|\(marginFormat)[view]\(marginFormat)|"

    if vertically {
      format = "V:" + format
    }

    let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format,
      options: nil, metrics: nil,
      views: ["view": view])

    parentView.addConstraints(constraints)
  }
  
  class func alignSameAttributes(item: AnyObject, toItem: AnyObject,
    constraintContainer: UIView, attribute: NSLayoutAttribute, margin: CGFloat = 0) -> [NSLayoutConstraint] {
      
    let constraint = NSLayoutConstraint(
      item: item,
      attribute: attribute,
      relatedBy: NSLayoutRelation.Equal,
      toItem: toItem,
      attribute: attribute,
      multiplier: 1,
      constant: margin)
    
    constraintContainer.addConstraint(constraint)
    
    return [constraint]
  }

  class func equalWidth(viewOne: UIView, viewTwo: UIView, constraintContainer: UIView) -> [NSLayoutConstraint] {
    
    return equalWidthOrHeight(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, isHeight: false)
  }
  
  // MARK: - Equal height and width
  
  class func equalHeight(viewOne: UIView, viewTwo: UIView, constraintContainer: UIView) -> [NSLayoutConstraint] {
    
    return equalWidthOrHeight(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, isHeight: true)
  }
  
  class func equalSize(viewOne: UIView, viewTwo: UIView, constraintContainer: UIView) -> [NSLayoutConstraint] {
    
    var constraints = equalWidthOrHeight(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, isHeight: false)
    
    constraints += equalWidthOrHeight(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, isHeight: true)
    
    return constraints
  }
  
  class func equalWidthOrHeight(viewOne: UIView, viewTwo: UIView, constraintContainer: UIView,
    isHeight: Bool) -> [NSLayoutConstraint] {
    
    var prefix = ""
    
    if isHeight { prefix = "V:" }
    
    if let constraints = NSLayoutConstraint.constraintsWithVisualFormat("\(prefix)[viewOne(==viewTwo)]",
      options: nil, metrics: nil,
      views: ["viewOne": viewOne, "viewTwo": viewTwo]) as? [NSLayoutConstraint] {
        
      constraintContainer.addConstraints(constraints)
      
      return constraints
    }
    
    return []
  }
  
  // MARK: - Align view next to each other
  
  class func viewsNextToEachOther(views: [UIView],
    constraintContainer: UIView, margin: CGFloat = 0,
    vertically: Bool = false) -> [NSLayoutConstraint] {
      
    if views.count < 2 { return []  }
    
    var constraints = [NSLayoutConstraint]()
    
    for (index, view) in enumerate(views) {
      if index >= views.count - 1 { break }
      
      let viewTwo = views[index + 1]
      
      constraints += twoViewsNextToEachOther(view, viewTwo: viewTwo,
        constraintContainer: constraintContainer, margin: margin, vertically: vertically)
    }
    
    return constraints
  }
  
  class func twoViewsNextToEachOther(viewOne: UIView, viewTwo: UIView,
    constraintContainer: UIView, margin: CGFloat = 0,
    vertically: Bool = false) -> [NSLayoutConstraint] {
      
    var marginFormat = ""
    
    if margin != 0 {
      marginFormat = "-\(margin)-"
    }
    
    var format = "[viewOne]\(marginFormat)[viewTwo]"
    
    if vertically {
      format = "V:" + format
    }
    
    if let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format,
      options: nil, metrics: nil,
      views: [ "viewOne": viewOne, "viewTwo": viewTwo ]) as? [NSLayoutConstraint] {
    
      constraintContainer.addConstraints(constraints)
      
      return constraints
    }
      
    return []
  }
  
  class func height(view: UIView, value: CGFloat) -> [NSLayoutConstraint] {
    return widthOrHeight(view, value: value, isHeight: true)
  }
  
  class func width(view: UIView, value: CGFloat) -> [NSLayoutConstraint] {
    return widthOrHeight(view, value: value, isHeight: false)
  }
  
  class func widthOrHeight(view: UIView, value: CGFloat, isHeight: Bool) -> [NSLayoutConstraint] {
    
    let layoutAttribute = isHeight ? NSLayoutAttribute.Height : NSLayoutAttribute.Width
    
    let constraint = NSLayoutConstraint(
      item: view,
      attribute: layoutAttribute,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: value)
    
    view.addConstraint(constraint)
    
    return [constraint]
  }
}


// ----------------------------
//
// iiQ.swift
//
// ----------------------------

//
//  iiQueue.swift
//
//  Shortcut functions to run code in asynchronously and in main queue
//
//  Created by Evgenii Neumerzhitckii on 11/10/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class iiQ {
  class func async(block: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
  }

  class func main(block: ()->()) {
    dispatch_async(dispatch_get_main_queue(), block)
  }

  class func runAfterDelay(delaySeconds: Double, block: ()->()) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delaySeconds * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
  }
}


