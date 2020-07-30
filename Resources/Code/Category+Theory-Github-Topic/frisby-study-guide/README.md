![learn monads](./docs/images/must-learn-monads.jpg)

# Frisby-study-guide
my workbook for the [Professor Frisby's mostly-adequate-guide](https://github.com/MostlyAdequate/mostly-adequate-guide)
Additionally I am using [ava](https://github.com/avajs/ava) and [ramda](http://ramdajs.com/)
## Getting started
These instruction will get you a copy of the project up & running on your local machine for development and testing purposes.  

### Prerequisites
Following installs are assumed:
* [node 8+](https://nodejs.org/en/download/)
* [npm](https://www.npmjs.com/get-npm)

### Installing
```
git clone git@github.com:kayvank/frisby-study-guide.git
cd frisby-study-guide
npm install
./node_modules/.bin/gulp test ## runs the tests
```
## Running the tests
There are 2 mothodes to run the automated tests:
- npm
- gulp

### npm 
using the npm is the quickest & simplest way:

```
npm run test:watch
```

### gulp
use gulp if you're interested in running lint & babel against the project

```
./node_modules/.bin/gulp 
### or ###
./node_modules/.bin/gulp watch
```
## Acknowledgments
* [Brian Londsdorf, Dr.Boolean](https://github.com/DrBoolean)
* [AVA casts](http://avacasts.cam/)
