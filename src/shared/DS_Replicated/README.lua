--[[

[CONFIG]
DoorRoot.DisableCollisionOnOpen
    -> set to true by default. determines whether doors are cancollide or not during opening
    -> what counts as the door is determined by what is welded to the mover
DoorRoot.OpenCooldown
    -> time between all scanner accesses if open
Scanner.ScanVisual
    -> the ScanVisual configuration to use. (CTRL+P for the PromptStates file)
Scanner.UseThrottle
    -> time between (INDIVIDUAL) scanner accesses if fail
Scanner.OnMountStrategy
    -> the function used when a prompt is entered. mostly for logic triggers
    -> just use ScannerAutoMount or ScannerManualMount 99% of the time but yes u can make compelx ones with this
Scanner.OnUseStrategy
    -> the function used (server) when the prompt is triggered, on the model itself
    -> this should not be doing any important logic, just visuals

AuthChecks
    -> the ruleset for opening tha door. (CTRL+P for the AuthChecks file.)
    -> the format is just {funcName, {args}}
    -> OR can be used to wrap around a rule to make it so that you only need 1
    -> AND is implicit
PartMover.Use
    -> which animation method to use (this doesnt do anything rn)
PartMover.Instructions
    -> where you store your animation sequences
    -> every entry in here will have to match the name of the value linking your prompt
       in the required folder, this is how you pick which sequence to use


[SETUP]
    1. copy the Required folder. just trust me bro its a lot less painful
    2. set the prefab to the config youd like under "InitRoot.Prefab"
    3. add anchored part(s) as hinge(s). weld your animated parts to that hinge
   
    4. for every part you want animated, add an folder to "PartMover.Instructions"
    5. name the folder after whatever part its for in the animation. so for
    example if your animation is animating Door1, name the folder Door1
    6. INSIDE THE FOLDER, add object values for every "point" in your animation
    so for example if your animation is moving to point GoTo, there should be an
    objectvalue named GoTo in the folder, pointing to the part
    7. make sure there is an objectvalue named Mover. this is your hinge

    8. in "Required.Scanners", add objectvalues pointing to the scanner PROMPTS
    9. name the objectvalues after whatever sequence youd like them to use so
    for example if you want the front scanner to use the OpenFront sequence, name
    the objectvalue OpenFront
    10. open your door : )

[TROUBLESHOOTING]
msg mothball16 on cord

]]
