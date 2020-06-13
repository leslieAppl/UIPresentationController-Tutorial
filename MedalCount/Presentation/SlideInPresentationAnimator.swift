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

//MARK: - Controlling animate transition directions in this file
final class SlideInPresentationAnimator: NSObject {
  //MARK: Step 19
  //MARK: - Properties
  let direction: PresentationDirection
  let isPresentation: Bool
  
  //MARK: - Initializers
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
}

//MARK: - UIViewControllerAnimatedTransitioning
extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // 1 If this is a presentation, the method asks the transitionContext for the view controller associated with .to. This is the view controller you’re moving to. If dismissal, it asks the transitionContext for the view controller associated with .from. This is the view controller you’re moving from.
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from

    guard let controller = transitionContext.viewController(forKey: key) else { return }
    
    // 2 If the action is a presentation, your code adds the view controller’s view to the view hierarchy. This code uses the transitionContext to get the container view.
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }
    
    // 3 Calculate the frames you’re animating from and to. The first line asks the transitionContext for the view’s frame when it’s presented. The rest of the section tackles the trickier task of calculating the view’s frame when it’s dismissed. This section sets the frame’s origin so it’s just outside the visible area based on the presentation direction.
    //Here is the core to make sliding in animation from two sides not from bottom rising up.
    //Because you have set the animation route in terms of origin.x and .y.
    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissedFrame = presentedFrame
    switch direction {
    case .left:
      dismissedFrame.origin.x = -presentedFrame.width
    case .right:
      dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
    case .top:
      dismissedFrame.origin.y = -presentedFrame.height
    case .bottom:
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
    }
    
    // 4 Determine the transition’s initial and final frames. When presenting the view controller, it moves from the dismissed frame to the presented frame — vice versa when dismissing.
    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame
    
    // 5 Lastly, this method animates the view from initial to final frame. If this is a dismissal, you remove the view controller’s view from the view hierarchy. Note that you call completeTransition(_:) on transitionContext to inform the transition has finished.
    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(withDuration: animationDuration, animations: {
      controller.view.frame = finalFrame
    }) { (finished) in
      if !self.isPresentation {
        controller.view.removeFromSuperview()
      }
      transitionContext.completeTransition(finished)
    }
  }
  
  
}
