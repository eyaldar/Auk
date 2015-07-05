import XCTest
import moa

class AukInterfaceShowRemoteImageTests: XCTestCase {
  
  var scrollView: UIScrollView!
  var auk: Auk!
  
  override func setUp() {
    super.setUp()
    
    scrollView = UIScrollView()
    
    // Set scroll view size
    let size = CGSize(width: 120, height: 90)
    scrollView.bounds = CGRect(origin: CGPoint(), size: size)
    
    auk = Auk(scrollView: scrollView)
  }
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.clear()
  }
    
  func testShowRemoteImage_setupIsCalled() {
    MoaSimulator.simulate("site.com")
    
    auk.show(url: "http://site.com/image.png")
    
    XCTAssertFalse(scrollView.showsHorizontalScrollIndicator)
  }
  
  func testShowRemoteImage() {
    let simulator = MoaSimulator.simulate("auk.png")
    
    auk.show(url: "http://site.com/auk.png")
    
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/auk.png", simulator.downloaders.first!.url)
    
    scrollView.layoutIfNeeded()
    
    let image = uiImageFromFile("67px.png")
    simulator.respondWithImage(image)
    
    XCTAssertEqual(1, aukPages(scrollView).count)
    
    // First image view remains nil
    XCTAssert(firstAukImage(scrollView, pageIndex: 0) == nil)
    
    // Loads image into the second image view
    XCTAssertEqual(67, secondAukImage(scrollView, pageIndex: 0)!.size.width)
  }
  
  func testShowRemoteImage_showSecondImageWhenScrolled() {
    let simulator = MoaSimulator.simulate("site.com")
    
    // Add two remote images
    auk.show(url: "http://site.com/auk.png")
    auk.show(url: "http://site.com/moa.png")
    
    // The first image is requested at first
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/auk.png", simulator.downloaders.first!.url)
    XCTAssertFalse(simulator.downloaders.first!.cancelled)
    
    // Scroll to make the second image visible
    scrollView.contentOffset.x = 10
    scrollView.delegate?.scrollViewDidScroll?(scrollView)
    
    // The second image is requested
    XCTAssertEqual(2, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/moa.png", simulator.downloaders.last!.url)
    XCTAssertFalse(simulator.downloaders.last!.cancelled)
    
    // Scroll to hide the first image
    scrollView.contentOffset.x = 120
    scrollView.delegate?.scrollViewDidScroll?(scrollView)
    
    // Download of first image is NOT cancelled yet because it is close (though not visible)
    XCTAssertFalse(simulator.downloaders.first!.cancelled)
    
    // Scroll more to cancel first image download
    scrollView.contentOffset.x = 180
    scrollView.delegate?.scrollViewDidScroll?(scrollView)
    
    // Download of first image is cancelled
    XCTAssert(simulator.downloaders.first!.cancelled)
  }
  
  func testShowRemoteImage_layoutSubviews() {
    MoaSimulator.simulate("site.com")
    
    auk.show(url: "http://site.com/image1.png")
    auk.show(url: "http://site.com/image2.png")
    
    scrollView.layoutIfNeeded()
    
    // Check content size
    // -------------
    
    XCTAssertEqual(CGSize(width: 240, height: 90), scrollView.contentSize)
    
    // View 1
    // -------------
    
    let aukView1 = aukPages(scrollView)[0]
    XCTAssertEqual(CGPoint(x: 0, y: 0), aukView1.frame.origin)
    XCTAssertEqual(CGSize(width: 120, height: 90), aukView1.frame.size)
    
    // View 2
    // -------------
    
    let aukView2 = aukPages(scrollView)[1]
    XCTAssertEqual(CGPoint(x: 120, y: 0), aukView2.frame.origin)
    XCTAssertEqual(CGSize(width: 120, height: 90), aukView2.frame.size)
  }
}