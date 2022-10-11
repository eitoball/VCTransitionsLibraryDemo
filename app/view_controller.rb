class ViewController < UIViewController
  @colorIndex = 0

  class << self
    def colorIndex(colors)
      @colorIndex = (@colorIndex + 1) % colors
    end
  end

  def viewDidLoad
    super

    @colors = [
      UIColor.redColor,
      UIColor.orangeColor,
      UIColor.yellowColor,
      UIColor.greenColor,
      UIColor.blueColor,
      UIColor.purpleColor
    ]
    self.view.backgroundColor =
      @colors[self.class.colorIndex(@colors.count)]
  end

  def prepareForSegue(segue, sender: _sender)
    if segue.identifier == 'ShowSettings'
      toVC = segue.destinationViewController
      toVC.transitioningDelegate = self
    end
    super
  end

  def animationControllerForPresentedController(presented, presentingController: presenting, sourceController: source)
    if application_delegate.settingsInteractionController
      application_delegate.settingsInteractionController.wireToViewController(presented, forOperation: CEInteractionOperationDismiss)
    end
    if application_delegate.settingsAnimationController
      application_delegate.settingsAnimationController.reverse = false
    end
    application_delegate.settingsAnimationController
  end

  def animationControllerForDismissedController(dismissed)
    if application_delegate.settingsAnimationController
      application_delegate.settingsAnimationController.reverse = true
    end
    application_delegate.settingsAnimationController
  end

  def interactionControllerForDismissal(animator)
    application_delegate.settingsInteractionController && application_delegate.settingsInteractionController.interactionInProgress ? application_delegate.settingsInteractionController : nil
  end

  def application_delegate
    UIApplication.sharedApplication.delegate
  end
end
