# Toast

Toast is a simple class that shows a Toast window on the screen. 100% Swift.

# Sample

![Sample](/Images/Toast.gif)

# How to use

Just include the *Toast.swift* file into your project and call:
```swift
Toast.show("Toast World!")
```

Additionally you can pass a Dictionnary ([String : AnyObject] or his counterpart *ToastAttributes*) where you can specify the text color and the background color like this:

```swift
var attributes = ToastAttributes()

attributes[Toast.TextColor] = textColorWell.color
attributes[Toast.BackgroundColor] = backgroundColorWell.color

Toast.show("Toast World!", attributes: attributes)
```

# More to come

Yes more more more...

# License

Read the **LICENSE** file.

# The most important part of this doc

This is the end ! Have fun.
