# BuxticProgresBar
Circular Progress Bar - with gradient coloring and auto-layouting support
- Preview 
![Preview](https://raw.githubusercontent.com/deimusmeister/BuxticProgresBar/master/full-preview.png)

Implements circular progress bar with gradient coloring  
   - Background blur with given gradient colors  
   - Progress tracker with gradient colors  
   - Variod ways of customization of colors and sizes  

---  
#### How to use
 - Import `BuxticProgressBar.swift` file in your project
 ```
         let progressView = BuxticProgressBar(gradientStartColor: .systemRed, gradientEndColor: .systemBlue)
        progressView.frame = CGRect(x: 0, y: 0, width: 166, height: 166)
        progressView.center = self.view.center

        progressView.progress = 0.9
        progressView.percentageFont = UIFont.systemFont(ofSize: 24)
        progressView.percentageColor = .systemBlue
```
