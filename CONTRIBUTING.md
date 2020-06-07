# Contributing guide

This file outlines how you can contribute to CaTeX.  
If you are new to contributing on GitHub, you might want to see the setup section below. Additionally, please take note of the notes at the end.

## Supporting new functionality

Supporting some functionality from the TeX spec requires editing the parser. However, there are already some abstractions in place that will make this easier.
For example, even though some special characters are not yet integrated (like the end of line character), the character enum already contains it and matches the spec.
Search for `// todo: [<feature>] is unsupported.` comments to find these.

On the flip side, adding support for new functions or symbols is very easy.

### Adding new functions

Supporting a new function will require 3 steps (matching the three directories: `lookup`, `parsing`, and `rendering`:

1. Add the new function to the *lookup*. All functions are defined in `lib/src/lookup/functions.dart`.  
   First, add the function to the `CaTeXFunction` enum (`\sum` becomes `CaTeXFunction.sum`).  
   Second, add a name entry to `supportedFunctionNames`, e.g. `\sum: CaTeXFunction.sum`.  
   Third, add the function to the `supportedMathFunctions` list if it is supported in math mode and to the `supportedTextFunctions` if it is supported in text mode (it can support both).  
   Fourth, add the function to the switch statement in `lookupFunction`.
   You will define the node you need to return in step 2, but you can already enter it because the class naming should be `<function name>Node`, e.g. `SumNode`.  
   Thus, you can already add `return SumNode(input)` for this example.
   If multiple functions can be combined into one handler (see the `fonts` function as an example), they can return the same node.
1. Create the `<function name>Node` class in `parsing/functions/<function_name>.dart`.  
   See `ParsingNode` and its subclasses to understand how to design your subclass. *Do **not*** directly subclass `ParsingNode`. You need to override `configureWidget` and `createRenderNode`.    
   You can also view other functions in the directory for reference.  
   In this step, you will also have to specify the number of `arguments` and the `greediness` value.
1. Create `Render<function name>` in `rendering/functions/<function_name>.dart`.
   Extend `RenderNode` this time; you need to override `configure` for sizing and `render`.

Please use the [pull request template for new functions][new function template]. To use it, you need to either manually insert the branches to compare or you can simply append `?template=new_function.md` to the URL after selecting the branches to compares.
   
### Adding new symbols

You can update the code generation to support some more symbols in `gen/symbols.dart`.  
The file contains a link which has way more symbols predefined than currently supported. Updating the generation to support these should be straight forward.

## Setting up your repo

### Fork the CaTeX repository

* Ensure you have configured an SSH key with GitHub; see [GitHub's directions](https://help.github.com/articles/generating-ssh-keys/).
* Fork [this repository][repo] using the "Fork" button in the upper right corner of the GitHub page.
* Clone the forked repo: `git clone git@github.com:<your_github_user_name>/CaTeX.git`
* Navigate into the project: `cd CaTeX`

[//]: # (todo replace with correct link)

* Add this repo as a remote repository: `git remote add upstream git@github.com:creativecreatorormaybenot/CaTeX.git`
   
### Create pull requests

* Fetch the latest repo state: `git fetch upstream`
* Create a feature branch: `git checkout upstream/master -b <name_of_your_branch>`
* Now, you can change the code necessary for your patch.

  Make sure that you bump the version in [`pubspec.yaml`][pubspec] 
  and add an entry to [`CHANGELOG.md`][changelog].  
  The version format is `r.M.m+p`. You will want to increment one of these values and which one you increment depends on the impact of your patch: 
  `p` for simple patches, `m` for minor versions, `M` for major versions, and `r` for releases.
  Do not forget to reset the values to the right of the value you incremented to 0. You should omit `+0`.
* Commit your changes: `git commit -am "<commit_message>"`
* Push your changes: `git push origin <name_of_your_branch>`

After having followed these steps, you are ready to [create a pull request](https://help.github.com/en/articles/creating-a-pull-request-from-a-fork).  
The GitHub interface makes this very easy by providing a button on your fork page that creates a pull request with changes from a recently pushed to branch.  
Alternatively, you can also use `git pull-request` via [GitHub hub](https://hub.github.com/).

## Notes

* Always add tests or confirm that your code is working with current tests.
* Use `flutter format . --fix` to format all code.
* Adhere to the lints, i.e. the warnings provided by Dart's linter based on the repo's lint rules.  
  Run `flutter analyze` in order to ensure that you are not missing any warnings or errors.

[//]: # (todo replace these links with the correct url)

[repo]: https://github.com/creativecreatorormaybenot/CaTeX
[pubspec]: https://github.com/creativecreatorormaybenot/CaTeX/blob/master/pubspec.yaml
[changelog]: https://github.com/creativecreatorormaybenot/CaTeX/blob/master/CHANGELOG.md
[new function template]: https://github.com/simpleclub/CaTeX/compare?template=new_function.md
