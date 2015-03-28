class SettingsViewController < UITableViewController
  def initWithCoder(aDecoder)
    super
    @animationControllers = ['None', 'Portal', 'Cards', 'Fold', 'Explode', 'Flip', 'Turn', 'Crossfade', 'NatGeo', 'Cube', 'Pan']
    @interactionControllers = ['None', 'HorizontalSwipe' ,'VerticalSwipe', 'Pinch'];
    self
  end

  def doneButtonPressed(sender)
    self.dismissViewControllerAnimated(true, completion: nil)
  end

  def classToTransitionName(instance)
    if !instance
      return 'None'
    end

    instance.class.to_s.sub(/\ACE/, '')
      .sub(/(Animation|Interaction)Controller\z/, '')
  end

  def transitionNameToInstance(transitionName)
    className = "CE#{transitionName}AnimationController"
    NSClassFromString(className).alloc.init
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if indexPath.section < 2
      # an animation controller was selected
      transitionName = @animationControllers[indexPath.row]
      transitionInstance = NSClassFromString("CE#{transitionName}AnimationController").alloc.init

      if indexPath.section == 0
        application_delegate.navigationControllerAnimationController = transitionInstance
      end

      if indexPath.section == 1
        application_delegate.settingsAnimationController = transitionInstance;
      end
    else
      # an interaction cntroller was selected
      transitionName = @interactionControllers[indexPath.row];
      className = "CE#{transitionName}InteractionController"
      transitionInstance = NSClassFromString(className).alloc.init

      if indexPath.section == 2
        application_delegate.navigationControllerInteractionController = transitionInstance
      end
      if indexPath.section == 3
        application_delegate.settingsInteractionController = transitionInstance
      end
    end
    self.tableView.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    # get the cell text
    transitionName = cell.textLabel.text

    # get the current animation / interaction controller
    currentTransition = if indexPath.section < 2
      indexPath.section == 0 ?
        application_delegate.navigationControllerAnimationController :
        application_delegate.settingsAnimationController
    else
      indexPath.section == 2 ?
        application_delegate.navigationControllerInteractionController :
        application_delegate.settingsInteractionController
    end

    # if they match - render a tick
    transitionClassName = self.classToTransitionName(currentTransition)
    cell.accessoryType = transitionName.isEqualToString(transitionClassName) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('cell')

    cell.textLabel.text = if indexPath.section < 2
      @animationControllers[indexPath.row]
    else
      @interactionControllers[indexPath.row]
    end
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    section < 2 ? @animationControllers.count : @interactionControllers.count
  end

  def numberOfSectionsInTableView(tableView)
    4
  end

  def tableView(tableView, titleForHeaderInSection: section)
    case section
    when 0; 'Navigation push / pop animation controller'
    when 1; 'Settings present / dismiss animation controller'
    when 2; 'Navigation push / pop interaction controller'
    when 3; 'Settings present / dismiss interaction controller'
    else; ''
    end
  end

  def application_delegate
    UIApplication.sharedApplication.delegate
  end
end
