# FlipgridChallenge

Overview
* The project follows MVVM-FlowViewController architecture that scales nicely as more screens/flows are added.
* I have added comments and TODOs/Out of Scopes througout the project.
* I have tried to keep the color and font as close as possible to the mocks.
* Validation is done only on Email and password fields.
* All the visual strings in the project have been localized.
* Making use of UIScrollView as a container view to ensure the view scrolls in case of smaller physical devices.
* Making use of UIStackview in profile confirmation screen to automatically adjust the spacing between the controls.
* Displaying a default placeholder avatar in case a user hasn't selected an avatar during profile creation. This enhances the User experience compared to when no avatar is shown.
* The code is tested on iPad as well, should work without any issues. However, the UI layout could be more polished to suit the bigger screen.
* Added unit tests for viewmodels.
* Implementation of basic networking classes/protocols that provides the API service.
* Provide a protocol approach to create view controllers that enforces a relationship with viewmodel.
* Simulating network activity with basic activity indicator view

Not handled due to time constraint/out of scope
* Mock test for Network service.
* Accessiblity support.
* Handling Camera/Photo library access denied case.
