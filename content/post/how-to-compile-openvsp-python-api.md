---
title: "How to Compile Openvsp Python Api"
date: 2020-02-02T15:09:38-04:00
draft: false
---

So you want to get dirty with OpenVSP? That's pretty ambitious. Being able to modify our models programatically can be very useful when using scripting methods. However, this is also not as easy as I thought it would be... so I decided to make a post about it. Let's go over the steps I went through to get OpenVSP accessible to my python scripts. Note: I did this on a UNIX based OS, so it probably won't help Windows users.

# Compiling OpenVSP

OpenVSP does not ship with a python api. So we need to compile the program, in order to obtain an api wrapper for python (and other languages). Let's check the dependency list. It's quite extensive:

* OpenGL (you should have this, courtesy of your OS)
* gcc (install it from your package manager)
* cmake (install it from your package manager)
* swig (install it from your package manager)
* python (you should have this, also courtesy of your OS)
* doxygen (install it from your package manager if you wish)

The next dependencies are bundled with OpenVSP, but I chose to use those installed on my system. The reason for this decision, is that I was running into problems with one of them (so I did the only sensible decision, and purged everything).

* cpptest (install it from your package manager, or compile it if your OS doesn't offer it)
* libxml2 (install it from your package manager)
* eigen3 (install it from your package manager, or compile it if your OS doesn't offer it)
* code-eli (install it from your package manager, or compile it if your OS doesn't offer it)
* fltk (install it from your package manager)
* glm (install it from your package manager)
* glew (install it from your package manager)
* cminpack (install it from your package manager, or compile it if your OS doesn't offer it)

I've no idea. Once those are installed, we can start he compilation process. For reasons you'll discover, I'm going to set everything up in my user's directory (paths will get very hairy):

```bash
$ pwd
/home/mregger/
$ mkdir openvsp
$ cd openvsp
```

Now let's start by cloning the OpenVSP repository:

```bash
$ git clone https://github.com/OpenVSP/OpenVSP.git
```

Looking into the newly created directory, we can see four directories hanging out:

```bash
$ ls OpenVSP
Libraries
SuperProject
extras
src
...
```

`SuperProject` has everything we need. Let's make a directory in it where the built files will go:

```bash
mkdir OpenVsp/SuperProject/build
cd OpenVSP/SuperProject/build
```

And now we can run `cmake`. This part is critical, because this is where we tell the compiler that **WE WANT THE PYTHON API**. This is also where we tell the compiler to not use the bundled libraries.

```bash
$ cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH='/usr' \
        -DVSP_USE_SYSTEM_CPPTEST=true \
        -DVSP_USE_SYSTEM_LIBXML2=true \
        -DVSP_USE_SYSTEM_EIGEN=true \
        -DVSP_USE_SYSTEM_CODEELI=true \
        -DVSP_USE_SYSTEM_FLTK=true \
        -DVSP_USE_SYSTEM_GLM=true \
        -DVSP_USE_SYSTEM_GLEW=true \
        -DVSP_USE_SYSTEM_CMINPACK=true \
        -DPYTHON_EXECUTABLE='/usr/bin/python3.8' \
        -DPYTHON_LIBRARY='/usr/lib/python3.8' \
        -DPYTHON_INCLUDE_DIR='/usr/include/python3.8' \
        -DPYTHON_INCLUDE_PATH='/usr/include'
```

Note that I pointed my build to python 3.8, which is what I would like to use. You can use a different python version, provided you have it installed. Then we run:

```bash
make
```

This will take a while, so let's go do something else.

# After The Compilation

After OpenVSP builds, we sould be able to find everything under `SuperProject/build/OpenVSP-prefix/src/OpenVSP-build`. If you don't have OpenVSP installed on your system, you can get the binary files and place them in your `/usr/bin` or `/bin` directories. Note: I highly recommend that you install a clean version of OpenVSP, and let your package manager figure this stuff out.

```bash
$ pushd ./OpenVSP-prefix/src/OpenVSP-build/_CPack_Packages/Linux/ZIP/Linux/*/
$ sudo mkdir -p /usr/bin/openvsp # or /bin/openvsp
$ sudo cp vsp vspaero vspscript vspslicer vspviewer /usr/bin/openvsp # or /bin/openvsp
$ sudo mkdir -p /usr/share/openvsp
$ sudo cp README.md /usr/share/openvsp
$ sudo cp LICENSE /usr/share/openvsp
$ sudo cp -r CustomScripts /usr/share/openvsp
$ sudo cp -r airfoil /usr/share/openvsp
$ sudo cp -r matlab /usr/share/openvsp
$ sudo cp -r scripts /usr/share/openvsp
$ sudo cp -r textures /usr/share/openvsp
$ pushd
```

But if you already have OpenVSP installed, there's no need for that. Let's go get our python api.

``` bash
$ pwd
/home/mregger/openvsp/OpenVSP/SuperPackage/build
$ ls OpenVSP-prefix/src/OpenVSP-build/src/python_api/
CMakeFiles           python         _vsp_g.so
cmake_install.cmake  Makefile     python_api.py  vsp.py
CTestTestfile.cmake  __pycache__  vsp_g.py       _vsp.so
```

And there it is. You'll notice that it is in a bit of an awkward place there, and it won't be fun to type that path in every time we want to import it. We need to move this stuff. Thankfully, none of the files depend on being where they are, so we can move them out of there without breaking anything. When we run `pip install` python likes to install packages in `/usr/lib/pythonX.Y/site-packages/`. We could just install everything there and be done with it. But that's not a good idea, because these packages are managed by `pip`, and we'd like to keep it that way. Also, my system purges that directory when a new python version comes out (yay Arch Linux), and we don't want to repeat this every time python updates. So what I will do instead, is find a nice and quiet little spot, where I can setup a python environment. This will act like a little bubble protecting the project's dependencies from literally anything (except coffee spills). Let's install `virtualenv` and navigate to where I want to work on the aircraft:

```bash
$ sudo pip install virtualenv
$ cd ~/Projects/kontor/ # this is where I will be working on kontor
$ virtualenv kontor_environment
```

This will create a directory called `kontor_environment`. Taking a look inside we can find where python will install packages:

```bash
$ ls kontor_environment/lib/python3.8/site-packages/
```

Let's "install" our freshly compiled python api in that directory, and pretend it's a real python package:

```bash
$ mkdir kontor_environment/lib/python3.8/site-packages/openvsp
$ cp -r ~/openvsp/OpenVSP/SuperPackage/build/OpenVSP-prefix/src/OpenVSP-build/src/python_api/* kontor_environment/lib/python3.8/site-packages/openvsp/
```

And that's it really. To test if we got everything working, we can copy [this](https://github.com/OpenVSP/OpenVSP/blob/master/src/python_api/test.py) file from the OpenVSP repo, which will allow us to test the api.

```bash
$ wget https://github.com/OpenVSP/OpenVSP/blob/master/src/python_api/test.py
$ nano test.py
# modify the import statement so we have
# from openvsp import vsp
# instead of
# import vsp as openvsp
$ source kontor_environment/bin/activate
$ python ./test.py
```

At this point we should have a nice error-less bunch of stuff.

# For Arch Linux users

If you use Arch Linux, there is an easier way to compile everything. The OpenVSP package exists in the AUR. You can simply pull the PCKGBUILD file, edit it and install OpenVSP like any other package.
