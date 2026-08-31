# Weather-SwiftUI

A SwiftUI weather app using the MV (Observable models) architecture pattern, showing current conditions and forecasts via a public weather API.

## Overview

This is a portfolio project built to demonstrate modern SwiftUI development practices, including the MV architecture pattern (as opposed to MVVM), the Observation framework, and clean SwiftUI idioms.

## Features

- Current weather conditions for a given location
- Multi-day forecast

## Architecture

This project uses **MV (Observable models)** rather than MVVM:

- Views bind directly to `@Observable` model classes, no separate ViewModel layer.
- State is grouped into coarse, aggregate models per screen (or app-wide) rather than one model per view.
- Business logic (fetching, parsing, formatting) lives in the model layer; views stay thin.
- Requires iOS 17+ for the Observation framework.

## Tech stack

- SwiftUI
- Swift Observation framework
- (weather API name, once chosen)
- XCTest for unit tests

## Requirements

- Xcode 15+
- iOS 17+

## Setup

1. Clone the repo
2. Open `Weather-SwiftUI.xcodeproj` (or `.xcworkspace`, if using SPM packages)
3. (Add any API key setup steps here once you pick a provider)
4. Build and run

## Roadmap

- [ ] Basic UI scaffold
- [ ] Weather API integration
- [ ] Location search
- [ ] Unit tests
- [ ] CI pipeline

## License

MIT
