[![Build Status](https://travis-ci.org/kgellci/Area51.svg?branch=master)](https://travis-ci.org/kgellci/Area51)

# Area51

Area51 is an open source Reddit client for iOS built entirely in Swift!

## Goals

- Provide a beginner friendly development environment
- Use the latest iOS development tools
- Document everything! Helps beginners learn :)
- Build an awesome open source Reddit client for iOS!

## How to get setup

### Requirements

Make sure you have Xcode: 10.1 or higher.

This project currently supports Swift 4.2+

### Setup

Clone the repo and run the generate command
```console
git clone git@github.com:kgellci/Area51.git
cd Area51/
make generate
```

After `generate` is finished doing its job, open Area51.xcodeproj, build and run.

### Running on a device
Edit the user.xcconfig file in Configs/ directory (don't worry, it is gitignored!)
Set `DEVELOPMENT_TEAM` in the user.xcconfig file. Example:
`DEVELOPMENT_TEAM = XXXXXXXXX`

You will need to close the xcode project, run `make generate`, open the project back up.
You can find your team ID by logging into developer.apple.com

# License
Area51 is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for more info.
