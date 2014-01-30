CAAnimationTest
===============

The idea behind this project was the explore two things:

* Core Animation
* KVO/KVC

## Core Animation

When you open the app you will see two buttons at the bottom of the screen. Whichever button is pressed will cause one of two animations to fire. 

### Fade Animation
The first animation is a “pop in” animation. The object starts with 0.2 scale and 0.0 opacity, and
then animates in over a duration defined by the model object. The animation progresses as follows:
- 0%:  Scale 0.2, opacity 0.0
- 40%:  Scale 1.2, opacity 1.0
- 80%:  Scale 0.9, opacity 1.0
- 100%: Scale 1.0, opacity 1.0

### Scale and Rotate Animation
The second animation is a “slide and rotate” animation. The object moves X pixels along the x-axis from the center towards the center (where X is defined by the model object.)

- 0%: Position (superview.midpoint.x - model.startX, superview.midpoint.y), angle 0
- 100%: Position (superview.midpoint.x, superview.midpoint.y), angle 0 (full 360º rotation)

## KVO/KVC

The Model Object has a primary property called value. An NSTimer will randomly change the value of this property every X seconds (where X can be 1-10). The MainViewController will be notified of when the value changes. When the value does change, the current animation is reset and recalibrated for the new value.

## Credits and Notable Mentions

* Thanks to NSHipster.com for valuable references and resources for KVO and Random Number generators. 
* Thanks to StackOverflow as always.
* Thanks to DuncanMC and the iOS-CAAnimation-group-demo project https://github.com/DuncanMC/iOS-CAAnimation-group-demo
* The image used in this project was taken from www.appannie.com and is owned/created by SourceBits, I claim no ownership of the image. 
