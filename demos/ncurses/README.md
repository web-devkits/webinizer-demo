# Tutorial for building and using ncurses library with Webinizer

## How to build ncurses with Webinizer

1. **`Main page`** - Click the `GET STARTED` button in Webinizer main page to enter the project list
   page.

2. **`Get started page`** - Click the `SELECT` button of the Ncurses project to enter the
   `Basic config` page.

3. **`Basic config page`**

   - Click the checkbox `Check the box if the project is a library` as we are building Ncurses as a
     library.

     > _**NOTE**.
     > `Please make sure this step is taken before proceeding, otherwise some unexpected errors will occur during the building process.`_
     >
     > _Please refer to [this](#faq) if you encounter similar tricky problems._

   - Click `BUILD STEPS ->` in the lower right corner or `Steps` in the top navigation panel to
     enter `Build steps` page.

4. **`Build steps page`**

   - Select `static` build target and then Webinizer will give you some recommended build steps for
     the project.
   - Click `YES` to accept the recommendation.
   - Click `ADD STEP` button to add another new build step.
   - Select `Make` option of `Build tools type`, then type `install` as `Arguments for build` and
     click the `SAVE` button to confirm.
   - Click `BUILD ->` in the lower right corner or `Build` in the top navigation panel to enter the
     `Build` page.

5. **`Build page`**

   - Click the `BUILD` button and then Webinizer will quickly return 2 recipes:
     `Recipe for main loop issue` & `Recipe for pthread support`. Click the `IGNORE` button for
     both.

     > Note. _These 2 recipes have no relation with the ncurses core code, but with the test/tools
     > in ncurses source folder so we can just ignore them._

   - Click the `BUILD` button again and then Webinizer will return the recipe:
     `Recipe for issue of building intermedium tools with native compiler other than Emscripten`.

     > Note. _This recipe is shown because `Ncurses` building process needs to build native tools to
     > generate some intermedium files, these tools should be native binaries. But as Webinizer uses
     > Emscripten to build project, these tools would be built as JS and WASM files. So we need to
     > use native compiler to build these tools. For `Ncurses`, enabling `cross-platform compiling`
     > will use gcc to build these tools. We can add arguments while running `configure` step to
     > achieve this._

   - Click `<- BUILD STEPS` in the lower left corner to go back to the `Build steps` page.

6. **`Build steps page`**

   - Click `MANAGE STEPS` and add argument
     `"--build=x86_64-pc-emscripten --host=x86_64-pc-linux-gnu" ` to STEP1 `configure`.
   - Click the `FINISH` button to save the changes.
   - Click `BUILD ->` to go back to the `Build` page.

7. **`Build page`**

   - Click the `BUILD` button and another recipe will appear: `Recipe for strip issue`.

     > Note. _This is because the build process is trying to strip WASM format object files. We need
     > to disable stripping while using Emscripten to build WASM files._

   - Click `<- BUILD STEPS` in the lower left corner to go back to the `Build steps` page again.

8. **`Build steps page`**

   - Click `MANAGE STEPS` and add argument `--disable-stripping` to STEP1 `configure`
   - Click the `FINISH` button to save the changes.
   - Click `BUILD ->` to go back to the `Build` page.

9. **`Build page`**

   - Click the `BUILD` button and another recipe will return shortly: `Recipe for C++ exception`.

     > Note. _This is because ncurses has some C++ demos. They have no relation with the ncurses
     > core library._

   - Click `IGNORE` and then click `BUILD` again.

After a while, it will show `Build successfully!` on the page.

## How to use ncurses library within another project

- All the ncurses build results will be displayed in a `webinizer_build` folder. The folder has 4
  sub-folders:

  - /bin
  - /include - header files of ncurses
  - /lib - library files of ncurses
  - /share

- If you want to build another project using ncurses library built by Webinizer, please go to the
  `Config` page and navigate to `Package & Native library info` from the left side navigator. For
  `Ncurses` library, we'd define the `required` package configurations for the `static` build target
  as below.

  - _Prefix_: `${projectRoot}/webinizer_build`
  - _Compiler flags_: `'-I${prefix}/include'`
  - _Linker flags_:
    `'-L${prefix}/lib' -lncurses '--preload-file ${prefix}/lib/terminfo@/home/web_user/.terminfo'`

- In addition, we also need to set the native library information in the `Native Library Info`
  section with `name` and `version` correctly.

  - _name_: `ncurses`
  - _version_: `6.1.20180127`

## FAQ

### Q: What if I forgot to check the `library` checkbox and encountered the errors not handled by Webinizer?

If you forget to check the `library` checkbox and the project build process has reached the last few
steps, then you would probably get the recipe `The errors not handled by webinizer` and the words
like `/usr/bin/tic: 2: Syntax error: "(" unexpected` appear in the logs panel.

_Solution_:

1. Stop the docker by `Crtl + C` in terminal or `docker stop $webinizer-container-id`.
2. Restart docker container with `run.sh` script.
3. Go to project `Basic config` page and **check** the `Check the box if the project is a library`.
