# UIPresentationController Tutorial: Getting Started
### Source: https://www.raywenderlich.com/3636807-uipresentationcontroller-tutorial-getting-started

## Slide In Presentation Action:
- The presented controller will take up two-thirds of the screen and the remaining third will show as dimmed. To dismiss the controller, you just tap on the dimmed portion.
- take care of three critical pieces: 
    - subclass
    - dimming view 
    - customizing the transition

## Custom Presentation Implementing Structure
- MainViewController.swift
    - override prepare(for segue:) 
        - Assigning custom transitioning delegate to the presented view controller's transitioningDelegate

- SlideInPresentationController.swift
    - PresentationController Class
        - Defining custom presentation process
            - Defining Custom PresentationController's init()
            - Overriding presentationTransitionWillBegin() 
            - Overriding dismissalTransitionWillBegin()
            - Overriding containerViewWillLayoutSubviews()
                - presentedView?.frame = frameOfPresentedViewInContainerView
                    - To reset the presented view’s frame to fit any changes to the containerView frame.
            - Overriding size(forChildContentContainer: )
                - To give the size of the presented view controller's content
            - Overriding frameOfPresentedViewInContainerView property 
                - to return the full frame of presented view

- SlideInPresentationManager.swift
    - Setting presentation direction
    - To conform UIViewControllerTransitioningDelegate protocol
        - //When you present a view controller using the UIModalPresentationStyle.custom presentation style, the system calls this method and asks for the presentation controller that manages your custom style. If you implement this method, use it to create and return the custom presentation controller object that you want to use to manage the presentation process.
            - presentationController(forPresented: presenting: source: ) 
                - //Here you instantiate a SlideInPresentationController with the direction from SlideInPresentationManager

## Creating the Animation Controller
- To slide in the Summer and Winter menus from the side
            
        //To add a custom animation transition, you’ll create a subclass of NSObject 
        //that conforms to UIViewControllerAnimatedTransitioning.
        
        //For complex animations you’d usually create two controllers 
        //— one for presentation and one for dismissal. 
        //In the case of this app, dismissal mirrors presentation, 
        //so you only need one animation controller.

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

## Adaptivity
- Making the effect work beautifully on all devices and both orientations
    - 
