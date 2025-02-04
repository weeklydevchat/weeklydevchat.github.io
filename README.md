# weeklydevchat.github.io
A static website hosted by GitHub Pages.  

We're using GitHub's Actions, so any push to the **_main_** branch triggers a build of the HTML.  Those are put into the _**gh_pages**_ branch

Results are published to [weeklydevchat.github.io](https://weeklydevchat.github.io/)

![GitHub Pages](https://github.com/weeklydevchat/weeklydevchat.github.io/actions/workflows/ci.yml/badge.svg)
[![Built with Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white)](https://squidfunk.github.io/mkdocs-material/)


# Authors Guide

Requirements:
 - **Python**  (any recent should be fine.  Recommended to use a virtual environment.)
    - **Material for MkDocs**

      `pip install mkdocs-material`

[Material for MKDocs](https://squidfunk.github.io/mkdocs-material/) is a theme and plugin package for [MkDocs](https://www.mkdocs.org). Visit both sites for complete information.


## Commands

* `mkdocs serve` - Start the live-reloading docs server. Use this to test changes locally before pushing.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        posts/    # blog posts, organised anyway you like
        ...       # Other markdown pages, images and other files.
