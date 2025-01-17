### Summary: Include screen shots or a video of your app highlighting its features
Attached 3 simulator screenshots of the app

![screenshot](Recipe/1.png)
![screenshot](Recipe/2.png)
![screenshot](Recipe/3.png)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
For this project, I focused on the requirements being met, and to setup some kind of centralized or syntax-based wrapping and generalization of the data loading and caching.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I wanted to finish in one sitting. A few hours. Most of the time was allotted for figuring out how to do the requirements, as I have not delivered any SwiftUI code or iOS 16 runtime yet!

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I felt somewhat restricted with SwiftUI but it is easy to get started.
(I always had Injection and hot reloading of compiled Swift - https://github.com/johnno1962/InjectionIII)

### Weakest Part of the Project: What do you think is the weakest part of your project?
Testing: I would normally shoot for integration and ui testing in my production environments and department. Code should be tested for weaknesses; generally fallible code needs more tests or rewrite.
For a compiled project, a lot of testing is actually handled by the compilers and symbolicators (same for optimization). So maintenance wise, keep unit testing to essentials, but do thorough integration testing.
Code should be self explanatory generally. Readable at declaration level not comments.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I haven't written that much async await and SwiftUI. Usually I have my own stack and interface pretty directly with UIKit and CoreAnimation on iOS, for concurrency I have used GCD, PromiseKit, and operations most extensively. I have been working mostly web and infra for some years, so definitely rusty!
A well supported and maintained project shines in many other areas like devops, tooling, environments, automated ui/integration tests, and fast deployments too.
