#  LoremPicsumWidgets

This is an example of how to share cached network data between a host application and a widget using App Groups. 

If you try to use it, you will need to set up your own App Group, since the group "group.lorempicsumwidgets" is tied to a provisioning profile that's tied to my developer account.

You will need to go to your project settings, "Signing & Capabilities" pane, and change the string in the "App Groups" section to one of your own. You will need to do this for both targets in the project. You will then need to replace the string in String.appGroupName to return the app group that you created.  

<video width="320" height="240" controls>
  <source src="readme_resources/screenrecording.mp4" type="video/mp4">
Your browser does not support the video tag.
</video>
