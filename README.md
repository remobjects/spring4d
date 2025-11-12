![Spring4D medium.png](https://bitbucket.org/repo/jxX7Lj/images/3496466100-Spring4D%20medium.png)


Spring4D is an open-source code library for Embarcadero Delphi XE and higher.
It consists of a number of different modules that contain a base class library (common types, interface based collection types, reflection extensions) and a dependency injection framework. It uses the Apache License 2.0.

Join us on the [Spring4D Google Group](https://groups.google.com/forum/#!forum/spring4d).

Oxygene Version
------------

Oxygene is an Object Pascal compiler made by RemObjects which supports the majority of Delphi-style Object Pascal, with a [significant number of modernizations](https://www.remobjects.com/elements/oxygene/language.aspx#sequences). It compiles to many more platforms, including Windows ARM and Linux ARM (natively via LLVM), plus support .Net and JVM targets too.

The repo is not yet complete but is intended to include tweaks necessary to get Spring4D to build with Oxygene.

Changes so far include:
* Updated Jedi.inc to recognise Oxygene (also [contributed to Jedi](https://github.com/project-jedi/jedi/pull/24))
* `method` is a reserved word in Oxygene ([see list of keywords](https://docs.elementscompiler.com/Oxygene/Keywords/))

We have not yet added our Elements project files. To create one yourself, open Water or Fire (RemObjects' Windows and Mac IDEs) and go to File > Import > Delphi project and select Spring.Base.

Other than basic compilation, some areas may need reconsideration: for example, Oxygene has nullable types built into the language, so how would S4D's `Nullable<>` be handled -- mapped to the language, perhaps? Or, should we add support for some of the more modern language features, like [sequences](https://www.remobjects.com/elements/oxygene/language.aspx#sequences) when iterating over collections? Our goal is to get the main portion of the library building and address these on a case-by-case basis.

Please support Spring4D
-----------------

The below is the donate button from the original project (before we forked it.) We absolutely recommend supporting them.

[![btn_donate_LG.gif](https://bitbucket.org/repo/jxX7Lj/images/1283204942-btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KG4H9QT3MSDN8)


Copyright (c) 2009 - 2024 Spring4D Team
