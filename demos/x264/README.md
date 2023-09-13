# Tutorial for building and using x264 library with Webinizer

## How to build x264 with Webinizer

1. **`Main page`** - Click `Get Started` in Webinizer main page to enter the project list page.

2. **`Get started page`** - Click the `SELECT` button of the X264 project to enter the
   `Basic config` page.

3. **`Basic config page`**

   - Click the `Check the box if the project is a library` as we are building X264 as a library.

     > **NOTE**. _Please make sure this step is taken before proceeding, otherwise some unexpected
     > errors might occur during the building process._

   - Click the `BUILD STEPS ->` in the lower right corner or `Steps` in the top navigation panel to
     enter the `Build steps` page.

4. **`Build steps page`**

   - Select the `static` build target and Webinizer will prompt you with the recommended build steps
     for the project.

   - Click `YES` to accept the recommendation.

   - Click the `MANAGE STEPS` button and add `--enable-static` to `Arguments for build` of STEP1
     `configure` to build a static library.

   - Click the `ADD STEP` button to add another step `make install` for x264.

   - Choose `Build tool type` as `make` and add `install` as `Arguments for build`, then click
     `SAVE` to confirm.

   - Click `BUILD ->` in the lower right corner or `Build` in the top navigation panel to enter the
     `Build` page.

5. **`Build page`**

   - Click the `BUILD` button and some recipes will show in several rounds of build.

   - `Recipe for main loop issue` - Click the `IGNORE` button as this is not applicable to `x264`
     library.

   - `Recipe for pthread support` - Click the `APPLY RECIPE` button to accept it.

   - `Recipe for exporting name of wasm module issue` - Click the `APPLY RECIPE` button to accept
     it.

   - `Recipe for build target specification issue` - Click `<- BUILD STEPS` in the lower left corner
     to go back to the `Build steps` page.

     > Note. _This is to suggest us to set the build target as `32-bit` architecture. We may need to
     > add appropriate build arguments accordingly in the `Build steps` page._

6. **`Build steps page`**

   - Click the `MANAGE STEPS` button and add `--host=i686-gnu` to `Arguments for build` of STEP1
     `configure`.

     > Note. _The argument to fix this issue might be varied from different projects and we should
     > check the build files to get the right one._

   - Click the `FINISH` button to save the changes.

   - Click `BUILD ->` to go back to the `Build` page.

7. **`Build page`**

   - Click the `BUILD` button again and some recipes will show in several rounds of build.

   - `Recipe for fpmath issue` - Click the `APPLY RECIPE` button to accept it.

   - `Recipe for asm issue` - Click `<- BUILD STEPS` in the lower left corner to go back to the
     `Build steps` page.

     > Note. _This is to suggest us to disable the x86 SIMD assmebly in the source code as
     > Emscripten doesn't support the compilation for it. We may need to add appropriate build
     > arguments accordingly in the `Build steps` page._

8. **`Build steps page`**

   - Click the `MANAGE STEPS` button and add `--disable-asm` to `Arguments for build` of STEP1
     `configure`.

     > Note. _The argument to fix this issue might be varied from different projects and we should
     > check the build files to get the right one._

   - Click the `FINISH` button to save the changes.

   - Click `BUILD ->` to go back to the `Build` page.

9. **`Build page`** - Click the `BUILD` button to trigger the build again.

After a while, it will show `Build successfully!` on the page.

## How to use x264 library within another project

If you want to build another project using `x264` library built by Webinizer, please go to the
`Configuration` page and navigate to the `Package & Native library info` section from the left side
navigation panel to define the `required` package configurations for the `static` build target as
below.

- _Prefix_: `${projectRoot}/webinizer_build`
- _Compiler flags_: `'-I${prefix}/include'`
- _Linker flags_: `'-L${prefix}/lib' -lx264`

In addition, we also need to set the native library information in the `Native Library Info` section
with `name` and `version` correctly.

- _name_: `x264`
- _version_: `r3011+5M`
