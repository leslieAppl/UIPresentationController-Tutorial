/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class SlideInPresentationController: UIPresentationController {
  
  //MARK: Step 11
  private var dimmingView: UIView!
  
  //MARK: Step 9
  private var direction: PresentationDirection
  
  //In addition to calculating the size of the presented view,
  //you need to return its full frame.
  override var frameOfPresentedViewInContainerView: CGRect {
    //MARK: Step 17
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
    
    switch direction {
    case .right:
      frame.origin.x = containerView!.frame.width*(1.0/3.0)
    case .bottom:
      frame.origin.y = containerView!.frame.height*(1.0/3.0)
    default:
      frame.origin = .zero
    }
    return frame
  }
  
  //MARK: Step 10
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
    self.direction = direction
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    setupDimmingView()
  }
  
  override func presentationTransitionWillBegin() {
  
    //MARK: Step 13
    guard let dimmingView = dimmingView else {
      return
    }
    // 1
    containerView?.insertSubview(dimmingView, at: 0)

    // 2
    dimmingView.topAnchor.constraint(equalTo: containerView!.topAnchor).isActive = true
    dimmingView.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor).isActive = true
    dimmingView.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
    dimmingView.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
    
    // 3
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 1.0
    })
  }
  
  override func dismissalTransitionWillBegin() {
  
    //MARK: Step 14
    //When a presentation or dismissal is in progress,
    //this method returns the transition coordinator object associated with that transition.
    //You can use this object to create additional animations
    //and synchronize them with the transition animations.
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    
    //Use this method to perform animations
    //that are not handled by the animator objects themselves
    coordinator.animate(alongsideTransition: { (_) in
      //This gives the effect of fading the dimming view
      self.dimmingView.alpha = 0.0
    }, completion: nil)
    
  }
  
  //This override will respond to layout changes in the presentation controller's containerView.
  override func containerViewWillLayoutSubviews() {
    //MARK: Step 15
    //Here you reset the presented view’s frame to fit any changes to the containerView frame.
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  //To give the size of the presented view controller's content
  //to the presentation controller.
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    //MARK: Setp 16
    switch direction {
    case .left, .right:
      return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
    case .bottom, .top:
      return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
    }
  }
}

// MARK: - Private
private extension SlideInPresentationController {
  //MARK: Step 12
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    
    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  
  @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    presentingViewController.dismiss(animated: true, completion: nil)
  }
}
